// BRAM.v
// Copyright 2014, Pico Computing, Inc.


module BRAM # (
    parameter DATA_WIDTH = 128,
    parameter DATA_DEPTH = 512,
    parameter LOG_DATA_DEPTH = 9,
    parameter LATCH_INPUT = "NO"

) (
    input wire                          wr_clk,
    input wire [LOG_DATA_DEPTH-1:0]     wr_addr,
    input wire     [DATA_WIDTH-1:0]     wr_data,
    input wire                          wr_en,

    input wire                          rd_clk,
    input wire [LOG_DATA_DEPTH-1:0]     rd_addr,
    output reg     [DATA_WIDTH-1:0]     rd_data
);

reg [DATA_WIDTH-1:0] mem [DATA_DEPTH-1:0];
reg [DATA_WIDTH-1:0] rd_data_p;

generate 
    if (LATCH_INPUT == "YES") begin: LATCH
        reg [DATA_WIDTH-1:0] wr_data_q;
        reg [LOG_DATA_DEPTH-1:0] wr_addr_q;
        reg wr_en_q;
        always @ (posedge wr_clk) begin
            wr_en_q     <= wr_en;
            wr_data_q   <= wr_data;
            wr_addr_q   <= wr_addr;
            if (wr_en_q)
                mem[wr_addr_q] <= wr_data_q;
        end

    end else if (LATCH_INPUT == "NO") begin: NOLATCH
        always @ (posedge wr_clk) begin
            if (wr_en)
                mem[wr_addr] <= wr_data;
        end

    end else begin: ERROR
        //ERROR: unkonwn value
    end
endgenerate

always @ (posedge rd_clk) begin
    rd_data_p   <= mem[rd_addr];
    rd_data     <= rd_data_p;
end

endmodule
