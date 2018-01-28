/*
* File Name     : async_fifo144.v
*
* Description   : This wrapper module just makes the ports for a Xilinx async
*                 FIFO look exactly like the Altera version of an async FIFO.
*
* Copyright     : 2015, Micron, Inc.
*/

module async_fifo144 (
	input                           aclr,
	input	    [143:0]             data,
	input	                        rdclk,
	input	                        rdreq,
	input	                        wrclk,
	input	                        wrreq,
	output	    [143:0]             q,
	output	                        rdempty,
	output	                        wrfull
);

    // synchronize the aclr to both the wrclk clock domain
    reg                             wr_rst_pre1 = 0;
    reg                             wr_rst      = 0;
    always @ (posedge wrclk) begin
        wr_rst_pre1                 <= aclr;
        wr_rst                      <= wr_rst_pre1;
    end

    // now just instantiate our IP core
    // Note: on ultrascale devices, srst is sample with respect to wr_clk
    async_fifo144_prim f (
        .srst                       (wr_rst),
        .wr_clk                     (wrclk),
        .rd_clk                     (rdclk),
        .din                        (data),
        .wr_en                      (wrreq),
        .rd_en                      (rdreq),
        .dout                       (q),
        .full                       (wrfull),
        .empty                      (rdempty),
        .wr_rst_busy                (),
        .rd_rst_busy                ()
    );

endmodule
