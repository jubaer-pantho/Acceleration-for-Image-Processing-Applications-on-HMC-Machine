`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2016 01:37:02 PM
// Design Name: 
// Module Name: newGupsWrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// gups_wrapper.v

module newGupsWrapper #(
        parameter SIZE_WIDTH = 4,
        parameter ADDR_WIDTH = 34,
        parameter DATA_WIDTH = 128
        ) (
        input                       hmc_tx_clk,
        input                       hmc_rx_clk,
        input                       hmc_rst,
        input                       hmc_trained,

        output                      hmc_clk_p0,
        output                      hmc_cmd_valid_p0,
        input                       hmc_cmd_ready_p0,
        output [3:0]                hmc_cmd_p0,
        output [ADDR_WIDTH-1:0]     hmc_addr_p0,
        output [SIZE_WIDTH-1:0]     hmc_size_p0,
        output [5:0]                hmc_tag_p0,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p0,
        output                      hmc_wr_data_valid_p0,
        input                       hmc_wr_data_ready_p0,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p0,
        input [5:0]                 hmc_rd_data_tag_p0,
        input                       hmc_rd_data_valid_p0,
        input [6:0]                 hmc_errstat_p0,
        input                       hmc_dinv_p0,
        output                      hmc_clk_p1,
        output                      hmc_cmd_valid_p1,
        input                       hmc_cmd_ready_p1,
        output [3:0]                hmc_cmd_p1,
        output [ADDR_WIDTH-1:0]     hmc_addr_p1,
        output [SIZE_WIDTH-1:0]     hmc_size_p1,
        output [5:0]                hmc_tag_p1,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p1,
        output                      hmc_wr_data_valid_p1,
        input                       hmc_wr_data_ready_p1,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p1,
        input [5:0]                 hmc_rd_data_tag_p1,
        input                       hmc_rd_data_valid_p1,
        input [6:0]                 hmc_errstat_p1,
        input                       hmc_dinv_p1,
        output                      hmc_clk_p2,
        output                      hmc_cmd_valid_p2,
        input                       hmc_cmd_ready_p2,
        output [3:0]                hmc_cmd_p2,
        output [ADDR_WIDTH-1:0]     hmc_addr_p2,
        output [SIZE_WIDTH-1:0]     hmc_size_p2,
        output [5:0]                hmc_tag_p2,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p2,
        output                      hmc_wr_data_valid_p2,
        input                       hmc_wr_data_ready_p2,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p2,
        input [5:0]                 hmc_rd_data_tag_p2,
        input                       hmc_rd_data_valid_p2,
        input [6:0]                 hmc_errstat_p2,
        input                       hmc_dinv_p2,
        output                      hmc_clk_p3,
        output                      hmc_cmd_valid_p3,
        input                       hmc_cmd_ready_p3,
        output [3:0]                hmc_cmd_p3,
        output [ADDR_WIDTH-1:0]     hmc_addr_p3,
        output [SIZE_WIDTH-1:0]     hmc_size_p3,
        output [5:0]                hmc_tag_p3,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p3,
        output                      hmc_wr_data_valid_p3,
        input                       hmc_wr_data_ready_p3,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p3,
        input [5:0]                 hmc_rd_data_tag_p3,
        input                       hmc_rd_data_valid_p3,
        input [6:0]                 hmc_errstat_p3,
        input                       hmc_dinv_p3,
        output                      hmc_clk_p4,
        output                      hmc_cmd_valid_p4,
        input                       hmc_cmd_ready_p4,
        output [3:0]                hmc_cmd_p4,
        output [ADDR_WIDTH-1:0]     hmc_addr_p4,
        output [SIZE_WIDTH-1:0]     hmc_size_p4,
        output [5:0]                hmc_tag_p4,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p4,
        output                      hmc_wr_data_valid_p4,
        input                       hmc_wr_data_ready_p4,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p4,
        input [5:0]                 hmc_rd_data_tag_p4,
        input                       hmc_rd_data_valid_p4,
        input [6:0]                 hmc_errstat_p4,
        input                       hmc_dinv_p4,
        output                      hmc_clk_p5,
        output                      hmc_cmd_valid_p5,
        input                       hmc_cmd_ready_p5,
        output [3:0]                hmc_cmd_p5,
        output [ADDR_WIDTH-1:0]     hmc_addr_p5,
        output [SIZE_WIDTH-1:0]     hmc_size_p5,
        output [5:0]                hmc_tag_p5,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p5,
        output                      hmc_wr_data_valid_p5,
        input                       hmc_wr_data_ready_p5,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p5,
        input [5:0]                 hmc_rd_data_tag_p5,
        input                       hmc_rd_data_valid_p5,
        input [6:0]                 hmc_errstat_p5,
        input                       hmc_dinv_p5,
        output                      hmc_clk_p6,
        output                      hmc_cmd_valid_p6,
        input                       hmc_cmd_ready_p6,
        output [3:0]                hmc_cmd_p6,
        output [ADDR_WIDTH-1:0]     hmc_addr_p6,
        output [SIZE_WIDTH-1:0]     hmc_size_p6,
        output [5:0]                hmc_tag_p6,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p6,
        output                      hmc_wr_data_valid_p6,
        input                       hmc_wr_data_ready_p6,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p6,
        input [5:0]                 hmc_rd_data_tag_p6,
        input                       hmc_rd_data_valid_p6,
        input [6:0]                 hmc_errstat_p6,
        input                       hmc_dinv_p6,
        output                      hmc_clk_p7,
        output                      hmc_cmd_valid_p7,
        input                       hmc_cmd_ready_p7,
        output [3:0]                hmc_cmd_p7,
        output [ADDR_WIDTH-1:0]     hmc_addr_p7,
        output [SIZE_WIDTH-1:0]     hmc_size_p7,
        output [5:0]                hmc_tag_p7,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p7,
        output                      hmc_wr_data_valid_p7,
        input                       hmc_wr_data_ready_p7,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p7,
        input [5:0]                 hmc_rd_data_tag_p7,
        input                       hmc_rd_data_valid_p7,
        input [6:0]                 hmc_errstat_p7,
        input                       hmc_dinv_p7,
        output                      hmc_clk_p8,
        output                      hmc_cmd_valid_p8,
        input                       hmc_cmd_ready_p8,
        output [3:0]                hmc_cmd_p8,
        output [ADDR_WIDTH-1:0]     hmc_addr_p8,
        output [SIZE_WIDTH-1:0]     hmc_size_p8,
        output [5:0]                hmc_tag_p8,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p8,
        output                      hmc_wr_data_valid_p8,
        input                       hmc_wr_data_ready_p8,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p8,
        input [5:0]                 hmc_rd_data_tag_p8,
        input                       hmc_rd_data_valid_p8,
        input [6:0]                 hmc_errstat_p8,
        input                       hmc_dinv_p8,
        output                      hmc_clk_p9,
        output                      hmc_cmd_valid_p9,
        input                       hmc_cmd_ready_p9,
        output [3:0]                hmc_cmd_p9,
        output [ADDR_WIDTH-1:0]     hmc_addr_p9,
        output [SIZE_WIDTH-1:0]     hmc_size_p9,
        output [5:0]                hmc_tag_p9,
        output [DATA_WIDTH-1:0]     hmc_wr_data_p9,
        output                      hmc_wr_data_valid_p9,
        input                       hmc_wr_data_ready_p9,

        input [DATA_WIDTH-1:0]      hmc_rd_data_p9,
        input [5:0]                 hmc_rd_data_tag_p9,
        input                       hmc_rd_data_valid_p9,
        input [6:0]                 hmc_errstat_p9,
        input                       hmc_dinv_p9,

        input                       PicoClk,
        input                       PicoRst,
        input  [31:0]               PicoAddr,
        input  [31:0]               PicoDataIn,
        output [31:0]               PicoDataOut,
        input                       PicoRd,
        input                       PicoWr
    );

    // Note: for now our GUPS modules do not pay attention to the errstat or
    // the dinv signals.  Properly constructed user modules should absolutely
    // pay attention to those signals.  The encoding for the errstat signals
    // can be found in the HMC consortium spec.

    // Use hmc_tx_clk as the user clock for all ports
    // or the really slow PicoClk as the user clock.
    // This is just to help us debug, because problems should be REALLY
    // obvious with a large difference in the clocks
    // TODO: in the future, we should completely re-write the GUPS modules
    // to just use a single clock. we should also let them define whatever
    // clock they want to use.
//  assign  hmc_clk_p0              = PicoClk;      // slow user clock
    assign  hmc_clk_p0              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p1              = PicoClk;      // slow user clock
    assign  hmc_clk_p1              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p2              = PicoClk;      // slow user clock
    assign  hmc_clk_p2              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p3              = PicoClk;      // slow user clock
    assign  hmc_clk_p3              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p4              = PicoClk;      // slow user clock
    assign  hmc_clk_p4              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p5              = PicoClk;      // slow user clock
    assign  hmc_clk_p5              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p6              = PicoClk;      // slow user clock
    assign  hmc_clk_p6              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p7              = PicoClk;      // slow user clock
    assign  hmc_clk_p7              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p8              = PicoClk;      // slow user clock
    assign  hmc_clk_p8              = hmc_tx_clk ;  // fast user clock
//  assign  hmc_clk_p9              = PicoClk;      // slow user clock
    assign  hmc_clk_p9              = hmc_tx_clk ;  // fast user clock

    user_wrapper user_wrapper (
        .tx_clk                         (hmc_clk_p0),
        .rx_clk                         (hmc_clk_p0),
        .hmc_rst                        (hmc_rst),
        .hmc_trained                    (hmc_trained),

        .addr_p0                     (hmc_addr_p0),
        .size_p0                     (hmc_size_p0),
        .tag_p0                      (hmc_tag_p0),
        .cmd_valid_p0                (hmc_cmd_valid_p0),
        .cmd_ready_p0                (hmc_cmd_ready_p0),
        .cmd_p0                      (hmc_cmd_p0),
        .wr_data_p0                  (hmc_wr_data_p0),
        .wr_data_valid_p0            (hmc_wr_data_valid_p0),
        .wr_data_ready_p0            (hmc_wr_data_ready_p0),
        .rd_data_p0                  (hmc_rd_data_p0),
        .rd_data_tag_p0              (hmc_rd_data_tag_p0),
        .rd_data_valid_p0            (hmc_rd_data_valid_p0),

        .addr_p1                     (hmc_addr_p1),
        .size_p1                     (hmc_size_p1),
        .tag_p1                      (hmc_tag_p1),
        .cmd_valid_p1                (hmc_cmd_valid_p1),
        .cmd_ready_p1                (hmc_cmd_ready_p1),
        .cmd_p1                      (hmc_cmd_p1),
        .wr_data_p1                  (hmc_wr_data_p1),
        .wr_data_valid_p1            (hmc_wr_data_valid_p1),
        .wr_data_ready_p1            (hmc_wr_data_ready_p1),
        .rd_data_p1                  (hmc_rd_data_p1),
        .rd_data_tag_p1              (hmc_rd_data_tag_p1),
        .rd_data_valid_p1            (hmc_rd_data_valid_p1),

        .addr_p2                     (hmc_addr_p2),
        .size_p2                     (hmc_size_p2),
        .tag_p2                      (hmc_tag_p2),
        .cmd_valid_p2                (hmc_cmd_valid_p2),
        .cmd_ready_p2                (hmc_cmd_ready_p2),
        .cmd_p2                      (hmc_cmd_p2),
        .wr_data_p2                  (hmc_wr_data_p2),
        .wr_data_valid_p2            (hmc_wr_data_valid_p2),
        .wr_data_ready_p2            (hmc_wr_data_ready_p2),
        .rd_data_p2                  (hmc_rd_data_p2),
        .rd_data_tag_p2              (hmc_rd_data_tag_p2),
        .rd_data_valid_p2            (hmc_rd_data_valid_p2),

        .addr_p3                     (hmc_addr_p3),
        .size_p3                     (hmc_size_p3),
        .tag_p3                      (hmc_tag_p3),
        .cmd_valid_p3                (hmc_cmd_valid_p3),
        .cmd_ready_p3                (hmc_cmd_ready_p3),
        .cmd_p3                      (hmc_cmd_p3),
        .wr_data_p3                  (hmc_wr_data_p3),
        .wr_data_valid_p3            (hmc_wr_data_valid_p3),
        .wr_data_ready_p3            (hmc_wr_data_ready_p3),
        .rd_data_p3                  (hmc_rd_data_p3),
        .rd_data_tag_p3              (hmc_rd_data_tag_p3),
        .rd_data_valid_p3            (hmc_rd_data_valid_p3),

        .addr_p4                     (hmc_addr_p4),
        .size_p4                     (hmc_size_p4),
        .tag_p4                      (hmc_tag_p4),
        .cmd_valid_p4                (hmc_cmd_valid_p4),
        .cmd_ready_p4                (hmc_cmd_ready_p4),
        .cmd_p4                      (hmc_cmd_p4),
        .wr_data_p4                  (hmc_wr_data_p4),
        .wr_data_valid_p4            (hmc_wr_data_valid_p4),
        .wr_data_ready_p4            (hmc_wr_data_ready_p4),
        .rd_data_p4                  (hmc_rd_data_p4),
        .rd_data_tag_p4              (hmc_rd_data_tag_p4),
        .rd_data_valid_p4            (hmc_rd_data_valid_p4),

        .addr_p5                     (hmc_addr_p5),
        .size_p5                     (hmc_size_p5),
        .tag_p5                      (hmc_tag_p5),
        .cmd_valid_p5                (hmc_cmd_valid_p5),
        .cmd_ready_p5                (hmc_cmd_ready_p5),
        .cmd_p5                      (hmc_cmd_p5),
        .wr_data_p5                  (hmc_wr_data_p5),
        .wr_data_valid_p5            (hmc_wr_data_valid_p5),
        .wr_data_ready_p5            (hmc_wr_data_ready_p5),
        .rd_data_p5                  (hmc_rd_data_p5),
        .rd_data_tag_p5              (hmc_rd_data_tag_p5),
        .rd_data_valid_p5            (hmc_rd_data_valid_p5),

        .addr_p6                     (hmc_addr_p6),
        .size_p6                     (hmc_size_p6),
        .tag_p6                      (hmc_tag_p6),
        .cmd_valid_p6                (hmc_cmd_valid_p6),
        .cmd_ready_p6                (hmc_cmd_ready_p6),
        .cmd_p6                      (hmc_cmd_p6),
        .wr_data_p6                  (hmc_wr_data_p6),
        .wr_data_valid_p6            (hmc_wr_data_valid_p6),
        .wr_data_ready_p6            (hmc_wr_data_ready_p6),
        .rd_data_p6                  (hmc_rd_data_p6),
        .rd_data_tag_p6              (hmc_rd_data_tag_p6),
        .rd_data_valid_p6            (hmc_rd_data_valid_p6),

        .addr_p7                     (hmc_addr_p7),
        .size_p7                     (hmc_size_p7),
        .tag_p7                      (hmc_tag_p7),
        .cmd_valid_p7                (hmc_cmd_valid_p7),
        .cmd_ready_p7                (hmc_cmd_ready_p7),
        .cmd_p7                      (hmc_cmd_p7),
        .wr_data_p7                  (hmc_wr_data_p7),
        .wr_data_valid_p7            (hmc_wr_data_valid_p7),
        .wr_data_ready_p7            (hmc_wr_data_ready_p7),
        .rd_data_p7                  (hmc_rd_data_p7),
        .rd_data_tag_p7              (hmc_rd_data_tag_p7),
        .rd_data_valid_p7            (hmc_rd_data_valid_p7),

        .addr_p8                     (hmc_addr_p8),
        .size_p8                     (hmc_size_p8),
        .tag_p8                      (hmc_tag_p8),
        .cmd_valid_p8                (hmc_cmd_valid_p8),
        .cmd_ready_p8                (hmc_cmd_ready_p8),
        .cmd_p8                      (hmc_cmd_p8),
        .wr_data_p8                  (hmc_wr_data_p8),
        .wr_data_valid_p8            (hmc_wr_data_valid_p8),
        .wr_data_ready_p8            (hmc_wr_data_ready_p8),
        .rd_data_p8                  (hmc_rd_data_p8),
        .rd_data_tag_p8              (hmc_rd_data_tag_p8),
        .rd_data_valid_p8            (hmc_rd_data_valid_p8),

        .addr_p9                     (hmc_addr_p9),
        .size_p9                     (hmc_size_p9),
        .tag_p9                      (hmc_tag_p9),
        .cmd_valid_p9                (hmc_cmd_valid_p9),
        .cmd_ready_p9                (hmc_cmd_ready_p9),
        .cmd_p9                      (hmc_cmd_p9),
        .wr_data_p9                  (hmc_wr_data_p9),
        .wr_data_valid_p9            (hmc_wr_data_valid_p9),
        .wr_data_ready_p9            (hmc_wr_data_ready_p9),
        .rd_data_p9                  (hmc_rd_data_p9),
        .rd_data_tag_p9              (hmc_rd_data_tag_p9),
        .rd_data_valid_p9            (hmc_rd_data_valid_p9),


        .PicoClk                        (PicoClk),
        .PicoRst                        (PicoRst),
        .PicoRd                         (PicoRd),
        .PicoWr                         (PicoWr),
        .PicoAddr                       (PicoAddr),
        .PicoDataIn                     (PicoDataIn),
        .PicoDataOut                    (PicoDataOut)
    );

endmodule