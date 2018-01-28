/*
* File Name     : rx_port.v
*
* Description   : This module is basically a serializer.  This accepts our
*                 parallel response data bus as an input.  We then filter out
*                 whatever response data is not bound for this port.  Finally,
*                 we serialize the response data and hand it off to the user
*                 interface.
*                 
*                 The general idea here is that we use a big memory to first
*                 catch only the data that is bound for this port (i.e. MS tag
*                 bits correspond to this PORT number).  We then read the
*                 response data out of that memory and hand it off to the user
*                 module.  For the rest of this description, we call this
*                 memory the rx_buffer.
*
*                 The complication arises because we need to be able to write
*                 N FLITS per data beat into the rx_buffer, but we can
*                 only hand off at most 1 FLIT to the user logic per data beat.
*                 This is likely a good starting point, so let's play
*                 out this scenario:
*                 1) we will write a full data beat (N FLITS wide)
*                 whenever any of the FLITS on that data beat are bound for
*                 our port
*                 2) we will read 1 data beat out of our rx_buffer every
*                 N cycles
*                 
*                 This bandwidth imbalance seems like a big hurdle, but
*                 luckily we will have N different ports in our system.
*                 On average, we expect to write 1 out of every N FLITS
*                 into our rx_buffer.  Note that this is not the same as
*                 saying that we need to write 1 out of every N data
*                 beats into our rx_buffer.
*                 
*                 As described, this system has a huge problem still.  It's
*                 possible that every single data beat has 1 response FLIT for
*                 each port.  All ports would have to write every data beat,
*                 and all ports would take N cycles to read a single data beat
*                 (just to get that 1 FLIT of valid data).  This would
*                 therefore require an infinitely sized rx_buffer for each
*                 port.
*                 
*                 However, we can place a further limitation upon this system
*                 in order to bound the size of the rx_buffer.  Recall that
*                 each port only has a finite number of tags.  If a port
*                 runs out of tags, it has to stop issuing requests.  We
*                 therefore can bound the size of the rx_buffer based upon the
*                 number of tags given to each port.  The most FLITS that we
*                 will ever store in our rx_buffer at any given time is:
*                 
*                 max_num_flits = 2^tag_bits * max_resp_pkt_len
*
*                 If we now convert this max number of FLITs that we must
*                 store in our rx_buffer to a max number of data beats, we can
*                 finally determine the upper bound for our rx_buffer depth:
*                 
*                 max_num_data_beats = 2^tag_bits * max_resp_pkt_cycles
*
* TODO          : 1) if we want, we could easily use the rx_buffer to cross
*                    a clock domain
*
* Copyright     : 2015, Micron Inc.
*/


module rx_port #(
    parameter name          = "",
    parameter verbose       = 0,
    parameter TAG_W         = 9,
    parameter ERR_W         = 8,
    parameter PORT          = 1,
    parameter FLIT_W        = 128,
    parameter N_FLITS       = 5,
    parameter PORT_TAG_W    = clogb2(N_FLITS),
    parameter USER_TAG_W    = TAG_W-PORT_TAG_W
) (
    input  wire                     clk,
    input  wire                     rst,

    // RX from PCS / packet detection
    input                           user_clk,
    input  wire [N_FLITS*FLIT_W-1:0]din,
    input  wire [N_FLITS-1:0]       present_map,
    input  wire [N_FLITS-1:0]       sof_map,
    input  wire [N_FLITS-1:0]       eof_map,
    input  wire [N_FLITS*TAG_W-1:0] tag_map,
    input  wire [N_FLITS*ERR_W-1:0] err_map,

    // Port
    output reg  [FLIT_W-1:0]        data            = 0,
    output reg  [TAG_W-1:0]         tag             = 0,
    output reg  [ERR_W-1:0]         error_response  = 0,    // valid on last data word of a packet, contains {DINV, ERRSTAT[6:0]}
    output reg                      valid           = 0
);
    ///////////////
    // FUNCTIONS //
    ///////////////

    // computes ceil( log( x ) )
    // Note: this requires that clogb2(0) = 1
    function integer clogb2;
        input [31:0] value;
        begin
            if (value == 0) value = 1;
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
                value = value >> 1;
            end
        end
    endfunction

    ////////////////
    // PARAMETERS //
    ////////////////

    // this is the width of the header (in bits)
    // the tail is this same width
    localparam  HEADER_W            = 64;

    // this is the max number of data beats that a single response packet can
    // span
    localparam  MAX_RESP_PKT_CYCLES = 3;

    // this is the upper bound on the depth of our rx_buffer
    localparam  MAX_NUM_DATA_BEATS  = (1<<USER_TAG_W) * MAX_RESP_PKT_CYCLES;

    // now this is the actual depth of our rx_buffer (round MAX_NUM_DATA_BEATS up to
    // a power of 2 to make life easy)
    localparam  LOG_DEPTH           = clogb2(MAX_NUM_DATA_BEATS);
    localparam  DEPTH               = 1<<LOG_DEPTH;

    // this is the width of our rx_buffer
    localparam  WIDTH               = N_FLITS * (FLIT_W+1+TAG_W+ERR_W);

    initial begin
        /* synthesis translate_off */
        if (verbose) begin
            $display("[%t] %m: TAG_W=%0d, PORT_TAG_W=%0d, USER_TAG_W=%0d", $time, TAG_W, PORT_TAG_W, USER_TAG_W);
            $display("[%t] %m: WIDTH=%0d, DEPTH=%0d, LOG_DEPTH=%0d, total size=%0d kb", $time, WIDTH, DEPTH, LOG_DEPTH, (WIDTH*DEPTH)>>10);
        end
        /* synthesis translate_on */
    end

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // synchronize the reset over to the user clock domain
    reg                             user_rst_1      = 0;
    reg                             user_rst_2      = 0;

    // buffer our input data bus by 1 cycle
    reg         [N_FLITS*FLIT_W-1:0]din_1           = 'h0;
    reg         [N_FLITS-1:0]       present_map_1   = 0;
    reg         [N_FLITS*TAG_W-1:0] tag_map_1       = 0;
    reg         [N_FLITS*ERR_W-1:0] err_map_1       = 0;
    
    // we use this register to save the MS bits of the last flit on our bus
    // this is in case valid data carries over in time (over a clock cycle
    // boundary)
    reg         [HEADER_W-1:0]      data_save       = 'h0;

    // test to see if these FLITS are bound for our port
    // if FLITS are not destined for our port, we mask off the pkt_map bits
    reg         [N_FLITS-1:0]       pkt_masked;
    reg         [TAG_W-1:0]         tag_test;
    
    // our rx_buffer, along with some write and read pointers
    // Note: our write pointer points to the next entry to be written
    // Note: our read pointer points to the next entry to be read
    // Note: we are empty when both the write and read pointer point to the
    // same entry
    reg         [WIDTH-1:0]         rx_buffer       [0:DEPTH-1];
    reg         [LOG_DEPTH-1:0]     wrptr           = 0;
    reg         [LOG_DEPTH-1:0]     rdptr           = 0;
    wire                            full;
    reg                             empty_1         = 1;

    // this register detects if we EVER get an overflow in our system
    // this can only be cleared with a reset
    // TODO: add the picobus to this module so we can read the value of this
    // register
    reg                             overflow        = 0;

    // we will have a 2 cycle read latency coming out of the rx_buffer for
    // optimal timing
    reg         [WIDTH-1:0]         rx_buffer_1     = 'h0;
    reg         [WIDTH-1:0]         rx_buffer_2     = 'h0;

    // we latch the read data after those 2 cycles in a buffer. we then use
    // this buffer to serialize our data.
    reg         [WIDTH-1:0]         rx_latch        = 'h0;
    reg                             rx_latch_valid  = 0; 
    // we break our rx_latch out into it's parts to make processing a bit
    // easier
    reg         [N_FLITS*FLIT_W-1:0]rx_latch_data   = 'h0;
    reg         [N_FLITS-1:0]       rx_latch_pkt    = 0;
    reg         [N_FLITS*TAG_W-1:0] rx_latch_tag    = 0;
    reg         [N_FLITS*ERR_W-1:0] rx_latch_err    = 0;

    // we need this counter to know when to latch our read data
    reg         [PORT_TAG_W-1:0]    rx_cnt          = 0;
    reg                             latching_data   = 0;
    wire                            latching_good_data;

    // this is a serializing mux right before our output buffer
    // we mux data out of the rx_latch into these registers
    reg         [FLIT_W-1:0]        data_pre1       = 0;
    reg         [TAG_W-1:0]         tag_pre1        = 0;
    reg         [ERR_W-1:0]         err_pre1        = 0;
    reg                             valid_pre1      = 0;

    integer                         f;

    ///////////////////
    // BUFFER INPUTS //
    ///////////////////

    // test if our input tag's MS bits match our port number
    // that's how we know if these responses are meant for our port
    always @ (*) begin
        pkt_masked                  = 0;
        for (f=0; f<N_FLITS; f=f+1) begin
            tag_test                = tag_map >> (f*TAG_W);
            if ((tag_test>>USER_TAG_W) == PORT[PORT_TAG_W-1:0]) begin
                pkt_masked  [f]     = present_map[f];
                if (verbose && present_map[f]) $display("[%t] %m: flit[%0d] tag=0x%0h matches our port=%0d", $time, f, tag_test, PORT);
            end
        end
    end

    // here we buffer the input data 1 cycle
    // also remember if any of these FLITS are bound for our port
    always @ (posedge clk) begin
        // Note: we know that we need to shift our data by the size of the header
        // in order to produce data that is properly aligned (not offset by the
        // header).  if we do it before we write that data to the memory, we can
        // save 1 rx_buffer entry (because we don't have to write the SOF FLIT to
        // the memory for packets that span a data beat boundary). i.e. RD_RS16
        // packets starting on flit[4] will only cause us to write 1 data beat
        // into the rx_buffer, whereas before it was 2 data beats.
        {data_save, din_1}          <= {din, data_save};
        // TODO: if ANY response packets are only 1 FLIT long, this
        // logic will be a bug (e.g. error response packets)
        present_map_1               <= pkt_masked & ~sof_map;
        tag_map_1                   <= tag_map;
        err_map_1                   <= err_map;
    end
    
    // synchronize the reset signal over to the user clock domain
    always @ (posedge user_clk) begin
        user_rst_1                  <= rst;
        user_rst_2                  <= user_rst_1;
    end
    
    ///////////////
    // RX BUFFER //
    ///////////////

    // this is our wide memory that might get written every cycle and will get
    // read every N_FLITS cycles
    // -don't worry about protecting this memory for overflow, but we should at
    // least detect that condition
    // -our write pointer needs to increment whenever we write some valid data
    // to this system
    // -our read pointer should update whenever we read some valid data from
    // this system. note that we can afford to wait a couple of cycles (if
    // needed) before we update the read pointer
    // -since we are not worried about corrupting data, we choose to
    // write this memory every cycle, and we only update the write pointer
    // when we had valid data.  this approach is more power hungry, but it
    // should have better timing
    // -we also read from this buffer every single cycle. we will have
    // a 2 cycle read latency, and we will only latch that read data every
    // N_FLITS cycles. we only update the read pointer if we just read data
    // that 
    always @ (posedge clk) begin
        rx_buffer   [wrptr]         <= {
                                        present_map_1,
                                        tag_map_1,
                                        err_map_1,
                                        din_1
                                       };
    end
    always @ (posedge user_clk) begin
        rx_buffer_1                 <= rx_buffer    [rdptr];
        rx_buffer_2                 <= rx_buffer_1;
    end

    // here is where we manage the read and write pointers
    // -the write pointer is pretty easy. just update it whenever we are
    // writing some data that we actually care about
    assign  full                    = (wrptr+1) == rdptr;
    always @ (posedge clk) begin
        if (rst) begin
            wrptr                   <= 0;
            overflow                <= 0;
        end else if (|present_map_1) begin
            wrptr                   <= wrptr + 1;
            if (full) begin
                overflow            <= 1;
                $display("[%t] %m: ERROR : writing to a full rx_buffer. wrptr=0x%0h, rdptr=0x%0h", $time, wrptr, rdptr);
                $stop;
            end
            if (verbose) $display("[%t] %m: writing data beat to rx_buffer[%0d] = 0x%0h, pkt_map=0x%0h, tag_map=0x%0h", $time, wrptr, din_1, present_map_1, tag_map_1);
        end
    end
  
    // Convert the wrptr to gray code before crossing it over to the user_clk
    reg   [LOG_DEPTH-1:0]  wrptr_gray = 0;
    always @ (posedge clk) begin
        if (rst) begin
            wrptr_gray <= 0;
        end else begin
            wrptr_gray <= wrptr[LOG_DEPTH-1:0] ^ {1'b0, wrptr[LOG_DEPTH-1:1]};
        end
    end

    // Cross it to the user_clk
    reg   [LOG_DEPTH-1:0]  wrptr_gray_user_clk = 0;
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            wrptr_gray_user_clk <= 0;
        end else begin
            wrptr_gray_user_clk <= wrptr_gray;
        end
    end

    // convert wrptr_gray_user_clk back to binary before using in comparison with rdptr for empty signal
    integer i;
    reg   [LOG_DEPTH-1:0]  wrptr_bin_comb = 0;
    always @ (*) begin
        wrptr_bin_comb[LOG_DEPTH-1] <= wrptr_gray_user_clk[LOG_DEPTH-1];

        for (i=LOG_DEPTH-2; i>=0; i=i-1) begin
            wrptr_bin_comb[i] <= wrptr_gray_user_clk[i] ^ wrptr_bin_comb[i+1] ;
        end
    end

    // register the binary value for timing
    reg   [LOG_DEPTH-1:0]  wrptr_bin = 0;
    always @ (posedge user_clk) 
        if (user_rst_2) 
            wrptr_bin <= 0;
        else 
            wrptr_bin <= wrptr_bin_comb;

    // -the read pointer is a little more complicated. we should update it
    // whenever we just read some meaningful data (basically, the rx_buffer
    // was not empty when we read it). we also need to make sure that we never
    // update this > 1 time every N_FLITS cycles
    // Note: our rx_latch grabs the data whenever rx_cnt is 0
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            rdptr                   <= 0;
        end else if (latching_good_data) begin
            rdptr                   <= rdptr + 1;
        end
        empty_1                     <= wrptr_bin == rdptr;
    end

    //////////////
    // RX LATCH //
    //////////////

    // we first latch the read data from the rx_buffer every N_FLITS cycles
    // Note: our grand_central_tx module numbers the ports using a 1-based
    // system
    assign  latching_good_data      = latching_data & ~empty_1;
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            rx_latch                <= 'hX;
            rx_latch_valid          <= 0;
            rx_latch_pkt            <= 'hX;
            rx_latch_tag            <= 'hX;
            rx_latch_err            <= 'hX;
            rx_latch_data           <= 'hX;
        end else if (latching_data) begin
            rx_latch                <= rx_buffer_2;
            rx_latch_valid          <= latching_good_data;
            // this breaks our data into it's parts. we treat the actual data
            // specially, so don't include it here
            {
                rx_latch_pkt,
                rx_latch_tag,
                rx_latch_err
            }                       <= rx_buffer_2 >>   (FLIT_W*N_FLITS);
            rx_latch_data           <= rx_buffer_2      [FLIT_W*N_FLITS-1:0];
            if (verbose && latching_good_data) $display("[%t] %m: latching good data into rx_latch=0x%0h", $time, rx_buffer_2);
        end
    end

    // this is our counter so we know when we are supposed to latch data
    // coming out of our rx_buffer
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            rx_cnt                  <= 0;
        end else if (latching_data) begin
            rx_cnt                  <= 0;
        end else begin
            rx_cnt                  <= rx_cnt + 1;
        end
        latching_data               <= rx_cnt == (N_FLITS-2);
    end

    /////////////////////////
    // USER PORT INTERFACE //
    /////////////////////////

    // we have our data sitting in our rx_latch
    // we just need to read a single FLIT per cycle out of our latch
    // we only assert the rd_data_valid output if the latch is holding valid
    // data and the current flit (according to our rx_cnt pointer) is valid
    // for this port
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            data_pre1               <= 'hX;
            tag_pre1                <= 'hX;
            err_pre1                <= 'hX;
            valid_pre1              <= 0;
        end else begin
            data_pre1               <= rx_latch_data >> (rx_cnt*FLIT_W);
            err_pre1                <= rx_latch_err  >> (rx_cnt*ERR_W);
            tag_pre1                <= rx_latch_tag  >> (rx_cnt*TAG_W);
            if (rx_latch_valid) begin
                valid_pre1          <= rx_latch_pkt  >> (rx_cnt*1);
            end else begin
                valid_pre1          <= 0;
            end
        end
    end

    // this is our final output buffer
    //-we want to ensure that we have solid timing at our user interface
    always @ (posedge user_clk) begin
        if (user_rst_2) begin
            data                    <= 'hX;
            tag                     <= 'hX;
            error_response          <= 'hX;
            valid                   <= 0;
        end else begin
            data                    <= data_pre1;
            tag                     <= tag_pre1;
            error_response          <= err_pre1;
            valid                   <= valid_pre1;
        end
    end

endmodule
