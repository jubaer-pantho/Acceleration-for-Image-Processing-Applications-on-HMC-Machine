/*
 * File Name     : hmc_sum_len.v
 *
 * Author        : Corey Olson
 *
 * Description   : This is a pipelined parallel addition of the len fields that travel with the N-FLIT parallel data bus.
 *
 * Assumptions   :
 *                  A1) if the valid signal is asserted, then at least 1 bit of pkt_map_in is asserted (i.e. din_valid not asserted for NULL FLITs)
 *                  A2) bits of len_in bus should be gated using the sof_map_in bits for each flit (i.e. if sof_map_in bit is not asserted for a FLIT, then that FLITs len bits can be anything)
 *                  A3) we do not need a ready signal in this module to provide backpressure
 *
 * Copyright     : 2013, Pico Computing, Inc.
 */
 module hmc_sum_len #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter LATENCY       = 1,                // this is the number of pipeline stages that we use to improve timing in our system (increasing this number should improve timing at the expense of higher latency).  Note that this must be >= 0
    parameter MAX_PKT_LEN   = 9,                // this is the maximum packet length (in terms of FLITS) as defined by the specification
    parameter FLIT_W        = 128,              // the width of a single flit (in bits)
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter W             = FLITS*FLIT_W,     // total width of the flit data channel. each flit is 128b, so ...
    // DO NOT MODIFY BELOW THIS LINE
    parameter LOG_SUM_W     = clogb2(FLITS*MAX_PKT_LEN)
                                                // worst-case number of bits required to represent the sum of all LEN fields on the input bus
                                                // if you don't want to use this, just use FLITS+MAX_PKT_LEN for the width of this bus
)
(
    input                   clk,
    input                   rst,

    input   [W-1:0]         din,
    input                   din_valid,
    input   [FLITS-1:0]     pkt_map_in,
    input   [FLITS-1:0]     eof_map_in,
    input   [FLITS-1:0]     sof_map_in,
    input   [4*FLITS-1:0]   len_in,
    input                   pkt_carry_in,

    output  [W-1:0]         dout,
    output                  dout_valid,
    output  [FLITS-1:0]     pkt_map_out,
    output  [FLITS-1:0]     eof_map_out,
    output  [FLITS-1:0]     sof_map_out,
    output  [4*FLITS-1:0]   len_out,
    output  [LOG_SUM_W-1:0] len_sum_out,
    output                  pkt_carry_out
 );

    ///////////////
    // FUNCTIONS //
    ///////////////
    // computes ceil( log( x ) )
    // Note: this requires that clogb2(0) = 1
    function integer clogb2;
        input [31:0] value;
        begin
            if (value == 0) value = 1;
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
                value = value >> 1;
            end
        end
    endfunction

    ///////////
    // LOGIC //
    ///////////

    // for these signals, the stage index (e.g. data[0] is data for stage 0) is the number of cycles of latency from the input
    // e.g. data[1] is 1 cycle delayed from the input
    reg [W-1:0]         data        [0:LATENCY];
    reg [0:0]           data_valid  [0:LATENCY];
    reg [FLITS-1:0]     pkt_map     [0:LATENCY];
    reg [FLITS-1:0]     eof_map     [0:LATENCY];
    reg [FLITS-1:0]     sof_map     [0:LATENCY];
    reg [4*FLITS-1:0]   len         [0:LATENCY];
    reg                 pkt_carry   [0:LATENCY];
    reg [LOG_SUM_W-1:0] len_sum     [0:LATENCY];

    // sample the input signals with 0 latency
    always @ (*) begin
        data        [0] = din;
        data_valid  [0] = din_valid;
        pkt_map     [0] = pkt_map_in;
        eof_map     [0] = eof_map_in;
        sof_map     [0] = sof_map_in;
        len         [0] = len_in;
        pkt_carry   [0] = pkt_carry_in;
    end

    // extract the length for each flit from the parallel bus
    reg [3:0]           flit_len    [0:FLITS-1];
    integer             z;
    always @ (*) begin
        for (z=0; z<FLITS; z=z+1) begin
            flit_len[z] = len[0] >> (4*z);
        end
    end

    // we first compute the parallel-addition of all LEN fields with the SOF bit set
    integer             y;
    always @ (*) begin
        len_sum[0] = 0;
        for (y=0; y<FLITS; y=y+1) begin
            if (sof_map[0][y]) begin
                len_sum[0] = len_sum[0] + flit_len[y];
                $display("[%t] %s : sum after adding flit[%0d] = %d", $time, name, y, len_sum[0]);
            end
        end
    end

    // next we insert some pipeline stages before the output
    // this should improve timing by letting the tools move these pipeline stages whereever they are needed
    // Note: the number of pipeline stages = LATENCY
    integer             lat;
    always @ (posedge clk) begin
        for (lat=1; lat<=LATENCY; lat=lat+1) begin
            if (rst) begin
                data        [lat]   <= 'h0;
                data_valid  [lat]   <= 'h0;
                pkt_map     [lat]   <= 'h0;
                eof_map     [lat]   <= 'h0;
                sof_map     [lat]   <= 'h0;
                len         [lat]   <= 'h0;
                len_sum     [lat]   <= 'h0;
                pkt_carry   [lat]   <= 0;
            end else begin
                data        [lat]   <= data         [lat-1];
                data_valid  [lat]   <= data_valid   [lat-1];
                pkt_map     [lat]   <= pkt_map      [lat-1];
                eof_map     [lat]   <= eof_map      [lat-1];
                sof_map     [lat]   <= sof_map      [lat-1];
                len         [lat]   <= len          [lat-1];
                len_sum     [lat]   <= len_sum      [lat-1];
                pkt_carry   [lat]   <= pkt_carry    [lat-1];
            end
        end
    end

    // now just assign the outputs
    assign dout         = data      [LATENCY];
    assign dout_valid   = data_valid[LATENCY];
    assign pkt_map_out  = pkt_map   [LATENCY];
    assign eof_map_out  = eof_map   [LATENCY];
    assign sof_map_out  = sof_map   [LATENCY];
    assign len_out      = len       [LATENCY];
    assign len_sum_out  = len_sum   [LATENCY];
    assign pkt_carry_out=pkt_carry  [LATENCY];

    ///////////
    // DEBUG //
    ///////////
    always @ (posedge clk) begin
        if (verbose) begin
            if (len_sum_out > 0)                    $display("[%t] %s : sof_map = 0x%h, total length = %d", $time, name, sof_map_out, len_sum_out);
            if (|sof_map_out && len_sum_out == 0)   $display("[%t] %s : ERROR : sof_map = 0x%h, len_sum = %d", $time, name, sof_map_out, len_sum_out);
            if (dout_valid && pkt_map_out == 0)     $display("[%t] %s : ERROR : dout_valid = %d, pkt_map = 0x%h", $time, name, dout_valid, pkt_map_out);
        end
    end
 endmodule
