/* add_seq.v
 * Copyright 2013 Pico Computing, Inc.
 *
 * This module adds sequence numbers and FRPs to flits passing through.
 * It does not perform any flow control internally - it merely passes packets through.
 * We assign FRPs by incrementing the FRP by one for each packet. This isn't what the spec specifies, but both
 *   the bfm and the 2013 silicon deviate from the spec in their own way. We're establishing a third way.
 *   (It seems that the only thing that matters is that the FRP is unique among all un-acked packets, and no one is
 *    performing any math on someone else's FRPs, or inferring the existence of interpolated FRPs.
 *    It's not even clear that they need to be used in increasing order, although we haven't tested with out-of-order use.)
 * Rather than developing a structure that would allow us to rewind to any point in the buffer given a retry pointer,
 *   we use a fifo to record our FRPs. We know that if our link partner sends a retry request, it'll be for the very
 *   next unacked packet. However, this makes it a little more complicated to handle large "jumps" in the received RRPs.
 *   We may need to skip over several entries in the fifo in order to sync up with an RRP, during which time we could receive
 *   more incoming RRPs. We can handle those by keeping only the last one around (since it implies the previous ones).
 */

`timescale 1ns / 1ps

module add_seq #(
    parameter verbose       = 1,
    parameter name          = "",
    parameter FRP_W         = 10,               // internal FRP width (in bits)
    parameter FLIT_W        = 128,              // the width of a single flit (in bits)
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*FLIT_W      // total width of the flit data channel. each flit is 128b, so ...
    ) (
    input       clk,
    input       rst,

    //TODO s/4/FLITS-1/, s/639/W/
    // Input Stream
    input  [639:0]          data_i,
    input  [4:0]            present_i,
    input  [4:0]            sof_i,
    input  [4:0]            eof_i,
    input   [4*FLITS-1:0]   len_i,
    input   [4*FLITS-1:0]   len_eof_i,
    input                   pkt_carry_i,

    // Output Stream
    output     [639:0]      data_o,
    output       [4:0]      present_o,
    output       [4:0]      sof_o,
    output       [4:0]      eof_o,
    output  [4*FLITS-1:0]   len_o,
    output  [4*FLITS-1:0]   len_eof_o,
    output                  pkt_carry_o,

    output reg [FRP_W*FLITS-1:0]    new_frps,
    output reg [FLITS-1:0]          new_frps_map,
    output reg [9:0]                new_frps_buf_inx,
    output reg                      new_frps_valid
    );

    localparam LATENCY = 2;

    integer i, j;

    // seq is valid in the same stage in which assigned_seq is computed - NOT stage 0 or stage <LATENCY>
    reg  [2:0]      seq;
    wire [2:0]      next_seq;
    reg  [FRP_W-1:0]      frp, frp_sof;
    wire [FRP_W-1:0]      next_frp, next_frp_sof;
    reg  [9:0]      buf_inx; // a count of the non-null beats, which can be used as a buffer index. counts with frp_sof.

    // note that prev_count has one more number of elements than the number of flits. this is to include a count across ALL the flits.
    // (ie - the count of all flits previous to something past the end, is the count of all flits total.)
    reg [2:0]           prev_count  [0:FLITS][0:LATENCY]; // three bits wide, since max value is 4 (ie: one less than the number of parallel flits)
    //wire[2:0]           prev_count0 [0:FLITS]; // synthesis workaround
    reg [2:0]           prev_count_sof [0:FLITS][0:LATENCY]; // same thing, computed at the SOFs rather than EOFs
    reg [W-1:0]         data        [LATENCY:0];
    reg [FLITS-1:0]     pkt_map     [LATENCY:0];
    reg [FLITS-1:0]     sof         [LATENCY:0];
    reg [FLITS-1:0]     eof         [LATENCY:0];
    reg [4*FLITS-1:0]   len         [LATENCY:0];
    reg [4*FLITS-1:0]   len_eof     [LATENCY:0];
    reg                 pkt_carry   [LATENCY:0];

    // sample the input signals with 0 latency
    always @ (*) begin
        data        [0] = data_i;
        pkt_map     [0] = present_i;
        eof         [0] = eof_i;
        sof         [0] = sof_i;
        len         [0] = len_i;
        len_eof     [0] = len_eof_i;
        pkt_carry   [0] = pkt_carry_i;
    end

    // we first compute the number of EOFs previous to each flit slot.
    /*assign prev_count0[0] = 3'h0;
    assign prev_count0[1] = prev_count0[0] + (eof_i[0] ? 3'h1 : 3'h0);
    assign prev_count0[2] = prev_count0[1] + (eof_i[1] ? 3'h1 : 3'h0);
    assign prev_count0[3] = prev_count0[2] + (eof_i[2] ? 3'h1 : 3'h0);
    assign prev_count0[4] = prev_count0[3] + (eof_i[3] ? 3'h1 : 3'h0);
    assign prev_count0[5] = prev_count0[4] + (eof_i[4] ? 3'h1 : 3'h0);
    */

    always @ (*) begin
        for (i=0; i<=FLITS; i=i+1) begin
            prev_count[i][0] = 'h0;
            prev_count_sof[i][0] = 'h0;
            for (j=0; j<i; j=j+1) begin
                //TODO do NOT count PRET and IRTRY, per section 11.2.2
                if (eof_i[j]) begin
                    prev_count[i][0] = prev_count[i][0] + 1;
                    if (verbose) $display("[%t] %s : flit %d sum after adding flit[%0d] = %d", $time, name, i, j, prev_count[i][0]);
                end
                if (sof_i[j]) begin
                    prev_count_sof[i][0] = prev_count_sof[i][0] + 1;
                end
            end
        end
    end

    // next we insert some pipeline stages
    // this should improve timing by letting the tools move these pipeline stages wherever they are needed
    // Note: the number of pipeline stages = LATENCY
    integer lat;
    always @ (posedge clk) begin
        for (lat=1; lat<=LATENCY; lat=lat+1) begin
            if (rst) begin
                for (j=0; j<=FLITS; j=j+1) begin
                    prev_count      [j][lat]    <= 'h0;
                    prev_count_sof  [j][lat]    <= 'h0;
                end
                data        [lat]   <= 'h0;
                pkt_map     [lat]   <= 'h0;
                sof         [lat]   <= 'h0;
                eof         [lat]   <= 'h0;
                len         [lat]   <= 'h0;
                len_eof     [lat]   <= 'h0;
                pkt_carry   [lat]   <= 0;
            end else begin
                for (j=0; j<=FLITS /*&& lat >= 2*/; j=j+1) begin
                    //prev_count      [j][1]      <= prev_count0   [j];
                    prev_count      [j][lat]    <= prev_count    [j][lat-1];
                end
                for (j=0; j<=FLITS; j=j+1) begin
                    prev_count_sof  [j][lat]    <= prev_count_sof[j][lat-1];
                end
                data        [lat]   <= data         [lat-1];
                pkt_map     [lat]   <= pkt_map      [lat-1];
                sof         [lat]   <= sof          [lat-1];
                eof         [lat]   <= eof          [lat-1];
                len         [lat]   <= len          [lat-1];
                len_eof     [lat]   <= len_eof      [lat-1];
                pkt_carry   [lat]   <= pkt_carry    [lat-1];
            end
        end
    end

    // compute the sequence number for each flit
    reg  [2:0]      assigned_seq [FLITS-1:0];
    reg  [FRP_W-1:0]      assigned_frp [FLITS-1:0], assigned_rrp[FLITS-1:0], assigned_frp_sof[FLITS-1:0];
    reg  [W-1:0]    data_with_assigned_seq;
    reg  [FRP_W*(FLITS)-1:0]  all_frps_sof_wire;
    always @(*) begin
            if (eof[LATENCY-1][0]) begin
                assigned_seq[0]  <= seq + prev_count[0][LATENCY-1];
                assigned_frp[0]  <= frp + prev_count[0][LATENCY-1];
                assigned_rrp[0]  <= 8'h0;
                //if (verbose) $display("[%t] %s : setting assigned_seq[0] to %d + %d", $time, name, seq, prev_count[0][LATENCY-1]);
            end else begin
                assigned_seq[0]  <= data[LATENCY-1][FLIT_W*0+18+64:FLIT_W*0+16+64];
                assigned_frp[0]  <= data[LATENCY-1][FLIT_W*0+15+64:FLIT_W*0+8+64];
                assigned_rrp[0]  <= data[LATENCY-1][FLIT_W*0+7+64:FLIT_W*0+0+64];
            end
            // we don't have to generate this _conditionally_, like we do for the tail's frp, since we gate it below.
            assigned_frp_sof[0]  <= frp_sof + prev_count_sof[0][LATENCY-1];
            if (eof[LATENCY-1][1]) begin
                assigned_seq[1]  <= seq + prev_count[1][LATENCY-1];
                assigned_frp[1]  <= frp + prev_count[1][LATENCY-1];
                assigned_rrp[1]  <= 8'h0;
                //if (verbose) $display("[%t] %s : setting assigned_seq[1] to %d + %d", $time, name, seq, prev_count[1][LATENCY-1]);
            end else begin
                assigned_seq[1]  <= data[LATENCY-1][FLIT_W*1+18+64:FLIT_W*1+16+64];
                assigned_frp[1]  <= data[LATENCY-1][FLIT_W*1+15+64:FLIT_W*1+8+64];
                assigned_rrp[1]  <= data[LATENCY-1][FLIT_W*1+7+64:FLIT_W*1+0+64];
            end
            // we don't have to generate this _conditionally_, like we do for the tail's frp, since we gate it below.
            assigned_frp_sof[1]  <= frp_sof + prev_count_sof[1][LATENCY-1];
            if (eof[LATENCY-1][2]) begin
                assigned_seq[2]  <= seq + prev_count[2][LATENCY-1];
                assigned_frp[2]  <= frp + prev_count[2][LATENCY-1];
                assigned_rrp[2]  <= 8'h0;
                //if (verbose) $display("[%t] %s : setting assigned_seq[2] to %d + %d", $time, name, seq, prev_count[2][LATENCY-1]);
            end else begin
                assigned_seq[2]  <= data[LATENCY-1][FLIT_W*2+18+64:FLIT_W*2+16+64];
                assigned_frp[2]  <= data[LATENCY-1][FLIT_W*2+15+64:FLIT_W*2+8+64];
                assigned_rrp[2]  <= data[LATENCY-1][FLIT_W*2+7+64:FLIT_W*2+0+64];
            end
            // we don't have to generate this _conditionally_, like we do for the tail's frp, since we gate it below.
            assigned_frp_sof[2]  <= frp_sof + prev_count_sof[2][LATENCY-1];
            if (eof[LATENCY-1][3]) begin
                assigned_seq[3]  <= seq + prev_count[3][LATENCY-1];
                assigned_frp[3]  <= frp + prev_count[3][LATENCY-1];
                assigned_rrp[3]  <= 8'h0;
                //if (verbose) $display("[%t] %s : setting assigned_seq[3] to %d + %d", $time, name, seq, prev_count[3][LATENCY-1]);
            end else begin
                assigned_seq[3]  <= data[LATENCY-1][FLIT_W*3+18+64:FLIT_W*3+16+64];
                assigned_frp[3]  <= data[LATENCY-1][FLIT_W*3+15+64:FLIT_W*3+8+64];
                assigned_rrp[3]  <= data[LATENCY-1][FLIT_W*3+7+64:FLIT_W*3+0+64];
            end
            // we don't have to generate this _conditionally_, like we do for the tail's frp, since we gate it below.
            assigned_frp_sof[3]  <= frp_sof + prev_count_sof[3][LATENCY-1];
            if (eof[LATENCY-1][4]) begin
                assigned_seq[4]  <= seq + prev_count[4][LATENCY-1];
                assigned_frp[4]  <= frp + prev_count[4][LATENCY-1];
                assigned_rrp[4]  <= 8'h0;
                //if (verbose) $display("[%t] %s : setting assigned_seq[4] to %d + %d", $time, name, seq, prev_count[4][LATENCY-1]);
            end else begin
                assigned_seq[4]  <= data[LATENCY-1][FLIT_W*4+18+64:FLIT_W*4+16+64];
                assigned_frp[4]  <= data[LATENCY-1][FLIT_W*4+15+64:FLIT_W*4+8+64];
                assigned_rrp[4]  <= data[LATENCY-1][FLIT_W*4+7+64:FLIT_W*4+0+64];
            end
            // we don't have to generate this _conditionally_, like we do for the tail's frp, since we gate it below.
            assigned_frp_sof[4]  <= frp_sof + prev_count_sof[4][LATENCY-1];

        all_frps_sof_wire = 'h0;
        for (i=0; i < FLITS; i=i+1) begin
            if (sof[LATENCY-1][i]) begin
                all_frps_sof_wire = all_frps_sof_wire | (assigned_frp_sof[i] << FRP_W*i);
                //$display("[%t] %m : adding in frp[%d] 0x%x, all:0x%x", $time, i, assigned_frp_sof[i], all_frps_sof_wire);
            end
        end
    end

    always @(posedge clk) begin
            data_with_assigned_seq[FLIT_W*0+127:FLIT_W*0+19+64]   <= data[LATENCY-1][FLIT_W*0+127:FLIT_W*0+19+64];
            data_with_assigned_seq[FLIT_W*0+18+64:FLIT_W*0+16+64] <= assigned_seq[0][2:0];
            data_with_assigned_seq[FLIT_W*0+15+64:FLIT_W*0+8+64]  <= assigned_frp[0][7:0];
            data_with_assigned_seq[FLIT_W*0+7+64:FLIT_W*0+0+64]   <= assigned_rrp[0][7:0];
            data_with_assigned_seq[FLIT_W*0+63:FLIT_W*0+0]        <= data[LATENCY-1][FLIT_W*0+63:FLIT_W*0+0];
            if (eof[LATENCY-1][0]) if (verbose) $display("[%t] %s : assigned seq %d to flit 0 (frp:0x%x, rrp:0x%x)", $time, name, assigned_seq[0][2:0], assigned_frp[0], assigned_rrp[0]);
            if (eof[LATENCY-1][0]) if (verbose) $display("[%t] %s : flit pieces a:%x b:%x c:%x", $time, name, {data[LATENCY-1][FLIT_W*0+127:FLIT_W*0+19+64], 3'h0}, assigned_seq[0][2:0], data[LATENCY-1][FLIT_W*0+15+64:FLIT_W*0+0]);
            data_with_assigned_seq[FLIT_W*1+127:FLIT_W*1+19+64]   <= data[LATENCY-1][FLIT_W*1+127:FLIT_W*1+19+64];
            data_with_assigned_seq[FLIT_W*1+18+64:FLIT_W*1+16+64] <= assigned_seq[1][2:0];
            data_with_assigned_seq[FLIT_W*1+15+64:FLIT_W*1+8+64]  <= assigned_frp[1][7:0];
            data_with_assigned_seq[FLIT_W*1+7+64:FLIT_W*1+0+64]   <= assigned_rrp[1][7:0];
            data_with_assigned_seq[FLIT_W*1+63:FLIT_W*1+0]        <= data[LATENCY-1][FLIT_W*1+63:FLIT_W*1+0];
            if (eof[LATENCY-1][1]) if (verbose) $display("[%t] %s : assigned seq %d to flit 1 (frp:0x%x, rrp:0x%x)", $time, name, assigned_seq[1][2:0], assigned_frp[1], assigned_rrp[1]);
            if (eof[LATENCY-1][1]) if (verbose) $display("[%t] %s : flit pieces a:%x b:%x c:%x", $time, name, {data[LATENCY-1][FLIT_W*1+127:FLIT_W*1+19+64], 3'h0}, assigned_seq[1][2:0], data[LATENCY-1][FLIT_W*1+15+64:FLIT_W*1+0]);
            data_with_assigned_seq[FLIT_W*2+127:FLIT_W*2+19+64]   <= data[LATENCY-1][FLIT_W*2+127:FLIT_W*2+19+64];
            data_with_assigned_seq[FLIT_W*2+18+64:FLIT_W*2+16+64] <= assigned_seq[2][2:0];
            data_with_assigned_seq[FLIT_W*2+15+64:FLIT_W*2+8+64]  <= assigned_frp[2][7:0];
            data_with_assigned_seq[FLIT_W*2+7+64:FLIT_W*2+0+64]   <= assigned_rrp[2][7:0];
            data_with_assigned_seq[FLIT_W*2+63:FLIT_W*2+0]        <= data[LATENCY-1][FLIT_W*2+63:FLIT_W*2+0];
            if (eof[LATENCY-1][2]) if (verbose) $display("[%t] %s : assigned seq %d to flit 2 (frp:0x%x, rrp:0x%x)", $time, name, assigned_seq[2][2:0], assigned_frp[2], assigned_rrp[2]);
            if (eof[LATENCY-1][2]) if (verbose) $display("[%t] %s : flit pieces a:%x b:%x c:%x", $time, name, {data[LATENCY-1][FLIT_W*2+127:FLIT_W*2+19+64], 3'h0}, assigned_seq[2][2:0], data[LATENCY-1][FLIT_W*2+15+64:FLIT_W*2+0]);
            data_with_assigned_seq[FLIT_W*3+127:FLIT_W*3+19+64]   <= data[LATENCY-1][FLIT_W*3+127:FLIT_W*3+19+64];
            data_with_assigned_seq[FLIT_W*3+18+64:FLIT_W*3+16+64] <= assigned_seq[3][2:0];
            data_with_assigned_seq[FLIT_W*3+15+64:FLIT_W*3+8+64]  <= assigned_frp[3][7:0];
            data_with_assigned_seq[FLIT_W*3+7+64:FLIT_W*3+0+64]   <= assigned_rrp[3][7:0];
            data_with_assigned_seq[FLIT_W*3+63:FLIT_W*3+0]        <= data[LATENCY-1][FLIT_W*3+63:FLIT_W*3+0];
            if (eof[LATENCY-1][3]) if (verbose) $display("[%t] %s : assigned seq %d to flit 3 (frp:0x%x, rrp:0x%x)", $time, name, assigned_seq[3][2:0], assigned_frp[3], assigned_rrp[3]);
            if (eof[LATENCY-1][3]) if (verbose) $display("[%t] %s : flit pieces a:%x b:%x c:%x", $time, name, {data[LATENCY-1][FLIT_W*3+127:FLIT_W*3+19+64], 3'h0}, assigned_seq[3][2:0], data[LATENCY-1][FLIT_W*3+15+64:FLIT_W*3+0]);
            data_with_assigned_seq[FLIT_W*4+127:FLIT_W*4+19+64]   <= data[LATENCY-1][FLIT_W*4+127:FLIT_W*4+19+64];
            data_with_assigned_seq[FLIT_W*4+18+64:FLIT_W*4+16+64] <= assigned_seq[4][2:0];
            data_with_assigned_seq[FLIT_W*4+15+64:FLIT_W*4+8+64]  <= assigned_frp[4][7:0];
            data_with_assigned_seq[FLIT_W*4+7+64:FLIT_W*4+0+64]   <= assigned_rrp[4][7:0];
            data_with_assigned_seq[FLIT_W*4+63:FLIT_W*4+0]        <= data[LATENCY-1][FLIT_W*4+63:FLIT_W*4+0];
            if (eof[LATENCY-1][4]) if (verbose) $display("[%t] %s : assigned seq %d to flit 4 (frp:0x%x, rrp:0x%x)", $time, name, assigned_seq[4][2:0], assigned_frp[4], assigned_rrp[4]);
            if (eof[LATENCY-1][4]) if (verbose) $display("[%t] %s : flit pieces a:%x b:%x c:%x", $time, name, {data[LATENCY-1][FLIT_W*4+127:FLIT_W*4+19+64], 3'h0}, assigned_seq[4][2:0], data[LATENCY-1][FLIT_W*4+15+64:FLIT_W*4+0]);
    end

    always @(posedge clk) begin
        if (rst) begin
            buf_inx <= 'h0;
        end else begin
            new_frps        <= all_frps_sof_wire;
            if (|sof[LATENCY-1]) $display("[%t] %m : latched new_frps: {0x%x}, sof:0b%b, frp_sof:0x%x, prev_count_sof:0x%x", $time, all_frps_sof_wire, sof[LATENCY-1], frp_sof, prev_count_sof[FLITS-1][LATENCY-1]);
            new_frps_map    <= sof[LATENCY-1];
            new_frps_valid  <= |sof[LATENCY-1];
            new_frps_buf_inx<= buf_inx;
            if (|pkt_map[LATENCY-1])
                buf_inx <= buf_inx + 1;
        end
    end

    assign next_seq = seq + prev_count[FLITS][LATENCY-1];
    assign next_frp = frp + prev_count[FLITS][LATENCY-1];
    assign next_frp_sof = frp_sof + prev_count_sof[FLITS][LATENCY-1];

    assign data_o   = data_with_assigned_seq;
    assign present_o= pkt_map   [LATENCY];
    assign sof_o    = sof       [LATENCY];
    assign eof_o    = eof       [LATENCY];
    assign len_o    = len       [LATENCY];
    assign len_eof_o= len_eof   [LATENCY];
    assign pkt_carry_o  = pkt_carry [LATENCY];

    always @(posedge clk) begin
        if (rst) begin
            seq     <= 1;
            frp     <= 10'h1; // we need the first FRP to be 1. after that, anything goes.
            frp_sof <= 10'h1;
        end else begin
            seq     <= next_seq;
            frp     <= next_frp;
            frp_sof <= next_frp_sof;
            if (verbose && (seq != next_seq)) begin
                $display("[%t] %s : next seq: %d, next frp: 0x%x, next_frp_sof: 0x%x, EOFs this beat: %d (0b%b)", $time, name, next_seq, next_frp, next_frp_sof, prev_count[FLITS][LATENCY-1], eof[LATENCY-1]);
                $display("[%t] %s : frp_sof: 0x%x, next_frp_sof: 0x%x (frp_sof + 0x%x). (vanilla prev_count: 0x%x)", $time, name, frp_sof, next_frp_sof, prev_count_sof[FLITS][LATENCY-1], prev_count[FLITS][LATENCY-1]);
            end
            if (verbose && present_o != 0) $display("[%t] %s : output %x", $time, name, data_o);
        end
    end

endmodule
