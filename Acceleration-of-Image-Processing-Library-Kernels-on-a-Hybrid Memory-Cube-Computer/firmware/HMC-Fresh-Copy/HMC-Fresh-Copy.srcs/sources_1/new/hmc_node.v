// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

`include "hmc_cfg.vh"

module hmc_node #(
    parameter name = "",
    parameter BASE_ADDR = 32'h1000,
    // don't change parameters below here without verifying that the code fully supports the new value.
    parameter N_PORTS = 5,
    parameter FLITS = 5,
    parameter FLIT_W = 128
    ) (
    input       tx_clk,
    input       rx_clk,
    input       rst,

    input               logger_rst,
    input               debug_clk,
    input               debug_rst,
    input       [31:0]  debug_addr,
    input       [31:0]  debug_din,
    output      [31:0]  debug_dout,
    input               debug_rd,
    input               debug_wr,

    output              flit_logger_stop,

    input               clk_p0,
    input               cmd_valid_p0,
    output              cmd_ready_p0,
    input        [3:0]  cmd_p0,
    input       [33:0]  addr_p0,
    input        [3:0]  size_p0,
    input        [5:0]  tag_p0,
    input      [127:0]  wr_data_p0,
    input               wr_data_valid_p0,
    output              wr_data_ready_p0,

    output     [127:0]  rd_data_p0,
    output       [5:0]  rd_data_tag_p0,
    output       [7:0]  error_response_p0,
    output              rd_data_valid_p0,
    input               clk_p1,
    input               cmd_valid_p1,
    output              cmd_ready_p1,
    input        [3:0]  cmd_p1,
    input       [33:0]  addr_p1,
    input        [3:0]  size_p1,
    input        [5:0]  tag_p1,
    input      [127:0]  wr_data_p1,
    input               wr_data_valid_p1,
    output              wr_data_ready_p1,

    output     [127:0]  rd_data_p1,
    output       [5:0]  rd_data_tag_p1,
    output       [7:0]  error_response_p1,
    output              rd_data_valid_p1,
    input               clk_p2,
    input               cmd_valid_p2,
    output              cmd_ready_p2,
    input        [3:0]  cmd_p2,
    input       [33:0]  addr_p2,
    input        [3:0]  size_p2,
    input        [5:0]  tag_p2,
    input      [127:0]  wr_data_p2,
    input               wr_data_valid_p2,
    output              wr_data_ready_p2,

    output     [127:0]  rd_data_p2,
    output       [5:0]  rd_data_tag_p2,
    output       [7:0]  error_response_p2,
    output              rd_data_valid_p2,
    input               clk_p3,
    input               cmd_valid_p3,
    output              cmd_ready_p3,
    input        [3:0]  cmd_p3,
    input       [33:0]  addr_p3,
    input        [3:0]  size_p3,
    input        [5:0]  tag_p3,
    input      [127:0]  wr_data_p3,
    input               wr_data_valid_p3,
    output              wr_data_ready_p3,

    output     [127:0]  rd_data_p3,
    output       [5:0]  rd_data_tag_p3,
    output       [7:0]  error_response_p3,
    output              rd_data_valid_p3,
    input               clk_p4,
    input               cmd_valid_p4,
    output              cmd_ready_p4,
    input        [3:0]  cmd_p4,
    input       [33:0]  addr_p4,
    input        [3:0]  size_p4,
    input        [5:0]  tag_p4,
    input      [127:0]  wr_data_p4,
    input               wr_data_valid_p4,
    output              wr_data_ready_p4,

    output     [127:0]  rd_data_p4,
    output       [5:0]  rd_data_tag_p4,
    output       [7:0]  error_response_p4,
    output              rd_data_valid_p4,

    output reg [639:0]  dout,
    output reg   [4:0]  present_map,
    output reg   [4:0]  sof_map,
    output reg   [4:0]  eof_map,

    input  [639:0]  din
    );

    // this is the internal FRP width. Note that our FRP width in our packets
    // still adheres to the HMC spec.
    localparam  FRP_W   = 11;

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    wire [31:0] flit_logger_debug_dout;
    flit_logger #(.BASE_ADDR(32'h1010000)) rd_tag_logger (
        .clk (rx_clk),
        .rst (logger_rst),
        .din (rd_data_valid_p0),
        .din_aux(rd_data_tag_p0),

        .stop(flit_logger_stop),

        .PicoClk(debug_clk),
        .PicoRst(debug_rst),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoAddr(debug_addr),
        .PicoDataIn(debug_din),
        .PicoDataOut(flit_logger_debug_dout)
    );
    `else
    assign flit_logger_debug_dout = 'h0;
    `endif //ENABLE_ALL_FLIT_LOGGERS

    // stitch together all the PicoBus/debug_bus signals from ourself and our submodules.
    reg  [31:0]     node_debug_dout;
    wire [31:0]     flow_debug_dout, pkt_stat1_debug_dout, pkt_stat3_debug_dout,
                    rx_err_injector_debug_dout, tx_err_injector_debug_dout, rx_log2_dout,
                    rx_retry_debug_dout, tx_log1_dout, tx_log2_dout, tx_log3_dout,
                    rx_log3_dout, rx_log4_dout,
                    verify_flow_control_debug_dout,
                    verify_find_pkts_debug_dout,
                    verify_gc_tx_debug_dout,
                    gc_tx_debug_dout,
                    gc_rx_debug_dout,
                    errstat_debug_dout;

    assign debug_dout = flow_debug_dout |
                        node_debug_dout |
                        pkt_stat1_debug_dout |
                        pkt_stat3_debug_dout |
                        rx_err_injector_debug_dout |
                        rx_log2_dout |
                        rx_log3_dout |
                        rx_log4_dout |
                        rx_retry_debug_dout |
                        tx_log1_dout |
                        tx_log2_dout |
                        tx_log3_dout |
                        tx_err_injector_debug_dout |
                        verify_gc_tx_debug_dout |
                        verify_flow_control_debug_dout |
                        verify_find_pkts_debug_dout |
                        flit_logger_debug_dout |
                        gc_tx_debug_dout |
                        gc_rx_debug_dout |
                        errstat_debug_dout;

    // these signals are between the tx grand central module and the flow
    wire                flow_control_rdy, flow_control_rdy_raw;
    reg                 flow_control_rdy_raw_q, flow_control_rdy_raw_q2;

    // these signals connect the stages of the tx pipeline
    localparam TX_STAGES = 7;
    wire [639:0]        tx_data[TX_STAGES-1:0];
    wire [4:0]          tx_present_map[TX_STAGES-1:0];
    wire [4:0]          tx_sof_map[TX_STAGES-1:0];
    wire [4:0]          tx_eof_map[TX_STAGES-1:0];
    wire [5*4-1:0]      tx_len[TX_STAGES-1:0], tx_len_eof[TX_STAGES-1:0];
    wire                tx_pkt_carry[TX_STAGES-1:0];
    wire [FRP_W*5-1:0]  tx_new_frps;
    wire [(5)-1:0]      tx_new_frps_map;
    wire [9:0]          tx_new_frps_buf_inx;
    wire                tx_new_frps_valid;

    always @(posedge tx_clk) begin
        dout         <= tx_data       [TX_STAGES-1];
        present_map  <= tx_present_map[TX_STAGES-1];
        sof_map      <= tx_sof_map    [TX_STAGES-1];
        eof_map      <= tx_eof_map    [TX_STAGES-1];
    end

    wire [7:0]      rtc, rtc_tx_clk;
    wire            rtc_valid, rtc_valid_tx_clk;
    reg  [9:0]      tokens;
    wire [7:0]      tx_start_retry_count, tx_start_retry_rp;
    wire            tx_start_retry_valid;
    wire            tx_abort_valid, tx_abort_rdy;
    wire [7:0]      tx_abort_rp;

    // if these are set, they mask out (i.e. hide) errors in the respective stage of the rx pipeline.
    reg             rx1_err_mask=0, rx2_err_mask=0;

    // connect the rx rrp/frp extractor to the tx flow control.
    wire [7:0]      rx_rrp, tx_rx_rrp;
    wire            rx_rrp_valid,tx_rx_rrp_ready, tx_rx_rrp_valid, tx_rx_rrp_empty;
    assign tx_rx_rrp_valid = ~tx_rx_rrp_empty;
    wire [7:0]      rx_frp, tx_rx_frp;
    wire            rx_frp_valid,tx_rx_frp_ready, tx_rx_frp_valid, tx_rx_frp_empty;
    assign tx_rx_frp_valid = ~tx_rx_frp_empty;

    wire [7:0]      rx_start_retry_count, rx_start_retry_rp;
    wire            rx_start_retry_valid, tx_start_retry_rdy;
    wire            rx_err_abort_valid, rx_err_abort_rdy, rx_clear_err_abort;

    integer i;

    reg rst_q=1, rst_q2=1, rst_q3_tx=1;

    always @(posedge tx_clk) begin
        rst_q   <= rst;
        rst_q2  <= rst_q;
        rst_q3_tx       <= rst_q2;

        if (rst_q2) begin
        end else begin
            //$display("[%t] scratch time", $time);

            //for (i=0; i < 5; i = i+1)
            //if (rx_sof_map[0]) $display("[%t] %s pkt at flit %d. cmd:%b, lng:%d, dln:%d, tag:0x%x", $time, name, 0, rx_dout[128*0+5:128*0+0], rx_dout[128*0+10:128*0+7], rx_dout[128*0+14:128*0+11], rx_dout[128*0+23:128*0+15]);
            //if (rx_sof_map[1]) $display("[%t] %s pkt at flit %d. cmd:%b, lng:%d, dln:%d, tag:0x%x", $time, name, 1, rx_dout[128*1+5:128*1+0], rx_dout[128*1+10:128*1+7], rx_dout[128*1+14:128*1+11], rx_dout[128*1+23:128*1+15]);
            //if (rx_sof_map[2]) $display("[%t] %s pkt at flit %d. cmd:%b, lng:%d, dln:%d, tag:0x%x", $time, name, 2, rx_dout[128*2+5:128*2+0], rx_dout[128*2+10:128*2+7], rx_dout[128*2+14:128*2+11], rx_dout[128*2+23:128*2+15]);
            //if (rx_sof_map[3]) $display("[%t] %s pkt at flit %d. cmd:%b, lng:%d, dln:%d, tag:0x%x", $time, name, 3, rx_dout[128*3+5:128*3+0], rx_dout[128*3+10:128*3+7], rx_dout[128*3+14:128*3+11], rx_dout[128*3+23:128*3+15]);
            //if (rx_sof_map[4]) $display("[%t] %s pkt at flit %d. cmd:%b, lng:%d, dln:%d, tag:0x%x", $time, name, 4, rx_dout[128*4+5:128*4+0], rx_dout[128*4+10:128*4+7], rx_dout[128*4+14:128*4+11], rx_dout[128*4+23:128*4+15]);
        end
    end

    always @(posedge debug_clk) begin
        node_debug_dout <= 'h0;

        if (debug_wr && debug_addr[31:8] == BASE_ADDR[31:8]) begin
            case (debug_addr[7:0])
                8'h0: begin
                    rx1_err_mask    <= debug_din[0];
                    rx2_err_mask    <= debug_din[1];
                end
            endcase
        end

        if (debug_rd && debug_addr[31:0] == BASE_ADDR[31:8]) begin
            case (debug_addr[7:0])
                8'h0:   node_debug_dout <= {30'h0, rx2_err_mask, rx1_err_mask};
            endcase
        end
    end

    /*******
     * TX  *
     *******/

    assign flow_control_rdy = flow_control_rdy_raw_q2;
    always @(posedge tx_clk) begin
        if (rst_q2) begin
            flow_control_rdy_raw_q  <= 0;
            flow_control_rdy_raw_q2 <= 0;
        end else begin
            flow_control_rdy_raw_q  <= flow_control_rdy_raw;
            flow_control_rdy_raw_q2 <= flow_control_rdy_raw_q;
        end
    end

    // TODO: think about adding a valid/rdy handshake to this
    // TODO: insert backpressure from flow control module (flow_control_rdy)
    wire cmd_ready_wire_p0;
    assign cmd_ready_p0 = cmd_ready_wire_p0 & flow_control_rdy;
    wire cmd_ready_wire_p1;
    assign cmd_ready_p1 = cmd_ready_wire_p1 & flow_control_rdy;
    wire cmd_ready_wire_p2;
    assign cmd_ready_p2 = cmd_ready_wire_p2 & flow_control_rdy;
    wire cmd_ready_wire_p3;
    assign cmd_ready_p3 = cmd_ready_wire_p3 & flow_control_rdy;
    wire cmd_ready_wire_p4;
    assign cmd_ready_p4 = cmd_ready_wire_p4 & flow_control_rdy;
    grand_central_tx #(.name(name), .verbose(0), .N_PORTS(N_PORTS)) gc_tx (
        .clk(tx_clk),
        .rst(rst_q3_tx),

        .clk_p0(clk_p0),
        .addr_p0(addr_p0),
        .size_p0(size_p0),
        .tag_p0(tag_p0),
        .cmd_valid_p0(cmd_valid_p0 & flow_control_rdy),
        .cmd_ready_p0(cmd_ready_wire_p0),
        .cmd_p0(cmd_p0),
        .wr_data_p0(wr_data_p0),
        .wr_data_valid_p0(wr_data_valid_p0),
        .wr_data_ready_p0(wr_data_ready_p0),
        .clk_p1(clk_p1),
        .addr_p1(addr_p1),
        .size_p1(size_p1),
        .tag_p1(tag_p1),
        .cmd_valid_p1(cmd_valid_p1 & flow_control_rdy),
        .cmd_ready_p1(cmd_ready_wire_p1),
        .cmd_p1(cmd_p1),
        .wr_data_p1(wr_data_p1),
        .wr_data_valid_p1(wr_data_valid_p1),
        .wr_data_ready_p1(wr_data_ready_p1),
        .clk_p2(clk_p2),
        .addr_p2(addr_p2),
        .size_p2(size_p2),
        .tag_p2(tag_p2),
        .cmd_valid_p2(cmd_valid_p2 & flow_control_rdy),
        .cmd_ready_p2(cmd_ready_wire_p2),
        .cmd_p2(cmd_p2),
        .wr_data_p2(wr_data_p2),
        .wr_data_valid_p2(wr_data_valid_p2),
        .wr_data_ready_p2(wr_data_ready_p2),
        .clk_p3(clk_p3),
        .addr_p3(addr_p3),
        .size_p3(size_p3),
        .tag_p3(tag_p3),
        .cmd_valid_p3(cmd_valid_p3 & flow_control_rdy),
        .cmd_ready_p3(cmd_ready_wire_p3),
        .cmd_p3(cmd_p3),
        .wr_data_p3(wr_data_p3),
        .wr_data_valid_p3(wr_data_valid_p3),
        .wr_data_ready_p3(wr_data_ready_p3),
        .clk_p4(clk_p4),
        .addr_p4(addr_p4),
        .size_p4(size_p4),
        .tag_p4(tag_p4),
        .cmd_valid_p4(cmd_valid_p4 & flow_control_rdy),
        .cmd_ready_p4(cmd_ready_wire_p4),
        .cmd_p4(cmd_p4),
        .wr_data_p4(wr_data_p4),
        .wr_data_valid_p4(wr_data_valid_p4),
        .wr_data_ready_p4(wr_data_ready_p4),

        .PicoClk                    (debug_clk),
        .PicoRst                    (debug_rst),
        .PicoRd                     (debug_rd),
        .PicoWr                     (debug_wr),
        .PicoAddr                   (debug_addr),
        .PicoDataIn                 (debug_din),
        .PicoDataOut                (gc_tx_debug_dout),

        .logger_rst                 (logger_rst),
        .flit_logger_stop           (flit_logger_stop),

        .dout       (tx_data        [0]),
        .present_map(tx_present_map [0]),
        .sof_map    (tx_sof_map     [0]),
        .eof_map    (tx_eof_map     [0]),
        .len        (tx_len         [0]),
        .len_eof    (tx_len_eof     [0]),
        .pkt_carry  (tx_pkt_carry   [0])
    );

`ifdef ENABLE_VERIFY_GC_TX
    verify_req_pkt #(
        .verbose                    (0),
        .BASE_ADDR                  (32'hD000)
    ) verify_gc_tx (
        .clk                        (tx_clk),
        .rst                        (rst_q3_tx),

        .data_in                    (tx_data        [0]),
        .pkt_map_in                 (tx_present_map [0]),
        .sof_map_in                 (tx_sof_map     [0]),
        .eof_map_in                 (tx_eof_map     [0]),
        .len_in                     (tx_len         [0]),
        .pkt_carry_in               (tx_pkt_carry   [0]),

        .PicoClk                    (debug_clk),
        .PicoRst                    (1'b0),
        .PicoAddr                   (debug_addr),
        .PicoRd                     (debug_rd),
        .PicoWr                     (debug_wr),
        .PicoDataIn                 (debug_din),
        .PicoDataOut                (verify_gc_tx_debug_dout)
    );
`else
    assign  verify_gc_tx_debug_dout = 'h0;
`endif

    // intentionally not controlled by the define ENABLE_ALL_FLIT_LOGGERS
    /*flit_logger
        #(.BASE_ADDR(32'hfa0000), .NAME("tx_log1"))
    tx1_flit_logger (
        .clk(tx_clk),
        .rst(rst_q3_tx),
        .din(tx_data[0][639:0]),
        .din_aux({12'h0, tx_len[0][19:0], 3'h0, 5'h0, 3'h0, tx_eof_map[0], 3'h0, tx_sof_map[0], 3'h0, tx_present_map[0]}),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(tx_log1_dout)
        );*/
    assign tx_log1_dout = 'h0;

    // optional clock rate change into faster domain
    wire tx_clk_fast;
    `ifdef FAST_TX_CLOCK
        assign tx_clk_fast = tx_clk;

        // we'll need to tweak the signals after they come out of the fifo, so here are the intermediate wires we use for that.
        wire                tx_empty_1;
        wire                tx_valid_1 = ~tx_empty_1; // is the data coming out of the fifo valid?
        wire [639:0]        tx_data_1;
        wire [4:0]          tx_present_map_1;
        wire [4:0]          tx_sof_map_1;
        wire [4:0]          tx_eof_map_1;
        wire [5*4-1:0]      tx_len_1, tx_len_eof_1;
        wire                tx_pkt_carry_1;

        assign tx_data          [1] = tx_valid_1 ? tx_data_1 : 'h0;
        assign tx_present_map   [1] = tx_valid_1 ? tx_present_map_1 : 'h0;
        assign tx_sof_map       [1] = tx_valid_1 ? tx_sof_map_1 : 'h0;
        assign tx_eof_map       [1] = tx_valid_1 ? tx_eof_map_1 : 'h0;
        assign tx_len           [1] = tx_valid_1 ? tx_len_1 : 'h0;
        assign tx_len_eof       [1] = tx_valid_1 ? tx_len_eof_1 : 'h0;
        assign tx_pkt_carry     [1] = tx_valid_1 ? ~tx_pkt_carry_1 : 0;

        async_fifo_wrapper #(.W(FLITS*(FLIT_W+1+1+1+4+4)), .PACKET_MODE(1)) tx_fast_clk_start_fifo (
            .aclr       (rst_q3_tx),

            .wrclk      (tx_clk),
            .wrreq      (|tx_present_map[0]),
            .wrlast     (~tx_pkt_carry[0]),
            .data       ({  tx_data         [0],
                            tx_present_map  [0],
                            tx_sof_map      [0],
                            tx_eof_map      [0],
                            tx_len          [0],
                            tx_len_eof      [0]}),

            .rdclk      (tx_clk_fast),
            .rdreq      (1), // internally guarded against overrun.
            .rdlast     (tx_pkt_carry_1),
            .q          ({tx_data_1,
                            tx_present_map_1,
                            tx_sof_map_1,
                            tx_eof_map_1,
                            tx_len_1,
                            tx_len_eof_1}),
            .rdempty    (tx_empty_1)
            );

        reg [31:0] rc, wc;
        always @(posedge tx_clk) begin
            if (rst_q3_tx) begin
                wc  <= 'h0;
            end else begin
                if (|tx_present_map[0]) wc <= wc+1;
                if (|tx_present_map[0]) $display("[%t] %m writing to fast_entry_fifo: 0x%x, pkt:%b, sof:%b, eof:%b, len:0x%x, carry:%b", $time, tx_data[0], tx_present_map[0], tx_sof_map[0], tx_eof_map[0], tx_len[0], tx_pkt_carry[0]);
            end
        end
        reg [639:0] tx_data_1_q = 'h0;
        always @(posedge tx_clk_fast) begin
            if (rst_q3_tx) begin
                rc  <= 'h0;
            end else begin
                if (tx_valid_1) rc <= rc+1;
                if (|tx_present_map[1]) begin
                    $display("[%t] %m reading from fast_entry_fifo: (counts: %d/%d) 0x%x, pkt:%b, sof:%b, eof:%b, len:0x%x, carry:%b, tx_pkt_carry_1:%b", $time, wc, rc, tx_data[1], tx_present_map[1], tx_sof_map[1], tx_eof_map[1], tx_len[1], tx_pkt_carry[1], tx_pkt_carry_1);
                    if (tx_data[1] == tx_data_1_q) begin
                        $display("[%t] %m DUPLICATE data back to back out of fast_entry_fifo!", $time);
                    end
                    tx_data_1_q <= tx_data[1];
                end
                if (tx_valid_1 != |tx_present_map[1]) begin
                    $display("[%t] %m fast_entry_fifo error. emitted non-present data!", $time);
                    $stop;
                end
            end
        end
    `else
        assign tx_clk_fast = tx_clk;
        assign tx_data          [1] = tx_data       [0];
        assign tx_present_map   [1] = tx_present_map[0];
        assign tx_sof_map       [1] = tx_sof_map    [0];
        assign tx_eof_map       [1] = tx_eof_map    [0];
        assign tx_len           [1] = tx_len        [0];
        assign tx_len_eof       [1] = tx_len_eof    [0];
        assign tx_pkt_carry     [1] = tx_pkt_carry  [0];
    `endif // FAST_TX_CLOCK

    `ifdef SIMULATION
    hmc_pkt_display #(.name("tx_0")) tx_0_display (
        .clk(tx_clk),

        .din(tx_data[0]),
        .sof(tx_sof_map[0]),
        .eof(tx_eof_map[0])
    );
    hmc_pkt_display #(.name("tx_1")) tx_1_display (
        .clk(tx_clk),

        .din(tx_data[1]),
        .sof(tx_sof_map[1]),
        .eof(tx_eof_map[1])
    );
    `endif //SIMULATION

    add_seq #(
        .name       ({name,".add_seq"}),
        .verbose    (1),
        .FRP_W      (FRP_W)
        ) add_seq (
        .clk        (tx_clk_fast),
        .rst        (rst_q3_tx),

        .data_i     (tx_data        [1]),
        .present_i  (tx_present_map [1]),
        .sof_i      (tx_sof_map     [1]),
        .eof_i      (tx_eof_map     [1]),
        .len_i      (tx_len         [1]),
        .len_eof_i  (tx_len_eof     [1]),
        .pkt_carry_i(tx_pkt_carry   [1]),

        .data_o     (tx_data        [2]),
        .present_o  (tx_present_map [2]),
        .sof_o      (tx_sof_map     [2]),
        .eof_o      (tx_eof_map     [2]),
        .len_o      (tx_len         [2]),
        .len_eof_o  (tx_len_eof     [2]),
        .pkt_carry_o(tx_pkt_carry   [2]),

        .new_frps       (tx_new_frps),
        .new_frps_map   (tx_new_frps_map),
        .new_frps_buf_inx(tx_new_frps_buf_inx),
        .new_frps_valid (tx_new_frps_valid)
    );

    // intentionally not controlled by the define ENABLE_ALL_FLIT_LOGGERS
    /*flit_logger
        #(.BASE_ADDR(32'hfb0000), .NAME("tx_log2"))
    tx2_flit_logger (
        .clk(tx_clk_fast),
        .rst(rst),
        .din(tx_data[1][639:0]),
        .din_aux({12'h0, tx_len[1][19:0], 3'h0, 5'h0, 3'h0, tx_eof_map[1], 3'h0, tx_sof_map[1], 3'h0, tx_present_map[1]}),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(tx_log2_dout)
        );*/
    assign tx_log2_dout = 'h0;

    hmc_flow_control #(
        .name           ({name,".flow_control"}),
        .verbose        (1),
        .FRP_W          (FRP_W),
        .MAX_PKT_LEN    (9),
        .FLIT_W         (128),
        .FLITS          (5)
    ) tx_token_flow_control (
        .clk            (tx_clk_fast),
        .rst            (rst_q3_tx),

        .debug_clk      (debug_clk),
        .debug_rd       (debug_rd),
        .debug_wr       (debug_wr),
        .debug_addr     (debug_addr),
        .debug_din      (debug_din),
        .debug_dout     (flow_debug_dout),

        .rtc_valid      (rtc_valid_tx_clk),
        .rtc            (rtc_tx_clk),

        .tx_valid_in    (|(tx_present_map[2])),
        .tx_rdy_in      (flow_control_rdy_raw),

        .tx_data_in     (tx_data        [2]),
        .pkt_map_in     (tx_present_map [2]),
        .sof_map_in     (tx_sof_map     [2]),
        .eof_map_in     (tx_eof_map     [2]),
        .len_in         (tx_len         [2]),
        .pkt_carry_in   (tx_pkt_carry   [2]),

        .new_frps       (tx_new_frps),
        .new_frps_map   (tx_new_frps_map),
        .new_frps_buf_inx(tx_new_frps_buf_inx),
        .new_frps_valid (tx_new_frps_valid),

        .rx_rrp         (tx_rx_rrp),
        .rx_rrp_valid   (tx_rx_rrp_valid),
        .rx_rrp_ready   (tx_rx_rrp_ready),

        .rx_frp         (tx_rx_frp),
        .rx_frp_valid   (tx_rx_frp_valid),
        .rx_frp_ready   (tx_rx_frp_ready),

        .start_retry_count  (tx_start_retry_count),
        .start_retry_rp     (tx_start_retry_rp),
        .start_retry_valid  (tx_start_retry_valid),
        .start_retry_rdy    (tx_start_retry_rdy),

        .rx_err_abort_valid (tx_abort_valid),
        .rx_err_abort_rdy   (tx_abort_rdy),
        .rx_err_abort_rp    (tx_abort_rp),

        .tx_data_out    (tx_data        [3]),
        .pkt_map_out    (tx_present_map [3]),
        .sof_map_out    (tx_sof_map     [3]),
        .eof_map_out    (tx_eof_map     [3]),
        .len_out        (tx_len         [3])
    );

`ifdef ENABLE_VERIFY_FLOW_CONTROL
    verify_req_pkt #(
        .verbose                    (0),
        .BASE_ADDR                  (32'hD300)
    ) verify_flow_control (
        .clk                        (tx_clk),
        .rst                        (rst_q3_tx),

        .data_in                    (tx_data        [3]),
        .pkt_map_in                 (tx_present_map [3]),
        .sof_map_in                 (tx_sof_map     [3]),
        .eof_map_in                 (tx_eof_map     [3]),
        .len_in                     (tx_len         [3]),
        //.pkt_carry_in               (tx_pkt_carry   [3]),
        .pkt_carry_in               (1'b0),

        .PicoClk                    (debug_clk),
        .PicoRst                    (1'b0),
        .PicoAddr                   (debug_addr),
        .PicoRd                     (debug_rd),
        .PicoWr                     (debug_wr),
        .PicoDataIn                 (debug_din),
        .PicoDataOut                (verify_flow_control_debug_dout)
    );
`else
    assign  verify_flow_control_debug_dout  = 'h0;
`endif

    // intentionally not controlled by the define ENABLE_ALL_FLIT_LOGGERS
    /*flit_logger
        #(.BASE_ADDR(32'hf90000), .NAME("tx_log3"))
    tx3_flit_logger (
        .clk(tx_clk_fast),
        .rst(rst),
        .din(tx_data[2][639:0]),
        .din_aux({12'h0, tx_len[2][19:0], 3'h0, 5'h0, 3'h0, tx_eof_map[2], 3'h0, tx_sof_map[2], 3'h0, tx_present_map[2]}),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(tx_log3_dout)
        );*/
    assign tx_log3_dout = 'h0;

    // this module just finishes up the crc by including the last flit (which was modified since the prelim crc was generated.)
    hmc_crc_seq_add hmc_crc_seq_add (
        .tx_clk(tx_clk_fast),

        .tx_data_i      (tx_data        [3]),
        .tx_present_i   (tx_present_map [3]),
        .tx_sof_i       (tx_sof_map     [3]),
        .tx_eof_i       (tx_eof_map     [3]),

        .tx_data_o      (tx_data        [4]),
        .present_o      (tx_present_map [4]),
        .sof_o          (tx_sof_map     [4]),
        .eof_o          (tx_eof_map     [4])
    );

    `ifdef SIMULATION
    hmc_pkt_display #(.name("tx_3"), .verbose(1)) tx_3_display (
        .clk(tx_clk),
        .rst(rst_q3_tx),

        .din(tx_data[3]),
        .sof(tx_sof_map[3]),
        .eof(tx_eof_map[3])
    );
    hmc_pkt_display #(.name("tx_4"), .verbose(1)) tx_4_display (
        .clk(tx_clk),
        .rst(rst_q3_tx),

        .din(tx_data[4]),
        .sof(tx_sof_map[4]),
        .eof(tx_eof_map[4])
    );
    `endif //SIMULATION

    `ifdef ENABLE_ERROR_INJECTORS
    err_injector #(.BASE_ADDR(32'h6000)) tx_err_injector (
        .clk        (tx_clk_fast),

        .debug_clk  (debug_clk),
        .debug_addr (debug_addr),
        .debug_din  (debug_din),
        .debug_dout (tx_err_injector_debug_dout),
        .debug_rd   (debug_rd),
        .debug_wr   (debug_wr),

        .data_i     (tx_data        [4]),
        .present_i  (tx_present_map [4]),
        .sof_i      (tx_sof_map     [4]),
        .eof_i      (tx_eof_map     [4]),

        .data_o     (tx_data        [5]),
        .present_o  (tx_present_map [5]),
        .sof_o      (tx_sof_map     [5]),
        .eof_o      (tx_eof_map     [5])
    );
    `else
    assign tx_data          [5] = tx_data       [4];
    assign tx_present_map   [5] = tx_present_map[4];
    assign tx_sof_map       [5] = tx_sof_map    [4];
    assign tx_eof_map       [5] = tx_eof_map    [4];
    assign tx_err_injector_debug_dout = 'h0;
    `endif //ENABLE_ERROR_INJECTORS

    // optional switch back into the normal tx clock domain.
    `ifdef FAST_TX_CLOCK
        // we'll need to tweak the signals after they come out of the fifo, so here are the intermediate wires we use for that.
        wire                tx_empty_6;
        wire                tx_valid_6 = ~tx_empty_6; // is the data coming out of the fifo valid?
        wire [639:0]        tx_data_6;
        wire [4:0]          tx_present_map_6;
        wire [4:0]          tx_sof_map_6;
        wire [4:0]          tx_eof_map_6;
        //wire [5*4-1:0]      tx_len_6, tx_len_eof_6;
        wire                tx_pkt_carry_6;

        assign tx_data          [6] = tx_valid_6 ? tx_data_6 : 'h0;
        assign tx_present_map   [6] = tx_valid_6 ? tx_present_map_6 : 'h0;
        assign tx_sof_map       [6] = tx_valid_6 ? tx_sof_map_6 : 'h0;
        assign tx_eof_map       [6] = tx_valid_6 ? tx_eof_map_6 : 'h0;
        //assign tx_len           [6] = tx_valid_6 ? tx_len_6 : 'h0;
        //assign tx_len_eof       [6] = tx_valid_6 ? tx_len_eof_6 : 'h0;
        //assign tx_pkt_carry     [6] = tx_valid_6 ? ~tx_pkt_carry_6 : 0;

        async_fifo_wrapper #(.W(FLITS*(FLIT_W+1+1+1))) tx_fast_clk_end_fifo (
            .aclr       (rst_q3_tx),

            .wrclk      (tx_clk_fast),
            .wrreq      (|tx_present_map[5]),
            .wrlast     (0 /*~tx_pkt_carry[5]*/),
            .data       ({  tx_data         [5],
                            tx_present_map  [5],
                            tx_sof_map      [5],
                            tx_eof_map      [5]}),

            .rdclk      (tx_clk),
            .rdreq      (1), // internally guarded against overrun.
            .rdlast     (tx_pkt_carry_6),
            .q          ({  tx_data_6,
                            tx_present_map_6,
                            tx_sof_map_6,
                            tx_eof_map_6}),
            .rdempty    (tx_empty_6)
            );

        reg [31:0] rc6, wc6;
        always @(posedge tx_clk_fast) begin
            if (rst_q3_tx) begin
                wc6  <= 'h0;
            end else begin
                if (|tx_present_map[5]) wc6 <= wc6+1;
                if (|tx_present_map[5]) $display("[%t] %m writing to fast_end fifo: 0x%x", $time, tx_data[5]);
            end
        end
        always @(posedge tx_clk) begin
            if (rst_q3_tx) begin
                rc6  <= 'h0;
            end else begin
                if (tx_valid_6) rc6 <= rc6+1;
                if (|tx_present_map[6]) $display("[%t] %m reading from fast_end fifo: (counts: %d/%d) 0x%x", $time, wc6, rc6, tx_data[6]);
            end
        end
    `else
        assign tx_data          [6] = tx_data       [5];
        assign tx_present_map   [6] = tx_present_map[5];
        assign tx_sof_map       [6] = tx_sof_map    [5];
        assign tx_eof_map       [6] = tx_eof_map    [5];
    `endif // FAST_TX_CLOCK






    /********
     * RX   *
     ********/

    // these signals connect the stages of the rx pipeline
    wire [639:0]        rx_data[5:0];
    wire [4:0]          rx_pkt[5:1];
    wire [4:0]          rx_sof[5:1];
    wire [4:0]          rx_eof[5:1];
    wire [4:0]          rx_err[5:1];

    reg [639:0] din_q='h0, din_q2='h0;
    reg         rx_rst_q=1, rx_rst_q2=1, rst_q3_pkt_stat=1;
    always @(posedge rx_clk) begin
        rx_rst_q        <= rst;
        rx_rst_q2       <= rx_rst_q;
        rst_q3_pkt_stat <= rx_rst_q2;

        if (rx_rst_q2) begin
        end else begin
            din_q   <= din;
            din_q2  <= din_q;
        end
    end

    always @(posedge rx_clk) begin
        if (rx_rst_q2) begin
            tokens  <= 'h0;
        end else begin
            if (rtc_valid) begin
                $display("[%t] %s rtc: 0x%x. new token count: 0x%x", $time, name, rtc, tokens+rtc);
                tokens  <= tokens + rtc;
            end
        end
    end

    `ifdef ENABLE_ERROR_INJECTORS
    err_injector #(.BASE_ADDR(32'h5000)) rx_err_injector (
        .clk        (rx_clk),

        .debug_clk  (debug_clk),
        .debug_addr (debug_addr),
        .debug_din  (debug_din),
        .debug_dout (rx_err_injector_debug_dout),
        .debug_rd   (debug_rd),
        .debug_wr   (debug_wr),

        .data_i     (din_q2),
        .data_o     (rx_data[0])
    );
    `else
    assign rx_data[0] = din_q2;
    assign rx_err_injector_debug_dout = 'h0;
    `endif //ENABLE_ERROR_INJECTORS

    // we should really have these checks enabled, but the crc module (among a few others) doesn't play nice.
    // thus, for now, we leave the controller in reset during hmc linking.
    /*always @(posedge rx_clk) begin
        if (~rx_rst_q2) begin
            //if (|rx_data[0]) $display("[%t] rx_data[0]: 0x%x", $time, rx_data[0]);
            //$display("[%t] rx_data[1]: 0x%x, 0x%x, 0x%x, 0x%x, 0x%x", $time, rx_data[1], rx_pkt[1], rx_sof[1], rx_eof[1], rx_err[1]);
            //$display("[%t] rx_data[2]: 0x%x", $time, rx_data[2]);
            if (|rx_data[0] === 1'bx) begin $display("[%t] rx_data[0] has x!", $time); $stop; end
            if (|rx_data[1] === 1'bx) begin $display("[%t] rx_data[1] has x!", $time); $stop; end
            if (|rx_data[2] === 1'bx) begin $display("[%t] rx_data[2] has x! (rx_data[1]: 0x%x", $time, rx_data[1]); $stop; end
        end
    end*/

    hmc_find_pkts finder (
        .rx_clk(rx_clk),

        .rx_data_i(rx_data[0]),

        .rx_data_o      (rx_data[1]),
        .rx_sof_o       (rx_sof[1]),
        .rx_eof_o       (rx_eof[1]),
        .rx_present_o   (rx_pkt[1]),
        .rx_err_o       (rx_err[1])
        );

`ifdef ENABLE_VERIFY_FIND_PKTS
    // even though these are response packets coming back, we can still use
    // our request packet verification module to check the sof, eof, and
    // pkt_map bits for flaws
    verify_req_pkt #(
        .verbose                    (0),
        
        // since this is on the response side, we don't have a len[] bus or
        // a pkt_carry field
        .CHECK_LEN_EN               (0),
        .CHECK_PKT_CARRY_EN         (0),

        .BASE_ADDR                  (32'hD600)
    ) verify_find_pkts (
        .clk                        (rx_clk),
        .rst                        (rst_q3_pkt_stat),

        .data_in                    (rx_data        [1]),
        .pkt_map_in                 (rx_pkt         [1]),
        .sof_map_in                 (rx_sof         [1]),
        .eof_map_in                 (rx_eof         [1]),
        .len_in                     (32'h0),
        .pkt_carry_in               (1'b0),

        .PicoClk                    (debug_clk),
        .PicoRst                    (1'b0),
        .PicoAddr                   (debug_addr),
        .PicoRd                     (debug_rd),
        .PicoWr                     (debug_wr),
        .PicoDataIn                 (debug_din),
        .PicoDataOut                (verify_find_pkts_debug_dout)
    );
`else
    assign  verify_find_pkts_debug_dout = 'h0;
`endif

    `ifdef ENABLE_PKT_STAT
    pkt_stat #(.name(name), .verbose(0), .FLITS(5), .BASE_ADDR(32'hc000)) rx1_stat (
        .clk        (rx_clk),
        .rst        (rst_q3_pkt_stat),

        .data       (rx_data[1]),
        .sof        (rx_sof[1]),

        .trigger    (flit_logger_stop),

        .debug_clk  (debug_clk),
        .debug_addr (debug_addr),
        .debug_din  (debug_din),
        .debug_dout (pkt_stat1_debug_dout),
        .debug_rd   (debug_rd),
        .debug_wr   (debug_wr)
        );
    `else
    assign pkt_stat1_debug_dout = 'h0;
    `endif //ENABLE_PKT_STAT

    `ifdef ENABLE_RX_CRC
    hmc_crc_seq_chk hmc_crc_seq_chk (
        .rx_clk(rx_clk),

        .rx_data_i      (rx_data[1]),
        .rx_present_i   (rx_pkt[1]),
        .rx_sof_i       (rx_sof[1]),
        .rx_eof_i       (rx_eof[1]),
        .rx_err_i       (rx_err[1]),

        .rx_data_o      (rx_data[2]),
        .rx_present_o   (rx_pkt[2]),
        .rx_sof_o       (rx_sof[2]),
        .rx_eof_o       (rx_eof[2]),
        .rx_err_o       (rx_err[2])
    );
    `else
    assign rx_data[2]   = rx_data[1];
    assign rx_pkt[2]    = rx_pkt[1];
    assign rx_sof[2]    = rx_sof[1];
    assign rx_eof[2]    = rx_eof[1];
    assign rx_err[2]    = rx_err[1];
    `endif //ENABLE_RX_CRC

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    flit_logger
        #(.BASE_ADDR(32'hfc0000), .NAME("rx_log2"))
    rx2_flit_logger (
        .clk(rx_clk),
        .rst(rst_q3_pkt_stat),
        .din(rx_data[2][639:0]),
        .din_aux({32'h0, 3'h0, rx_err[2], 3'h0, rx_eof[2], 3'h0, rx_sof[2], 3'h0, rx_pkt[2]}),

        .stop(flit_logger_stop),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(rx_log2_dout)
        );
    `else
    assign rx_log2_dout = 'h0;
    `endif //ENABLE_ALL_FLIT_LOGGERS

    `ifdef SIMULATION
    hmc_pkt_display #(.name("rx_pre_retry")) rx_pre_retry_pkt_display (
        .clk(rx_clk),

        .din(rx_data[2]),
        .sof(rx_sof[2]),
        .eof(rx_eof[2])
    );
    `endif //SIMULATION

    // we need to gather several pieces of data when we detect an rx erro and request a retry:
    // 1) the error condition itself.
    // 2) the last good frp
    // because these are generated by different modules, and the frp takes two more cycles than the error detection,
    // we delay the rx_err_abort_valid signal to give the frp extractor time to catch up. we also cache the last
    // good frp, in case the error occurs during a lull in rx traffic.
    reg [3:0]   rx_err_abort_q;
    reg [7:0]   last_rx_frp;
    always @(posedge rx_clk) begin
        rx_err_abort_q  <= {rx_err_abort_q[2:0], rx_err_abort_valid};
        if (rx_frp_valid) last_rx_frp <= rx_frp;
        if (rx_err_abort_q[1]) $display("[%t] %m : saw slave ErrorAbort with FRP 0x%x/%d, lastfrp:0x%x (valid:%d, abort:%d)", $time, rx_frp, rx_frp, last_rx_frp, rx_frp_valid, rx_err_abort_valid);
    end

    // fifo-handling signals for some of the async fifos that move from the rx->tx domain.
    wire tx_start_retry_empty;
    assign tx_start_retry_valid = ~tx_start_retry_empty;
    wire tx_abort_empty;
    assign tx_abort_valid = ~tx_abort_empty;

    // this module watches the rx bus for retry-related packets.
    // it also stops the rx stream on encountering an error, and restarts it during the retry process.
    assign rx_retry_debug_dout = 'h0; //TODO remove once we patch in below.
    hmc_rx_retry #(.name({name,".catch_retry"}), .verbose(1), .FLITS(5)) catch_retry (
        .clk(rx_clk),
        .rst(rx_rst_q2),

        /*.debug_clk  (debug_clk),
        .debug_addr (debug_addr),
        .debug_din  (debug_din),
        .debug_dout (rx_retry_debug_dout),
        .debug_rd   (debug_rd),
        .debug_wr   (debug_wr),*/

        .data_i     (rx_data[2]),
        .pkt_i      (rx_pkt[2]),
        .sof_i      (rx_sof[2]),
        .eof_i      (rx_eof[2]),
        .err_i      (rx_err[2]),

        .data_o     (rx_data[3]),
        .pkt_o      (rx_pkt[3]),
        .sof_o      (rx_sof[3]),
        .eof_o      (rx_eof[3]),
        .err_o      (rx_err[3]),

        .start_retry_count(rx_start_retry_count),
        .start_retry_rp(rx_start_retry_rp),
        .start_retry_valid(rx_start_retry_valid),

        .err_abort_valid    (rx_err_abort_valid),
        .err_abort_rdy      (rx_err_abort_rdy)
        );
    // these two fifos could be merged into one, for a small loss in flexibility.
    async_fifo_wrapper #(.W(16)) rx_retry_fifo (
        .aclr(rx_rst_q2),
        .wrclk(rx_clk),
        .wrreq(rx_start_retry_valid),
        .data({rx_start_retry_count, rx_start_retry_rp}),
        //.full(),
        .rdclk(tx_clk),
        .rdreq(tx_start_retry_rdy & tx_start_retry_valid),
        .q({tx_start_retry_count, tx_start_retry_rp}),
        .rdempty(tx_start_retry_empty)
    );
    async_fifo_wrapper #(.W(8)) rx_abort_fifo (
        .aclr(rx_rst_q2),
        .wrclk(rx_clk),
        .wrreq(rx_err_abort_q[1]),
        .data(last_rx_frp),
        //.full(),
        .rdclk(tx_clk),
        .rdreq(tx_abort_rdy & tx_abort_valid),
        .q(tx_abort_rp),
        .rdempty(tx_abort_empty)
    );

    `ifdef SIMULATION
    hmc_pkt_display #(.name("rx_post_retry")) rx_post_retry_pkt_display (
        .clk(rx_clk),
        .rst(rx_rst_q2),

        .din(rx_data[3]),
        .sof(rx_sof[3]),
        .eof(rx_eof[3])
    );
    `endif //SIMULATION

    rrp_extractor #(.name({name,".rx_rrp"}), .verbose(1), .FLITS(5)) rrp_extractor (
        .clk(rx_clk),
        .rst(rx_rst_q2),

        .din(rx_data[3]),
        .sof(rx_sof[3]),
        .eof(rx_eof[3] & ~rx_err[3]),

        .rrp(rx_rrp),
        .rrp_valid(rx_rrp_valid),

        .frp(rx_frp),
        .frp_valid(rx_frp_valid)
        );
    // rx_rrp[_valid] seems to be a difficult timing path. here's an extra register stage.
    reg  [7:0]  rx_rrp_q;
    reg         rx_rrp_valid_q;
    always @(posedge rx_clk) begin
        if (rx_rst_q2)  begin
            rx_rrp_valid_q  <= 0;
        end else begin
            rx_rrp_valid_q  <= rx_rrp_valid;
            rx_rrp_q        <= rx_rrp;
        end
    end
    async_fifo_wrapper #(.W(8)) rx_rrp_fifo (
        .aclr(rx_rst_q2),
        .wrclk(rx_clk),
        .wrreq(rx_rrp_valid_q),
        .data(rx_rrp_q),
        //.full(),
        .rdclk(tx_clk),
        .rdreq(tx_rx_rrp_ready),
        .q(tx_rx_rrp),
        .rdempty(tx_rx_rrp_empty)
    );
    async_fifo_wrapper #(.W(8)) rx_frp_fifo (
        .aclr(rx_rst_q2),
        .wrclk(rx_clk),
        .wrreq(rx_frp_valid),
        .data(rx_frp),
        //.full(),
        .rdclk(tx_clk),
        .rdreq(tx_rx_frp_ready & ~tx_rx_frp_empty),
        .q(tx_rx_frp),
        .rdempty(tx_rx_frp_empty)
    );

    rtc #(.name({name,".rtc"}), .verbose(1), .FLITS(5)) rtc_module (
        .clk(rx_clk),
        .rst(rx_rst_q2),

        .debug_clk      (debug_clk),
        .debug_rd       (debug_rd),
        .debug_wr       (debug_wr),
        .debug_addr     (debug_addr),
        .debug_din      (debug_din),

        .din(rx_data[3]),
        .sof(rx_sof[3]),
        .eof(rx_eof[3]),

        .rtc(rtc),
        .rtc_valid(rtc_valid)
        );

    // move the returned tokens from rx_clk to tx_clk.
    wire            rtc_fifo_empty;
    wire [143:0]    rtc_fifo_dout;
    assign rtc_valid_tx_clk = ~rtc_fifo_empty;
    assign rtc_tx_clk[7:0]  = rtc_fifo_dout[7:0];
    async_fifo_wrapper #(.W(144)) rtc_fifo (
        .aclr(rx_rst_q2),
        .wrclk(rx_clk),
        .wrreq(rtc_valid),
        .data({136'h0, rtc[7:0]}),
        //.full(),
        .rdclk(tx_clk),
        .rdreq(~rtc_fifo_empty),
        .q(rtc_fifo_dout),
        .rdempty(rtc_fifo_empty)
    );

    `ifdef ENABLE_PKT_STAT_POST_RETRY
    pkt_stat #(.name(name), .verbose(0), .FLITS(5), .BASE_ADDR(32'hc100)) rx3_stat (
        .clk(rx_clk),
        .rst(rst_q3_pkt_stat),

        .data(rx_data[3]),
        .sof(rx_sof[3]),

        .debug_clk(debug_clk),
        .debug_addr(debug_addr),
        .debug_din(debug_din),
        .debug_dout(pkt_stat3_debug_dout),
        .debug_rd(debug_rd),
        .debug_wr(debug_wr)
        );
    `else
    assign pkt_stat3_debug_dout = 'h0;
    `endif // ENABLE_PKT_STAT_POST_RETRY

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    flit_logger
        #(.BASE_ADDR(32'hf60000), .NAME("rx_log3"))
    rx3_flit_logger (
        .clk(rx_clk),
        .rst(rst_q3_pkt_stat),
        .din(rx_data[3][639:0]),
        .din_aux({32'h0, 3'h0, rx_err[3], 3'h0, rx_eof[3], 3'h0, rx_sof[3], 3'h0, rx_pkt[3]}),

        .stop(flit_logger_stop),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(rx_log3_dout)
        );
    `else
    assign rx_log3_dout = 'h0;
    `endif //ENABLE_ALL_FLIT_LOGGERS

    wire [44:0] rx_tags[5:4];
    tag_flits tag_flits (
        .clk            (rx_clk),

        .din            (rx_data[3]),
        .sof_map_i      (rx_sof[3]),
        .eof_map_i      (rx_eof[3]),
        .present_map_i  (rx_pkt[3]),

        .dout           (rx_data[4]),
        .sof_map_o      (rx_sof[4]),
        .eof_map_o      (rx_eof[4]),
        .present_map_o  (rx_pkt[4]),
        .tag_map_o      (rx_tags[4])
    );

    `ifdef ENABLE_ALL_FLIT_LOGGERS
    flit_logger
        #(.BASE_ADDR(32'hf50000), .NAME("rx_log4"))
    rx4_flit_logger (
        .clk(rx_clk),
        .rst(rst_q3_pkt_stat),
        .din(rx_data[4][639:0]),
        .din_aux({rx_tags[4][44:13], 3'h0, rx_err[4], 3'h0, rx_eof[4], 3'h0, rx_sof[4], 3'h0, rx_pkt[4]}),

        .stop(flit_logger_stop),

        .PicoClk(debug_clk),
        .PicoRst(1'b0),
        .PicoAddr(debug_addr),
        .PicoRd(debug_rd),
        .PicoWr(debug_wr),
        .PicoDataIn(debug_din),
        .PicoDataOut(rx_log4_dout)
        );
    `else
    assign rx_log4_dout = 'h0;
    `endif //ENABLE_ALL_FLIT_LOGGERS

    wire [39:0] rx_error_response;
    errstat  errstat    (
        .clk            (rx_clk),
        .rst            (rx_rst_q2),

        .din            (rx_data[4]),
        .sof_map_i      (rx_sof[4]),
        .eof_map_i      (rx_eof[4]),
        .present_map_i  (rx_pkt[4]),
        .tag_map_i      (rx_tags[4]),

        .dout           (rx_data[5]),
        .sof_map_o      (rx_sof[5]),
        .eof_map_o      (rx_eof[5]),
        .present_map_o  (rx_pkt[5]),
        .tag_map_o      (rx_tags[5]),
        .err_map_o      (rx_error_response),

        .debug_clk      (debug_clk),
        .debug_addr     (debug_addr),
        .debug_din      (debug_din),
        .debug_dout     (errstat_debug_dout),
        .debug_rd       (debug_rd),
        .debug_wr       (debug_wr)
    );

    grand_central_rx #(.name({name,".gc_rx"}), .verbose(1), .N_PORTS(N_PORTS)) gc_rx (
        .clk(rx_clk),
        .rst(rx_rst_q2),

        .clk_p0(clk_p0),
        .data_p0(rd_data_p0),
        .tag_p0(rd_data_tag_p0),
        .error_response_p0(error_response_p0),
        .data_valid_p0(rd_data_valid_p0),
        .clk_p1(clk_p1),
        .data_p1(rd_data_p1),
        .tag_p1(rd_data_tag_p1),
        .error_response_p1(error_response_p1),
        .data_valid_p1(rd_data_valid_p1),
        .clk_p2(clk_p2),
        .data_p2(rd_data_p2),
        .tag_p2(rd_data_tag_p2),
        .error_response_p2(error_response_p2),
        .data_valid_p2(rd_data_valid_p2),
        .clk_p3(clk_p3),
        .data_p3(rd_data_p3),
        .tag_p3(rd_data_tag_p3),
        .error_response_p3(error_response_p3),
        .data_valid_p3(rd_data_valid_p3),
        .clk_p4(clk_p4),
        .data_p4(rd_data_p4),
        .tag_p4(rd_data_tag_p4),
        .error_response_p4(error_response_p4),
        .data_valid_p4(rd_data_valid_p4),
        
        .PicoClk                    (debug_clk),
        .PicoRst                    (debug_rst),
        .PicoRd                     (debug_rd),
        .PicoWr                     (debug_wr),
        .PicoAddr                   (debug_addr),
        .PicoDataIn                 (debug_din),
        .PicoDataOut                (gc_rx_debug_dout),

        .logger_rst                 (logger_rst),
        .flit_logger_stop           (flit_logger_stop),

        .din        (rx_data[5]),
        .sof_map    (rx_sof[5]),
        .eof_map    (rx_eof[5]),
        .present_map(rx_pkt[5]),
        .tag_map    (rx_tags[5]),
        .err_map    (rx_error_response)
        );

endmodule
