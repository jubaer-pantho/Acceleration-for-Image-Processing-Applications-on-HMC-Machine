/*
 * File Name     : hmc_flow_control.v
 *
 * Author        : Corey Olson
 *
 * Description   : This module implements token flow control on the transmit
 *                 side of the link to guarantee that we do not overflow the
 *                 HMC receive buffer.  It does this by tracking the number of
 *                 FLITs that the HMC receive buffer can hold.  When we issue
 *                 a new FLIT (or set of FLITs) to the HMC, we decrement
 *                 a token count register (TCR).  When the HMC has removed
 *                 those FLITs from its receive buffer, it returns those
 *                 tokens to us, which is either in the form of a Token RET
 *                 packet (TRET) or a normal response packet with an embedded
 *                 Return Token Count (RTC) field.  Note that a different
 *                 module (rtc.v) extracts the returned token information and
 *                 provides that count to this module.
 *
 *                 Whenever the token count (for the HMC receive buffer) gets
 *                 too low, this module tells the higher-level HMC controller
 *                 logic to slow down / stop sending request packets.  It does
 *                 this by de-asserting its din_rdy output.
 *                 However, there may already be many FLITs/packets in flight
 *                 from the high-level control logic to this flow control
 *                 module, so we instantiate a FIFO at the input to this
 *                 module, which will buffer ALL of those packets/FLITs that
 *                 are already in flight.  If this module stops sending actual
 *                 FLITS/packets due to a low token count, then it will
 *                 generate NULL FLITs and send those to the HMC controller
 *                 PHY, because the NULL FLITs do not count against the flow
 *                 control token count.
 *
 *                 At the output of this FIFO, we instantiate a packet issue
 *                 module, which controls the issuing of new packets to the
 *                 PHY.  If there are no valid packets in the input FIFO, then
 *                 this module will issue NULL packets to the PHY.  The packet
 *                 issue module also determines when we need to stop sending
 *                 request packets to the HMC by comparing the length fields
 *                 on the data bus (from the input FIFO) to the current TCR.
 *                 If we cannot send all FLITS associated with the SOF FLITs
 *                 on the current data beat, then we do not send any of them.
 *
 *                 It's possible that we will finish sending a packet (packet
 *                 0) during data beat 1 whose header FLIT was from a previous
 *                 data beat (e.g. data beat 0).  It's also possible that we
 *                 want to start sending a new packet (e.g. packet 1) on data
 *                 beat 1.  However, if the HMC receive buffer just filled up
 *                 with the FLITs from packet 0 (we know this by checking the
 *                 TCR), then we better not start sending the FLITs for packet
 *                 1 until we have received some tokens back from the HMC
 *                 (meaning the recieve buffer now has more room).  Also, we
 *                 better finish sending the FLITs for packet 0, so as to not
 *                 insert NULL flits in the middle of a packet.  Therefore, if
 *                 we cannot send all FLITs for a data beat, then we inject
 *                 NULL FLITs on the output data bus starting at the first
 *                 FLIT on the bus with the SOF bit asserted.  Similarly,
 *                 when we do receive tokens back from the HMC, we do not want
 *                 to resend the tail of a previous packet, so we inject NULL
 *                 FLITs on the output data bus up to (but not including) the
 *                 FLIT with the first SOF bit asserted.
 *
 * Tasks         :
 *                  - maintains a token count register (TCR), which is the
 *                    available space in the receive buffer for the HMC
 *                      - if no TX packet at input, sends NULL packets
 *                      - else parallel-computes LNG of all FLITs w/ SOF
 *                        asserted and compares to TCR
 *                          - if LNG <= TCR, sends data beat packet & decrements TCR
 *                          - if LNG > TCR, sends masked data beat (don't send
 *                            any new packets)
 *                  - accepts rtc from rtc.v; adds to TCR
 *                  - includes some debug counters / status registers
 *
 * Assumptions   :
 *                A1) NULL FLITs do not count against the flow control token
 *                count for the HMC receive buffer.
 *                A2) this module should generate NULL FLITs and send them to
 *                the HMC controller PHY in the event that the token count
 *                gets too low.
 *                A3) this module will generate NULL FLITs in the event that
 *                we do not have any valid packets to send at the input of
 *                this module.
 *                A4) if we receive the start of a packet on the input to this
 *                module, we wil not get any NULL FLITs until after the last
 *                FLIT for that packet is received (i.e. no NULL FLITs
 *                inserted in the middle of a packet)
 *                A5) rtc module has crossed from the RX to the TX clock
 *                domain, so the rtc input is synchronous to the TX clock domain
 *                A6) some module in the higher-level logic of the
 *                controller's TX pipeline generates a pkt_map, sof_map,
 *                eof_map, and len fields
 *                A7) after this module, we don't need the pkt_map, eof_map,
 *                or sof_map
 *                A8) we decrement the TCR when we send the header FLIT for
 *                a packet, even if that packet has FLITs that get sent on the
 *                next data beat.
 *                A9) the data at the output of the hmc_sync_tx_fifo
 *                (tx_data_1) will not change unless rd_en signal (tx_rdy_in)
 *                is asserted while empty signal (tx_empty_1) is deasserted
 *                A10) the rx_rrp and rx_frp will maintain their last valid value
 *                even after we accept it by asserting ready. this is altera fifo behavior.
 *
 * Schematic     :
 *
 *               -----------         -------             -----------
 *      ------> |   sum     | ----> | tx    | --------> | packet    | --->
 *              |   length  |  |    | FIFO  |           | issue     |
 *               -----------   |     -------             -----------
 *               -------       |
 *              | apply | -----.
 *              | masks |
 *               -------
 *
 * Notes         :
 *                  1) could have masked the data bus before the tx data FIFO,
 *                      but that would have increased the width of the FIFO by
 *                      2*640 bits
 *                  2) could have computed the sum of the FLIT length fields
 *                      after the tx FIFO, but I think we want as few stages as
 *                      possible between the TX fifo and the packet issue module
 *
 * Copyright     : 2013, Pico Computing, Inc.
 */

`timescale 1ns / 1ps

`include "hmc_def.vh"
`include "hmc_cfg.vh"

module hmc_flow_control #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FRP_W         = 10,               // internal FRP width (in bits)
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

    // return token count (RTC) from rtc module
    // Note: assume this is synchronous to the TX clock
    input                   rtc_valid,
    input   [3+4:0]         rtc,                // the rtc field is only 5b, but we may need to aggregate FLITS # of maximal rtc values.
                                                //   (the +3 should "really" be +log2(FLITS) )

    // TX Input Stream
    input   [FLITS-1:0]     pkt_map_in,
    input   [FLITS-1:0]     sof_map_in,
    input   [FLITS-1:0]     eof_map_in,
    input   [4*FLITS-1:0]   len_in,
    input                   pkt_carry_in,
    input   [W-1:0]         tx_data_in,
    input                   tx_valid_in,
    output                  tx_rdy_in,

    // these are the FRPs that have already been embedded in our data stream
    input   [FRP_W*FLITS-1:0]   new_frps,
    input   [FLITS-1:0]         new_frps_map,
    input   [9:0]               new_frps_buf_inx,
    input                       new_frps_valid,

    // these are our original FRPs that have been returned by the HMC
    // our slave captured these as RRPs and is now giving them to us
    // Note: assume these have already been synchronized to the tx_clk domain
    input   [7:0]           rx_rrp,
    input                   rx_rrp_valid,
    output                  rx_rrp_ready,

    // these are FRPs from the HMC
    // our slave captured these and is now giving them to us
    // we should now send these to the HMC as RRPs
    // Note: assume these have already been synchronized to the tx_clk domain
    input   [7:0]           rx_frp,
    input                   rx_frp_valid,
    output                  rx_frp_ready,

    // we get this retry pointer from an IRTRY packet from the HMC
    // this tells us that we should start our retry at start_retry_rp, so we
    // need to hand this to our rp_to_index module to turn this into a tx
    // buffer entry and a flit mask for the first data beat of our retry
    input   [7:0]           start_retry_count,
    input   [7:0]           start_retry_rp,
    input                   start_retry_valid,
    output                  start_retry_rdy,

    input                   rx_err_abort_valid,
    output                  rx_err_abort_rdy,
    input   [7:0]           rx_err_abort_rp,

    // TX Output Data (to PHY)
    output  [W-1:0]         tx_data_out,

    // Output Data
    // Note: this will most likely get synthesized out
    output  [FLITS-1:0]     pkt_map_out,
    output  [FLITS-1:0]     sof_map_out,
    output  [FLITS-1:0]     eof_map_out,
    output  [4*FLITS-1:0]   len_out,

    // Debug Bus
    input               debug_clk,
    input       [31:0]  debug_addr,
    input       [31:0]  debug_din,
    output      [31:0]  debug_dout,
    input               debug_rd,
    input               debug_wr
);

    `include "hmc_func.h.v"

    localparam PRECOMPUTE_LATENCY = 1;

    integer i;

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

    //////////////////////
    // internal signals //
    //////////////////////

    // we feed our start retry and start retry valid signals into the
    // rp_to_index module
    // we get these signals out of that module
    wire    [9:0]           tx_frps_buf_inx;
    wire                    start_retry_valid_q;
    wire    [FLITS-1:0]     tx_frps_replay_start_mask;
    wire    [7:0]           start_retry_rp_q;

    // these signals are the outputs of the module that sums up the lengths
    wire    [FLITS-1:0]     pkt_map_0;
    wire    [FLITS-1:0]     sof_map_0;
    wire    [FLITS-1:0]     eof_map_0;

    wire    [FLITS-1:0]     pkt_map_first_flits_0;
    wire    [FLITS-1:0]     sof_map_first_flits_0;
    wire    [FLITS-1:0]     eof_map_first_flits_0;

    wire    [FLITS-1:0]     pkt_map_last_flits_0;
    wire    [FLITS-1:0]     sof_map_last_flits_0;
    wire    [FLITS-1:0]     eof_map_last_flits_0;

    wire    [4*FLITS-1:0]   len_0;
    wire    [LOG_SUM_W-1:0] sum_len_0;
    wire                    pkt_carry_0;
    wire    [W-1:0]         tx_data_0;
    wire                    tx_valid_0;
    wire                    tx_full_0;

    // these signals are all outputs of the FIFO that buffers FLITs (even when tx_rdy_in gets deasserted)
    wire    [FLITS-1:0]     pkt_map_1;
    wire    [FLITS-1:0]     sof_map_1;
    wire    [FLITS-1:0]     eof_map_1;
    wire    [FLITS-1:0]     pkt_map_first_flits_1;
    wire    [FLITS-1:0]     sof_map_first_flits_1;
    wire    [FLITS-1:0]     eof_map_first_flits_1;
    wire    [FLITS-1:0]     pkt_map_last_flits_1;
    wire    [FLITS-1:0]     sof_map_last_flits_1;
    wire    [FLITS-1:0]     eof_map_last_flits_1;
    wire    [4*FLITS-1:0]   len_1;
    wire    [LOG_SUM_W-1:0] sum_len_1;
    wire                    pkt_carry_1;
    wire    [W-1:0]         tx_data_1;
    wire                    tx_empty_1;
    wire                    tx_data_valid_1;
    wire                    data_retry_1, data_retry_start_1, data_retry_end_1;

    // hmc_packet_issue -> hmc_apply_flit_mask connection
    wire    [FLITS-1:0]     pkt_map_3;
    wire    [FLITS-1:0]     sof_map_3;
    wire    [FLITS-1:0]     eof_map_3;
    wire    [4*FLITS-1:0]   len_3;
    wire    [LOG_SUM_W-1:0] sum_len_3;
    wire    [W-1:0]         tx_data_3;

    // hmc_apply_flit_mask connection -> hmc_inject_pret connection
    wire    [FLITS-1:0]     pkt_map_4;
    wire    [FLITS-1:0]     sof_map_4;
    wire    [FLITS-1:0]     eof_map_4;
    wire    [4*FLITS-1:0]   len_4;
    wire    [LOG_SUM_W-1:0] sum_len_4;
    wire    [W-1:0]         tx_data_4;

    // hmc_inject_pret connection -> hmc_add_rrp connection
    wire    [FLITS-1:0]     pkt_map_5;
    wire    [FLITS-1:0]     sof_map_5;
    wire    [FLITS-1:0]     eof_map_5;
    wire    [4*FLITS-1:0]   len_5;
    wire    [LOG_SUM_W-1:0] sum_len_5;
    wire    [W-1:0]         tx_data_5;

    // Note: this is an unused output
    wire    [LOG_SUM_W-1:0] sum_len_out;

    wire tx_rdy_pkt_issue, tx_almost_full;
    assign tx_rdy_in = ~tx_almost_full;

    wire [31:0]     tx_log4_dout, tx_log5_dout, debug_dout_packet_issue;
    wire [31:0]     debug_dout_rp_to_index;
    reg  [31:0]     debug_dout_internal;

    wire            retry_armed;
    assign debug_dout[31:0] =   debug_dout_internal |
                                tx_log4_dout |
                                tx_log5_dout |
                                debug_dout_rp_to_index |
                                debug_dout_packet_issue;

    ///////////////////////////////////////////////////
    // CONVERT RETRY POINTERS TO TX BUFFER LOCATIONS //
    ///////////////////////////////////////////////////

    // -when we start a retry, we will start our retry from our last received
    // RRP from the HMC (which is really the last FRP that the HMC received
    // successfully).  we get that from start_retry_rp input
    // -we then need to convert that rrp value to a location in our tx buffer
    // where we need to start transmitting from
    // -we can look that up if we store our buffer locations for each FRP as
    // we are transmitting outgoing packets
    // -we also need to compute a mask for each FRP that tells which of those
    // FLITS can be replayed when we startup during our retry
    // Note: we may need to store the same tx buffer address for 'FLITS'
    // different FRPs every clock cycle
    // Note: when we need to read this memory (probably VERY infrequent) we
    // will need to produce a tx buffer location for 1 RRP
    rp_to_index_wrapper #(
        .name               ({name,".rp_to_index_wrapper"}  ),
        .verbose            (1                  ),
        .FLITS              (FLITS              ),
        .INX_W              (10),
        .FRP_W              (FRP_W),
        .RRP_W              (8)
    ) rp_to_index_wrapper_inst (
        .clk                (clk),
        .rst                (rst),
        
        .debug_clk          (debug_clk),
        .debug_rd           (debug_rd),
        .debug_wr           (debug_wr),
        .debug_addr         (debug_addr),
        .debug_din          (debug_din),
        .debug_dout         (debug_dout_rp_to_index),
        
        .new_frps           (new_frps),
        .new_frps_map       (new_frps_map),
        .new_frps_buf_inx   (new_frps_buf_inx),
        .new_frps_valid     (new_frps_valid),

        .rx_rrp             (rx_rrp),
        .rx_rrp_valid       (rx_rrp_valid),

        .rrp_in             (start_retry_rp+1),
        .rrp_in_valid       (start_retry_valid),

        .inx_out            (tx_frps_buf_inx),
        .rrp_out            (start_retry_rp_q),
        .inx_out_valid      (start_retry_valid_q),
        .replay_mask_out    (tx_frps_replay_start_mask)
    );

    ///////////
    // logic //
    ///////////

    //TODO how do we handle receiving acks during retry? do we need to special case it, or just handle it with the range check?
    reg  [7:0] rx_rrp_latch;
    assign rx_rrp_ready = 1;

    always @(posedge clk) begin
        if (rst) begin
            rx_rrp_latch        <= 1;
        end else begin
            if (rx_rrp_valid)
                rx_rrp_latch    <= rx_rrp;

            if (rx_rrp_valid && rx_rrp_ready && verbose) $display("[%t] %s : consumed rx_rrp:0x%x", $time, name, rx_rrp);
            //if (rx_rrp_valid && !rx_rrp_ready && verbose) $display("[%t] %s : NOT consumed rx_rrp:0x%x", $time, name, rx_rrp);
            if (start_retry_valid && verbose) $display("[%t] %s : got StartRetry signal. Retry_armed = %d (RP:0x%x, count:%d)", $time, name, retry_armed, start_retry_rp, start_retry_count);
            if (start_retry_valid_q && verbose) $display("[%t] %s : replay_start_mask: %b, tx_frps_buf_inx: 0x%x", $time, name, tx_frps_replay_start_mask, tx_frps_buf_inx);
        end
    end

    // sum up all the len fields for the SOF flits
    hmc_sum_len #(
        .name               ({name,".sum_len"}  ),
        .verbose            (0                  ),
        .LATENCY            (PRECOMPUTE_LATENCY ),
        .MAX_PKT_LEN        (MAX_PKT_LEN        ),
        .FLIT_W             (FLIT_W             ),
        .FLITS              (FLITS              ),
        .W                  (W                  )
    ) sum_len (
        .clk                (clk                ),
        .rst                (rst                ),

        .din                (tx_data_in         ),
        .din_valid          (tx_valid_in        ),
        .pkt_map_in         (pkt_map_in         ),
        .eof_map_in         (eof_map_in         ),
        .sof_map_in         (sof_map_in         ),
        .len_in             (len_in             ),
        .pkt_carry_in       (pkt_carry_in       ),

        .dout               (tx_data_0          ),
        .dout_valid         (tx_valid_0         ),
        .pkt_map_out        (pkt_map_0          ),
        .eof_map_out        (eof_map_0          ),
        .sof_map_out        (sof_map_0          ),
        .len_out            (len_0              ),
        .len_sum_out        (sum_len_0          ),
        .pkt_carry_out      (pkt_carry_0        )
    );

    // module to mask off some FLITs of the data bus
    // 1) unmasked data bus
    // 2) mask off such that we only expose the first flits on the data bus (before the first SOF)
    // 3) mask off such that we only expose the last flits on the data bus (after the first EOF)
    hmc_mask_flits #(
        .name                       ({name,".mask_flits"}   ),
        .verbose                    (verbose                ),
        .LATENCY                    (PRECOMPUTE_LATENCY     ),
        .FLIT_W                     (FLIT_W                 ),
        .FLITS                      (FLITS                  ),
        .W                          (W                      )
    ) flow_control_mask_flits (
        .clk                        (clk                    ),
        .rst                        (rst                    ),

        .pkt_map_in         (pkt_map_in         ),
        .eof_map_in         (eof_map_in         ),
        .sof_map_in         (sof_map_in         ),
        .len_in             (len_in             ),

        .pkt_map_out_first_flits    (pkt_map_first_flits_0  ),
        .eof_map_out_first_flits    (eof_map_first_flits_0  ),
        .sof_map_out_first_flits    (sof_map_first_flits_0  ),

        .pkt_map_out_last_flits     (pkt_map_last_flits_0   ),
        .eof_map_out_last_flits     (eof_map_last_flits_0   ),
        .sof_map_out_last_flits     (sof_map_last_flits_0   )
    );

    /*
     * This is probably the most important FIFO/Buffer in our entire
     * Controller.  If we need to stop sending packets to the HMC, we apply
     * some backpressure up at the user port level.  However, we don't want to
     * drop all the data on the floor that was already in flight between the
     * user logic and the hmc_packet_issue module.  Therefore, we use this
     * buffer to catch all the data.  Therefore, we call this our TX buffer,
     * because all TX data first flows through this buffer.
     * 
     * In the event of an error on the link, it's possible that we will need
     * to resend some packets that we have already sent.  Since we know that
     * all packets flow through this buffer, we re-use this buffer as a form
     * of a retry buffer.  Note that the nomenclature used to talk with this
     * buffer is different from that described in the HMC specification, so
     * please don't be confused by the spec.
     */
    // Note: we assume this FIFO is deep enough to hold all FLITs that are in flight once tx_rdy_in gets deasserted
    // Note: we CANNOT write to this FIFO when it is full without corrupting data (but we assume this FIFO will never go full)
    // Note: we CAN read from this FIFO when it is empty without corrupting data
    hmc_tx_buffer #(
        .name               ({name,".tx_fifo"}   ),
        .verbose            (verbose             ),
        .W                  (FLITS*(FLIT_W+3+3+3+4)+1+LOG_SUM_W )
    ) flow_control_data_hmc_fifo_ (
        .clk                (clk                ),
        .rst                (rst                ),

        .start_retry_valid  (start_retry_valid_q & start_retry_rdy & retry_armed),
        .start_retry_rp     (tx_frps_buf_inx[7:0]),
        .dout_retry         (data_retry_1       ),
        .dout_retry_start   (data_retry_start_1 ),
        .dout_retry_end     (data_retry_end_1   ),

        .din                ({tx_data_0,
                              pkt_map_0,
                              eof_map_0,
                              sof_map_0,
                              pkt_map_first_flits_0,
                              sof_map_first_flits_0,
                              eof_map_first_flits_0,
                              pkt_map_last_flits_0,
                              sof_map_last_flits_0,
                              eof_map_last_flits_0,
                              pkt_carry_0,
                              len_0,
                              sum_len_0}        ),
        .wr_en              (tx_valid_0         ),
        .full               (tx_full_0          ),  // Note: this full signal is unused, because we assume this FIFO will never go full
        .half_full          (tx_almost_full     ),

        .dout               ({tx_data_1,
                              pkt_map_1,
                              eof_map_1,
                              sof_map_1,
                              pkt_map_first_flits_1,
                              sof_map_first_flits_1,
                              eof_map_first_flits_1,
                              pkt_map_last_flits_1,
                              sof_map_last_flits_1,
                              eof_map_last_flits_1,
                              pkt_carry_1,
                              len_1,
                              sum_len_1}        ),
        .rd_en              (tx_rdy_pkt_issue   ),
        .empty              (tx_empty_1         )
    );
    assign tx_data_valid_1  = ~tx_empty_1;

    // debugging help for what's entering and leaving the tx buffer
    always @(posedge clk) begin
        if (!rst) begin
            if (verbose && tx_valid_0) begin
                $display("[%t] %s : writing to tx_buffer: 0x%x, pkt:%b, sof:%b, eof:%b", $time, name, tx_data_0, pkt_map_0, sof_map_0, eof_map_0);
            end
        end
    end

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    flit_logger
        #(.BASE_ADDR(32'hf80000), .NAME("tx_log4"))
    tx4_flit_logger (
        .clk(clk),
        .rst(rst),
        .din(tx_data_1[639:0]),
        .din_aux({/* 45b of pkt map data */
                  pkt_map_1,
                  eof_map_1,
                  sof_map_1,
                  pkt_map_first_flits_1,
                  sof_map_first_flits_1,
                  eof_map_first_flits_1,
                  pkt_map_last_flits_1,
                  sof_map_last_flits_1,
                  eof_map_last_flits_1,
                  /* 19b: */ eof_map_1, 1'h0, sof_map_1, 3'h0, pkt_map_1}),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(tx_log4_dout)
        );
    `else // DISABLE
    assign tx_log4_dout = 'h0;
    `endif // ENABLE_ALL_FLIT_LOGGERS

    // packet issue module to select which data bus to send, control the TCR
    // Note: this module also manages the Token Count Register (TCR)
    // we manage the TCR here because we want it as close to the output of this flow control module as possible
    hmc_packet_issue #(
        .name                       ({name,".packet_issue"} ),
        .verbose                    (verbose                ),
        .FLIT_W                     (FLIT_W                 ),
        .FLITS                      (FLITS                  ),
        .W                          (W                      )
    ) flow_control_packet_issue (
        .clk                        (clk                    ),
        .rst                        (rst                    ),

        .debug_clk                  (debug_clk              ),
        .debug_rd                   (debug_rd               ),
        .debug_wr                   (debug_wr               ),
        .debug_addr                 (debug_addr             ),
        .debug_din                  (debug_din              ),
        .debug_dout                 (debug_dout_packet_issue),

        .start_link_retry           (start_retry_valid_q    ),
        .start_link_retry_rdy       (start_retry_rdy        ),
        .start_link_retry_mask      (tx_frps_replay_start_mask),
        .retry_armed                (retry_armed            ), 

        .rx_err_abort_valid         (rx_err_abort_valid     ),
        .rx_err_abort_rdy           (rx_err_abort_rdy       ),
        .rx_err_abort_rp            (rx_err_abort_rp        ),

        .rtc_valid                  (rtc_valid              ),
        .rtc                        (rtc                    ),

        .tx_valid_in                (tx_data_valid_1        ),
        .tx_rdy_in                  (tx_rdy_pkt_issue       ),

        .tx_data_in                 (tx_data_1              ),
        .pkt_map_in                 (pkt_map_1              ),
        .eof_map_in                 (eof_map_1              ),
        .sof_map_in                 (sof_map_1              ),
        .pkt_map_in_first_flits     (pkt_map_first_flits_1  ),
        .eof_map_in_first_flits     (eof_map_first_flits_1  ),
        .sof_map_in_first_flits     (sof_map_first_flits_1  ),
        .pkt_map_in_last_flits      (pkt_map_last_flits_1   ),
        .eof_map_in_last_flits      (eof_map_last_flits_1   ),
        .sof_map_in_last_flits      (sof_map_last_flits_1   ),
        .len_in                     (len_1                  ),
        .len_sum_in                 (sum_len_1              ),
        .pkt_carry_in               (pkt_carry_1            ),
        .din_retry                  (data_retry_1           ),
        .din_retry_start            (data_retry_start_1     ),
        .din_retry_end              (data_retry_end_1       ),

        .tx_data_out                (tx_data_3              ),
        .pkt_map_out                (pkt_map_3              ),
        .sof_map_out                (sof_map_3              ),
        .eof_map_out                (eof_map_3              ),
        .len_out                    (len_3                  ),
        .len_sum_out                (sum_len_3              )
    );

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    flit_logger
        #(.BASE_ADDR(32'hf70000), .NAME("tx_log5"))
    tx5_flit_logger (
        .clk(clk),
        .rst(rst),
        .din(tx_data_3[639:0]),
        .din_aux({12'h0, len_3[19:0],    3'h0, 5'h0, 3'h0, eof_map_3, 3'h0, sof_map_3, 3'h0, pkt_map_3}),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(tx_log5_dout)
        );
    `else
    assign tx_log5_dout = 'h0;
    `endif // ENABLE_ALL_FLIT_LOGGERS

    hmc_apply_flit_mask #(
        .verbose(verbose)
    ) apply_flit_mask (
        .clk            (clk                    ),
        .rst            (rst                    ),

        .data_i         (tx_data_3              ),
        .pkt_map_i      (pkt_map_3              ),
        .eof_map_i      (eof_map_3              ),
        .sof_map_i      (sof_map_3              ),
        .len_i          (len_3                  ),
        .len_sum_i      (sum_len_3              ),

        .data_o         (tx_data_4              ),
        .pkt_map_o      (pkt_map_4              ),
        .eof_map_o      (eof_map_4              ),
        .sof_map_o      (sof_map_4              ),
        .len_o          (len_4                  ),
        .len_sum_o      (sum_len_4              )
    );

    // thanks to the decision to start FRP at one rather than zero, we need this special-casing till we get a real FRP.
    // TODO: I think we actually want to start this super_frp at 0
    // Reasoning:
    // -assume we send exactly 1 packet to the HMC with RRP=1
    // -now assume the first packet we receive from the HMC has FRP=1
    // -now assume that first packet from the HMC is not received correctly
    // (e.g. CRC error).
    // -since the HMC received our RRP=1, it will think that we received that
    // first packet correctly, so it will not send it during the retry
    // Note: this special case probably ONLY affects the FIRST packet, so
    // let's not worry about this for now
    assign rx_frp_ready = rx_frp_valid;
    reg [7:0] super_frp='h1;
    reg [7:0] super_frp_1;
    always @(posedge clk) begin
        if (rst) begin
            super_frp   <= 1;
        end else if (rx_frp_valid) begin
            super_frp   <= rx_frp;
        end
        super_frp_1     <= super_frp;
    end

    // if our TX pipeline isn't sending anything, let's just send PRETs
    hmc_inject_pret #(
        .verbose(verbose)
    ) inject_pret (
        .clk            (clk                    ),
        .rst            (rst                    ),

        .data_i         (tx_data_4              ),
        .pkt_map_i      (pkt_map_4              ),
        .eof_map_i      (eof_map_4              ),
        .sof_map_i      (sof_map_4              ),
        .len_i          (len_4                  ),
        .len_sum_i      (sum_len_4              ),

        .rrp_i          (super_frp_1            ),

        .data_o         (tx_data_5              ),
        .pkt_map_o      (pkt_map_5              ),
        .eof_map_o      (eof_map_5              ),
        .sof_map_o      (sof_map_5              ),
        .len_o          (len_5                  ),
        .len_sum_o      (sum_len_5              )
    );

    hmc_add_rrp #(
        .verbose(0)
    ) add_rrp (
        .clk            (clk                    ),
        .rst            (rst                    ),

        .rrp            (super_frp_1            ),

        .data_i         (tx_data_5              ),
        .pkt_map_i      (pkt_map_5              ),
        .eof_map_i      (eof_map_5              ),
        .sof_map_i      (sof_map_5              ),
        .len_i          (len_5                  ),
        .len_sum_i      (sum_len_5              ),

        .data_o         (tx_data_out            ),
        .pkt_map_o      (pkt_map_out            ),
        .eof_map_o      (eof_map_out            ),
        .sof_map_o      (sof_map_out            ),
        .len_o          (len_out                ),
        .len_sum_o      (sum_len_out            )
    );

    ///////////
    // DEBUG //
    ///////////

    // diagnostic counters accessible from the debug bus
    reg  [31:0] tx_full_0_count, tx_full_0_count_dbg, tx_empty_1_count, tx_empty_1_count_dbg;
    reg  [31:0] start_retry_valid_count, start_retry_valid_count_dbg;
    reg  [31:0] rx_err_abort_valid_count, 
                rx_err_abort_valid_count_dbg,
                rx_err_abort_valid_count_dbg_1;
    reg  [31:0] rx_err_abort_count, 
                rx_err_abort_count_dbg,
                rx_err_abort_count_dbg_1;
    reg  [31:0] buf_wr_drop_count, buf_wr_drop_count_dbg;
    always @(posedge clk) begin
        if (rst) begin
            tx_full_0_count             <= 'h0;
            tx_empty_1_count            <= 'h0;
            start_retry_valid_count     <= 'h0;
            rx_err_abort_valid_count    <= 'h0;
            rx_err_abort_count          <= 'h0;
            buf_wr_drop_count           <= 'h0;
        end else begin
            if (tx_full_0)              tx_full_0_count             <= tx_full_0_count + 1;
            if (tx_empty_1)             tx_empty_1_count            <= tx_empty_1_count + 1;
            if (start_retry_valid && 
                start_retry_rdy && retry_armed)        start_retry_valid_count     <= start_retry_valid_count + 1;
            if (rx_err_abort_valid)     rx_err_abort_valid_count    <= rx_err_abort_valid_count + 1;
            if (rx_err_abort_valid &&
                rx_err_abort_rdy)       rx_err_abort_count          <= rx_err_abort_count + 1;
            if (tx_full_0 && tx_valid_0)buf_wr_drop_count           <= buf_wr_drop_count + 1;
        end
    end

    // debug bus interface
    reg  [7:0]  max_frp_dbg;
    reg  [7:0]  rx_rrp_dbg;
    always @(posedge debug_clk) begin
        // move all the debug info into the debug_clk domain.
        tx_full_0_count_dbg             <= tx_full_0_count;
        tx_empty_1_count_dbg            <= tx_empty_1_count;
        start_retry_valid_count_dbg     <= start_retry_valid_count;
        max_frp_dbg                     <= new_frps>>(10*(FLITS-1));
        rx_err_abort_valid_count_dbg    <= rx_err_abort_valid_count;
        rx_err_abort_valid_count_dbg_1  <= rx_err_abort_valid_count_dbg;
        rx_err_abort_count_dbg          <= rx_err_abort_count;
        rx_err_abort_count_dbg_1        <= rx_err_abort_count_dbg;
        rx_rrp_dbg                      <= rx_rrp;
        buf_wr_drop_count_dbg           <= buf_wr_drop_count;


        debug_dout_internal <= 'h0;

        if (debug_rd) begin
            case (debug_addr[31:0])
                //32'h700:        debug_dout_internal <= {};
                32'h704:        debug_dout_internal <= tx_full_0_count_dbg;
                32'h708:        debug_dout_internal <= tx_empty_1_count_dbg;
                32'h70c:        debug_dout_internal <= start_retry_valid_count_dbg;
                32'h710:        debug_dout_internal <= {8'h0, rx_rrp_dbg[7:0], 8'h0, max_frp_dbg[7:0]};
                32'h714:        debug_dout_internal <= buf_wr_drop_count_dbg;
                32'h718:        debug_dout_internal <= rx_err_abort_valid_count_dbg_1;
                32'h71c:        debug_dout_internal <= rx_err_abort_count_dbg_1;
            endcase
        end
    end

    always @ (posedge clk) begin
        if (tx_full_0) begin
            $display("[%t] %s : Error: tx_full_0 should never go high!", $time, name);
            $stop;
        end
    end

endmodule
