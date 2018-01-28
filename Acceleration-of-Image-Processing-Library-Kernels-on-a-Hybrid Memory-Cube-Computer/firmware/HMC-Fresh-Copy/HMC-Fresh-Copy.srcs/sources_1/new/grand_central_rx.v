// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

module grand_central_rx #(parameter name = "", parameter verbose = 0, N_PORTS = 5) (
    input  wire             clk,
    input  wire             rst,

    input                   clk_p0,
    output wire    [127:0]  data_p0,
    output wire      [8:0]  tag_p0,
    output wire      [7:0]  error_response_p0,
    output wire             data_valid_p0,

    input                   clk_p1,
    output wire    [127:0]  data_p1,
    output wire      [8:0]  tag_p1,
    output wire      [7:0]  error_response_p1,
    output wire             data_valid_p1,

    input                   clk_p2,
    output wire    [127:0]  data_p2,
    output wire      [8:0]  tag_p2,
    output wire      [7:0]  error_response_p2,
    output wire             data_valid_p2,

    input                   clk_p3,
    output wire    [127:0]  data_p3,
    output wire      [8:0]  tag_p3,
    output wire      [7:0]  error_response_p3,
    output wire             data_valid_p3,

    input                   clk_p4,
    output wire    [127:0]  data_p4,
    output wire      [8:0]  tag_p4,
    output wire      [7:0]  error_response_p4,
    output wire             data_valid_p4,

    
    input               PicoClk,
    input               PicoRst,
    input [31:0]        PicoAddr,
    input               PicoRd,
    input               PicoWr,
    input [31:0]        PicoDataIn,
    output  [31:0]      PicoDataOut,
    
    input               logger_rst,
    input               flit_logger_stop,

    input  wire    [639:0]  din,
    input  wire      [4:0]  present_map,
    input  wire      [4:0]  sof_map,
    input  wire      [4:0]  eof_map,
    input  wire     [44:0]  tag_map,
    input  wire     [39:0]  err_map
    );

    generate
    if (N_PORTS > 0) begin
    rx_port #(.name({name,".rx_port"}), .verbose(1), .PORT(1)) rx_port0 (
        .clk            (clk),
        .rst            (rst),

        .user_clk       (clk_p0),
        .data           (data_p0),
        .valid          (data_valid_p0),
        .tag            (tag_p0),
        .error_response (error_response_p0),

        .din            (din),
        .present_map    (present_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .tag_map        (tag_map),
        .err_map        (err_map)
    );
    end
    if (N_PORTS > 1) begin
    rx_port #(.name({name,".rx_port"}), .verbose(1), .PORT(2)) rx_port1 (
        .clk            (clk),
        .rst            (rst),

        .user_clk       (clk_p1),
        .data           (data_p1),
        .valid          (data_valid_p1),
        .tag            (tag_p1),
        .error_response (error_response_p1),

        .din            (din),
        .present_map    (present_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .tag_map        (tag_map),
        .err_map        (err_map)
    );
    end
    if (N_PORTS > 2) begin
    rx_port #(.name({name,".rx_port"}), .verbose(1), .PORT(3)) rx_port2 (
        .clk            (clk),
        .rst            (rst),

        .user_clk       (clk_p2),
        .data           (data_p2),
        .valid          (data_valid_p2),
        .tag            (tag_p2),
        .error_response (error_response_p2),

        .din            (din),
        .present_map    (present_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .tag_map        (tag_map),
        .err_map        (err_map)
    );
    end
    if (N_PORTS > 3) begin
    rx_port #(.name({name,".rx_port"}), .verbose(1), .PORT(4)) rx_port3 (
        .clk            (clk),
        .rst            (rst),

        .user_clk       (clk_p3),
        .data           (data_p3),
        .valid          (data_valid_p3),
        .tag            (tag_p3),
        .error_response (error_response_p3),

        .din            (din),
        .present_map    (present_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .tag_map        (tag_map),
        .err_map        (err_map)
    );
    end
    if (N_PORTS > 4) begin
    rx_port #(.name({name,".rx_port"}), .verbose(1), .PORT(5)) rx_port4 (
        .clk            (clk),
        .rst            (rst),

        .user_clk       (clk_p4),
        .data           (data_p4),
        .valid          (data_valid_p4),
        .tag            (tag_p4),
        .error_response (error_response_p4),

        .din            (din),
        .present_map    (present_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .tag_map        (tag_map),
        .err_map        (err_map)
    );
    end
    endgenerate
    
    wire        [31:0]              flit_logger_debug_dout  [0:4];
`ifdef ENABLE_PORT_FLIT_LOGGERS
    flit_logger #(
        .BASE_ADDR                  (32'h1120000)
    ) rx_port_0_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        data_valid_p0 ?
                                        {
                                        31'h0, data_valid_p0,    // 223:192
                                        24'h0, error_response_p0,// 191:160
                                        23'h0, tag_p0,           // 159:128
                                        data_p0              // 127:0
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
        .BASE_ADDR                  (32'h1130000)
    ) rx_port_1_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        data_valid_p1 ?
                                        {
                                        31'h0, data_valid_p1,    // 223:192
                                        24'h0, error_response_p1,// 191:160
                                        23'h0, tag_p1,           // 159:128
                                        data_p1              // 127:0
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
        .BASE_ADDR                  (32'h1140000)
    ) rx_port_2_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        data_valid_p2 ?
                                        {
                                        31'h0, data_valid_p2,    // 223:192
                                        24'h0, error_response_p2,// 191:160
                                        23'h0, tag_p2,           // 159:128
                                        data_p2              // 127:0
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
        .BASE_ADDR                  (32'h1150000)
    ) rx_port_3_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        data_valid_p3 ?
                                        {
                                        31'h0, data_valid_p3,    // 223:192
                                        24'h0, error_response_p3,// 191:160
                                        23'h0, tag_p3,           // 159:128
                                        data_p3              // 127:0
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
        .BASE_ADDR                  (32'h1160000)
    ) rx_port_4_logger (
        .clk                        (clk),
        .rst                        (logger_rst),

        .din                        (
                                        data_valid_p4 ?
                                        {
                                        31'h0, data_valid_p4,    // 223:192
                                        24'h0, error_response_p4,// 191:160
                                        23'h0, tag_p4,           // 159:128
                                        data_p4              // 127:0
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
