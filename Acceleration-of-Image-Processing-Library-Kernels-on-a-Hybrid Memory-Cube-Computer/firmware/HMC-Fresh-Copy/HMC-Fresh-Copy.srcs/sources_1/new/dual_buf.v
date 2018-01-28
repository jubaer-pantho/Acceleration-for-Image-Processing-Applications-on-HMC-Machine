// Copyright 2013 Pico Computing, Inc.
/*
 * dual buffer: isolate input/output handshake signals, and improve timing
 */

module dual_buf # (
    parameter WIDTH=128
) (
    input clk,
    input rst,

    input [WIDTH-1:0] data,
    input data_valid,
    output data_ready,

    output [WIDTH-1:0] q,
    output q_valid,
    input q_ready
);
// better to keep it in logic ???
`ifdef XILINX_FPGA
(* ram_style = "distributed" *) reg [WIDTH-1:0] dbuf [0:1];
`else
(* ramstyle = "logic" *) reg [WIDTH-1:0] dbuf [0:1];
`endif
reg [1:0] dbuf_valid;
reg isel, osel; //input select, output select

assign q = dbuf[osel];
assign data_ready = ~dbuf_valid[isel];
assign q_valid = dbuf_valid[osel];

always @ (posedge clk) begin
        if (data_valid & data_ready) begin
            dbuf[isel] <= data;
            dbuf_valid[isel] <= 1;
            isel <= ~isel;
        end

        if (q_valid & q_ready) begin
            dbuf_valid[osel] <= 0;
            osel <= ~osel;
        end
    if (rst) begin
        dbuf_valid <= 0;
        isel <= 0;
        osel <= 0;
    end
end

endmodule
