/*
 * File Name     : errstat.v
 *
 * Copyright     : 2015, Pico Computing, Inc.

 * This module extracts the errstat[6:0] and dinv fields from the tail of each 
 * packet and passes it out on port err_map_o[7:0] as {dinv, errstat[6:0]}.
 * err_map_o[7:0] is always zero on all flits except end of frame flits where
 * it signals the error response for the entire packet.
 * This module adds one cycle of latency to the RX pipeline.
 */


module errstat  #(
    parameter name          = "",
    parameter verbose       = 1,
    parameter N_FLITS       = 5
) (
    input  wire                     clk,
    input  wire                     rst,

    input  wire [N_FLITS*128-1:0]   din,
    input  wire [N_FLITS-1:0]       present_map_i,
    input  wire [N_FLITS-1:0]       sof_map_i,
    input  wire [N_FLITS-1:0]       eof_map_i,
    input  wire [N_FLITS*9-1:0]     tag_map_i,

    output reg  [N_FLITS*128-1:0]   dout,
    output reg  [N_FLITS-1:0]       present_map_o,
    output reg  [N_FLITS-1:0]       sof_map_o,
    output reg  [N_FLITS-1:0]       eof_map_o,
    output reg  [N_FLITS*9-1:0]     tag_map_o,
    output reg  [N_FLITS*8-1:0]     err_map_o,

    // Debug Bus
    input  wire                     debug_clk,
    input  wire [31:0]              debug_addr,
    input  wire [31:0]              debug_din,
    output reg  [31:0]              debug_dout,
    input  wire                     debug_rd,
    input  wire                     debug_wr
);

    `include "hmc_func.h.v"

    wire [N_FLITS-1:0]     errvalid;
    reg  [N_FLITS-1:0]     errvalid_q=0;

    assign errvalid = eof_map_i & present_map_i;  // erstat[6:0] and dinv are valid with eof

    integer j;
    always @ (posedge clk) begin
        // register data
        dout          <= din;                     // din is passed straight through as dout
        present_map_o <= present_map_i;           // present_map_i is passed straight through 
        sof_map_o     <= sof_map_i;               // sof_map_i is passed straight through 
        eof_map_o     <= eof_map_i;               // eof_map_i is passed straight through 
        tag_map_o     <= tag_map_i;               // tag_map_i is passed straight through 
 
        // set the err_map_o bits for each flit from the packet tail if the flit is 
        // present and is an eof, otherwise set the err_map_o bits to 0.
        for (j=0; j<N_FLITS; j=j+1) begin         
            err_map_o[8*(j)+:8] <= errvalid[j] ? {GetDINV(din[128*(j)+:128]), GetERRSTAT(din[128*(j)+:128])} : 'h0;
        end
    end

    initial begin 
        dout          <= 0;
        present_map_o <= 0;
        sof_map_o     <= 0;
        eof_map_o     <= 0;
        err_map_o     <= 0;
    end

    // Diagnostic registers accessible from the debug bus
    integer i;
    reg [31:0] errstat_count;   // Count of the number of error status conditions received.
    reg [7:0]  errstat_latch;   // Latch the first error status code 

    always @ (posedge clk) begin
        if (rst) begin
            errstat_count <= 0;   
            errstat_latch <= 0;  
        end else begin
            errvalid_q <= errvalid;
            for (i=0; i<5; i=i+1) begin
                if (errvalid_q[i] && (err_map_o[i*8 +: 8] != 0)) begin
                    errstat_count <= errstat_count + 1;                             // count all error status conditions 
                    if (errstat_latch == 0) errstat_latch <=  err_map_o[i*8 +: 8];  // Latch the first error status value
                    if (verbose) $display("[%t] ERRSTAT non-zero status received: %02x", $time, err_map_o[i*8 +: 8]);
                end
            end
        end
    end

    // Move the debug info to the debug_clk domain
    reg [31:0] errstat_count_dbg,   errstat_count_dbg_1;   
    reg [7:0]  errstat_latch_dbg,   errstat_latch_dbg_1;   
    always @(posedge debug_clk) begin
        errstat_count_dbg   <= errstat_count;   
        errstat_count_dbg_1 <= errstat_count_dbg;   
        errstat_latch_dbg   <= errstat_latch;   
        errstat_latch_dbg_1 <= errstat_latch_dbg;   
    end
   
    // debug read data bus connection
    always @(posedge debug_clk) begin
        if (debug_rd)
            case (debug_addr[31:0]) 
                32'h0900:   debug_dout <= errstat_count_dbg_1;
                32'h0904:   debug_dout <= {24'h0, errstat_latch_dbg_1};
                default :   debug_dout <= 0;          
            endcase
        else
            debug_dout <= 0;          
    end
        
endmodule
