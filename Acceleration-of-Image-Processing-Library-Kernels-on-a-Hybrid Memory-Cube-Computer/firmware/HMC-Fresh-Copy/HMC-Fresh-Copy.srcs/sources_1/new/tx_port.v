/*
* File Name     : tx_port.v
*
* Description   : This module handles the conversion of the user HMC
*                 interface to our 5-FLIT internal data bus.  This first
*                 converts the user HMC interface to the HMC packet protocol
*                 (in 128-bit FLITS).  It then packs those flits onto a 5-FLIT
*                 wide data bus.  Note that the output of this module will be
*                 talking to 1 of the ports on our arbiter.
*
* Copyright     : 2015, Micron Inc.
*/
`timescale 1ns / 1ps
module tx_port #(
    parameter name          = "",
    parameter verbose       = 0,
    parameter N_FLITS       = 5,
    parameter BUF_SIZE      = 10,
    parameter PORT          = 1
) (
    input               clk,
    input               rst,

    input               user_clk,
    input       [33:0]  addr,
    input        [3:0]  size,
    input        [5:0]  tag,
    input               cmd_valid,
    output              cmd_ready,
    input        [3:0]  cmd,
    input      [127:0]  wr_data,
    input               wr_data_valid,
    output              wr_data_ready,

    output     [639:0]          dout,
    output     [N_FLITS-1:0]    present_map,
    output     [N_FLITS-1:0]    sof_map,
    output     [N_FLITS-1:0]    eof_map,
    output     [N_FLITS*4-1:0]  len,
    output     [N_FLITS*4-1:0]  len_eof,
    output                      pkt_carry,
    input                       load
    );

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // this is the bus that comes out of the usr2flit module
    wire                            flit_valid;
    wire                            flit_ready;
    wire        [127:0]             flit;
    wire        [3:0]               flit_remain;
    wire                            flit_sof;
    wire                            flit_eof;
    
    //////////////////////
    // CONVERT TO FLITS //
    //////////////////////

    // this module takes our user HMC interface and turns that into a series
    // of FLITS that form packets, according to the HMC spec
    usr2flit #(.verbose(verbose), .PORT(PORT)) flitter (
        .clk(clk), .rst(rst),

        .user_clk(user_clk),
        .cmd_valid(cmd_valid),
        .cmd_ready(cmd_ready),
        .cmd(cmd),
        .addr(addr),
        .size(size),
        .tag(tag),
        .wr_data(wr_data),
        .wr_data_valid(wr_data_valid),
        .wr_data_ready(wr_data_ready),
        .dout(flit[127:0]),
        .flit_valid(flit_valid),
        .flit_ready(flit_ready),
        .flit_remain(flit_remain),
        .flit_sof(flit_sof),
        .flit_eof(flit_eof)
    );

    ////////////////////////
    // DE-SERIALIZE FLITS //
    ////////////////////////

    // this module accepts a serial stream of flits and outputs a bus of
    // parallel flits. this is a little special though, because we know that
    // when we are granted access, we will get that access for exactly
    // 2 cycles.  we also know that we will have 8 dead cycles between grants
    FlitsToParallel #(
        .N_FLITS                    (N_FLITS),
        .NAME                       ({name,".flits_to_parallel"}),
        .VERBOSE                    (verbose)
    ) flits_to_parallel (
        .clk                        (clk),
        .rst                        (rst),

        .flit                       (flit),
        .flit_valid                 (flit_valid),
        .flit_ready                 (flit_ready),
        .flit_remain                (flit_remain),
        .flit_sof                   (flit_sof),
        .flit_eof                   (flit_eof),

        .dout                       (dout),
        .present_map                (present_map),
        .sof_map                    (sof_map),
        .eof_map                    (eof_map),
        .len                        (len),
        .len_eof                    (len_eof),
        .pkt_carry                  (pkt_carry),
        .load                       (load)
    );

endmodule
