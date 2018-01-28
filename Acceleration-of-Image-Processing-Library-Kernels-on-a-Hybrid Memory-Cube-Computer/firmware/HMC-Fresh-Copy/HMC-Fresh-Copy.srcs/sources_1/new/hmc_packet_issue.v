/*
 * File Name     : hmc_packet_issue.v
 *
 * Author        : Corey Olson
 *
 * Description   :  This is the module that determines if we should actually
 *                  issue packets to the HMC controller PHY or not.  This also
 *                  manages the token count register (TCR).  Note that we ONLY
 *                  start a new packet if we can send ALL FLITS for ALL new
 *                  packets on the parallel data bus.  If TCR < len_sum_in, then
 *                  we don't send ANY partial packets; we only complete packets
 *                  that were started on a previous data beat.
 *
 * Assumptions   :
 *                  A1) if tx_valid_in is deasserted, then tx_data_in can be ANYTHING (i.e. does NOT have to be all 0s)
 *                  A2) rtc_valid and rtc have already been synchronized to this clock (clk)
 *                  A3) we have 1 cycle of latency through this module
 *                  A4) sending all 0's on the tx_data_out bus is equivalent to sending all NULL flits
 *                  A5) we can output the len bus even when we want to send NULL flits (i.e. len output bus should be masked with SOF bus)
 *                  A6) if the tx_rdy_in signal is not asserted, then the input data will NOT change
 *                  A7) if the HMC link is not trained, then the reset will be asserted into this module
 *                  A8) tx_valid_in is only deasserted after a cycle on which 'carry' is false. (ie - not in the middle of a packet)
 *
 * Copyright     : 2013, Pico Computing, Inc.
 */

 `timescale 1ns / 1ps

module hmc_packet_issue #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter MAX_PKT_LEN   = 9,                // this is the maximum packet length (in terms of FLITS) as defined by the specification
    parameter FLIT_W        = 128,              // the width of a single flit (in bits)
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*FLIT_W,     // total width of the flit data channel. each flit is 128b, so ...
    // DO NOT MODIFY BELOW THIS LINE
    parameter LOG_SUM_W     = clogb2(FLITS*MAX_PKT_LEN)
                                                // worst-case number of bits required to represent the sum of all LEN fields on the input bus
                                                // if you don't want to use this, just use FLITS+MAX_PKT_LEN for the width of this bus
)
(
    // Clocks
    // Note: assume this is the TX clock
    input                   clk,
    input                   rst,

    input                   debug_clk,
    input       [31:0]      debug_addr,
    input       [31:0]      debug_din,
    output reg  [31:0]      debug_dout,
    input                   debug_rd,
    input                   debug_wr,

    input                   start_link_retry,
    output reg              start_link_retry_rdy,
    input   [FLITS-1:0]     start_link_retry_mask,
    output reg              retry_armed,

    input                   rx_err_abort_valid,
    output reg              rx_err_abort_rdy=0,
    input   [7:0]           rx_err_abort_rp,

    // return token count (RTC) from rtc module
    // Note: assume this is synchronous to the TX clock
    input                   rtc_valid,
    input   [3+4:0]         rtc,                // the rtc field is only 5b, but we may need to aggregate FLITS # of maximal rtc values.
                                                //   (the +3 should "really" be +log2(FLITS) )

    // TX Input Stream
    input   [4*FLITS-1:0]   len_in,
    input   [LOG_SUM_W-1:0] len_sum_in,
    input                   tx_valid_in,
    output                  tx_rdy_in,
    input                   pkt_carry_in,

    // this is the unmasked version of the input data
    input   [W-1:0]         tx_data_in,
    input   [FLITS-1:0]     pkt_map_in,
    input   [FLITS-1:0]     sof_map_in,
    input   [FLITS-1:0]     eof_map_in,

    input                   din_retry,         // is dout resent, or original data?
    input                   din_retry_start,   // first beat of a retry
    input                   din_retry_end,     // last beat of a retry

    // this is the version of the input data with only the first FLITs being valid (all flits after the first EOF masked off)
    input   [W-1:0]         tx_data_in_first_flits,
    input   [FLITS-1:0]     pkt_map_in_first_flits,
    input   [FLITS-1:0]     sof_map_in_first_flits,
    input   [FLITS-1:0]     eof_map_in_first_flits,

    // this is the version of the input data with only the last FLITs being valid (all flits before the first SOF masked off)
    input   [W-1:0]         tx_data_in_last_flits,
    input   [FLITS-1:0]     pkt_map_in_last_flits,
    input   [FLITS-1:0]     sof_map_in_last_flits,
    input   [FLITS-1:0]     eof_map_in_last_flits,

    // TX Output Data (to PHY)
    output  [W-1:0]         tx_data_out,

    // Output Data
    // Note: this will most likely get synthesized out
    output  [FLITS-1:0]     pkt_map_out,
    output  [FLITS-1:0]     sof_map_out,
    output  [FLITS-1:0]     eof_map_out,
    output  [4*FLITS-1:0]   len_out,
    output  [LOG_SUM_W-1:0] len_sum_out
);

    // number of ClearErrorAbort packets to send.
    localparam cfg_retry_pkt_count = 25;
    // number of StartRetry packets to send upon seeing an rx error. must be more than FLITS, to ensure
    //   we take more than one clock to send them all. (see note in hmc_rx_retry.)
    localparam cfg_rx_retry_pkt_count = 25;

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

    reg  [7:0]  state, state_1, state_2;
    localparam  STATE_TX                = 8'b00000001;
    localparam  STATE_LINK_RETRY_INIT   = 8'b00000010;
    localparam  STATE_LINK_RETRY_RESEND = 8'b00000100;
    localparam  STATE_RX_IRTRY          = 8'b00001000;

    wire    link_retry_init = state == STATE_LINK_RETRY_INIT,
            link_retry_resending = state == STATE_LINK_RETRY_RESEND,
            rx_start_retry = state == STATE_RX_IRTRY;

    // multi-field config/control register. driven from the picobus.
    reg  [31:0]         cfg0 = 'h0;

    // this register is used to determine if we have already outputted the first
    // FLITS on the data bus and are currently waiting for the TCR to be >
    // len_sum in order to to output the remaining FLITs on that bus
    reg                 first_flits_sent;

    // we can quiesce our traffic on demand.
    wire                quiesce = cfg0[0];
    reg                 quiesce_1;

    reg  [4:0]          retry_pkt_count = 0;
    wire [7:0]          rrp=8'h0; //TODO wire this up.
    reg  [7:0]          rx_err_abort_rp_reg; // save the rp for an rx ErrorAbort.
    wire [63:0]         irtry_head, irtry_tail, rx_irtry_tail;
    wire [127:0]        irtry_pkt = {irtry_tail, irtry_head};
    wire [127:0]        rx_irtry_pkt = {rx_irtry_tail, irtry_head};
    reg  [FLITS-1:0]    start_link_retry_mask_reg;
    wire [FLITS-1:0]    retry_mask = din_retry_start ? start_link_retry_mask_reg : {FLITS{1'b1}};
    reg  [7:0]          cnt_rx_irtry=0;
    
    // in the event of a TX retry, we likely respond to the first TX retry
    // request (from the HMC) after it has already sent the 2nd request (which
    // is likely flowing through our RX pipeline somewhere).  we therefore
    // need to respond to the first request, but not the 2nd one (or even the
    // 3rd possibly).  we use a signal (retry_armed) which is asserted when we
    // should actually pay attention to the retry requests.  After we start
    // the retry, we should de-assert retry_armed.  we then use a timeout
    // counter (retry_arm_cnt) to know how long we should hold retry_armed low
    // for.  we let software control the reset value for this down-counter by
    // setting retry_arm_cnt_rst_val via the debug bus.
    reg  [15:0]         retry_arm_cnt = 0;
    reg  [15:0]         retry_arm_cnt_1;
    reg  [15:0]         retry_arm_cnt_rst_val = 16'hFFFF;
    reg  [15:0]         retry_arm_cnt_rst_val_1;
    reg  [15:0]         retry_arm_cnt_rst_val_2;

    wire carry = pkt_carry_in; //0; // placeholder for the packet carryover input bit.
    reg  carry_waiting;

    // tracks the number of tx and rx retries that we have done
    reg     [7:0]       cnt_tx_retry    = 0;
    reg                 inc_tx_retry    = 0;
    reg     [7:0]       cnt_rx_retry    = 0;
    reg                 inc_rx_retry    = 0;

    ////////////////
    // MANAGE TCR //
    ////////////////

    //`define GREGS_DEBUGGING_STOP_AND_GO_TOKENS
    `ifdef GREGS_DEBUGGING_STOP_AND_GO_TOKENS
    reg [3+4:0] fake_rtc='h0;
    reg         fake_rtc_valid=0;
    initial begin
        #50000;
        @(posedge clk);
        fake_rtc        <= 8'h30;
        fake_rtc_valid  <= 1;
        @(posedge clk);
        fake_rtc        <= 8'h0;
        fake_rtc_valid  <= 0;

        #50000;
        @(posedge clk);
        fake_rtc        <= 8'h30;
        fake_rtc_valid  <= 1;
        @(posedge clk);
        fake_rtc        <= 8'h0;
        fake_rtc_valid  <= 0;
    end
    `endif

    // 0-latency computation for the rtc (qualified with the rtc_valid signal)
    // Note: this is the amount that gets added to the TCR
    reg [3+4:0]             rtc_q=0;
    reg [3+4:0]             rtc_q1=0;
    // 0-latency qualifying computation for the length of new packets that we are sending to the HMC (qualified with the tx_rdy_in signal)
    reg [LOG_SUM_W-1:0]     len_sum_q=0;
    always @ (*) begin
        // the rtc input is only valid when the 'rtc_valid' signal is asserted
        // A2) rtc_valid and rtc have already been synchronized to this clock (clk)
        `ifdef GREGS_DEBUGGING_STOP_AND_GO_TOKENS
        if (fake_rtc_valid) rtc_q = fake_rtc;
        else                rtc_q = 0;
        `else
        if (rtc_valid)  rtc_q = rtc;
        else            rtc_q = 0;
        `endif

        // the length sum should only be decremented when we are actually accepting data from the input bus into our register
        // this means we are sending FLITs for new packets
        if (tx_valid_in && tx_rdy_in && (state == STATE_TX))    len_sum_q   = len_sum_in;
        else                                                    len_sum_q   = 0;
    end

    // this is the token count register (TCR)
    // Note: this tells the number of FLITs that the input buffer inside the HMC can hold
    // XXX: gme has tcr starting at zero till we can either inject tokens successfully, or catch the initial trets from the hmc.
    reg [9:0]               tcr=10'h0;
    always @ (posedge clk) begin
        if (rst) begin
            tcr <= 10'h0;
            //if (verbose) $display("[%t] %s : resetting TCR to 0", $time, name);
        end else begin
            tcr <= tcr + rtc_q1 - len_sum_q;
            if (verbose) begin
                if (rtc_q1 > 0)                  $display("[%t] %s : TCR = %d, receiving RTC = %d", $time, name, tcr, rtc_q1);
                if (len_sum_q > 0)              $display("[%t] %s : TCR = %d, issuing new packet lengths = %d, len_sum_in = %d, len_in = 0x%x", $time, name, tcr, len_sum_q, len_sum_in, len_in);
                if (rtc_q1 > 0 || len_sum_q > 0) $display("[%t] %s : new TCR = %d", $time, name, tcr + rtc_q1 - len_sum_q);
            end
        end
        // we register the rtc count in order to improve timing in the system
        rtc_q1  <= rtc_q;
    end

    ////////////////////////////
    // SELECT THE OUTPUT DATA //
    ////////////////////////////

    // we use these internal signals as registers, then we just assign the
    // output wires to these respective registers
    reg [W-1:0]         tx_data=0;
    reg [FLITS-1:0]     pkt_map=0;
    reg [FLITS-1:0]     sof_map=0;
    reg [FLITS-1:0]     eof_map=0;
    reg [4*FLITS-1:0]   len=0;
    reg [LOG_SUM_W-1:0] len_sum=0;

    assign rx_irtry_tail = {
        32'h0,
        5'h0,               /* RTC */
        3'h0,               /* SLID */
        5'h0,               /* res */
        3'h0,               /* SEQ */
        8'h1,               /* FRP */ // setting FRP[0] makes this a StartRetry packet, rather than a ClearErrorAbort one.
        rx_err_abort_rp_reg[7:0] /* RRP */
    };
    assign irtry_tail = {
        32'h0,
        5'h0,               /* RTC */
        3'h0,               /* SLID */
        5'h0,               /* res */
        3'h0,               /* SEQ */
        8'h2,               /* FRP */ // setting FRP[1] makes this a ClearErrorAbort packet, rather than a StartRetry one.
        rrp[7:0]            /* RRP */
    };
    assign irtry_head = {
        3'h0,               /* CUB */
        3'h0,               /* res */
        34'h0,              /* ADRS */
        9'h0,               /* TAG */
        4'h1,               /* DLN */
        4'h1,               /* LNG */
        1'h0,               /* res */
        6'h3                /* CMD */
    };

    // detemine which data to send on the output data bus
    // A3) we have 1 cycle of latency through this module
    // A6) this register assumes that if the tx_rdy_in signal is de-asserted, then the input data will NOT change
    // A7) if the HMC link is not trained, then the reset will be asserted into this module
    always @ (posedge clk) begin
        rx_err_abort_rdy    <= 0;
        quiesce_1           <= quiesce;
        inc_tx_retry        <= 0;
        inc_rx_retry        <= 0;


        if (start_link_retry && ~retry_armed) 
            start_link_retry_rdy<= 1;
        else
            start_link_retry_rdy<= 0;

        if (start_link_retry && start_link_retry_rdy && retry_armed)
            start_link_retry_mask_reg   <= start_link_retry_mask;
            
        if (retry_arm_cnt_1 == 0)
            retry_armed             <= 1;

        if (rst) begin
            state                   <= STATE_TX;
            first_flits_sent        <= 0;
            tx_data                 <= 'hX; // unnecessary now that we're masking the data after this module, right?
            pkt_map                 <= 'h0;
            sof_map                 <= 'h0;
            eof_map                 <= 'h0;
            len                     <= 'hX;
            len_sum                 <= 'hX;
            retry_armed             <= 1;
            carry_waiting           <= 0;
            cnt_rx_irtry            <= 0;
        end else begin
            case (state)
                STATE_RX_IRTRY: begin
                    // this is just an interruption in the normal tx data, but should not affect the tx data in any other way (besides time).
                    //   (unlike STATE_LINK_RETRY_INIT, which rewinds the tx data for replay after sending the IRTRYs.)

                    tx_data     <= {FLITS{rx_irtry_pkt[127:0]}};
                    pkt_map     <= {FLITS{1'b1}};
                    sof_map     <= {FLITS{1'b1}};
                    eof_map     <= {FLITS{1'b1}};
                    len         <= {FLITS{4'h1}};
                    len_sum     <= FLITS; //TODO kinda. not really applicable, though.

                    retry_pkt_count <= retry_pkt_count + FLITS;
                    if (retry_pkt_count + FLITS >= cfg_rx_retry_pkt_count) begin
                        state               <= STATE_TX;
                        $display("[%t] %s : done sending rx StartRetry IRTRY packets", $time, name);
                    end
                end

                STATE_LINK_RETRY_INIT: begin

                    tx_data     <= {FLITS{irtry_pkt[127:0]}};
                    pkt_map     <= {FLITS{1'b1}};
                    sof_map     <= {FLITS{1'b1}};
                    eof_map     <= {FLITS{1'b1}};
                    len         <= {FLITS{4'h1}};
                    len_sum     <= FLITS; //TODO kinda. not really applicable, though.

                    // clean up stuff for when we leave this state
                    first_flits_sent        <= 0;

                    retry_armed         <= 0; // handles too-rapid retry requests gracefully. (don't get stuck in a loop).

                    retry_pkt_count <= retry_pkt_count + FLITS;
                    if (retry_pkt_count + FLITS >= cfg_retry_pkt_count) begin
                        $display("[%t] %s : done sending LinkRetry_Init IRTRY packets", $time, name);
                        //link_retry_init         <= 0;
                        //link_retry_resending    <= 1;
                        state   <= STATE_LINK_RETRY_RESEND;
                    end
                end

                STATE_LINK_RETRY_RESEND: begin
                    if (tx_valid_in) begin
                        if (verbose) $display("[%t] %s : in link_retry_resending state. din_retry:%d, din_retry_start:%d, pkt_map_in:%b, retry_mask:%b, data:0x%x",
                                                $time, name, din_retry, din_retry_start, pkt_map_in, retry_mask, tx_data_in);
                        tx_data     <= tx_data_in;
                        pkt_map         <= pkt_map_in & retry_mask; // this will get applied to sof, eof, etc later.
                        sof_map         <= sof_map_in;
                        eof_map         <= eof_map_in;
                        len             <= len_in;
                        len_sum         <= len_sum_in;
                        //TODO when to leave this state?
                        if (din_retry_end) begin
                            //link_retry_resending    <= 0;
                            state       <= STATE_TX;
                            if (verbose) $display("[%t] %s : leaving link_retry_resending state", $time, name);
                        end
                    end
                end

                STATE_TX: begin
                    // it's safe to send the data on through unconditionally, since we're setting the masks in this block.
                    tx_data     <= tx_data_in;

                    // checking tx_rdy_in includes checking quiesce, etc
                    if (tx_valid_in && tx_rdy_in) begin
                        pkt_map         <= pkt_map_in;
                        sof_map         <= sof_map_in;
                        eof_map         <= eof_map_in;
                        len             <= len_in;
                        len_sum         <= len_sum_in;
                        carry_waiting   <= carry;
                        if (verbose) begin
                            $display("[%t] %s : issuing all FLITS on the data bus: pkt_map=0x%h, sof_map=0x%h, eof_map=0x%h, carry=%d",
                                    $time, name, pkt_map_in, sof_map_in, eof_map_in, carry);
                        end
                    end else begin
                        pkt_map         <= 'h0;
                        sof_map         <= 'h0;
                        eof_map         <= 'h0;
                        len             <= 'h0;
                        len_sum         <= 'h0;
                        if (tx_valid_in && carry_waiting) begin
                            $display("[%t] %s : FAILED TO ISSUE CARRIED PACKET!!! 5", $time, name);
                            $finish;
                        end
                        if (tx_valid_in) begin
                            if (verbose) begin
                                //$display("[%t] %s : NOT issuing FLITS that are available. out of tokens (%d)", $time, name, tcr);
                            end
                        end
                    end

                    // if we're not in the middle of a packet (where we can't be interrupted),
                    // check to see if we should move into one of the retry states.
                    if (~tx_valid_in || ~tx_rdy_in || ~carry) begin
                        // we prioritize 'tx retry' responses since the hmc is running a timer waiting for our response.
                        if (start_link_retry && retry_armed) begin
                            start_link_retry_rdy<= 1;
                            //link_retry_init     <= 1;
                            state               <= STATE_LINK_RETRY_INIT;
                            retry_pkt_count     <= 'h0;
                            inc_tx_retry        <= 1;
                            $display("[%t] %s : starting LinkRetry_Init with %d IRTRY packets (data:0x%x)", $time, name, cfg_retry_pkt_count, irtry_pkt);
                            $display("[%t] %m : start_link_retry asserted, and we can start a retry", $time);
                        end else if (rx_err_abort_valid) begin
                            retry_pkt_count     <= 'h0;
                            rx_err_abort_rdy    <= 1; // ack the abort signal to clear it.
                            rx_err_abort_rp_reg <= rx_err_abort_rp;
                            inc_rx_retry        <= 1;
                            state               <= STATE_RX_IRTRY;
                            cnt_rx_irtry        <= cnt_rx_irtry + 1;
                            $display("[%t] %s : got RX ErrorAbort going to IRTRY tx state. rp:0x%x/%d", $time, name, rx_err_abort_rp, rx_err_abort_rp);
                            $display("[%t] %m : rx_err_abort_valid asserted, and we can start a retry", $time);
                        end else if (start_link_retry) begin
                            $display("[%t] %m : start_link_retry asserted, but we are not armed (retry_armed=%0d). retry_arm_cnt = 0x%0h", $time, retry_armed, retry_arm_cnt);
                        end
                    end else if (start_link_retry) begin
                        $display("[%t] %m : start_link_retry asserted, but I have to wait a cycle before we can start a retry", $time);
                    end else if (rx_err_abort_valid) begin
                        $display("[%t] %m : rx_err_abort_valid asserted, but I have to wait a cycle before we can start a retry", $time);
                    end
                end
            endcase
        end
    end

    // -we know that we can send new data when we are in the transmit state and
    // we are not low on tokens
    // -if we are doing a retry, we don't worry about tokens, because those
    // have already been accounted for
    // Note: we compare our TCR to a raw value instead of the actual number of
    // tokens for this data beat to improve timing. we will use the real token
    // count when updating our tcr later. this really only makes a difference
    // if we are getting low on tokens, and we make the assumption (for now)
    // that we have enough to not have to worry about that
    assign tx_rdy_in =  (state == STATE_TX && (carry_waiting || (tcr >= (FLITS-1+MAX_PKT_LEN) && !quiesce_1))) ||
                        (state == STATE_LINK_RETRY_RESEND);

    /*always @(posedge clk) begin
        if (!rst) begin
            if (verbose && |pkt_map)
                $display("[%t] %s : tx_data_out: 0x%x,0x%x,0x%x,0x%x,0x%x",
                    $time, name,
                    tx_data_out[639:512], tx_data_out[511:384], tx_data_out[383:256], tx_data_out[255:128], tx_data_out[127:0]);
        end
    end*/
        
    // when we start a retry, we set this down-counter to its reset value
    // we know that it's ok to start another retry when this counter hits 0
    // Note: if we see a TX retry request come into this module and this
    // counter is non-zero, we should totally ignore (i.e. assert the ready
    // signal to acknowledge that we saw it, but DO NOT start a new TX retry)
    // Note: our counter starts counting once we exit STATE_LINK_RETRY_INIT
    always @ (posedge clk) begin
        // if we start a TX retry, then set this count to its reset value
        // else we just do a down-counter that stops once it gets to 0
        if (state == STATE_LINK_RETRY_INIT) begin
            retry_arm_cnt           <= retry_arm_cnt_rst_val_2;
        end else if (retry_arm_cnt != 0) begin
            retry_arm_cnt           <= retry_arm_cnt - 1;
        end
        // pipelined counter to improve timing
        retry_arm_cnt_1             <= retry_arm_cnt;
        // synchronize the retry arm reset value to our clock
        retry_arm_cnt_rst_val_1     <= retry_arm_cnt_rst_val;
        retry_arm_cnt_rst_val_2     <= retry_arm_cnt_rst_val_1;
    end

    ////////////////////////
    // Assign the Outputs //
    ////////////////////////

    assign tx_data_out  = tx_data;
    assign pkt_map_out  = pkt_map;
    assign sof_map_out  = sof_map;
    assign eof_map_out  = eof_map;
    assign len_out      = len;
    assign len_sum_out  = len_sum;

    // control regs that need to be brought back into the hmc clock domain from the debug bus.
    reg  [31:0]         cfg0_dbg='h0, cfg0_sync;
    always @(posedge clk) begin
        if (rst) begin
            cfg0        <= 0;
            cfg0_sync   <= 0;
        end else begin
            cfg0_sync   <= cfg0_dbg;
            cfg0        <= cfg0_sync;
        end
    end

    // debugging info
    reg [3+4:0]         rtc_q_shadow;
    reg [LOG_SUM_W-1:0] len_sum_out_shadow;
    reg [31:0]          rtc_count, len_sum_out_count, backpressure_count, active_beat_count;
    reg [15:0]          rdy_info;
    reg [5:0]           len_sum_in_shadow;
    reg                 tx_rdy_in_shadow, tx_valid_in_shadow;
    reg                 tcr_wrap_latch;
    reg                 freeze;
    always @(posedge clk) begin
        if (rst) begin
            freeze              <= 0;
            rtc_q_shadow        <= 'h0;
            len_sum_out_shadow  <= 'h0;
            rtc_count           <= 'h0;
            len_sum_out_count   <= 'h0;
            backpressure_count  <= 'h0;
            active_beat_count   <= 'h0;
            tcr_wrap_latch      <= 0;
            cnt_tx_retry        <= 0;
            cnt_rx_retry        <= 0;
        end else begin
            //TODO add bus control of whether to freeze the status registers when we get start a retry
            //if (start_link_retry)
            //    freeze              <= 1;
            if (tcr[9])
                tcr_wrap_latch      <= 1;

            if (~freeze) begin
                rtc_q_shadow        <= rtc_q1;
                len_sum_out_shadow  <= len_sum_out;
                rtc_count           <= rtc_count + rtc_q_shadow;
                len_sum_out_count   <= len_sum_out_count + len_sum_out_shadow;
                if (tx_valid_in & ~tx_rdy_in)
                    backpressure_count  <= backpressure_count + 1;
                if (tx_valid_in & tx_rdy_in)
                    active_beat_count   <= active_beat_count + 1;
                rdy_info            <= {tx_valid_in, tx_rdy_in,                                                     // 2b
                                        rx_err_abort_valid, rx_err_abort_rdy, rx_err_abort_rp[7:0],                 // 10b
                                        link_retry_resending, rx_start_retry, start_link_retry, link_retry_init};   // 4b
                len_sum_in_shadow   <= len_sum_in;
                tx_rdy_in_shadow    <= tx_rdy_in;
                tx_valid_in_shadow  <= tx_valid_in;
            end

            if (inc_tx_retry) begin
                cnt_tx_retry        <= cnt_tx_retry + 1;
            end
            
            if (inc_rx_retry) begin
                cnt_rx_retry        <= cnt_rx_retry + 1;
            end
        end
    end

    // debug bus interface. a control bits and a lot of debug info.
    reg [31:0]  rtc_count_dbg, len_sum_out_count_dbg, backpressure_count_dbg, active_beat_count_dbg;
    reg [9:0]   tcr_dbg;
    reg [15:0]  rdy_info_dbg;
    reg [5:0]   len_sum_in_dbg;
    reg [7:0]   cnt_rx_irtry_dbg;
    reg         tx_rdy_in_dbg, tx_valid_in_dbg;
    reg         tcr_wrap_latch_dbg;
    reg [15:0]  retry_arm_cnt_dbg;
    reg [15:0]  retry_arm_cnt_dbg_1;
    reg                 retry_armed_dbg;
    reg                 retry_armed_dbg_1;
    reg     [7:0]       cnt_tx_retry_1  = 0;
    reg     [7:0]       cnt_tx_retry_2  = 0;
    reg     [7:0]       cnt_rx_retry_1  = 0;
    reg     [7:0]       cnt_rx_retry_2  = 0;
    always @(posedge debug_clk) begin
        // move debug-bus-readable signals to the debug_clk domain.
        rtc_count_dbg           <= rtc_count;
        len_sum_out_count_dbg   <= len_sum_out_count;
        tcr_dbg                 <= tcr;
        backpressure_count_dbg  <= backpressure_count;
        rdy_info_dbg            <= rdy_info;
        len_sum_in_dbg          <= len_sum_in_shadow;
        tx_rdy_in_dbg           <= tx_rdy_in_shadow;
        tx_valid_in_dbg         <= tx_valid_in_shadow;
        active_beat_count_dbg   <= active_beat_count;
        tcr_wrap_latch_dbg      <= tcr_wrap_latch;
        cnt_rx_irtry_dbg        <= cnt_rx_irtry;
        state_1                 <= state;
        state_2                 <= state_1;
        retry_arm_cnt_dbg       <= retry_arm_cnt_1;
        retry_arm_cnt_dbg_1     <= retry_arm_cnt_dbg;
        retry_armed_dbg         <= retry_armed;
        retry_armed_dbg_1       <= retry_armed_dbg;
        cnt_tx_retry_1          <= cnt_tx_retry;
        cnt_tx_retry_2          <= cnt_tx_retry_1;
        cnt_rx_retry_1          <= cnt_rx_retry;
        cnt_rx_retry_2          <= cnt_rx_retry_1;

        debug_dout  <= 'h0;

        if (debug_rd) begin
            case (debug_addr[31:0])
                32'h430:        debug_dout  <= {{4{tx_rdy_in_dbg}}, rdy_info_dbg[15:0], 1'h0, tcr_wrap_latch_dbg, tcr_dbg[9:0]};
                32'h434:        debug_dout  <= rtc_count_dbg;
                32'h438:        debug_dout  <= len_sum_out_count_dbg;
                32'h43c:        debug_dout  <= backpressure_count_dbg;
                32'h440:        debug_dout  <= {20'hdecae, 2'h0, {4{tx_valid_in_dbg}}, len_sum_in_dbg[5:0]};
                32'h444:        debug_dout  <= active_beat_count_dbg;
                32'h448:        debug_dout  <= cnt_rx_irtry_dbg;
                32'h44c:        debug_dout  <= state_2;
                32'h450:        debug_dout  <= cfg0_dbg;
                32'h454:        debug_dout  <= cnt_tx_retry_2;
                32'h458:        debug_dout  <= cnt_rx_retry_2;
                32'h460:        debug_dout  <= retry_arm_cnt_rst_val;
                32'h464:        debug_dout  <= retry_arm_cnt_dbg_1;
                32'h468:        debug_dout  <= retry_armed_dbg_1;
            endcase
        end

        if (debug_wr) begin
            case (debug_addr[31:0])
                32'h448:        retry_arm_cnt_rst_val   <= debug_din;
                32'h450:        cfg0_dbg    <= debug_din;
            endcase
        end
    end

endmodule
