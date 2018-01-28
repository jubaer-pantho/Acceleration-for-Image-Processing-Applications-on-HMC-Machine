// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

`include "hmc_def.vh"

// this module watches an (incoming) stream of data for IRTRY packets
// it assumes that the number of contiguous StartRetry packets in a burst is at least <FLITS>.
//   (because we make an optimizing assumption that we can grab the requested retry pointer from a specific flit rather
//   than scanning the whole bus.)
module hmc_rx_retry #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*128         // total width of the flit data channel. each flit is 128b, so ...
    ) (
    input                   clk,
    input                   rst,

    input   [W-1:0]         data_i,
    input   [FLITS-1:0]     pkt_i,
    input   [FLITS-1:0]     eof_i,
    input   [FLITS-1:0]     sof_i,
    input   [FLITS-1:0]     err_i,

    output reg [W-1:0]      data_o,
    output reg [FLITS-1:0]  pkt_o,
    output reg [FLITS-1:0]  eof_o,
    output reg [FLITS-1:0]  sof_o,
    output reg [FLITS-1:0]  err_o,

    output reg [7:0]        start_retry_count,
    output reg [7:0]        start_retry_rp,
    output reg              start_retry_valid,

    output reg              err_abort_valid=0,
    input                   err_abort_rdy
    );

    `include "hmc_func.h.v"

    // the minimum of IRTRY ClearErrorAbort packets we need to see before resuming RX after ErrorAbort.
    localparam MIN_CLEAR_ERROR_ABORT_COUNT = 15; // three beats.

    integer i;

    // <sum> is the sum of all valid IRTRY packets in the current beat.
    reg  [2:0]  sum_start, sum_start_q, sum_clear, sum_clear_q;

    // accumulator to count contiguous runs of IRTRY packets.
    reg  [7:0]  accum_start, accum_clear;
    // a note to ignore the rest of the ClearErrorAbort packets in a burst, once we've "gotten the message".
    reg         cea_busy;

    // latch the RRP that accompanies a StartRetry packet
    reg  [7:0]  sr_rrp;

    reg                 err_abort = 0;
    wire [FLITS-1:0]    err_filled_i = err_abort ? {FLITS{1'b1}} : FillLeft5(err_i);
    // keep a map of which flits are IRTRY packets, so we can mask them out of our output later.
    reg  [FLITS-1:0]    irtry_map;

    // add up the number of IRTRY packets in this beat
    always @(*) begin
        sum_start = 'h0;
        sum_clear = 'h0;
        for (i=0; i < FLITS; i=i+1) begin
            // StartRetry IRTRY packets have FRP == 1
            if (eof_i[i] && sof_i[i] && (GetFRP(data_i >> (i*128)) == 8'h1) && (GetCMD(data_i >> (i*128)) == `HMC_CMD_IRTRY)) begin
                sum_start = sum_start + 1;
                $display("[%t] %m : adding to sum_start", $time);
            end
            // StartRetry IRTRY packets have FRP == 2
            if (eof_i[i] && sof_i[i] && (GetFRP(data_i >> (i*128)) == 8'h2) && (GetCMD(data_i >> (i*128)) == `HMC_CMD_IRTRY)) begin
                sum_clear = sum_clear + 1;
                $display("[%t] %m : adding to sum_clear", $time);
            end

            irtry_map[i] = (GetCMD(data_i >> (i*128)) == `HMC_CMD_IRTRY) ? sof_i[i] : 0;
        end
    end

    // latch the sum of packets in the beat.
    always @(posedge clk) begin
        if (rst) begin
            sum_start_q <= 'h0;
            sr_rrp      <= 'h0;
            sum_clear_q <= 'h0;
        end else begin
            sum_start_q <= sum_start;
            sum_clear_q <= sum_clear;
            if (eof_i[0] && sof_i[0] && (GetFRP(data_i) == 8'h1) && (GetCMD(data_i) == `HMC_CMD_IRTRY)) begin
                sr_rrp  <= GetRRP(data_i);
                //$display("[%t] %m : latched sr_rrp:0x%x", $time, GetRRP(din));
            end
        end
    end

    always @(posedge clk) begin
        start_retry_valid   <= 0;
        start_retry_count   <= 'h0;
        start_retry_rp      <= 'h0;
        cea_busy            <= 0;

        if (rst) begin
            accum_start <= 'h0;
            accum_clear <= 'h0;
        end else begin
            if (sum_start_q != 0) begin
                accum_start         <= accum_start + sum_start_q;
            end else if (accum_start != 0) begin
                accum_start         <= 'h0;
                start_retry_valid   <= 1;
                start_retry_count   <= accum_start;
                start_retry_rp      <= sr_rrp;
                if (verbose) $display("[%t] %m : saw %d StartRetry packets. RRP:0x%x", $time, accum_start, sr_rrp);
            end

            if (accum_clear >= MIN_CLEAR_ERROR_ABORT_COUNT) begin
                accum_clear     <= 'h0;
                cea_busy        <= 1; // a note to ignore the rest of the ClearErrorAbort packets in this burst.
                if (verbose) $display("[%t] %m : saw %d ClearErrorAbort packets.", $time, accum_clear);
            end else if (!cea_busy) begin
                accum_clear     <= accum_clear + sum_clear_q;
            end
            if (sum_clear_q == 0)
                cea_busy        <= 0;
        end
    end


    // assert the err_abort_valid as a one-cycle signal (presumably feeding a fifo).
    // also set the internal err_abort signal to remember we're in that state.
    always @(posedge clk) begin
        err_abort_valid <= 0;

        if (rst) begin
            err_abort                   <= 0;
        end else begin
            err_abort                   <= err_abort | |err_i;
            if (|err_i && ~err_abort) begin
                err_abort_valid <= 1;
                if (verbose) $display("[%t] %m : entering ErrorAbort mode.", $time);
            end
            if (accum_clear >= MIN_CLEAR_ERROR_ABORT_COUNT) begin
                err_abort       <= 0;
                $display("[%t] %m : clearing ErrorAbort mode.", $time);
            end
        end
    end


    always @(posedge clk) begin
        if (rst) begin
            data_o      <= 'h0;
            pkt_o       <= 'h0;
            sof_o       <= 'h0;
            eof_o       <= 'h0;
            err_o       <= 'h0;
        end else begin
            data_o      <= data_i;
            pkt_o       <= pkt_i & ~err_filled_i & ~irtry_map;
            sof_o       <= sof_i & ~err_filled_i & ~irtry_map;
            eof_o       <= eof_i & ~err_filled_i & ~irtry_map;
            err_o       <= err_filled_i & ~irtry_map;
        end
    end

endmodule
