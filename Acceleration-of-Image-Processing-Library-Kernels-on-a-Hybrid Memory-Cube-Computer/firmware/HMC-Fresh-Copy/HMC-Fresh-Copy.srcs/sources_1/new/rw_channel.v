/*
* File Name     : rw_channel.v
*
* Description   : This module accepts the user command interface and forms
*                 request packets that conform to the HMC spec.  This combines
*                 the write_channel and the read_channel into a single module.
*                 
*                 Note that this does NOT compute any CRC information.
*
* Note          : In the future, if we want to split the cmd channel into
*                 separate read request and write request channels, then we
*                 should just put an arbiter in front of this module.
*
* Copyright     : 2015, Micron Inc.
*/
`include "hmc_def.vh"
module rw_channel #(
    parameter   PORT                = 1,
    parameter   NAME                = "rw_channel",
    parameter   VERBOSE             = 1
)
(
    // synchronous clock and reset for this module
    input                           clk,
    input                           rst,

    // this is a slightly expanded version of the user interface
    // basically, we have expanded the cmd[] field into the signals that each
    // bit represents
    input                           cmd_valid,
    output                          cmd_ready,
    input       [2:0]               cub,        // not used yet
    input       [5:0]               tag,
    input                           posted,
    input                           mode,
    input                           bwr,
    input                           atomic,
    input                           add8,       // high: dual 8-byte add; low: single 16-byte add
    input       [33:0]              addr,
    input       [3:0]               size,
    input                           wr,

    // this is the write data channel
    input       [127:0]             wr_data,
    input                           wr_data_valid,
    output                          wr_data_ready,

    // this is our 128-bit flit channel
    // this has both cmd + data combined
    // we formed this based upon the HMC spec
    output  reg [127:0]             dout        = 'h0,
    output  reg                     flit_valid  = 0,
    input                           flit_ready,
    output  reg [3:0]               flit_remain = 0,
    output  reg                     sof         = 0,
    output  reg                     eof         = 0
);
    ////////////////
    // PARAMETERS //
    ////////////////

    // these are the states that we find in our state machine for this module
    // it's very important that we don't have any dead cycles before, after,
    // or during a flit, unless we don't have valid data at the input (for
    // some reason).  
    localparam  STATE_IDLE          = 'b001,    // wait for valid command, send the header
                STATE_WR            = 'b010,    // send 128 total bits of our write data (64b from half_data register, 64b from write_data_buf)
                STATE_TAIL          = 'b100;    // send the final 64 bits of write data combined w/ our tail

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // this is our header for our request packet
    // we form this using the hmc_request_header module
    wire        [63:0]              header;
    
    // this is our tail for our request packet
    // the tail for request packets holds a lot of info that we can't possibly
    // know at this point (e.g. SEQ, FRP, RRP, CRC). therefore, we just assign
    // the tail to all 0s for now, and we will fill that info in later
    wire        [63:0]              tail;

    // these are only needed to insert the correct size into the tail for read
    // requests
    wire        [3:0]               size_q;
    wire        [4:0]               size_plus_one;

    // this is the registered version of our header + write data
    wire        [63:0]              header_buf_q;
    wire                            header_buf_q_valid;
    reg                             header_buf_q_ready  = 0;
    wire                            wr_q;
    wire        [127:0]             wdata_buf_q;
    wire                            wdata_buf_q_valid;
    reg                             wdata_buf_q_ready   = 0;
    
    // this is the registered version of the MS half of our write data
    // we need this register because the write data payload is offset by 64
    // bits in our packets.  for example, on a 16B write, we send the LS 64
    // bits with our header, then the MS 64 bits with our tail.
    reg         [63:0]              half_data           = 64'h0;

    // we use this counter to track the number of flits that are remaining in
    // our current packet
    wire        [3:0]               flits_in_pkt        = header_buf_q[`CMD_LEN_FIELD];
    reg         [3:0]               count               = 0;
    reg                             load_count          = 0;

    // this control signal tells us when we should send a flit to our output
    reg                             next_flit_valid     = 0;

    // these are our state registers
    reg         [2:0]               state,
                                    nextState;
    reg         [19*8-1:0]          stateName           [0:7];

    //////////////
    // DATAPATH //
    //////////////
    
    // this is a completely combinational module that simply forms our request
    // headers based upon the HMC spec
    hmc_request_header hmc_header (
        .cub                        (cub),
        .tag                        ({PORT[2:0], tag}),
        .wr                         (wr),
        .posted                     (posted),
        .mode                       (mode),
        .bwr                        (bwr),
        .atomic                     (atomic),
        .add8                       (add8),
        .addr                       (addr),
        .size                       (size),
        .dout                       (header)
    );
    
    // buffer the command information
    // Note: this is likely the first thing that we do within the HMC
    // controller, so we want to buffer the command + data first, which should
    // improve timing as much as possible
    dual_buf #(
        .WIDTH                      (1+4+64)
    ) header_buf (
        .clk                        (clk),
        .rst                        (rst),
        .data                       ({wr,size,header}),
        .data_valid                 (cmd_valid),
        .data_ready                 (cmd_ready),
        .q                          ({wr_q,size_q,header_buf_q}),
        .q_valid                    (header_buf_q_valid),
        .q_ready                    (header_buf_q_ready)
    );

    // buffer the write data before we do anything
    dual_buf # (
        .WIDTH                      (128)
    ) wdata_buf (
        .clk                        (clk),
        .rst                        (rst),
        .data                       (wr_data),
        .data_valid                 (wr_data_valid),
        .data_ready                 (wr_data_ready),
        .q                          (wdata_buf_q),
        .q_valid                    (wdata_buf_q_valid),
        .q_ready                    (wdata_buf_q_ready)
    );

    // cache the upper half of the write data when wdata_buf is read
    // wdata_buf is read whenever the lower half of data is sent
    always @ (posedge clk) begin
        if (wdata_buf_q_ready && wdata_buf_q_valid) begin
            half_data               <= wdata_buf_q[127:64];
        end
    end
    
    // use the control signals (see the CONTROL section of this module) to
    // determine our next outputs
    always @ (posedge clk) begin
        dout                        <= 'hX;
        flit_valid                  <= next_flit_valid;
        flit_remain                 <= 'hX;
        sof                         <= 0;
        eof                         <= 0;

        case (state)
            // in this state, we know we either need to send a full read
            // request packet or a write request header + 64b of write data
            STATE_IDLE: begin
                sof                 <= 1;
                flit_remain         <= flits_in_pkt;
                if (wr_q) begin
                    dout            <= {wdata_buf_q, header_buf_q};
                    if (next_flit_valid && VERBOSE) $display("[%t] %m sending out header for WR packet = %032x, %0d flits remain", $time, {wdata_buf_q, header_buf_q}, flits_in_pkt);
                end else begin
                    eof             <= 1;
                    dout            <= {tail,        header_buf_q};
                    if (next_flit_valid && VERBOSE) $display("[%t] %m sending out RD packet = %032x, %0d flits remain", $time, {tail, header_buf_q}, flits_in_pkt);
                end
            end
            // in this state, we know we are in the middle of a write packet
            // therefore, we just send the half of the write data from the
            // previous data beat along with the half of the write data from
            // the current data beat
            STATE_WR: begin
                dout                <= {wdata_buf_q, half_data};
                flit_remain         <= count;
                if (next_flit_valid && VERBOSE) $display("[%t] %m sending out write data = %032x, %0d flits remain", $time, {wdata_buf_q, half_data}, count);
            end
            // in this state, we know we are almost done with a write request
            // packet.  we just have the remaining 64b of write data + the
            // tail
            STATE_TAIL: begin
                eof                 <= 1;
                flit_remain         <= 1;
                dout                <= {tail,        half_data};
                if (next_flit_valid && VERBOSE) $display("[%t] %m sending out tail flit for WR = %032x, %0d flits remain", $time, {tail, half_data}, 1);
            end
        endcase
    end

    // this counts the number of flits left in our current packet
    // we load this from our 'size' input when we start a flit
    always @ (posedge clk) begin
        if (load_count) begin
            count                   <= flits_in_pkt-1;
        end else if (next_flit_valid) begin
            count                   <= count - 1;
        end
    end
    
    // the tail is basically all 0s.  we will fill in most of this data later
    // in the pipeline
    // Note regarding the RTC: we know that the HMC will decrement its token
    // count when it sends us read response packets. we compensate for this by
    // returning the tokens for that response packet with the request packet
    // (BEFORE the response packet is even sent by the HMC).
    assign tail = {
        32'h0,              /* CRC */
        size_plus_one,      /* RTC */
        3'h0,               /* SLID */
        5'h0,               /* res */
        3'h0,               /* SEQ */
        8'h0,               /* FRP */
        8'h0                /* RRP */
    };

    // the purpose of this wire is so we can send out the correct number of
    // tokens when we are sending out a read request packet.  if we are
    // sending a write packet, we want this to be zero.  Note that if we are
    // not currently sending the tail FLIT, we don't care what this value is.
    // Note that if we are sending a write packet, we don't send the tail
    // until we are in STATE_TAIL. that's why we can differentiate writes
    // versus reads using the current state.
    assign  size_plus_one           = (state==STATE_IDLE) ? size_q+1 : 0;

    /////////////
    // CONTROL //
    /////////////

    // this is our state register
    always @ (posedge clk) begin
        if (rst) begin
            state                   <= STATE_IDLE;
        end else begin
            state                   <= nextState;
            /*
            if (VERBOSE && state!=nextState) begin
                $display("[%0t] %m transition from state %s to %s", $realtime, stateName[state], stateName[nextState]);
            end
            */
        end
    end

    // this is our next state logic
    // again, we use a MEALY type state machine for this control logic
    always @ (*) begin

        load_count                  = 0;
        header_buf_q_ready          = 0;
        wdata_buf_q_ready           = 0;
        nextState                   = state;

        next_flit_valid             = 0;

        case (state)
            // in this state, we are waiting for a valid command (first and
            // foremost). if that command is a read, then we should output the
            // read request packet. if it's a write, we better wait for valid
            // write data before outputting our header
            STATE_IDLE: begin
                load_count          = 1;
                if (header_buf_q_valid && flit_ready) begin
                    if (wr_q) begin
                        if (wdata_buf_q_valid) begin
                            header_buf_q_ready  = 1;
                            wdata_buf_q_ready   = 1;
                            next_flit_valid     = 1;
                            if (flits_in_pkt==2) begin
                                nextState       = STATE_TAIL;
                            end else begin
                                nextState       = STATE_WR;
                            end
                        end
                    end else begin
                        header_buf_q_ready      = 1;
                        next_flit_valid         = 1;
                    end
                end 
            end
            // in this state, we know we are doing a write.  therefore, we
            // only have to look at the flow control signals for the write
            // data. we know we are almost done with our write (and can
            // therefore transition to the STATE_TAIL state) when we are
            // sending out a valid flit and our count=2
            STATE_WR: begin
                wdata_buf_q_ready               = 1;
                if (wdata_buf_q_valid) begin
                    next_flit_valid             = 1;
                    if (count==2) begin
                        nextState               = STATE_TAIL;
                    end
                end
            end
            // in this state, we know we are almost done with a write request
            // packet.  we just have the remaining 64b of write data + the
            // tail
            STATE_TAIL: begin
                next_flit_valid                 = 1;
                nextState                       = STATE_IDLE;
            end
        endcase
    end
    
    ///////////
    // DEBUG //
    ///////////

    // this is just to help for some debug print statements
    initial begin
        stateName   [STATE_IDLE]    = "STATE_IDLE";
        stateName   [STATE_WR]      = "STATE_WR";
        stateName   [STATE_TAIL]    = "STATE_TAIL";
    end

endmodule
