// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

module grand_central_tx #(parameter name = "", parameter verbose = 0, parameter N_PORTS = 5) (
    input               clk,
    input               rst,

    input               clk_p0,
    input       [33:0]  addr_p0,
    input        [3:0]  size_p0,
    input        [5:0]  tag_p0,
    input               cmd_valid_p0,
    output              cmd_ready_p0,
    input        [3:0]  cmd_p0,
    input      [127:0]  wr_data_p0,
    input               wr_data_valid_p0,
    output              wr_data_ready_p0,
    input               clk_p1,
    input       [33:0]  addr_p1,
    input        [3:0]  size_p1,
    input        [5:0]  tag_p1,
    input               cmd_valid_p1,
    output              cmd_ready_p1,
    input        [3:0]  cmd_p1,
    input      [127:0]  wr_data_p1,
    input               wr_data_valid_p1,
    output              wr_data_ready_p1,
    input               clk_p2,
    input       [33:0]  addr_p2,
    input        [3:0]  size_p2,
    input        [5:0]  tag_p2,
    input               cmd_valid_p2,
    output              cmd_ready_p2,
    input        [3:0]  cmd_p2,
    input      [127:0]  wr_data_p2,
    input               wr_data_valid_p2,
    output              wr_data_ready_p2,
    input               clk_p3,
    input       [33:0]  addr_p3,
    input        [3:0]  size_p3,
    input        [5:0]  tag_p3,
    input               cmd_valid_p3,
    output              cmd_ready_p3,
    input        [3:0]  cmd_p3,
    input      [127:0]  wr_data_p3,
    input               wr_data_valid_p3,
    output              wr_data_ready_p3,
    input               clk_p4,
    input       [33:0]  addr_p4,
    input        [3:0]  size_p4,
    input        [5:0]  tag_p4,
    input               cmd_valid_p4,
    output              cmd_ready_p4,
    input        [3:0]  cmd_p4,
    input      [127:0]  wr_data_p4,
    input               wr_data_valid_p4,
    output              wr_data_ready_p4,
    
    input               PicoClk,
    input               PicoRst,
    input [31:0]        PicoAddr,
    input               PicoRd,
    input               PicoWr,
    input [31:0]        PicoDataIn,
    output  [31:0]      PicoDataOut,
    
    input               logger_rst,
    input               flit_logger_stop,

    output     [639:0]  dout,
    output   [5*4-1:0]  len,
    output   [5*4-1:0]  len_eof,
    output       [4:0]  present_map,
    output       [4:0]  sof_map,
    output       [4:0]  eof_map,
    output              pkt_carry
    );

    wire [639:0]    dout_p0;
    wire [5*4-1:0]  len_p0;
    wire [5*4-1:0]  len_eof_p0;
    wire [4:0]      present_map_p0;
    wire [4:0]      sof_map_p0;
    wire [4:0]      eof_map_p0;
    wire            load_p0;
    wire            pkt_carry_p0;
    wire [639:0]    dout_p1;
    wire [5*4-1:0]  len_p1;
    wire [5*4-1:0]  len_eof_p1;
    wire [4:0]      present_map_p1;
    wire [4:0]      sof_map_p1;
    wire [4:0]      eof_map_p1;
    wire            load_p1;
    wire            pkt_carry_p1;
    wire [639:0]    dout_p2;
    wire [5*4-1:0]  len_p2;
    wire [5*4-1:0]  len_eof_p2;
    wire [4:0]      present_map_p2;
    wire [4:0]      sof_map_p2;
    wire [4:0]      eof_map_p2;
    wire            load_p2;
    wire            pkt_carry_p2;
    wire [639:0]    dout_p3;
    wire [5*4-1:0]  len_p3;
    wire [5*4-1:0]  len_eof_p3;
    wire [4:0]      present_map_p3;
    wire [4:0]      sof_map_p3;
    wire [4:0]      eof_map_p3;
    wire            load_p3;
    wire            pkt_carry_p3;
    wire [639:0]    dout_p4;
    wire [5*4-1:0]  len_p4;
    wire [5*4-1:0]  len_eof_p4;
    wire [4:0]      present_map_p4;
    wire [4:0]      sof_map_p4;
    wire [4:0]      eof_map_p4;
    wire            load_p4;
    wire            pkt_carry_p4;

    arbiter #(.name({name,".arbiter"}), .verbose(1)) arb (
        .clk(clk),
        .rst(rst),

        .load_p0(load_p0),
        .data_p0(dout_p0),
        .len_p0(len_p0),
        .len_eof_p0(len_eof_p0),
        .present_map_p0(present_map_p0),
        .sof_map_p0(sof_map_p0),
        .eof_map_p0(eof_map_p0),
        .pkt_carry_p0(pkt_carry_p0),
        .load_p1(load_p1),
        .data_p1(dout_p1),
        .len_p1(len_p1),
        .len_eof_p1(len_eof_p1),
        .present_map_p1(present_map_p1),
        .sof_map_p1(sof_map_p1),
        .eof_map_p1(eof_map_p1),
        .pkt_carry_p1(pkt_carry_p1),
        .load_p2(load_p2),
        .data_p2(dout_p2),
        .len_p2(len_p2),
        .len_eof_p2(len_eof_p2),
        .present_map_p2(present_map_p2),
        .sof_map_p2(sof_map_p2),
        .eof_map_p2(eof_map_p2),
        .pkt_carry_p2(pkt_carry_p2),
        .load_p3(load_p3),
        .data_p3(dout_p3),
        .len_p3(len_p3),
        .len_eof_p3(len_eof_p3),
        .present_map_p3(present_map_p3),
        .sof_map_p3(sof_map_p3),
        .eof_map_p3(eof_map_p3),
        .pkt_carry_p3(pkt_carry_p3),
        .load_p4(load_p4),
        .data_p4(dout_p4),
        .len_p4(len_p4),
        .len_eof_p4(len_eof_p4),
        .present_map_p4(present_map_p4),
        .sof_map_p4(sof_map_p4),
        .eof_map_p4(eof_map_p4),
        .pkt_carry_p4(pkt_carry_p4),

        .dout(dout),
        .len(len),
        .len_eof(len_eof),
        .present_map(present_map),
        .sof_map(sof_map),
        .eof_map(eof_map),
        .pkt_carry(pkt_carry)
    );

    generate 
    if (N_PORTS > 0) begin
    tx_port #(.name({name,".p0"}), .verbose(1), .PORT(1)) tx_port0 (
        .clk(clk),
        .rst(rst),

        // external user interface
        .user_clk(clk_p0),
        .addr(addr_p0),
        .size(size_p0),
        .tag(tag_p0),
        .cmd_valid(cmd_valid_p0),
        .cmd_ready(cmd_ready_p0),
        .cmd(cmd_p0),
        .wr_data(wr_data_p0),
        .wr_data_valid(wr_data_valid_p0),
        .wr_data_ready(wr_data_ready_p0),

        // internal arbiter interface
        .dout(dout_p0),
        .len(len_p0),
        .len_eof(len_eof_p0),
        .present_map(present_map_p0),
        .sof_map(sof_map_p0),
        .eof_map(eof_map_p0),
        .pkt_carry(pkt_carry_p0),
        .load(load_p0)
    );
    end else begin
        assign present_map_p0 = 0;
        assign sof_map_p0 = 0;
        assign eof_map_p0 = 0;
        assign len_eof_p0 = 0;
        assign pkt_carry_p0 = 0;
    end
    if (N_PORTS > 1) begin
    tx_port #(.name({name,".p1"}), .verbose(1), .PORT(2)) tx_port1 (
        .clk(clk),
        .rst(rst),

        // external user interface
        .user_clk(clk_p1),
        .addr(addr_p1),
        .size(size_p1),
        .tag(tag_p1),
        .cmd_valid(cmd_valid_p1),
        .cmd_ready(cmd_ready_p1),
        .cmd(cmd_p1),
        .wr_data(wr_data_p1),
        .wr_data_valid(wr_data_valid_p1),
        .wr_data_ready(wr_data_ready_p1),

        // internal arbiter interface
        .dout(dout_p1),
        .len(len_p1),
        .len_eof(len_eof_p1),
        .present_map(present_map_p1),
        .sof_map(sof_map_p1),
        .eof_map(eof_map_p1),
        .pkt_carry(pkt_carry_p1),
        .load(load_p1)
    );
    end else begin
        assign present_map_p1 = 0;
        assign sof_map_p1 = 0;
        assign eof_map_p1 = 0;
        assign len_eof_p1 = 0;
        assign pkt_carry_p1 = 0;
    end
    if (N_PORTS > 2) begin
    tx_port #(.name({name,".p2"}), .verbose(1), .PORT(3)) tx_port2 (
        .clk(clk),
        .rst(rst),

        // external user interface
        .user_clk(clk_p2),
        .addr(addr_p2),
        .size(size_p2),
        .tag(tag_p2),
        .cmd_valid(cmd_valid_p2),
        .cmd_ready(cmd_ready_p2),
        .cmd(cmd_p2),
        .wr_data(wr_data_p2),
        .wr_data_valid(wr_data_valid_p2),
        .wr_data_ready(wr_data_ready_p2),

        // internal arbiter interface
        .dout(dout_p2),
        .len(len_p2),
        .len_eof(len_eof_p2),
        .present_map(present_map_p2),
        .sof_map(sof_map_p2),
        .eof_map(eof_map_p2),
        .pkt_carry(pkt_carry_p2),
        .load(load_p2)
    );
    end else begin
        assign present_map_p2 = 0;
        assign sof_map_p2 = 0;
        assign eof_map_p2 = 0;
        assign len_eof_p2 = 0;
        assign pkt_carry_p2 = 0;
    end
    if (N_PORTS > 3) begin
    tx_port #(.name({name,".p3"}), .verbose(1), .PORT(4)) tx_port3 (
        .clk(clk),
        .rst(rst),

        // external user interface
        .user_clk(clk_p3),
        .addr(addr_p3),
        .size(size_p3),
        .tag(tag_p3),
        .cmd_valid(cmd_valid_p3),
        .cmd_ready(cmd_ready_p3),
        .cmd(cmd_p3),
        .wr_data(wr_data_p3),
        .wr_data_valid(wr_data_valid_p3),
        .wr_data_ready(wr_data_ready_p3),

        // internal arbiter interface
        .dout(dout_p3),
        .len(len_p3),
        .len_eof(len_eof_p3),
        .present_map(present_map_p3),
        .sof_map(sof_map_p3),
        .eof_map(eof_map_p3),
        .pkt_carry(pkt_carry_p3),
        .load(load_p3)
    );
    end else begin
        assign present_map_p3 = 0;
        assign sof_map_p3 = 0;
        assign eof_map_p3 = 0;
        assign len_eof_p3 = 0;
        assign pkt_carry_p3 = 0;
    end
    if (N_PORTS > 4) begin
    tx_port #(.name({name,".p4"}), .verbose(1), .PORT(5)) tx_port4 (
        .clk(clk),
        .rst(rst),

        // external user interface
        .user_clk(clk_p4),
        .addr(addr_p4),
        .size(size_p4),
        .tag(tag_p4),
        .cmd_valid(cmd_valid_p4),
        .cmd_ready(cmd_ready_p4),
        .cmd(cmd_p4),
        .wr_data(wr_data_p4),
        .wr_data_valid(wr_data_valid_p4),
        .wr_data_ready(wr_data_ready_p4),

        // internal arbiter interface
        .dout(dout_p4),
        .len(len_p4),
        .len_eof(len_eof_p4),
        .present_map(present_map_p4),
        .sof_map(sof_map_p4),
        .eof_map(eof_map_p4),
        .pkt_carry(pkt_carry_p4),
        .load(load_p4)
    );
    end else begin
        assign present_map_p4 = 0;
        assign sof_map_p4 = 0;
        assign eof_map_p4 = 0;
        assign len_eof_p4 = 0;
        assign pkt_carry_p4 = 0;
    end
    endgenerate

    // Note: these flit loggers are a little tricky. they record any data
    // beats that contain non-zero data.  we should therefore zero out all
    // data on any data beats that we don't care about
    wire        [31:0]              flit_logger_debug_dout  [0:4];
`ifdef ENABLE_PORT_FLIT_LOGGERS
    flit_logger #(
        .BASE_ADDR                  (32'h1020000)
    ) tx_port_0_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        ((cmd_valid_p0 & cmd_ready_p0) ||
                                         (wr_data_valid_p0 & wr_data_ready_p0)) ? 
                                        {
                                        30'h0,  addr_p0,        // 383:320
                                        32'h0,
                                        28'h0,  size_p0,        // 289:256
                                        26'h0,  tag_p0,         // 255:224
                                        30'h0,  
                                        cmd_valid_p0,
                                        cmd_ready_p0,           // 223:192
                                        28'h0,  cmd_p0,         // 191:160
                                        30'h0,  
                                        wr_data_valid_p0,
                                        wr_data_ready_p0,       // 159:128
                                        wr_data_p0              // 127:0
                                        }
                                        :
                                        640'h0
                                    ),
        .din_aux                    (),

        .stop                       (flit_logger_stop),

        .PicoClk                    (PicoClk),
        .PicoRst                    (PicoRst),
        .PicoRd                     (PicoRd),
        .PicoWr                     (PicoWr),
        .PicoAddr                   (PicoAddr),
        .PicoDataIn                 (PicoDataIn),
        .PicoDataOut                (flit_logger_debug_dout[0])
    );
    flit_logger #(
        .BASE_ADDR                  (32'h1030000)
    ) tx_port_1_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        ((cmd_valid_p1 & cmd_ready_p1) ||
                                         (wr_data_valid_p1 & wr_data_ready_p1)) ? 
                                        {
                                        30'h0,  addr_p1,        // 383:320
                                        32'h0,
                                        28'h0,  size_p1,        // 289:256
                                        26'h0,  tag_p1,         // 255:224
                                        30'h0,  
                                        cmd_valid_p1,
                                        cmd_ready_p1,           // 223:192
                                        28'h0,  cmd_p1,         // 191:160
                                        30'h0,  
                                        wr_data_valid_p1,
                                        wr_data_ready_p1,       // 159:128
                                        wr_data_p1              // 127:0
                                        }
                                        :
                                        640'h0
                                    ),
        .din_aux                    (),

        .stop                       (flit_logger_stop),

        .PicoClk                    (PicoClk),
        .PicoRst                    (PicoRst),
        .PicoRd                     (PicoRd),
        .PicoWr                     (PicoWr),
        .PicoAddr                   (PicoAddr),
        .PicoDataIn                 (PicoDataIn),
        .PicoDataOut                (flit_logger_debug_dout[1])
    );
    flit_logger #(
        .BASE_ADDR                  (32'h1040000)
    ) tx_port_2_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        ((cmd_valid_p2 & cmd_ready_p2) ||
                                         (wr_data_valid_p2 & wr_data_ready_p2)) ? 
                                        {
                                        30'h0,  addr_p2,        // 383:320
                                        32'h0,
                                        28'h0,  size_p2,        // 289:256
                                        26'h0,  tag_p2,         // 255:224
                                        30'h0,  
                                        cmd_valid_p2,
                                        cmd_ready_p2,           // 223:192
                                        28'h0,  cmd_p2,         // 191:160
                                        30'h0,  
                                        wr_data_valid_p2,
                                        wr_data_ready_p2,       // 159:128
                                        wr_data_p2              // 127:0
                                        }
                                        :
                                        640'h0
                                    ),
        .din_aux                    (),

        .stop                       (flit_logger_stop),

        .PicoClk                    (PicoClk),
        .PicoRst                    (PicoRst),
        .PicoRd                     (PicoRd),
        .PicoWr                     (PicoWr),
        .PicoAddr                   (PicoAddr),
        .PicoDataIn                 (PicoDataIn),
        .PicoDataOut                (flit_logger_debug_dout[2])
    );
    flit_logger #(
        .BASE_ADDR                  (32'h1050000)
    ) tx_port_3_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        ((cmd_valid_p3 & cmd_ready_p3) ||
                                         (wr_data_valid_p3 & wr_data_ready_p3)) ? 
                                        {
                                        30'h0,  addr_p3,        // 383:320
                                        32'h0,
                                        28'h0,  size_p3,        // 289:256
                                        26'h0,  tag_p3,         // 255:224
                                        30'h0,  
                                        cmd_valid_p3,
                                        cmd_ready_p3,           // 223:192
                                        28'h0,  cmd_p3,         // 191:160
                                        30'h0,  
                                        wr_data_valid_p3,
                                        wr_data_ready_p3,       // 159:128
                                        wr_data_p3              // 127:0
                                        }
                                        :
                                        640'h0
                                    ),
        .din_aux                    (),

        .stop                       (flit_logger_stop),

        .PicoClk                    (PicoClk),
        .PicoRst                    (PicoRst),
        .PicoRd                     (PicoRd),
        .PicoWr                     (PicoWr),
        .PicoAddr                   (PicoAddr),
        .PicoDataIn                 (PicoDataIn),
        .PicoDataOut                (flit_logger_debug_dout[3])
    );
    flit_logger #(
        .BASE_ADDR                  (32'h1060000)
    ) tx_port_4_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        ((cmd_valid_p4 & cmd_ready_p4) ||
                                         (wr_data_valid_p4 & wr_data_ready_p4)) ? 
                                        {
                                        30'h0,  addr_p4,        // 383:320
                                        32'h0,
                                        28'h0,  size_p4,        // 289:256
                                        26'h0,  tag_p4,         // 255:224
                                        30'h0,  
                                        cmd_valid_p4,
                                        cmd_ready_p4,           // 223:192
                                        28'h0,  cmd_p4,         // 191:160
                                        30'h0,  
                                        wr_data_valid_p4,
                                        wr_data_ready_p4,       // 159:128
                                        wr_data_p4              // 127:0
                                        }
                                        :
                                        640'h0
                                    ),
        .din_aux                    (),

        .stop                       (flit_logger_stop),

        .PicoClk                    (PicoClk),
        .PicoRst                    (PicoRst),
        .PicoRd                     (PicoRd),
        .PicoWr                     (PicoWr),
        .PicoAddr                   (PicoAddr),
        .PicoDataIn                 (PicoDataIn),
        .PicoDataOut                (flit_logger_debug_dout[4])
    );
`else // ENABLE_PORT_FLIT_LOGGERS
    assign  flit_logger_debug_dout  [0]  =   'h0;
    assign  flit_logger_debug_dout  [1]  =   'h0;
    assign  flit_logger_debug_dout  [2]  =   'h0;
    assign  flit_logger_debug_dout  [3]  =   'h0;
    assign  flit_logger_debug_dout  [4]  =   'h0;
`endif // ENABLE_PORT_FLIT_LOGGERS

    assign  PicoDataOut     =   32'h0                           |
                                flit_logger_debug_dout  [0]     |
                                flit_logger_debug_dout  [1]     |
                                flit_logger_debug_dout  [2]     |
                                flit_logger_debug_dout  [3]     |
                                flit_logger_debug_dout  [4]     |
                                32'h0;

endmodule
