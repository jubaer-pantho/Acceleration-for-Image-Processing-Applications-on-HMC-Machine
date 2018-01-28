/*
* File Name     : old_flit_logger.v
*
* Description   : This is an older version of the flit logger module that gets
*                 used during the PHY bringup.  In the future, we should
*                 probably replace this w/ the newer one, which is
*                 flit_logger.v.
*
* Copyright     : 2015, Micron, Inc.
*/
module old_flit_logger #(
	parameter BASE_ADDR = 24'h8e,
	parameter NAME = ""
	) (
	input			clk,
	input			rst,
	input [639:0]	din,

	input			debug_clk,
	input [31:0]	debug_addr,
	input			debug_rd,
	input			debug_wr,
	input [31:0]	debug_din,
	output [31:0]	debug_dout
	);

	reg [127:0] flits_0 [4:0];
	reg [127:0] flits_ [4:0];
	reg [127:0] flits [4:0];
	reg [4:0] flits_valid;
	reg flits_valid_reg = 0;
	always @(posedge clk) begin
		flits_0[0] <= din[127:0];
		flits_0[1] <= din[255:128];
		flits_0[2] <= din[383:256];
		flits_0[3] <= din[511:384];
		flits_0[4] <= din[639:512];
		flits_[0] <= flits_0[0];
		flits_[1] <= flits_0[1];
		flits_[2] <= flits_0[2];
		flits_[3] <= flits_0[3];
		flits_[4] <= flits_0[4];
		flits[0] <= flits_[0];
		flits[1] <= flits_[1];
		flits[2] <= flits_[2];
		flits[3] <= flits_[3];
		flits[4] <= flits_[4];
		flits_valid[0] <= |flits_0[0][5:0];
		flits_valid[1] <= |flits_0[1][5:0];
		flits_valid[2] <= |flits_0[2][5:0];
		flits_valid[3] <= |flits_0[3][5:0];
		flits_valid[4] <= |flits_0[4][5:0];
		flits_valid_reg <= |flits_valid;
	end

	wire rx_en = debug_addr[31:8] == BASE_ADDR;
	reg rx_debug_rd = 0;
	reg rx_cap_rst = 0;
	reg [127:0] rx_debug_data_reg [4+1:0];
	reg [31:0] rx_debug_dout = 0;
	assign debug_dout = rx_debug_dout;
	wire [4:0] rx_debug_empty, rx_debug_full;
	always @(posedge debug_clk) begin
		if(rx_en & debug_wr) begin
			case(debug_addr[7:2])
			0: rx_debug_rd <= debug_din[0];
			//1: rx_cap_rst  <= debug_din[0];
			endcase
		end
		// we're providing a common hardcoded-addr rst register to be shared among all flit_logger modules.
		// this makes it easy to have shared timestamps. (well, if they're on their own clocks, they could still drift ...)
        // TODO: should this be on the same reset address as the other flit
        // loggers? if so, it's 32'hff00fc
		if ((debug_addr[31:0] == 32'h8e04) & debug_wr)
			rx_cap_rst	<= debug_din[0];

		if(rx_en & debug_rd) begin
			case(debug_addr[7:2])
			0:  rx_debug_dout <= rx_debug_data_reg[0][31:0];
			1:  rx_debug_dout <= rx_debug_data_reg[0][63:32];
			2:  rx_debug_dout <= rx_debug_data_reg[0][95:64];
			3:  rx_debug_dout <= rx_debug_data_reg[0][127:96];
			4:  rx_debug_dout <= rx_debug_data_reg[1][31:0];
			5:  rx_debug_dout <= rx_debug_data_reg[1][63:32];
			6:  rx_debug_dout <= rx_debug_data_reg[1][95:64];
			7:  rx_debug_dout <= rx_debug_data_reg[1][127:96];
			8:  rx_debug_dout <= rx_debug_data_reg[2][31:0];
			9:  rx_debug_dout <= rx_debug_data_reg[2][63:32];
			10: rx_debug_dout <= rx_debug_data_reg[2][95:64];
			11: rx_debug_dout <= rx_debug_data_reg[2][127:96];
			12: rx_debug_dout <= rx_debug_data_reg[3][31:0];
			13: rx_debug_dout <= rx_debug_data_reg[3][63:32];
			14: rx_debug_dout <= rx_debug_data_reg[3][95:64];
			15: rx_debug_dout <= rx_debug_data_reg[3][127:96];
			16: rx_debug_dout <= rx_debug_data_reg[4][31:0];
			17: rx_debug_dout <= rx_debug_data_reg[4][63:32];
			18: rx_debug_dout <= rx_debug_data_reg[4][95:64];
			19: rx_debug_dout <= rx_debug_data_reg[4][127:96];
			20: rx_debug_dout <= {15'h0, rx_cap_rst, 3'h0, rx_debug_full, 3'h0, rx_debug_empty};
			24: rx_debug_dout <= rx_debug_data_reg[5][31:0];
			25: rx_debug_dout <= rx_debug_data_reg[5][63:32];
			26: rx_debug_dout <= rx_debug_data_reg[5][95:64];
			27: rx_debug_dout <= rx_debug_data_reg[5][127:96];
			default: rx_debug_dout <= 0;
			endcase
		end else
			rx_debug_dout <= 0;
	end

	reg [31:0]	rx_cap_time;
	reg			rx_cap_time_rst;
	always @(posedge clk) begin
	       rx_cap_time_rst <= rst | rx_cap_rst;

	       if (rx_cap_time_rst)	rx_cap_time     <= 'h0;
	       else					rx_cap_time     <= rx_cap_time + 1;

	       if (flits_valid_reg) $display("[%t] %s logging flits: 0x%x, 0x%x, 0x%x, 0x%x, 0x%x", $time, NAME, flits[4], flits[3], flits[2], flits[1], flits[0]);
	end

	wire [127:0]   rx_cap_extra_data = {32'hdeadbeef, 64'h0, rx_cap_time[31:0]};

	wire [127:0] rx_debug_data [4+1:0];
	reg rx_debug_rd_ = 0, rx_debug_rd_0 = 0, rx_debug_rd_1 = 0, rx_debug_rd_2 = 0, rx_debug_rd_3 = 0;
    FIFO #(
        .SYNC                       (1),
        .DATA_WIDTH                 (128+5*128)
    ) fifo (
        .clk                        (clk),
        .rst                        (rst | rx_cap_rst),

        .wr_en                      (flits_valid_reg),
        .din                        ({
                                        rx_cap_extra_data,
                                        flits           [4],
                                        flits           [3],
                                        flits           [2],
                                        flits           [1],
                                        flits           [0]
                                    }),
        .full                       (rx_debug_full      [0]),

        .rd_en                      (rx_debug_rd_0 & ~rx_debug_rd_1),
        .dout                       ({
                                        rx_debug_data   [5],
                                        rx_debug_data   [4],
                                        rx_debug_data   [3],
                                        rx_debug_data   [2],
                                        rx_debug_data   [1],
                                        rx_debug_data   [0]
                                    }),
        .empty                      (rx_debug_empty     [0])
    );
    assign rx_debug_empty   [4:1] = rx_debug_empty      [0];
    assign rx_debug_full    [4:1] = rx_debug_full       [0];

    reg [127:0] rx_debug_data_ [5:0];
	always @(posedge clk) begin
	    rx_debug_data_[0] <= rx_debug_data[0];
	    rx_debug_data_[1] <= rx_debug_data[1];
	    rx_debug_data_[2] <= rx_debug_data[2];
	    rx_debug_data_[3] <= rx_debug_data[3];
	    rx_debug_data_[4] <= rx_debug_data[4];
	    rx_debug_data_[5] <= rx_debug_data[5];
		if(rx_debug_rd_3) begin
			rx_debug_data_reg[0] <= rx_debug_data_[0];
			rx_debug_data_reg[1] <= rx_debug_data_[1];
			rx_debug_data_reg[2] <= rx_debug_data_[2];
			rx_debug_data_reg[3] <= rx_debug_data_[3];
			rx_debug_data_reg[4] <= rx_debug_data_[4];
			rx_debug_data_reg[5] <= rx_debug_data_[5];
		end
		rx_debug_rd_  <= rx_debug_rd;
		rx_debug_rd_0 <= rx_debug_rd_;
		rx_debug_rd_1 <= rx_debug_rd_0;
		rx_debug_rd_2 <= rx_debug_rd_1;
		rx_debug_rd_3 <= rx_debug_rd_1 & ~rx_debug_rd_2;
	end

endmodule
