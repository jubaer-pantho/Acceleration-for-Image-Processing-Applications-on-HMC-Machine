// hmc_top.v
// Copyright 2014 Pico Computing, Inc.

`timescale 1ns / 1ps

`include "hmc_def.vh"
`include "hmc_cfg.vh"

//`define ENABLE_SOURCEPROBE
`define ENABLE_PCIE

`ifdef SIMULATION
    `define HMC_N_PORTS 5
`else
`ifndef HMC_N_PORTS
    `define HMC_N_PORTS 5
`endif
`endif
/*
 * Top level project module
 */
module hmc_top # (parameter N_PORTS = `HMC_N_PORTS,
                  parameter HMC_LINK_NUMBER = 0) (
    // HMC Link Interface
    input  refclk,
`ifdef XILINX_FPGA
	input  [`LANES-1:0] lxrxp,
	input  [`LANES-1:0] lxrxn,
	output [`LANES-1:0] lxtxp,
	output [`LANES-1:0] lxtxn,
`else
    input  [`LANES-1:0] lxrx,
    output [`LANES-1:0] lxtx,
`endif

    // HMC Power Save Pins
    output lxrxps,
    input  lxtxps,

    // HMC Error Interrupt
    input  ferr_n,

    // HMC Global Reset
    inout  p_rst_n,

    // HMC I2C
    inout  scl,
    inout  sda,

    // HMC Power I2C
    inout  hmc_power_scl,
    inout  hmc_power_sda,

    // Stratix Power I2C
    inout  stratix_power_scl,
    inout  stratix_power_sda,

    // Temp I2C
    inout  stratix_temp_scl,
    inout  stratix_temp_sda,

    // Total System Power
    inout  system_power_scl,
    inout  system_power_sda,

    // HMC ID
    input  [1:0] fpga_id,

    // Extra Clk
    input  extra_clk,

    output              hmc_tx_clk,
    output              hmc_rx_clk,
    output              hmc_rst_out,

    input               clk_p0,
    input               cmd_valid_p0,
    output              cmd_ready_p0,
    input [3:0]         cmd_p0,
    input [33:0]        addr_p0,
    input [3:0]         size_p0,
    input [5:0]         tag_p0,
    input [127:0]       wr_data_p0,
    input               wr_data_valid_p0,
    output              wr_data_ready_p0,

    output [127:0]      rd_data_p0,
    output [5:0]        rd_data_tag_p0,
    output [6:0]        errstat_p0,
    output              dinv_p0,
    output              rd_data_valid_p0,

    input               clk_p1,
    input               cmd_valid_p1,
    output              cmd_ready_p1,
    input [3:0]         cmd_p1,
    input [33:0]        addr_p1,
    input [3:0]         size_p1,
    input [5:0]         tag_p1,
    input [127:0]       wr_data_p1,
    input               wr_data_valid_p1,
    output              wr_data_ready_p1,

    output [127:0]      rd_data_p1,
    output [5:0]        rd_data_tag_p1,
    output [6:0]        errstat_p1,
    output              dinv_p1,
    output              rd_data_valid_p1,

    input               clk_p2,
    input               cmd_valid_p2,
    output              cmd_ready_p2,
    input [3:0]         cmd_p2,
    input [33:0]        addr_p2,
    input [3:0]         size_p2,
    input [5:0]         tag_p2,
    input [127:0]       wr_data_p2,
    input               wr_data_valid_p2,
    output              wr_data_ready_p2,

    output [127:0]      rd_data_p2,
    output [5:0]        rd_data_tag_p2,
    output [6:0]        errstat_p2,
    output              dinv_p2,
    output              rd_data_valid_p2,

    input               clk_p3,
    input               cmd_valid_p3,
    output              cmd_ready_p3,
    input [3:0]         cmd_p3,
    input [33:0]        addr_p3,
    input [3:0]         size_p3,
    input [5:0]         tag_p3,
    input [127:0]       wr_data_p3,
    input               wr_data_valid_p3,
    output              wr_data_ready_p3,

    output [127:0]      rd_data_p3,
    output [5:0]        rd_data_tag_p3,
    output [6:0]        errstat_p3,
    output              dinv_p3,
    output              rd_data_valid_p3,

    input               clk_p4,
    input               cmd_valid_p4,
    output              cmd_ready_p4,
    input [3:0]         cmd_p4,
    input [33:0]        addr_p4,
    input [3:0]         size_p4,
    input [5:0]         tag_p4,
    input [127:0]       wr_data_p4,
    input               wr_data_valid_p4,
    output              wr_data_ready_p4,

    output [127:0]      rd_data_p4,
    output [5:0]        rd_data_tag_p4,
    output [6:0]        errstat_p4,
    output              dinv_p4,
    output              rd_data_valid_p4,


    input               PicoClk,
    input               PicoRst,
    input  [31:0]       PicoAddr,
    input  [31:0]       PicoDataIn,
    output [31:0]       PicoDataOut,
    input               PicoRd,
    input               PicoWr,

    output              hmc_trained_out
);

(* KEEP *) wire rx_clk, tx_clk;
(* KEEP *) wire hmc_trained;

assign hmc_rx_clk = rx_clk;
assign hmc_tx_clk = tx_clk;

wire [639:0] hmc_tx_data, hmc_rx_data; // wires for the controller to connect to the phy

wire [510:0] source;
wire [510:0] probe;
`ifdef ENABLE_SOURCEPROBE
sourceprobe sourceprobe (
    .source(source),
    .probe(probe)
);
`else
assign source = 511'h0;
`endif

wire extra_clk_slow;

wire [31:0] Debug_PicoDataOut;

`ifdef SIMULATION
debug_clk_gen debug_pll (
    .extra_clk(extra_clk),
    .extra_clk_slow(extra_clk_slow)
);
`else
(* KEEP *) wire signaltap_clk;
debug_pll debug_pll (
    .refclk(extra_clk),
    .rst(1'b0),
    .outclk_0(extra_clk_slow),
//    .outclk_1(debug_clk),
//    .outclk_2(signaltap_clk),
    .locked()
);
`endif // SIMULATION


wire [31:0] I2C_PicoDataOut;
assign PicoDataOut = I2C_PicoDataOut | Debug_PicoDataOut;

picobus_to_i2c picobus_to_i2c (
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(I2C_PicoDataOut),
    .scl(scl),
    .sda(sda),
    .hmc_power_scl(hmc_power_scl),
    .hmc_power_sda(hmc_power_sda),
    .stratix_power_scl(stratix_power_scl),
    .stratix_power_sda(stratix_power_sda),
    .stratix_temp_scl(stratix_temp_scl),
    .stratix_temp_sda(stratix_temp_sda),
    .system_power_scl(system_power_scl),
    .system_power_sda(system_power_sda)
);

(* KEEP *) wire [31:0] hmc_init_debug_dout;
hmc_init hmc_init (
    .extra_clk(extra_clk_slow),
    .lxrxps(lxrxps),
    .lxtxps(lxtxps),
    .p_rst_n(p_rst_n),
    .fpga_id(fpga_id),
    .debug_clk(PicoClk),
    .debug_addr(PicoAddr),
    .debug_din(PicoDataIn),
    .debug_dout(hmc_init_debug_dout),
    .debug_rd(PicoRd),
    .debug_wr(PicoWr)
);

(* KEEP *) wire [31:0] hmc_phy_debug_dout;
hmc_phy #(.HMC_LINK_NUMBER(HMC_LINK_NUMBER)) 
    hmc_phy (
    .refclk(refclk),
`ifdef XILINX_FPGA
    .lxrxp(lxrxp),
    .lxrxn(lxrxn),
    .lxtxp(lxtxp),
    .lxtxn(lxtxn),
`else
    .lxrx(lxrx),
    .lxtx(lxtx),
`endif
    .extra_clk(extra_clk_slow),
    .hmc_trained(hmc_trained),
    .rx_clk(rx_clk),
    .rx_data(hmc_rx_data),
    .tx_clk(tx_clk),
    .tx_data(hmc_tx_data),
    .debug_clk(PicoClk),
    .debug_addr(PicoAddr),
    .debug_din(PicoDataIn),
    .debug_dout(hmc_phy_debug_dout),
    .debug_rd(PicoRd),
    .debug_wr(PicoWr)
);




// quartus 13.1 goes completely off the rails, timing-wise, if this is removed!
// (things near the transceivers start failing with -1.7ns slack.)
wire flit_logger_stop;
wire [31:0] rx_debug_dout;
`ifdef ENABLE_BOUNDARY_FLIT_LOGGERS
flit_logger
    #(.BASE_ADDR(32'hfe0000), .NAME("RX"))
rx_flit_logger (
    .clk(rx_clk),
    .rst(~hmc_trained),
    .din(hmc_rx_data[639:0]),

    .stop(flit_logger_stop),

    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataIn(PicoDataIn),
    .PicoDataOut(rx_debug_dout)
    );
`else
assign rx_debug_dout = 'h0;
`endif //ENABLE_BOUNDARY_FLIT_LOGGERS

wire [31:0] tx_debug_dout;
`ifdef ENABLE_BOUNDARY_FLIT_LOGGERS
flit_logger
    #(.BASE_ADDR(32'hfd0000), .NAME("TX"))
tx_flit_logger (
    .clk(tx_clk),
    .rst(~hmc_trained),
    .din(hmc_tx_data[639:0]),

    .stop(flit_logger_stop),

    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataIn(PicoDataIn),
    .PicoDataOut(tx_debug_dout)
    );
`else
assign tx_debug_dout = 'h0;
`endif //ENABLE_BOUNDARY_FLIT_LOGGERS

wire [31:0] hmc_node_debug_dout;
wire [31:0] ctl_debug_dout;

assign Debug_PicoDataOut = hmc_init_debug_dout | hmc_phy_debug_dout | rx_debug_dout | tx_debug_dout | ctl_debug_dout | hmc_node_debug_dout;
/*
reg debug_rd_q=0;
always @(posedge PicoClk) begin
    debug_rd_q  <= PicoRd;
    if (debug_rd_q)
        $display("debug_rd data components, 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x",
            hmc_init_debug_dout, hmc_phy_debug_dout, rx_debug_dout, tx_debug_dout,
            ctl_debug_dout, user_debug_dout, hmc_node_debug_dout);
end
*/





    //wire   [4:0]  present_map, sof_map;
    reg             hmc_trained_q=0, hmc_trained_q2=0, hmc_trained_q3=0;

    assign hmc_trained_out = hmc_trained_q3;

    always @(posedge tx_clk) begin
        hmc_trained_q   <= hmc_trained;
        hmc_trained_q2  <= hmc_trained_q;
        hmc_trained_q3  <= hmc_trained_q2;
    end

    reg        ctl_rst = 1, ctl_rst_q=0, ctl_rst_q2=0;
    reg [31:0] ctl_debug_dout_reg;
    wire[31:0] hmc_ctrl_config_reg;
    reg [15:0] injected_tokens;
    assign ctl_debug_dout = ctl_debug_dout_reg;
    always @(posedge PicoClk) begin
        if (~hmc_trained)
            injected_tokens <= 0;
        else if (PicoWr && PicoAddr == 32'h480)
            injected_tokens <= injected_tokens + PicoDataIn[4:0];

        if (PicoWr && PicoAddr == 32'h404)  ctl_rst             <= PicoDataIn[0];

        ctl_debug_dout_reg  <= 32'h0;
        if (PicoRd && PicoAddr == 32'h400)  ctl_debug_dout_reg  <= {32'hdecaf0, `HMC_CTRL_VER};
        if (PicoRd && PicoAddr == 32'h404)  ctl_debug_dout_reg  <= {12'h404, 16'h0, 2'h0, ctl_rst, ctl_rst};
        if (PicoRd && PicoAddr == 32'h40c)  ctl_debug_dout_reg  <= {16'hcafe, injected_tokens[15:0]};
        if (PicoRd && PicoAddr == 32'h410)  ctl_debug_dout_reg  <= hmc_ctrl_config_reg;
    end

    // this lets us read our current configuration from the PicoBus
    // Note: these are all ifdefs that can be found in hmc_cfg.vh
    wire        [11:0]              flit_logger_depth               = `FLIT_LOGGER_DEPTH;
    wire                            enable_boundary_flit_loggers    = `ifdef ENABLE_BOUNDARY_FLIT_LOGGERS 1 `else 0 `endif;
    wire                            enable_port_flit_loggers        = `ifdef ENABLE_PORT_FLIT_LOGGERS 1 `else 0 `endif;
    wire                            enable_all_flit_loggers         = `ifdef ENABLE_ALL_FLIT_LOGGERS 1 `else 0 `endif;
    wire                            enable_error_injectors          = `ifdef ENABLE_ERROR_INJECTORS 1 `else 0 `endif;
    wire                            enable_verify_gc_tx             = `ifdef ENABLE_VERIFY_GC_TX 1 `else 0 `endif;
    wire                            enable_verify_flow_control      = `ifdef ENABLE_VERIFY_FLOW_CONTROL 1 `else 0 `endif;
    wire                            enable_verify_find_pkts         = `ifdef ENABLE_VERIFY_FIND_PKTS 1 `else 0 `endif;
    wire                            enable_rx_crc                   = `ifdef ENABLE_RX_CRC 1 `else 0 `endif;
    wire                            enable_pkt_stat_post_retry      = `ifdef ENABLE_PKT_STAT_POST_RETRY 1 `else 0 `endif;
    wire                            enable_pkt_stat                 = `ifdef ENABLE_PKT_STAT 1 `else 0 `endif;
    assign  hmc_ctrl_config_reg     =   {
                                        flit_logger_depth,              // [31:20]
                                        1'b0,
                                        enable_port_flit_loggers,       // [18]
                                        enable_boundary_flit_loggers,   // [17]
                                        enable_all_flit_loggers,        // [16]
                                        3'b0,
                                        enable_error_injectors,         // [12]
                                        1'b0,
                                        enable_verify_gc_tx,            // [10]
                                        enable_verify_flow_control,     // [9]
                                        enable_verify_find_pkts,        // [8]
                                        3'b0,
                                        enable_rx_crc,                  // [4]
                                        2'b0,
                                        enable_pkt_stat_post_retry,     // [1]
                                        enable_pkt_stat                 // [0]
                                        };

    always @(posedge tx_clk) begin
        ctl_rst_q   <= ctl_rst;
        ctl_rst_q2  <= ctl_rst_q;
    end

    hmc_node #(
        .name("B"),
        .BASE_ADDR(32'hc000),
        .N_PORTS(N_PORTS)
    ) hmc_node (
        .tx_clk(tx_clk),
        .rx_clk(rx_clk),
        .rst(ctl_rst_q2),

        .logger_rst(~hmc_trained),
        .debug_clk(PicoClk),
        .debug_rst(PicoRst),
        .debug_rd(PicoRd),
        .debug_wr(PicoWr),
        .debug_addr(PicoAddr),
        .debug_din(PicoDataIn),
        .debug_dout(hmc_node_debug_dout),

        .flit_logger_stop(flit_logger_stop),

        .clk_p0(clk_p0),
        .addr_p0(addr_p0),
        .size_p0(size_p0),
        .tag_p0(tag_p0),
        .cmd_valid_p0(cmd_valid_p0),
        .cmd_ready_p0(cmd_ready_p0),
        .cmd_p0(cmd_p0),
        .wr_data_p0(wr_data_p0),
        .wr_data_valid_p0(wr_data_valid_p0),
        .wr_data_ready_p0(wr_data_ready_p0),

        .rd_data_p0(rd_data_p0),
        .rd_data_tag_p0(rd_data_tag_p0),
        .error_response_p0({dinv_p0, errstat_p0}),
        .rd_data_valid_p0(rd_data_valid_p0),
        .clk_p1(clk_p1),
        .addr_p1(addr_p1),
        .size_p1(size_p1),
        .tag_p1(tag_p1),
        .cmd_valid_p1(cmd_valid_p1),
        .cmd_ready_p1(cmd_ready_p1),
        .cmd_p1(cmd_p1),
        .wr_data_p1(wr_data_p1),
        .wr_data_valid_p1(wr_data_valid_p1),
        .wr_data_ready_p1(wr_data_ready_p1),

        .rd_data_p1(rd_data_p1),
        .rd_data_tag_p1(rd_data_tag_p1),
        .error_response_p1({dinv_p1, errstat_p1}),
        .rd_data_valid_p1(rd_data_valid_p1),
        .clk_p2(clk_p2),
        .addr_p2(addr_p2),
        .size_p2(size_p2),
        .tag_p2(tag_p2),
        .cmd_valid_p2(cmd_valid_p2),
        .cmd_ready_p2(cmd_ready_p2),
        .cmd_p2(cmd_p2),
        .wr_data_p2(wr_data_p2),
        .wr_data_valid_p2(wr_data_valid_p2),
        .wr_data_ready_p2(wr_data_ready_p2),

        .rd_data_p2(rd_data_p2),
        .rd_data_tag_p2(rd_data_tag_p2),
        .error_response_p2({dinv_p2, errstat_p2}),
        .rd_data_valid_p2(rd_data_valid_p2),
        .clk_p3(clk_p3),
        .addr_p3(addr_p3),
        .size_p3(size_p3),
        .tag_p3(tag_p3),
        .cmd_valid_p3(cmd_valid_p3),
        .cmd_ready_p3(cmd_ready_p3),
        .cmd_p3(cmd_p3),
        .wr_data_p3(wr_data_p3),
        .wr_data_valid_p3(wr_data_valid_p3),
        .wr_data_ready_p3(wr_data_ready_p3),

        .rd_data_p3(rd_data_p3),
        .rd_data_tag_p3(rd_data_tag_p3),
        .error_response_p3({dinv_p3, errstat_p3}),
        .rd_data_valid_p3(rd_data_valid_p3),
        .clk_p4(clk_p4),
        .addr_p4(addr_p4),
        .size_p4(size_p4),
        .tag_p4(tag_p4),
        .cmd_valid_p4(cmd_valid_p4),
        .cmd_ready_p4(cmd_ready_p4),
        .cmd_p4(cmd_p4),
        .wr_data_p4(wr_data_p4),
        .wr_data_valid_p4(wr_data_valid_p4),
        .wr_data_ready_p4(wr_data_ready_p4),

        .rd_data_p4(rd_data_p4),
        .rd_data_tag_p4(rd_data_tag_p4),
        .error_response_p4({dinv_p4, errstat_p4}),
        .rd_data_valid_p4(rd_data_valid_p4),

        .dout(hmc_tx_data[639:0]),
        //.present_map(present_map),
        //.sof_map(sof_map),
        .din(hmc_rx_data[639:0])
        );

    assign hmc_rst_out = ctl_rst_q2;

endmodule
