// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

`include "hmc_def.vh"

// get the return token counts from a stream of flits. also take care of summing up any counts that arrive on the same beat.
// rtc is the number of tokens returned. it will be zero on cycles where no tokens were returned, so you don't necessarily need
// to look at rtc_valid.
// rtc_valid is high on cycles where rtc is nonzero. as noted above, it's not strictly necessary.
module rtc #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*128         // total width of the flit data channel. each flit is 128b, so ...
    ) (
    input                   clk,
    input                   rst,

    input                   debug_clk,
    input       [31:0]      debug_addr,
    input       [31:0]      debug_din,
    input                   debug_rd,
    input                   debug_wr,

    input  [W-1:0]          din,
    input  [FLITS-1:0]      sof,
    input  [FLITS-1:0]      eof,

    output     [3+4:0]      rtc,                // the rtc field is only 5b, but we may need to aggregate FLITS # of maximal rtc values.
                                                //   (the +3 should "really" be +log2(FLITS) )
    output                  rtc_valid
    );

    `include "hmc_func.h.v"

    // these regs are where we extract the info from each of the parallel flits in the generate loop below.
    reg [FLITS-1:0]     single_rtc [FLITS-1:0];
    reg [FLITS-1:0]     single_rtc_valid;

    // this is a pipelined adder tree for the token counts.
    reg [3+4:0]         sum, sum_q;
    reg                 sum_valid, sum_valid_q;
    assign rtc      = sum_q;
    assign rtc_valid= sum_valid_q;

    // provide the ability for a debug-bus write to inject extra tokens into our output.
    // a write to 0x480 will inject the low five bits of debug_din.
    // the low level mechanics: we toggle do_inject each time 0x480 is written, and logic on the main clk picks up the toggle.
    reg [4:0]   inject_count_dbg;
    reg         inject_valid, do_inject=0;
    always @(posedge debug_clk) begin
        if (debug_wr && debug_addr[31:0] == 32'h480) begin
            do_inject       <= ~do_inject;
            inject_count_dbg<= debug_din[4:0];
        end
    end
    // move the do_inject toggle into the 'clk' domain and catch edges.
    // since do_inject simply toggles on a write, we need to catch negative and positive edges.
    reg [3:0]   do_inject_q='h0;
    reg [4:0]   inject_count='h0, inject_count_dbg_q;
    always @(posedge clk) begin
        do_inject_q[3:0]    <= {do_inject_q[2:0], do_inject};
        inject_count_dbg_q  <= inject_count_dbg;

        if (do_inject_q[3] != do_inject_q[2]) begin
            inject_valid    <= 1;
            inject_count    <= inject_count_dbg_q;
        end else begin
            inject_valid    <= 0;
            inject_count    <= 'h0;
        end
    end

    // grab the rtc field from each flit if it's valid.
    genvar i;
    generate for (i=0; i < FLITS; i=i+1) begin:rtc_genloop
        // the RTC is valid on all EOFs except for those that are part of a NULL,PRET,IRTRY command.
        // fortunately, those are all single-flit packets, so we can check for them right here without needing
        // to reach back in time.
        wire valid_wire = eof[i] & (~sof[i] | RTC_valid_for_cmd(din[5+i*128:i*128]));
        always @(posedge clk) begin
            if (rst) begin
                single_rtc_valid[i] <= 1'b0;
                single_rtc[i]       <= 'h0;
            end else begin
                single_rtc_valid[i] <= valid_wire;
                single_rtc[i]       <= valid_wire ? din[95+i*128:91+i*128] : 'h0;
                if (verbose && eof[i] && (~sof[i] | RTC_valid_for_cmd(din[5+i*128:i*128])))
                    $display("[%t] %s RTC field valid for eof on flit %x. eof: %b. rtc: 0x%x", $time, name, i, eof[i], din[95+i*128:91+i*128]);
            end
        end
    end endgenerate

    // this is the pipelined adder tree for the parallel counts that we have in single_rtc[]
    always @(posedge clk) begin
        if (rst) begin
            sum_valid   <= 0;
            sum_valid_q <= 0;
            sum_q       <= 'h0;
        end else begin
            sum_valid   <= |single_rtc_valid | inject_valid;
            
            // now handle the pipeline stages, which we added purely for timing.
            sum_q       <= sum;
            sum_valid_q <= sum_valid;
        end
    end
    generate if (FLITS == 5) begin:fiveflits
        always @(posedge clk)
            if (rst)    sum <= 'h0;
            else        sum <= inject_count + single_rtc[0] + single_rtc[1] + single_rtc[2] + single_rtc[3] + single_rtc[4];
    end else if (FLITS == 4) begin:fourflits
        always @(posedge clk)
            sum <= inject_count + single_rtc[0] + single_rtc[1] + single_rtc[2] + single_rtc[3];
    end endgenerate

endmodule
