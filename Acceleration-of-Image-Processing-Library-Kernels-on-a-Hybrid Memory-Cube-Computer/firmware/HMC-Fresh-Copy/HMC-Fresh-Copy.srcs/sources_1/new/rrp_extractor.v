// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

`include "hmc_def.vh"

// This module gets the RRPs from a stream of flits.
// It now returns the FRPs as well, since they're extracted similarly. (But not exactly the same!)
module rrp_extractor #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*128         // total width of the flit data channel. each flit is 128b, so ...
    ) (
    input                   clk,
    input                   rst,

    input  [W-1:0]          din,
    input  [FLITS-1:0]      sof,
    input  [FLITS-1:0]      eof,

    output [8*FLITS-1:0]    rrp,
    output                  rrp_valid,

    output [8*FLITS-1:0]    frp,
    output                  frp_valid
    );

    `include "hmc_func.h.v"

    // these regs are where we extract the info from each of the parallel flits in the generate loop below.
    reg [7:0]           single_rrp [FLITS-1:0], single_frp [FLITS-1:0];
    reg [FLITS-1:0]     single_rrp_valid, single_frp_valid;

    // pipelining for timing
    reg [7:0]   last_rrp, last_rrp_q;
    reg         last_rrp_valid, last_rrp_valid_q;
    reg [7:0]   last_frp, last_frp_q;
    reg         last_frp_valid, last_frp_valid_q;

    assign rrp          = last_rrp_q;
    assign rrp_valid    = last_rrp_valid_q;
    assign frp          = last_frp_q;
    assign frp_valid    = last_frp_valid_q;

    // grab the RRP field from each flit if it's valid.
    genvar i;
    generate for (i=0; i < FLITS; i=i+1) begin:rrp_genloop
        // the RRP is valid on all EOFs except for those that are part of a NULL,TRET,IRTRY command.
        // fortunately, those are all single-flit packets, so we can check for them right here without needing
        // to reach back in time.
        wire rrp_valid_wire = eof[i] & (~sof[i] | RRP_valid_for_cmd(din[5+i*128:i*128]));
        wire frp_valid_wire = eof[i] & (~sof[i] | FRP_valid_for_cmd(din[5+i*128:i*128]));
        always @(posedge clk) begin
            if (rst) begin
                single_rrp_valid[i] <= 1'b0;
                single_rrp[i]       <= 'h0;
                single_frp_valid[i] <= 1'b0;
                single_frp[i]       <= 'h0;
            end else begin
                single_rrp_valid[i] <= rrp_valid_wire;
                single_frp_valid[i] <= frp_valid_wire;
                single_rrp[i]       <= rrp_valid_wire ? GetRRP(din >> (i*128)) : 'h0;
                single_frp[i]       <= frp_valid_wire ? GetFRP(din >> (i*128)) : 'h0;
                //if (verbose && eof[i] && (~sof[i] | RRP_valid_for_cmd(din[5+i*128:i*128])))
                //    $display("[%t] %s : RRP field valid for eof on flit %x. eof: %b. rrp: 0x%x", $time, name, i, eof[i], GetRRP(din >> (i*128)));
            end
        end
    end endgenerate

    integer j;
    always @(*) begin
        last_rrp_valid = |single_rrp_valid;
        casex (single_rrp_valid)
            5'b1xxxx:  last_rrp = single_rrp[4];
            5'b01xxx:  last_rrp = single_rrp[3];
            5'b001xx:  last_rrp = single_rrp[2];
            5'b0001x:  last_rrp = single_rrp[1];
            5'b00001:  last_rrp = single_rrp[0];
            default:   last_rrp = 8'h0;
        endcase

        last_frp_valid = |single_frp_valid;
        casex (single_frp_valid)
            5'b1xxxx:  last_frp = single_frp[4];
            5'b01xxx:  last_frp = single_frp[3];
            5'b001xx:  last_frp = single_frp[2];
            5'b0001x:  last_frp = single_frp[1];
            5'b00001:  last_frp = single_frp[0];
            default:   last_frp = 8'h0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            last_rrp_q          <= 'h0;
            last_rrp_valid_q    <= 0;
            last_frp_q          <= 'h0;
            last_frp_valid_q    <= 0;
        end else begin
            last_rrp_q          <= last_rrp;
            last_rrp_valid_q    <= last_rrp_valid;
            last_frp_q          <= last_frp;
            last_frp_valid_q    <= last_frp_valid;
            if (verbose && last_rrp_valid_q) $display("[%t] %s : outputting RRP 0x%x", $time, name, last_rrp_q);
            if (verbose && last_frp_valid_q) $display("[%t] %s : outputting FRP 0x%x", $time, name, last_frp_q);
            //if (verbose && |single_rrp_valid) $display("[%t] %s : single_rrp_valid: 0b%b, all RRPs: 0x%x, 0x%x, 0x%x, 0x%x, 0x%x",
            //    $time, name, single_rrp_valid, single_rrp[4], single_rrp[3], single_rrp[2], single_rrp[1], single_rrp[0]);
        end
    end

endmodule
