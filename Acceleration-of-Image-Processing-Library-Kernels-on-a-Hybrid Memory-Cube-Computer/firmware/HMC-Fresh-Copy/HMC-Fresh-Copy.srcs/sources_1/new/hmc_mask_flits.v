/*
 * File Name     : hmc_mask_flits.v
 *
 * Author        : Corey Olson
 *
 * Description   : This module serves to mask off FLITs of the output data bus, and it provides 3 different output buses.  Here are the output buses:
 *                  1) dout             = original, unmodified input data
 *                  2) dout_first_flits = output data with only the first FLITs being valid (all flits after the first EOF masked off)
 *                  3) dout_last_flits  = output data with only the last FLITs being valid (all flits before the first SOF masked off)
 *
 * Assumptions   :
 *                  A1) it's ok to output non-zero data with dout_valid = 0
 *
 * Copyright     : 2013, Pico Computing, Inc.
 */
 module hmc_mask_flits #(
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
    //input                   din_valid,
    input   [FLITS-1:0]     pkt_map_in,
    input   [FLITS-1:0]     eof_map_in,
    input   [FLITS-1:0]     sof_map_in,
    input   [4*FLITS-1:0]   len_in,
    input   [LOG_SUM_W-1:0] len_sum_in,

    //output                  dout_valid,
    //input                   dout_rdy,
    output  [4*FLITS-1:0]   len_out,
    output  [LOG_SUM_W-1:0] len_sum_out,

    // this is the unmasked version of the output data
    output  [W-1:0]         dout,
    output  [FLITS-1:0]     pkt_map_out,
    output  [FLITS-1:0]     eof_map_out,
    output  [FLITS-1:0]     sof_map_out,

    // this is the version of the output data with only the first FLITs being valid (all flits after the first EOF masked off)
    output  [W-1:0]         dout_first_flits,
    output  [FLITS-1:0]     pkt_map_out_first_flits,
    output  [FLITS-1:0]     eof_map_out_first_flits,
    output  [FLITS-1:0]     sof_map_out_first_flits,

    // this is the version of the output data with only the last FLITs being valid (all flits before the first SOF masked off)
    output  [W-1:0]         dout_last_flits,
    output  [FLITS-1:0]     pkt_map_out_last_flits,
    output  [FLITS-1:0]     eof_map_out_last_flits,
    output  [FLITS-1:0]     sof_map_out_last_flits
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

    // this function will return the desired bit range
    // Note: this is equivalent to returning data[high:low]
    function [31:0] GetBits;
        input   [31:0]      data;
        input   integer     high;
        input   integer     low;
        begin
            GetBits = (data >> low) & ((1<<(high+1))-1);
        end
    endfunction

    ///////////
    // LOGIC //
    ///////////

    // for these signals, the stage index (e.g. data[0] is data for stage 0) is the number of cycles of latency from the input
    // e.g. data[1] is 1 cycle delayed from the input
    //reg [0:0]           data_valid      [0:LATENCY];
    reg [4*FLITS-1:0]   len             [0:LATENCY];
    reg [LOG_SUM_W-1:0] len_sum         [0:LATENCY];

    reg [W-1:0]         data            [0:LATENCY];
    reg [FLITS-1:0]     pkt_map         [0:LATENCY];
    reg [FLITS-1:0]     eof_map         [0:LATENCY];
    reg [FLITS-1:0]     sof_map         [0:LATENCY];

    reg [W-1:0]         data_first_flits    [0:LATENCY];
    reg [FLITS-1:0]     pkt_map_first_flits [0:LATENCY];
    reg [FLITS-1:0]     sof_map_first_flits [0:LATENCY];
    reg [FLITS-1:0]     eof_map_first_flits [0:LATENCY];

    reg [W-1:0]         data_last_flits     [0:LATENCY];
    reg [FLITS-1:0]     pkt_map_last_flits  [0:LATENCY];
    reg [FLITS-1:0]     sof_map_last_flits  [0:LATENCY];
    reg [FLITS-1:0]     eof_map_last_flits  [0:LATENCY];

    reg [FLIT_W-1:0]    data_before_mask;

    // first, sample the input data with 0 latency
    always @ (*) begin
        //data_valid                  [0] = din_valid;
        len                         [0] = len_in;
        len_sum                     [0] = len_sum_in;

        data                        [0] = din;
        pkt_map                     [0] = pkt_map_in;
        eof_map                     [0] = eof_map_in;
        sof_map                     [0] = sof_map_in;
    end

    // next, apply the desired masks
    // Note: this is also with 0 latency (w.r.t. input data)
    integer             flit;

    always @ (*) begin

        /*
         * this section is creating our masked version of the data bus that ONLY
         * keeps those FLITS that belong to a packet from a previous data beat.
         * In other words, we do NOT want to start a new packet.
         * Therefore, we mask off ALL flits after (and including) the first FLIT
         * with an SOF bit set.
         */
        // here we start with an assumption that we won't mask off any FLITs
        // we then check to see if a FLIT is the end of a packet, and if so,
        // we mask off all those FLITS after it
        // Note: if we mask off a FLIT, the data DOES need to be zero
        data_first_flits            [0] = {W{1'b0}};
        pkt_map_first_flits         [0] = pkt_map_in;
        eof_map_first_flits         [0] = eof_map_in;
        // Note: we know that this will ALWAYS be 0, because we DO NOT want to
        // start a new packet for this version of the data bus.  we simply
        // include this here for symmetry
        sof_map_first_flits         [0] = {FLITS{1'b0}};

        // mask the flits after the first SOF
        for (flit=0; flit<FLITS; flit=flit+1) begin

            // grab the FLIT that may or may not get masked off
            data_before_mask                    = din >> (FLIT_W*flit);

            // if we see an SOF bit before (and including) this FLIT, then we
            // do NOT want to include this FLIT in this output bus
            // Note: if there is no SOF bit on the bus, then all FLITS should be valid
            if (GetBits(sof_map_in,flit,0) != 0) begin
                pkt_map_first_flits [0][flit]   = 1'b0;
                eof_map_first_flits [0][flit]   = 1'b0;
            end else begin
                data_first_flits    [0]         = data_first_flits[0] | (data_before_mask << (FLIT_W*flit));
            end
        end

        /*
         * this section is creating our masked version of the data bus that ONLY
         * keeps those FLITS that belong to a new packet, which is started on this data beat.
         * In other words, we ONLY want those FLITS that start a new packet.
         * Therefore, we mask off ALL flits before the first FLIT
         * with an SOF bit set.
         */
        // here we start with an assumption that we will mask off ALL FLITS
        // we then check to see if a FLIT is the start of a packet, and if so,
        // we add in ALL FLITS after it (and including the current FLIT)
        // Note: if we mask off a FLIT, the data DOES need to be zero
        data_last_flits             [0] = {W{1'b0}};
        pkt_map_last_flits          [0] = {FLITS{1'b0}};
        sof_map_last_flits          [0] = {FLITS{1'b0}};
        eof_map_last_flits          [0] = {FLITS{1'b0}};

        // add in those FLITS on the bus that appear after the first SOF bit
        for (flit=0; flit<FLITS; flit=flit+1) begin

            // grab the FLIT that may or may not get masked off
            data_before_mask                    = din >> (FLIT_W*flit);

            // if we see an SOF bit before (and including) this FLIT, then we
            // DO want to include this FLIT in this output bus
            // Note: if there is no SOF bit on the bus, then all FLITS should be INVALID
            if (GetBits(sof_map_in,flit,0) != 0) begin
                pkt_map_last_flits  [0][flit]   = pkt_map_in[flit];
                sof_map_last_flits  [0][flit]   = sof_map_in[flit];
                eof_map_last_flits  [0][flit]   = eof_map_in[flit];
                data_last_flits     [0]         = data_last_flits[0] | (data_before_mask << (FLIT_W*flit));
            end
        end
    end

    // now, add pipeline registers
    // this should improve timing by letting the tools move these pipeline stages whereever they are needed
    // Note: the number of pipeline stages = LATENCY
    integer             lat;
    always @ (posedge clk) begin
        for (lat=1; lat<=LATENCY; lat=lat+1) begin
            if (rst) begin
                //data_valid          [lat]   <= 'h0;
                len                 [lat]   <= 'h0;
                len_sum             [lat]   <= 'h0;

                data                [lat]   <= 'h0;
                pkt_map             [lat]   <= 'h0;
                eof_map             [lat]   <= 'h0;
                sof_map             [lat]   <= 'h0;

                data_first_flits    [lat]   <= 'h0;
                pkt_map_first_flits [lat]   <= 'h0;
                sof_map_first_flits [lat]   <= 'h0;
                eof_map_first_flits [lat]   <= 'h0;

                data_last_flits     [lat]   <= 'h0;
                pkt_map_last_flits  [lat]   <= 'h0;
                sof_map_last_flits  [lat]   <= 'h0;
                eof_map_last_flits  [lat]   <= 'h0;

            end else /*if (dout_rdy)*/ begin
                //data_valid          [lat]   <= data_valid           [lat-1];
                len                 [lat]   <= len                  [lat-1];
                len_sum             [lat]   <= len_sum              [lat-1];

                data                [lat]   <= data                 [lat-1];
                pkt_map             [lat]   <= pkt_map              [lat-1];
                eof_map             [lat]   <= eof_map              [lat-1];
                sof_map             [lat]   <= sof_map              [lat-1];

                data_first_flits    [lat]   <= data_first_flits     [lat-1];
                pkt_map_first_flits [lat]   <= pkt_map_first_flits  [lat-1];
                sof_map_first_flits [lat]   <= sof_map_first_flits  [lat-1];
                eof_map_first_flits [lat]   <= eof_map_first_flits  [lat-1];

                data_last_flits     [lat]   <= data_last_flits      [lat-1];
                pkt_map_last_flits  [lat]   <= pkt_map_last_flits   [lat-1];
                sof_map_last_flits  [lat]   <= sof_map_last_flits   [lat-1];
                eof_map_last_flits  [lat]   <= eof_map_last_flits   [lat-1];
            end
        end
    end

    // assign the outputs
    //assign dout_valid               = data_valid            [LATENCY];
    assign len_out                  = len                   [LATENCY];
    assign len_sum_out              = len_sum               [LATENCY];

    assign dout                     = data                  [LATENCY];
    assign pkt_map_out              = pkt_map               [LATENCY];
    assign eof_map_out              = eof_map               [LATENCY];
    assign sof_map_out              = sof_map               [LATENCY];

    assign dout_first_flits         = data_first_flits      [LATENCY];
    assign pkt_map_out_first_flits  = pkt_map_first_flits   [LATENCY];
    assign sof_map_out_first_flits  = sof_map_first_flits   [LATENCY];
    assign eof_map_out_first_flits  = eof_map_first_flits   [LATENCY];

    assign dout_last_flits          = data_last_flits       [LATENCY];
    assign pkt_map_out_last_flits   = pkt_map_last_flits    [LATENCY];
    assign eof_map_out_last_flits   = eof_map_last_flits    [LATENCY];
    assign sof_map_out_last_flits   = sof_map_last_flits    [LATENCY];

    ///////////
    // DEBUG //
    ///////////
    always @ (posedge clk) begin
        if (verbose) begin
            /*if (dout_valid) begin
                if (|pkt_map_out)               $display("[%t] %s : standard    : pkt_map = 0x%h, sof_map = 0x%h, eof_map = 0x%h", $time, name, pkt_map_out, sof_map_out, eof_map_out);
                if (|pkt_map_out_first_flits)   $display("[%t] %s : first_flits : pkt_map = 0x%h, sof_map = 0x%h, eof_map = 0x%h", $time, name, pkt_map_out_first_flits, sof_map_out_first_flits, eof_map_out_first_flits);
                if (|pkt_map_out_last_flits)    $display("[%t] %s : last_flits  : pkt_map = 0x%h, sof_map = 0x%h, eof_map = 0x%h", $time, name, pkt_map_out_last_flits, sof_map_out_last_flits, eof_map_out_last_flits);
            end*/
        end
        if (pkt_map_out != (pkt_map_out_first_flits | pkt_map_out_last_flits)) begin
            $display("[%t] %s : pkt_map_out != (pkt_map_out_first_flits | pkt_map_out_last_flits !!! (0x%x, 0x%x, 0x%x)", $time, name, pkt_map_out, pkt_map_out_first_flits, pkt_map_out_last_flits);
            $finish;
        end
    end
endmodule
