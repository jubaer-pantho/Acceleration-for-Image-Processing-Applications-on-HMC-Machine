/*
* File Name     : debug_pll.v
*
* Description   : This wrapper module provides an agnostic interface for
*                 creating either an Altera PLL or a Xilinx MMCM.
*
* Copyright     : 2015, Micron, Inc.
*/
`include "hmc_def.vh"
`include "hmc_cfg.vh"
module debug_pll (
    input                           refclk,
    input                           rst,

    output                          outclk_0,
    output                          outclk_1,
    output                          outclk_2,

    output                          locked
);
    `define XILINX_FPGA

`ifdef XILINX_FPGA
    ////////////
    // XILINX //
    ////////////
    
    // refclk   = 200 MHz
    // outclk_0 =  50 MHz
    // outclk_1 =   5 MHz
    // outclk_2 = 208 MHz
    MMCME3_ADV #(
        .BANDWIDTH                  ("OPTIMIZED"),
        .CLKOUT4_CASCADE            ("FALSE"),
        .COMPENSATION               ("AUTO"),
        .STARTUP_WAIT               ("FALSE"),
        .DIVCLK_DIVIDE              (1),
        .CLKFBOUT_MULT_F            (3.125),
        .CLKFBOUT_PHASE             (0.000),
        .CLKFBOUT_USE_FINE_PS       ("FALSE"),
        .CLKOUT0_DIVIDE_F           (12.500),
        .CLKOUT0_PHASE              (0.000),
        .CLKOUT0_DUTY_CYCLE         (0.500),
        .CLKOUT0_USE_FINE_PS        ("FALSE"),
        .CLKOUT1_DIVIDE             (125),
        .CLKOUT1_PHASE              (0.000),
        .CLKOUT1_DUTY_CYCLE         (0.500),
        .CLKOUT1_USE_FINE_PS        ("FALSE"),
        .CLKOUT2_DIVIDE             (3),
        .CLKOUT2_PHASE              (0.000),
        .CLKOUT2_DUTY_CYCLE         (0.500),
        .CLKOUT2_USE_FINE_PS        ("FALSE"),
        .CLKIN1_PERIOD              (5.0)
    ) mmcme3_adv_inst (
        // Output clocks
        .CLKFBOUT                   (clkfbout_clk_wiz_0),
        .CLKOUT0                    (clk_out0_clk_wiz_0),
        .CLKOUT1                    (clk_out1_clk_wiz_0),
        .CLKOUT2                    (clk_out2_clk_wiz_0),
        // Input clock control
        .CLKFBIN                    (clkfbout_buf_clk_wiz_0),
        .CLKIN1                     (refclk),
        .CLKIN2                     (1'b0),
        // Tied to always select the primary input clock
        .CLKINSEL                   (1'b1),
        // Ports for dynamic reconfiguration
        .DADDR                      (7'h0),
        .DCLK                       (1'b0),
        .DEN                        (1'b0),
        .DI                         (16'h0),
        .DWE                        (1'b0),
        .CDDCDONE                   (),
        .CDDCREQ                    (1'b0),
        // Ports for dynamic phase shift
        .PSCLK                      (1'b0),
        .PSEN                       (1'b0),
        .PSINCDEC                   (1'b0),
        // Other control and status signals
        .LOCKED                     (locked),
        .PWRDWN                     (1'b0),
        .RST                        (rst)
    );
    BUFG clkf_buf (
        .O                          (clkfbout_buf_clk_wiz_0),
        .I                          (clkfbout_clk_wiz_0)
    );
    BUFG clkout0_buf (
        .O                          (outclk_0),
        .I                          (clk_out0_clk_wiz_0)
    );
    BUFG clkout1_buf (
        .O                          (outclk_1),
        .I                          (clk_out1_clk_wiz_0)
    );
    BUFG clkout2_buf (
        .O                          (outclk_2),
        .I                          (clk_out2_clk_wiz_0)
    );

`else
    ////////////
    // ALTERA //
    ////////////

    // refclk   = 200 MHz
    // outclk_0 = 100 MHz
    // outclk_1 =   4 MHz
    // outclk_2 = 250 MHz
    debug_pll altera_debug_pll (
        .refclk                     (refclk),
        .rst                        (rst),
        .outclk_0                   (outclk_0),
        .outclk_1                   (outclk_1),
        .outclk_2                   (outclk_2),
        .locked                     (locked)
    );
`endif

endmodule
