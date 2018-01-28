/*
* File Name     : hmc_inject_pret.v
*
* Description   : If our TX pipeline isn't sending any packets, then we want
*                 to send a PRET.
*
*                 If the incoming flits are not part of a packet
*                 (|pkt_map==0), we can send a PRET.
*                 
*                 We only need to send out a PRET if our
*                 current rrp_i is different from the one that we most
*                 recently sent.
*
* Copyright     : 2015, Micron Inc.
*/
module hmc_inject_pret #(
    parameter verbose       = 0,                // print out a bunch of info?
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
    
    input   [7:0]           rrp_i,

    output  reg [W-1:0]         data_o      = 'h0,
    output  reg [FLITS-1:0]     pkt_map_o   = 'h0,
    output  reg [FLITS-1:0]     eof_map_o   = 'h0,
    output  reg [FLITS-1:0]     sof_map_o   = 'h0,
    output  reg [4*FLITS-1:0]   len_o       = 'h0,
    output  reg [LOG_SUM_W-1:0] len_sum_o   = 'h0
);
    
    `include "hmc_func.h.v"

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

    ///////////////
    // INTERNALS //
    ///////////////

    // we use these signals to determine if we need to send a new PRET
    // -we need a new PRET if the RRP that was most recently sent is different
    // than our current RRP
    // -the proper way to do this is likely to extract RRPs from the outgoing
    // command packet stream. that likely requires a bunch of extra logic that
    // we don't want
    // -instead, we just send a PRET whenever our RRP (input to this module)
    // has changed.
    // Note: it's ok if we send multiple of the same RRP
    reg         [7:0]               last_rrp    = 0;
    reg                             need_pret   = 0;
    always @ (posedge clk) begin
        if (rst) begin
            need_pret               <= 0;
        end else begin
            need_pret               <= rrp_i != last_rrp;
            if (verbose && rrp_i != last_rrp) $display("[%t] %m rrp_i has changed from 0x%0h to 0x%0h.  Must send a PRET", $time, last_rrp, rrp_i);
        end
    end

    //////////
    // PRET //
    //////////

    // most of this artificial PRET is pretty easy. 
    // we can just set 1 FLIT on our data bus to a PRET w/ the current RRP
    // the flags all get set to signify that we just have 1 valid FLIT on this
    // data beat
    wire        [W-1:0]         data_pret       = MakePRET(rrp_i);
    wire        [FLITS-1:0]     pkt_map_pret    = 'h1;
    wire        [FLITS-1:0]     eof_map_pret    = 'h1;
    wire        [FLITS-1:0]     sof_map_pret    = 'h1;
    wire        [4*FLITS-1:0]   len_pret        = 'h1;
    wire        [4*FLITS-1:0]   len_sum_pret    = 'h1;

    /////////
    // MUX //
    /////////

    // this is the mux that actually sends out PRETs
    // if we have valid packet data on the input, send that along
    // -if we don't have valid data on the input, we send a PRET if needed
    always @ (posedge clk) begin
        if (rst) begin
            data_o              <= 'h0;
            pkt_map_o           <= 'h0;
            eof_map_o           <= 'h0;
            sof_map_o           <= 'h0;
            len_o               <= 'h0;
            len_sum_o           <= 'h0;
            last_rrp            <= 'h0;
        end else if (|pkt_map_i) begin
            data_o              <= data_i;
            pkt_map_o           <= pkt_map_i;
            eof_map_o           <= eof_map_i;
            sof_map_o           <= sof_map_i;
            len_o               <= len_i;
            len_sum_o           <= len_sum_i;
        end else if (need_pret) begin
            data_o              <= data_pret;
            pkt_map_o           <= pkt_map_pret;
            eof_map_o           <= eof_map_pret;
            sof_map_o           <= sof_map_pret;
            len_o               <= len_pret;
            len_sum_o           <= len_sum_pret;
            last_rrp            <= rrp_i;
            if (verbose) $display("[%t] %m sending PRET", $time);
        end else begin
            data_o              <= data_i;
            pkt_map_o           <= pkt_map_i;
            eof_map_o           <= eof_map_i;
            sof_map_o           <= sof_map_i;
            len_o               <= len_i;
            len_sum_o           <= len_sum_i;
        end
    end

endmodule
