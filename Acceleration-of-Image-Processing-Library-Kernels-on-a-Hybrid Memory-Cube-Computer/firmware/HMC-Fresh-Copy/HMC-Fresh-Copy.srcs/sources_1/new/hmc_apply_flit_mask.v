/*
 * File Name     : hmc_apply_flit_mask.v
 *
 * Copyright     : 2013, Pico Computing, Inc.
 */
 module hmc_apply_flit_mask #(
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
    
    input   [W-1:0]         data_i,
    input   [FLITS-1:0]     pkt_map_i,
    input   [FLITS-1:0]     eof_map_i,
    input   [FLITS-1:0]     sof_map_i,
    input   [4*FLITS-1:0]   len_i,
    input   [LOG_SUM_W-1:0] len_sum_i,
    
    output  [W-1:0]         data_o,               
    output  [FLITS-1:0]     pkt_map_o,
    output  [FLITS-1:0]     eof_map_o,
    output  [FLITS-1:0]     sof_map_o,
    output  [4*FLITS-1:0]   len_o,
    output  [LOG_SUM_W-1:0] len_sum_o
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
    reg [W-1:0]         data            [0:LATENCY];
    reg [FLITS-1:0]     pkt_map         [0:LATENCY];
    reg [FLITS-1:0]     eof_map         [0:LATENCY];
    reg [FLITS-1:0]     sof_map         [0:LATENCY];
    reg [4*FLITS-1:0]   len             [0:LATENCY];
    reg [LOG_SUM_W-1:0] len_sum         [0:LATENCY];
    
    integer i;
    reg [FLIT_W-1:0]    flit;
    always @ (*) begin
        pkt_map                     [0] = pkt_map_i;
        eof_map                     [0] = eof_map_i;
        sof_map                     [0] = sof_map_i;
        len                         [0] = len_i;
        len_sum                     [0] = len_sum_i;

        // each data flit is nulled out unless pkt_map_i is set.
        data[0] = {W{1'b0}};
        for (i=0; i < FLITS; i=i+1) begin
            flit = pkt_map_i[i] ? (data_i >> i*FLIT_W) & {FLIT_W{1'b1}} : {FLIT_W{1'b0}};
            data[0] = data[0] | flit << i*FLIT_W;
        end
    end
    
    // now, add pipeline registers
    // this should improve timing by letting the tools move these pipeline stages whereever they are needed
    // Note: the number of pipeline stages = LATENCY
    integer             lat;
    always @ (posedge clk) begin
        for (lat=1; lat<=LATENCY; lat=lat+1) begin
            if (rst) begin
                data                [lat]   <= 'h0;
                pkt_map             [lat]   <= 'h0;
                eof_map             [lat]   <= 'h0;
                sof_map             [lat]   <= 'h0;
                len                 [lat]   <= 'h0;
                len_sum             [lat]   <= 'h0;
                
            end else begin
                data                [lat]   <= data                 [lat-1];
                pkt_map             [lat]   <= pkt_map              [lat-1];
                eof_map             [lat]   <= eof_map              [lat-1];
                sof_map             [lat]   <= sof_map              [lat-1];
                len                 [lat]   <= len                  [lat-1];
                len_sum             [lat]   <= len_sum              [lat-1];
            end
        end
    end
    
    // assign the outputs
    assign data_o                   = data                  [LATENCY];
    assign pkt_map_o                = pkt_map               [LATENCY];
    assign eof_map_o                = eof_map               [LATENCY];
    assign sof_map_o                = sof_map               [LATENCY];     
    assign len_o                    = len                   [LATENCY];
    assign len_sum_o                = len_sum               [LATENCY];

    ///////////
    // DEBUG //
    ///////////
    always @ (posedge clk) begin
        if (verbose) begin
            if (|pkt_map_o) begin
                $display("[%t] %m : pkt_map_o: 0b%b, data_o: 0x%x", $time, pkt_map_o, data_o);
            end
        end
    end

endmodule
