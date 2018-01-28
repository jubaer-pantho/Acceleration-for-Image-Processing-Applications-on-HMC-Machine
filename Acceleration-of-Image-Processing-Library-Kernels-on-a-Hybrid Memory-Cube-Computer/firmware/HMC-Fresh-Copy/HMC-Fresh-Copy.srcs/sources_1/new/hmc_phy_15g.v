`timescale 1ns / 1ps

// TODO          : I think we need to align all the debug bus stuff to 4B
`include "hmc_def.h.v"
`include "hmc_cfg.vh"

module resetctl (
	input clk,
	input rst_i,
	output rst_o
);

reg rstb = 0;
always @(posedge clk or posedge rst_i) begin
	if(rst_i)
		rstb <= 0;
	else
		rstb <= 1;
end

assign rst_o = ~rstb;

endmodule


`ifdef SIMULATION
module fifo40 (
  input aclr,
  input [`LINKBITS-1:0] data,
  input rdclk,
  input rdreq,
  input wrclk,
  input wrreq,
  output reg [`LINKBITS-1:0] q = 0,
  output reg rdempty = 0,
  output reg wrfull = 0
);

reg [8:0] rdptr = 0, wrptr = 0;
reg [`LINKBITS-1:0] bram [511:0];
integer i;
initial begin
	for(i = 0; i < 512; i = i + 1) bram[i] = 0;
end
always @(posedge wrclk) begin
	if(aclr) begin
		wrptr <= 0;
	end else if(wrreq & ~wrfull) begin
		bram[wrptr] <= data;
		wrptr <= wrptr + 1;
	end
	wrfull <= (wrptr + 1) == rdptr;
end

always @(posedge rdclk) begin
	if(aclr) begin
		rdptr <= 0;
		q <= 0;
	end else if(rdreq & ~rdempty) begin
		q <= bram[rdptr];
		rdptr <= rdptr + 1; 
	end
	rdempty <= rdptr == wrptr;
end

endmodule
`endif


module null_detect (
	input clk,
	input reset,
	input [`LINKBITS-1:0] data_i,
	output reg [`LINKBITS-1:0] data_o = 0,
	output reg null_flits = 0,
	output reg error = 0
);

reg [(`LINKBITS*2)-1:0] sh  = 0;
reg [6:0]  off = 0;
reg null_flit = 0;
always @(posedge clk) begin
	null_flit <= data_i == {`LINKBITS{1'b0}};
	sh <= {data_i, sh[(`LINKBITS*2)-1:`LINKBITS]};
	if(reset) begin
		null_flits <= 0;
		error      <= 0;
	// check to see if we have a full NULL flit
	end else if(!null_flits & null_flit) begin
		null_flits <= 1;
		`ifdef HALFLINK
		casez(sh[`LINKBITS-1:0])
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0: error <= 1;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01: off <= 1;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011: off <= 2;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0111: off <= 3;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01111: off <= 4;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110: off <= 5;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0111100: off <= 6;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01111000: off <= 7;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000: off <= 8;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000z: off <= 9;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zz: off <= 10;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzz: off <= 11;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzz: off <= 12;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzz: off <= 13;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzz: off <= 14;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzz: off <= 15;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzz: off <= 16;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzz: off <= 17;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzz: off <= 18;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzz: off <= 19;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzz: off <= 20;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzz: off <= 21;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzz: off <= 22;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzz: off <= 23;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzz: off <= 24;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzz: off <= 25;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzz: off <= 26;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzz: off <= 27;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzz: off <= 28;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzz: off <= 29;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzz: off <= 30;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzz: off <= 31;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzz: off <= 32;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzz: off <= 33;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 34;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 35;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 36;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 37;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 38;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 39;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 40;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 41;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 42;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 43;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 44;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 45;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 46;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 47;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 48;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 49;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 50;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 51;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 52;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 53;
		80'bz0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 54;
		80'b0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 55;
		80'bz0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 56;
		80'b0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 57;
		80'bz0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 58;
		80'b0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 59;
		80'bz0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 60;
		80'b0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 61;
		80'bz0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 62;
		80'b0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 63;
		80'bz0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 64;
		80'b0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 65;
		80'bz0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 66;
		80'b0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 67;
		80'bz0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 68;
		80'b0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 69;
		80'bz0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 70;
		80'b0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 71;
		80'bz0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 72;
		80'b0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 73;
		80'bz0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 74;
		80'b0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 75;
		80'bz0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 76;
		80'b0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 77;
		80'bz011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 78;
		80'b011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 79;
		80'b11110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 80;
		endcase		
		`else
		casez(sh[`LINKBITS-1:0])
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0: error <= 1;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01: off <= 1;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011: off <= 2;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0111: off <= 3;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01111: off <= 4;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110: off <= 5;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0111100: off <= 6;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z01111000: off <= 7;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000: off <= 8;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000z: off <= 9;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zz: off <= 10;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzz: off <= 11;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzz: off <= 12;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzz: off <= 13;
		40'bz0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzz: off <= 14;
		40'b0z0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzz: off <= 15;
		40'bz0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzz: off <= 16;
		40'b0z0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzz: off <= 17;
		40'bz0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzz: off <= 18;
		40'b0z0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzz: off <= 19;
		40'bz0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzz: off <= 20;
		40'b0z0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzz: off <= 21;
		40'bz0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzz: off <= 22;
		40'b0z0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzz: off <= 23;
		40'bz0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzz: off <= 24;
		40'b0z0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzz: off <= 25;
		40'bz0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzz: off <= 26;
		40'b0z0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzz: off <= 27;
		40'bz0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzz: off <= 28;
		40'b0z0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzz: off <= 29;
		40'bz0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzz: off <= 30;
		40'b0z0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzz: off <= 31;
		40'bz0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzz: off <= 32;
		40'b0z0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzz: off <= 33;
		40'bz0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 34;
		40'b0z0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 35;
		40'bz0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 36;
		40'b0z011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 37;
		40'bz011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 38;
		40'b011110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 39;
		40'b11110000zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz: off <= 40;
		endcase
		`endif
	end

	case(off)
`ifndef HALFLINK
	1:  data_o <= sh[40:1];
	2:  data_o <= sh[41:2];
	3:  data_o <= sh[42:3];
	4:  data_o <= sh[43:4];
	5:  data_o <= sh[44:5];
	6:  data_o <= sh[45:6];
	7:  data_o <= sh[46:7];
	8:  data_o <= sh[47:8];
	9:  data_o <= sh[48:9];
	10: data_o <= sh[49:10];
	11: data_o <= sh[50:11];
	12: data_o <= sh[51:12];
	13: data_o <= sh[52:13];
	14: data_o <= sh[53:14];
	15: data_o <= sh[54:15];
	16: data_o <= sh[55:16];
	17: data_o <= sh[56:17];
	18: data_o <= sh[57:18];
	19: data_o <= sh[58:19];
	20: data_o <= sh[59:20];
	21: data_o <= sh[60:21];
	22: data_o <= sh[61:22];
	23: data_o <= sh[62:23];
	24: data_o <= sh[63:24];
	25: data_o <= sh[64:25];
	26: data_o <= sh[65:26];
	27: data_o <= sh[66:27];
	28: data_o <= sh[67:28];
	29: data_o <= sh[68:29];
	30: data_o <= sh[69:30];
	31: data_o <= sh[70:31];
	32: data_o <= sh[71:32];
	33: data_o <= sh[72:33];
	34: data_o <= sh[73:34];
	35: data_o <= sh[74:35];
	36: data_o <= sh[75:36];
	37: data_o <= sh[76:37];
	38: data_o <= sh[77:38];
	39: data_o <= sh[78:39];
	40: data_o <= sh[79:40];
`else
    1:  data_o <= sh[80:1];
    2:  data_o <= sh[81:2];
    3:  data_o <= sh[82:3];
    4:  data_o <= sh[83:4];
    5:  data_o <= sh[84:5];
    6:  data_o <= sh[85:6];
    7:  data_o <= sh[86:7];
    8:  data_o <= sh[87:8];
    9:  data_o <= sh[88:9];
    10: data_o <= sh[89:10];
    11: data_o <= sh[90:11];
    12: data_o <= sh[91:12];
    13: data_o <= sh[92:13];
    14: data_o <= sh[93:14];
    15: data_o <= sh[94:15];
    16: data_o <= sh[95:16];
    17: data_o <= sh[96:17];
    18: data_o <= sh[97:18];
    19: data_o <= sh[98:19];
    20: data_o <= sh[99:20];
    21: data_o <= sh[100:21];
    22: data_o <= sh[101:22];
    23: data_o <= sh[102:23];
    24: data_o <= sh[103:24];
    25: data_o <= sh[104:25];
    26: data_o <= sh[105:26];
    27: data_o <= sh[106:27];
    28: data_o <= sh[107:28];
    29: data_o <= sh[108:29];
    30: data_o <= sh[109:30];
    31: data_o <= sh[110:31];
    32: data_o <= sh[111:32];
    33: data_o <= sh[112:33];
    34: data_o <= sh[113:34];
    35: data_o <= sh[114:35];
    36: data_o <= sh[115:36];
    37: data_o <= sh[116:37];
    38: data_o <= sh[117:38];
    39: data_o <= sh[118:39];
    40: data_o <= sh[119:40];
	41: data_o <= sh[120:41];
	42: data_o <= sh[121:42];
	43: data_o <= sh[122:43];
	44: data_o <= sh[123:44];
	45: data_o <= sh[124:45];
	46: data_o <= sh[125:46];
	47: data_o <= sh[126:47];
	48: data_o <= sh[127:48];
	49: data_o <= sh[128:49];
	50: data_o <= sh[129:50];
	51: data_o <= sh[130:51];
	52: data_o <= sh[131:52];
	53: data_o <= sh[132:53];
	54: data_o <= sh[133:54];
	55: data_o <= sh[134:55];
	56: data_o <= sh[135:56];
	57: data_o <= sh[136:57];
	58: data_o <= sh[137:58];
	59: data_o <= sh[138:59];
	60: data_o <= sh[139:60];
	61: data_o <= sh[140:61];
	62: data_o <= sh[141:62];
	63: data_o <= sh[142:63];
	64: data_o <= sh[143:64];
	65: data_o <= sh[144:65];
	66: data_o <= sh[145:66];
	67: data_o <= sh[146:67];
	68: data_o <= sh[147:68];
	69: data_o <= sh[148:69];
	70: data_o <= sh[149:70];
	71: data_o <= sh[150:71];
	72: data_o <= sh[151:72];
	73: data_o <= sh[152:73];
	74: data_o <= sh[153:74];
	75: data_o <= sh[154:75];
	76: data_o <= sh[155:76];
	77: data_o <= sh[156:77];
	78: data_o <= sh[157:78];
	79: data_o <= sh[158:79];
	80: data_o <= sh[159:80];
`endif
	endcase
end

endmodule


module sync_shift (
    input clk,
    input [4:0] shift,
    input [`LINKBITS-1:0] rx_i,
    output reg [`LINKBITS-1:0] rx_o = 0
);

reg [(`LINKBITS*2)-1:0] rx_reg = 0;
reg [`LINKBITS-1:0] rx_0 = 0;

always @(posedge clk) begin
    rx_reg <= {rx_i, rx_reg[(`LINKBITS*2)-1:`LINKBITS]};
    
    case(shift)
    0:  rx_0 <= rx_reg[`LINKBITS-1:0];
    1:  rx_0 <= rx_reg[`LINKBITS:1];
    2:  rx_0 <= rx_reg[`LINKBITS+1:2];
    3:  rx_0 <= rx_reg[`LINKBITS+2:3];
    4:  rx_0 <= rx_reg[`LINKBITS+3:4];
    5:  rx_0 <= rx_reg[`LINKBITS+4:5];
    6:  rx_0 <= rx_reg[`LINKBITS+5:6];
    7:  rx_0 <= rx_reg[`LINKBITS+6:7];
    8:  rx_0 <= rx_reg[`LINKBITS+7:8];
    9:  rx_0 <= rx_reg[`LINKBITS+8:9];
    10: rx_0 <= rx_reg[`LINKBITS+9:10];
    11: rx_0 <= rx_reg[`LINKBITS+10:11];
    12: rx_0 <= rx_reg[`LINKBITS+11:12];
    13: rx_0 <= rx_reg[`LINKBITS+12:13];
    14: rx_0 <= rx_reg[`LINKBITS+13:14];
    15: rx_0 <= rx_reg[`LINKBITS+14:15];
    16: rx_0 <= rx_reg[`LINKBITS+15:16];
    17: rx_0 <= rx_reg[`LINKBITS+16:17];
    18: rx_0 <= rx_reg[`LINKBITS+17:18];
    19: rx_0 <= rx_reg[`LINKBITS+18:19];
    20: rx_0 <= rx_reg[`LINKBITS+19:20];
    21: rx_0 <= rx_reg[`LINKBITS+20:21];
    22: rx_0 <= rx_reg[`LINKBITS+21:22];
    23: rx_0 <= rx_reg[`LINKBITS+22:23];
    24: rx_0 <= rx_reg[`LINKBITS+23:24];
    25: rx_0 <= rx_reg[`LINKBITS+24:25];
    26: rx_0 <= rx_reg[`LINKBITS+25:26];
    27: rx_0 <= rx_reg[`LINKBITS+26:27];
    28: rx_0 <= rx_reg[`LINKBITS+27:28];
    29: rx_0 <= rx_reg[`LINKBITS+28:29];
    30: rx_0 <= rx_reg[`LINKBITS+29:30];
    31: rx_0 <= rx_reg[`LINKBITS+30:31];
    endcase
    rx_o <= rx_0;
end

endmodule


module hmc_sync_bonder (
    input  extra_clk,
	input  [`LANES-1:0]  rx_clk_s,   // SERDES Side
	input  [639:0] rx_data_s,
	input          tx_clk_s,
	output [639:0] tx_data_s,

	output         rx_clk_u,   // User Logic Side
	output [639:0] rx_data_u,	
	output         tx_clk_u,
	input  [639:0] tx_data_u,
	
	input  tx_reset,
	input  rx_reset,
	
	output reg ready = 0,
	output reg trained = 0,
	output [`LANES-1:0] training_error,
	output timeout,
	
	input  debug_clk,
    input  [31:0] debug_addr,
    input  [31:0] debug_din,
    input  debug_rd,
    input  debug_wr,
    output reg [31:0] debug_dout = 32'h0
);

// RX
wire [`LINKBITS-1:0] rx_s  [`LANES-1:0];
wire [`LINKBITS-1:0] rx_sh [`LANES-1:0];
wire [639:0] rx_data_sh, rx0, rx1;
reg [639:0] rx_0 = 0, rx_1 = 0;
link_unpack rx_link_unpack (
	rx_data_s,
	rx_s[0], rx_s[1], rx_s[2],  rx_s[3],  rx_s[4],  rx_s[5],  rx_s[6],  rx_s[7] `ifndef HALFLINK ,
	rx_s[8], rx_s[9], rx_s[10], rx_s[11], rx_s[12], rx_s[13], rx_s[14], rx_s[15] `endif
);

`ifndef HALFLINK
wire [`LINKBITS-1:0] r0 [`LANES-1:0];
wire [`LINKBITS-1:0] r1 [`LANES-1:0];
link_unpack r0_link_unpack (
	rx_0,
	r0[0], r0[1], r0[2],  r0[3],  r0[4],  r0[5],  r0[6],  r0[7] `ifndef HALFLINK ,
	r0[8], r0[9], r0[10], r0[11], r0[12], r0[13], r0[14], r0[15] `endif
);

link_unpack r1_link_unpack (
	rx_1,
	r1[0], r1[1], r1[2],  r1[3],  r1[4],  r1[5],  r1[6],  r1[7] `ifndef HALFLINK ,
	r1[8], r1[9], r1[10], r1[11], r1[12], r1[13], r1[14], r1[15] `endif
);

link_pack r0_link_pack (
    r0[0], r1[0], r0[1], r1[1], r0[2], r1[2], r0[3], r1[3],
    r0[4], r1[4], r0[5], r1[5], r0[6], r1[6], r0[7], r1[7],
    rx0
);

link_pack r1_link_pack (
    r0[8],  r1[8],  r0[9],  r1[9],  r0[10], r1[10], r0[11], r1[11],
    r0[12], r1[12], r0[13], r1[13], r0[14], r1[14], r0[15], r1[15],
    rx1
);
`else
assign rx0 = rx_0;
assign rx1 = 640'h0;
`endif

assign rx_clk_u = rx_clk_s[0];
assign tx_clk_u = tx_clk_s;
assign tx_data_s = tx_data_u;
assign training_error = 0;
assign timeout = 0;

reg cap_reg, cap_, cap__, cap_0, cap_1, cap_2, cap_3;
reg [4:0] shift [15:0];
// this counts the number of times we have tried to capture data in rx_0 and
// rx_1, which should happen on consecutive clock cycles 
reg [7:0] cnt_cap_rx0=0, cnt_cap_rx0_1, cnt_cap_rx0_2;
reg [7:0] cnt_cap_rx1=0, cnt_cap_rx1_1, cnt_cap_rx1_2;
// these are debug flags that get asserted if the rx_0 and rx_1 registers hold
// non-zero data
reg nz_rx0, nz_rx0_1, nz_rx0_2, nz_rx0_3, nz_rx0_4;
reg nz_rx1, nz_rx1_1, nz_rx1_2, nz_rx1_3, nz_rx1_4;
reg [31:0] status, status_1, status_2;
wire debug_en = debug_addr[31:8] == 24'h83;
wire cap;
always @(posedge debug_clk) begin
    if(debug_en & debug_wr) begin
        case(debug_addr[7:2])
        1: begin
            trained <= debug_din[0];
            ready   <= debug_din[1];
            cap_reg <= debug_din[2];
        end
        8: begin
            shift[0] <= debug_din[4:0];
            shift[1] <= debug_din[12:8];
            shift[2] <= debug_din[20:16];
            shift[3] <= debug_din[28:24];
        end
        9: begin
            shift[4] <= debug_din[4:0];
            shift[5] <= debug_din[12:8];
            shift[6] <= debug_din[20:16];
            shift[7] <= debug_din[28:24];        
        end
        10: begin
            shift[8] <= debug_din[4:0];
            shift[9] <= debug_din[12:8];
            shift[10] <= debug_din[20:16];
            shift[11] <= debug_din[28:24];        
        end
        11: begin
            shift[12] <= debug_din[4:0];
            shift[13] <= debug_din[12:8];
            shift[14] <= debug_din[20:16];
            shift[15] <= debug_din[28:24];        
        end        
        endcase
    end
    if(debug_en & debug_rd) begin
        case(debug_addr[7:2])
        1:  debug_dout <= {cap_reg, ready, trained};
        8:  debug_dout <= {3'h0, shift[3],  3'h0, shift[2],  3'h0, shift[1],  3'h0, shift[0]};
        9:  debug_dout <= {3'h0, shift[7],  3'h0, shift[6],  3'h0, shift[5],  3'h0, shift[4]};
        10: debug_dout <= {3'h0, shift[11], 3'h0, shift[10], 3'h0, shift[9],  3'h0, shift[8]};
        11: debug_dout <= {3'h0, shift[15], 3'h0, shift[14], 3'h0, shift[13], 3'h0, shift[12]};
        12: debug_dout <= rx0[31:0];
        13: debug_dout <= rx0[63:32];
        14: debug_dout <= rx0[95:64];
        15: debug_dout <= rx0[127:96];
        16: debug_dout <= rx0[159:128];
        17: debug_dout <= rx0[191:160];
        18: debug_dout <= rx0[223:192];
        19: debug_dout <= rx0[255:224];
        20: debug_dout <= rx0[287:256];
        21: debug_dout <= rx0[319:288];
        22: debug_dout <= rx0[351:320];
        23: debug_dout <= rx0[383:352];
        24: debug_dout <= rx0[415:384];
        25: debug_dout <= rx0[447:416];
        26: debug_dout <= rx0[479:448];
        27: debug_dout <= rx0[511:480];
        28: debug_dout <= rx0[543:512];
        29: debug_dout <= rx0[575:544];
        30: debug_dout <= rx0[607:576];
        31: debug_dout <= rx0[639:608];
        32: debug_dout <= rx1[31:0];
        33: debug_dout <= rx1[63:32];
        34: debug_dout <= rx1[95:64];
        35: debug_dout <= rx1[127:96];
        36: debug_dout <= rx1[159:128];
        37: debug_dout <= rx1[191:160];
        38: debug_dout <= rx1[223:192];
        39: debug_dout <= rx1[255:224];
        40: debug_dout <= rx1[287:256];
        41: debug_dout <= rx1[319:288];
        42: debug_dout <= rx1[351:320];
        43: debug_dout <= rx1[383:352];
        44: debug_dout <= rx1[415:384];
        45: debug_dout <= rx1[447:416];
        46: debug_dout <= rx1[479:448];
        47: debug_dout <= rx1[511:480];
        48: debug_dout <= rx1[543:512];
        49: debug_dout <= rx1[575:544];
        50: debug_dout <= rx1[607:576];
        51: debug_dout <= rx1[639:608];
        // GAP HERE
        61: debug_dout <= cnt_cap_rx0_2;
        62: debug_dout <= cnt_cap_rx1_2;
        63: debug_dout <= status_2;
        default: debug_dout <= 0;
        endcase
    end else
        debug_dout <= 0;
    cnt_cap_rx0_1       <= cnt_cap_rx0;
    cnt_cap_rx0_2       <= cnt_cap_rx0_1;
    cnt_cap_rx1_1       <= cnt_cap_rx1;
    cnt_cap_rx1_2       <= cnt_cap_rx1_1;
    status              <= {    tx_reset,       // 25
                                rx_reset,       // 24
                                2'b0,
                                nz_rx1_4,       // 21
                                nz_rx0_4,       // 20
                                1'b0,
                                ready,          // 18
                                trained,        // 17
                                timeout,        // 16
                                training_error  // 15:0
                            };
    status_1            <= status;
    status_2            <= status_1;
    nz_rx0_1            <= nz_rx0;
    nz_rx0_2            <= nz_rx0_1;
    nz_rx0_3            <= nz_rx0_2;
    nz_rx0_4            <= nz_rx0_3;
    nz_rx1_1            <= nz_rx1;
    nz_rx1_2            <= nz_rx1_1;
    nz_rx1_3            <= nz_rx1_2;
    nz_rx1_4            <= nz_rx1_3;
end

integer j;
always @(posedge rx_clk_u) begin
    cap_  <= cap_reg;
    cap__ <= cap_;
    cap_0 <= cap__;
    cap_1 <= cap_0;
    cap_2 <= cap_0 & ~cap_1;
    cap_3 <= cap_2;

    if(cap_2) begin
        rx_0 <= rx_data_sh; // first captured data
        cnt_cap_rx0 <= cnt_cap_rx0 + 1;
    end
    nz_rx0 <= |rx_0;
    
    if(cap_3) begin
        rx_1 <= rx_data_sh; // second captured data
        cnt_cap_rx1 <= cnt_cap_rx1 + 1;
    end
    nz_rx1 <= |rx_1;
end

genvar i;
generate for(i = 0; i < `LANES; i = i + 1) begin: sync_shift
    sync_shift sync_shift (
        .clk(rx_clk_u),
        .shift(shift[i]),
        .rx_i(rx_s[i]),
        .rx_o(rx_sh[i])
    );
end endgenerate

link_pack rx_link_pack (
	rx_sh[0], rx_sh[1], rx_sh[2],  rx_sh[3],  rx_sh[4],  rx_sh[5],  rx_sh[6],  rx_sh[7], `ifndef HALFLINK
	rx_sh[8], rx_sh[9], rx_sh[10], rx_sh[11], rx_sh[12], rx_sh[13], rx_sh[14], rx_sh[15], `endif
	rx_data_sh
);

link_interleave_pack rx_interleave_link_pack (
	rx_sh[0], rx_sh[1], rx_sh[2],  rx_sh[3],  rx_sh[4],  rx_sh[5],  rx_sh[6],  rx_sh[7], `ifndef HALFLINK
	rx_sh[8], rx_sh[9], rx_sh[10], rx_sh[11], rx_sh[12], rx_sh[13], rx_sh[14], rx_sh[15], `endif
	rx_data_u
);

reg [31:0] sec_reg = 0;
reg sec_rst = 0;
always @(posedge extra_clk) begin
    if(sec_reg >= 50000000) begin
        sec_reg <= 0;
        sec_rst <= 1;
    end else begin
        sec_reg <= sec_reg + 1;
        sec_rst <= 0;
    end
end

reg sec_rst_0 = 0, sec_rst_1 = 0;
(* KEEP *) reg [31:0] rx_clk_count = 0;
(* KEEP *) reg [31:0] rx_clk_count_per_second = 0;
always @(posedge rx_clk_u) begin
    if(sec_rst_0 & ~sec_rst_1) begin
        rx_clk_count <= 0;
        rx_clk_count_per_second <= rx_clk_count;
    end else
        rx_clk_count <= rx_clk_count + 1;
    sec_rst_0 <= sec_rst;
    sec_rst_1 <= sec_rst_0;
end

(* KEEP *) reg [127:0] rx_data_reg0, rx_data_reg1, rx_data_reg2, rx_data_reg3, rx_data_reg4;
(* KEEP *) reg rx_data_trig;
always @(posedge rx_clk_u) begin
    rx_data_reg0 <= rx_data_u[127:0];
    rx_data_reg1 <= rx_data_u[255:128];
    rx_data_reg2 <= rx_data_u[383:256];
    rx_data_reg3 <= rx_data_u[511:384];
    rx_data_reg4 <= rx_data_u[639:512];
    rx_data_trig <= {rx_data_u[517:512], rx_data_u[389:384], rx_data_u[261:256], rx_data_u[133:128], rx_data_u[5:0]} != 30'h0;
end

/*ila_0 ila_0 (
    .clk(rx_clk_u),
    .probe0({rx_clk_count_per_second, rx_clk_count, rx_data_trig, rx_data_reg4, rx_data_reg3, rx_data_reg2, rx_data_reg1, rx_data_reg0})
);*/

endmodule


module hmc_bonder (
	input  [`LANES-1:0]  rx_clk_s,   // SERDES Side
	input  [639:0] rx_data_s,
	input          tx_clk_s,
	output [639:0] tx_data_s,

	output         rx_clk_u,   // User Logic Side
	output [639:0] rx_data_u,	
	output         tx_clk_u,
	input  [639:0] tx_data_u,
	
	input  tx_reset,
	input  rx_reset,
	
	output reg ready = 0,
	output reg trained = 0,
	output [`LANES-1:0] training_error,
	output reg timeout = 0
);

assign rx_clk_u = rx_clk_s[0];
assign tx_clk_u = tx_clk_s;

genvar i;

// RX
wire [`LINKBITS-1:0] rx_s [`LANES-1:0];
reg  [`LINKBITS-1:0] rx_0 [`LANES-1:0];
wire [`LINKBITS-1:0] rx_1 [`LANES-1:0];
wire [`LINKBITS-1:0] rx_u [`LANES-1:0];
link_unpack rx_link_unpack (
	rx_data_s,
	rx_s[0], rx_s[1], rx_s[2],  rx_s[3],  rx_s[4],  rx_s[5],  rx_s[6],  rx_s[7] `ifndef HALFLINK ,
	rx_s[8], rx_s[9], rx_s[10], rx_s[11], rx_s[12], rx_s[13], rx_s[14], rx_s[15] `endif
);

wire rx_u_reset_sync;
resetctl rx_u_resetctl (
	.clk(rx_clk_u),
	.rst_i(rx_reset),
	.rst_o(rx_u_reset_sync)
);

reg [8:0] rx_ready_count;
reg [`LANES-1:0] rx_ready_ts1;
reg [8:0] rx_ready_timeout;
reg rx_ready = 0;
always @(posedge rx_clk_u) begin
	if(rx_u_reset_sync) begin
		rx_ready_count <= 0;
		rx_ready_timeout <= 0;
		rx_ready <= 0;
	end else if(~rx_ready_count[8]) begin
		rx_ready_count <= rx_ready_count + 9'h1;
	end else begin
		if(~rx_ready_timeout[8] & ~rx_ready) begin
			rx_ready_timeout <= rx_ready_timeout + 9'h1;
			if(&rx_ready_ts1)
				rx_ready <= 1;
		end
	end
	timeout <= rx_ready_timeout[8];
end

(* KEEP *) wire [`LANES-1:0] rxempty, rxfull;
wire [`LANES-1:0] null_flits;
wire [`LANES-1:0] null_rd_disable;
wire [`LANES-1:0] rx_reset_sync;
generate for(i = 0; i < `LANES; i = i + 1) begin : rx_fifo40
	resetctl resetctl (
		.clk(rx_clk_s[i]),
		.rst_i(rx_reset),
		.rst_o(rx_reset_sync[i])
	);

	always @(posedge rx_clk_s[i])
		rx_0[i] <= rx_s[i];
	
	always @(posedge rx_clk_u) begin
		if(rx_u_reset_sync)
			rx_ready_ts1[i] = 0;
		else if(|rx_1[i])
			rx_ready_ts1[i] = 1;
	end

`ifdef XILINX_FPGA
    fifo40 rx_fifo40 (
        .rst(rx_reset_sync[i]),
        .wr_clk(rx_clk_s[i]),
        .rd_clk(rx_clk_u),
        .din(rx_0[i]),
        .wr_en(~rx_reset_sync[i] & !rxfull[i]),
        .rd_en(~null_rd_disable[i] & !rxempty[i]),
        .dout(rx_1[i]),
        .full(rxfull[i]),
        .empty(rxempty[i])
    );
`else
	fifo40 rx_fifo40 (
		.aclr(rx_reset_sync[i]),
		.data(rx_0[i]),
		.rdclk(rx_clk_u),
		.rdreq(/*~rx_reset_sync[i] & ~rxempty[i] &*/ ~null_rd_disable[i]),
		.wrclk(rx_clk_s[i]),
		.wrreq(1'b1), //~rx_reset_sync[i] & ~rxfull[i]),
		.q(rx_1[i]),
		.rdempty(rxempty[i]),
		.wrfull(rxfull[i])
	);
`endif

	null_detect null_detect (
		.clk(rx_clk_u),
		.reset(~rx_ready),
		.data_i(rx_1[i]),
		.data_o(rx_u[i]),
		.null_flits(null_flits[i]),
		.error(training_error[i])
	);

	assign null_rd_disable[i] = null_flits[i] & !trained;
end endgenerate

always @(posedge rx_clk_u) begin
	ready   <= rx_ready;
	trained <= &null_flits;
end

link_interleave_pack rx_link_pack (
	rx_u[0], rx_u[1], rx_u[2],  rx_u[3],  rx_u[4],  rx_u[5],  rx_u[6],  rx_u[7], `ifndef HALFLINK
	rx_u[8], rx_u[9], rx_u[10], rx_u[11], rx_u[12], rx_u[13], rx_u[14], rx_u[15], `endif
	rx_data_u
);

// TX
/*
wire [39:0] tx_u  [15:0];
reg  [39:0] tx_s  [15:0];
link_unpack tx_link_unpack (
	tx_data_u,
	tx_u[0], tx_u[1], tx_u[2],  tx_u[3],  tx_u[4],  tx_u[5],  tx_u[6],  tx_u[7],
	tx_u[8], tx_u[9], tx_u[10], tx_u[11], tx_u[12], tx_u[13], tx_u[14], tx_u[15]
);

generate for(i = 0; i < 16; i = i + 1) begin : tx_fifo40
	always @(posedge tx_clk_u)
		tx_s[i] <= tx_u[i];
end endgenerate

link_pack tx_link_pack (
	tx_s[0], tx_s[1], tx_s[2],  tx_s[3],  tx_s[4],  tx_s[5],  tx_s[6],  tx_s[7],
	tx_s[8], tx_s[9], tx_s[10], tx_s[11], tx_s[12], tx_s[13], tx_s[14], tx_s[15],
	tx_data_s
);
*/
assign tx_data_s = tx_data_u;

`ifdef UNDEF
ila_0 ila_0 (
    .clk(rx_clk_u),
    .probe0({
        //rxempty,
        //rxfull,
        //null_flits,
        //null_rd_disable,
        //rx_reset_sync,
        //rx_ready_count,
        //rx_ready_ts1,
        //rx_ready_timeout,
        //rx_ready,
        //tx_reset,
        //rx_reset,
        rx_1[7][79:0],
        //rx_0[7][39:0],
        rx_1[6][79:0],
        //rx_0[6][39:0],
        rx_1[5][79:0],
        //rx_0[5][39:0],
        rx_1[4][79:0],
        //rx_0[4][39:0],
        rx_1[3][79:0],
        //rx_0[3][39:0],
        rx_1[2][79:0],
        //rx_0[2][39:0],
        rx_1[1][79:0],
        //rx_0[1][39:0],
        rx_1[0][79:0]
        //rx_0[0][39:0]
    })
);
`endif

endmodule


module hmc_init_state (
	input  debug_clk,
	input  [31:0] debug_addr,
	input  [31:0] debug_din,
	input  debug_rd,
	input  debug_wr,
	output reg [3:0] init_state = 4'hf,
	output reg [31:0] debug_dout = 32'h0
);

reg [7:0] reset_counter = 0;
wire reset = ~reset_counter[7];

wire debug_en = debug_addr[31:0] == 32'h8000;
always @(posedge debug_clk) begin
	if(~reset_counter[7])
		reset_counter <= reset_counter + 8'h1;
		
	if(reset)
		init_state <= 4'hf;
	else if(debug_wr & debug_en)
		init_state <= debug_din[3:0];

	if(debug_rd & debug_en)
		debug_dout <= {28'h0, init_state};
	else
		debug_dout <= 32'h0;
end

endmodule


module link_interleave_pack (
	input [`LINKBITS-1:0] l0, l1, l2, l3, l4, l5, l6, l7, `ifndef HALFLINK l8, l9, l10, l11, l12, l13, l14, l15, `endif  // 16 40-bit Unpacked Lane Inputs
	output reg [639:0] l = 0                                                             // 1 640-bit Packed Output
);

integer i;
always @(*) begin
	for(i = 0; i < `LINKBITS; i = i + 1) begin
		l[(i * `LANES) + 0]  <= l0[i];
		l[(i * `LANES) + 1]  <= l1[i];
		l[(i * `LANES) + 2]  <= l2[i];
		l[(i * `LANES) + 3]  <= l3[i];
		l[(i * `LANES) + 4]  <= l4[i];
		l[(i * `LANES) + 5]  <= l5[i];
		l[(i * `LANES) + 6]  <= l6[i];
		l[(i * `LANES) + 7]  <= l7[i];
`ifndef HALFLINK
		l[(i * `LANES) + 8]  <= l8[i];
		l[(i * `LANES) + 9]  <= l9[i];
		l[(i * `LANES) + 10] <= l10[i];
		l[(i * `LANES) + 11] <= l11[i];
		l[(i * `LANES) + 12] <= l12[i];
		l[(i * `LANES) + 13] <= l13[i];
		l[(i * `LANES) + 14] <= l14[i];
		l[(i * `LANES) + 15] <= l15[i];
`endif
	end
end

endmodule


module link_interleave_unpack (
	input [639:0] l,                                                                         // 1 640-bit Packed Input
	output reg [`LINKBITS-1:0] l0, l1, l2, l3, l4, l5, l6, l7 `ifndef HALFLINK , l8, l9, l10, l11, l12, l13, l14, l15 `endif  // 16 40-bit Unpacked Lane Outputs
);

integer i;
always @(*) begin
	for(i = 0; i < `LINKBITS; i = i + 1) begin
		l0[i]  <= l[(i * `LANES) + 0];
		l1[i]  <= l[(i * `LANES) + 1];
		l2[i]  <= l[(i * `LANES) + 2];
		l3[i]  <= l[(i * `LANES) + 3];
		l4[i]  <= l[(i * `LANES) + 4];
		l5[i]  <= l[(i * `LANES) + 5];
		l6[i]  <= l[(i * `LANES) + 6];
		l7[i]  <= l[(i * `LANES) + 7];
`ifndef HALFLINK
		l8[i]  <= l[(i * `LANES) + 8];
		l9[i]  <= l[(i * `LANES) + 9];
		l10[i] <= l[(i * `LANES) + 10];
		l11[i] <= l[(i * `LANES) + 11];
		l12[i] <= l[(i * `LANES) + 12];
		l13[i] <= l[(i * `LANES) + 13];
		l14[i] <= l[(i * `LANES) + 14];
		l15[i] <= l[(i * `LANES) + 15];
`endif
	end
end

endmodule


/*
 * Packs 16 40-bit interfaces into a 640-bit wide parallel interface
 * according to the HMC spec.
 */
module link_pack (
	input [`LINKBITS-1:0] l0, l1, l2, l3, l4, l5, l6, l7, `ifndef HALFLINK l8, l9, l10, l11, l12, l13, l14, l15, `endif  // 16 40-bit Unpacked Lane Inputs
	output reg [639:0] l = 0                                                             // 1 640-bit Packed Output
);

always @(*) begin
	l <= {`ifndef HALFLINK l15, l14, l13, l12, l11, l10, l9, l8, `endif l7, l6, l5, l4, l3, l2, l1, l0};
end

endmodule


/*
 * Unpacks a 640-bit parallel interface into 16 40-bit interfaces
 * according to the HMC spec.
 */
module link_unpack (
	input [639:0] l,                                                                         // 1 640-bit Packed Input
	output reg [`LINKBITS-1:0] l0, l1, l2, l3, l4, l5, l6, l7 `ifndef HALFLINK , l8, l9, l10, l11, l12, l13, l14, l15 `endif  // 16 40-bit Unpacked Lane Outputs
);

always @(*) begin
	l0  <= l[`LINKBITS-1:0];
	l1  <= l[(`LINKBITS*2)-1:`LINKBITS];
	l2  <= l[(`LINKBITS*3)-1:`LINKBITS*2];
	l3  <= l[(`LINKBITS*4)-1:`LINKBITS*3];
	l4  <= l[(`LINKBITS*5)-1:`LINKBITS*4];
	l5  <= l[(`LINKBITS*6)-1:`LINKBITS*5];
	l6  <= l[(`LINKBITS*7)-1:`LINKBITS*6];
	l7  <= l[(`LINKBITS*8)-1:`LINKBITS*7];
`ifndef HALFLINK
	l8  <= l[(`LINKBITS*9)-1:`LINKBITS*8];
	l9  <= l[(`LINKBITS*10)-1:`LINKBITS*9];
	l10 <= l[(`LINKBITS*11)-1:`LINKBITS*10];
	l11 <= l[(`LINKBITS*12)-1:`LINKBITS*11];
	l12 <= l[(`LINKBITS*13)-1:`LINKBITS*12];
	l13 <= l[(`LINKBITS*14)-1:`LINKBITS*13];
	l14 <= l[(`LINKBITS*15)-1:`LINKBITS*14];
	l15 <= l[(`LINKBITS*16)-1:`LINKBITS*15];
`endif
end

endmodule


/*
 * Implements RX training matching on a single 40-bit lane
 * based on if it's specified as being the LANE_FIRST,
 * LANE_LAST, or LANE_MID
 */
`define LANE_FIRST 1  // Specifies that this is Lane 0
`define LANE_LAST  2  // Specifies that this is the last Lane (7 or 15)
`define LANE_MID   0  // Specifies that this is a middle Lane (1-6 or 1-14)
module rx_train_x40 #(
	parameter LANE = `LANE_MID
) (
	input  [`LINKBITS-1:0] i,   // 40-bit Training Sequence Input
	output matched,    // Asserted if there's a training sequence match
	output reversed    // Asserted if the match is reversed (only for LANE_FIRST and LANE_LAST)
);

wire [3:0] lane_field =
  (LANE == `LANE_FIRST) ? 4'h3 :
  (LANE == `LANE_LAST)  ? 4'hc :
  4'h5;
wire [3:0] lane_field_rev =
  (LANE == `LANE_FIRST) ? 4'hc :
  (LANE == `LANE_LAST)  ? 4'h3 :
  4'h5;
wire use_rev = (LANE == `LANE_FIRST) | (LANE == `LANE_LAST);
wire [`LINKBITS-1:0] ts0     = {`ifdef HALFLINK 8'hf0, lane_field,     4'h4, 8'hf0, lane_field,     4'h3, 8'hf0, `endif lane_field,     4'h2, 8'hf0, lane_field,     4'h1, 8'hf0, lane_field,     4'h0};
wire [`LINKBITS-1:0] ts0_rev = {`ifdef HALFLINK 8'hf0, lane_field_rev, 4'h4, 8'hf0, lane_field_rev, 4'h3, 8'hf0, `endif lane_field_rev, 4'h2, 8'hf0, lane_field_rev, 4'h1, 8'hf0, lane_field_rev, 4'h0}; 
wire match          = i == ts0;
wire match_rev      = use_rev & (i == ts0_rev);

assign matched  = match | match_rev;
assign reversed = match_rev;

endmodule


/*
 * Implements TX training sequence transmission on a
 * single 40-bit lane.
 */
module tx_train_x40 #(
	parameter LANE = `LANE_MID
) (
	input clk,               // Clock
	input reset,             // Reset (Active high)
	input ready,
	output reg [`LINKBITS-1:0] o = 0  // TX Training Sequence Output
);

wire [3:0] lane_field = (LANE == `LANE_FIRST) ? 4'h3 :
								(LANE == `LANE_LAST)  ? 4'hc :
								4'h5;
reg done = 0;
reg [3:0] seq0 = 0, seq1 = 1, seq2 = 2 `ifdef HALFLINK , seq3 = 3, seq4 = 4 `endif ;
wire [15:0] ts0 = {4'hf, 4'h0, lane_field, seq0};
wire [15:0] ts1 = {4'hf, 4'h0, lane_field, seq1};
wire [15:0] ts2 = {4'hf, 4'h0, lane_field, seq2};
`ifdef HALFLINK
wire [15:0] ts3 = {4'hf, 4'h0, lane_field, seq3};
wire [15:0] ts4 = {4'hf, 4'h0, lane_field, seq4};
`else
reg toggle = 0;
`endif
always @(posedge clk) begin
	if(reset) begin
		seq0   <= 0;
		seq1   <= 4'h1;
		seq2   <= 4'h2;
`ifdef HALFLINK
		seq3   <= 4'h3;
		seq4   <= 4'h4;
`else
		toggle <= 0;
`endif
		done   <= 0;
		o      <= 0;
	end else if(done) begin
	    o      <= 0;
	end else if(!done) begin
`ifdef HALFLINK
	    if(ready & (seq4 == 4'hf))
	       done <= 1;
		o <= {ts4, ts3, ts2, ts1, ts0};
		seq0 <= seq0 + 4'h5;
		seq1 <= seq1 + 4'h5;
		seq2 <= seq2 + 4'h5;
		seq3 <= seq3 + 4'h5;
		seq4 <= seq4 + 4'h5;
`else
		if(~toggle) begin
			o <= {ts2[7:0], ts1, ts0};
			seq0 <= seq0 + 4'h3;
			seq1 <= seq1 + 4'h3;
			seq2 <= seq2 + 4'h3;
		end else begin
            if(ready & (seq1 == 4'hf))
                done <= 1;
			o <= {ts1, ts0, ts2[15:8]};
			seq0 <= seq0 + 4'h2;
			seq1 <= seq1 + 4'h2;
			seq2 <= seq2 + 4'h2;
		end
		toggle <= ~toggle;
`endif
	end
end

endmodule


/*
 * Implements single bit output, 15-bit state scrambling LFSR
 */
module scr_x15_serial (
	input  [14:0] state_i, // 15-bit Input State
	output [14:0] state_o, // 15-bit Output State
	output o               // 1-bit LFSR Output
);

assign state_o = {state_i[1] ^ state_i[0], state_i[14:1]};
assign o = state_i[0];

endmodule


/*
 * Iterates the LFSR to generate BITS amount of output
 */
module scr_x15_parallel #(
	parameter BITS = `LINKBITS
) (
    input  clk,
	input  [14:0] state_i,   // 15-bit Input State
	output [14:0] state_o,   // 15-bit Output State
	output [BITS-1:0] o,     // BITS-bit LFSR Output
	input  slip_up,
	input  slip_down
);

wire [14:0] state [BITS+1:0];
wire [BITS:0] o_;
reg o_0 = 0;

assign state[0] = state_i;
genvar i;
generate for(i = 0; i <= BITS; i = i + 1) begin : scr_x15_serial
	scr_x15_serial scr_x15_serial (
		.state_i(state[i]),
		.state_o(state[i+1]),
		.o(o_[i])
	);
end endgenerate

assign state_o =
  slip_up ? state[BITS+1] :
  (slip_down ? state[BITS-1] : state[BITS]);
assign o =
  slip_up ? o_[BITS:1] :
  (slip_down ? {o_[BITS-2:0], o_0} : o_[BITS-1:0]);

always @(posedge clk) begin
    o_0 <=
      slip_up ? o_[BITS] :
      (slip_down ? o_[BITS-2] : o_[BITS-1]);
end

endmodule


/*
 * Implements 40-bit wide scrambling with specified seed
 */
module scr_x15 (
	input  clk,              // Clock
	input  reset,            // Reset (resets state to seed)
	input  [14:0] seed,      // Seed to use as Initial LFSR State
	output reg [`LINKBITS-1:0] o = 0,  // 40-bit LFSR Output
	input  slip_up,
	input  slip_down
);

reg [14:0] state_i = 0;
wire [14:0] state_o;
wire [`LINKBITS-1:0] o_w;

scr_x15_parallel scr_x15_parallel (
    .clk(clk),
	.state_i(state_i),
	.state_o(state_o),
	.o(o_w),
	.slip_up(slip_up),
	.slip_down(slip_down)
);

always @(posedge clk) begin
	if(reset) state_i <= seed;
	else state_i <= state_o;
	o <= o_w;
end

endmodule


/*
 * HMC Initialization module handles issuing reset to HMC
 * and performing initial I2C configuration.
 */
module hmc_init (
	// Extra Clock
	input  extra_clk,

	// Power Save
	output reg lxrxps = 1'b1,
	input  lxtxps,
	
	// HMC Reset
	inout  p_rst_n,

    // Fatal Error Flag
    input  ferr_n,
	
	// FPGA ID
	input [1:0] fpga_id,
	
	// Debug Bus
	input  debug_clk,
	input  [31:0] debug_addr,
	input  [31:0] debug_din,
	output [31:0] debug_dout,
	input  debug_rd,
	input  debug_wr
);

wire halflink = `ifdef HALFLINK 1 `else 0 `endif ;
wire [6:0] linkbits = `LINKBITS;
wire [4:0] lanes = `LANES;

reg p_rst_n_reg = 0;

wire [3:0] init_state;
wire [31:0] hmc_init_state_debug_dout;
hmc_init_state hmc_init_state (
	.debug_clk(debug_clk),
	.debug_addr(debug_addr),
	.debug_din(debug_din),
	.debug_rd(debug_rd),
	.debug_wr(debug_wr),
	.init_state(init_state),
	.debug_dout(hmc_init_state_debug_dout)
);

reg [31:0] id_debug_dout = 0;
reg ferr_n_1, ferr_n_2;
reg p_rst_n_1, p_rst_n_2;
// GME: apparently there's a bug in the hmc bfm v17646, where if p_rst_n is z at the beginning of time, it'll go through the motions
//   of linking with us, but not actually send any responses to us. like something in the tx pipe is jammed.
`ifdef SIMULATION
reg p_rst_n_en = 1;
`else 
reg p_rst_n_en = 0;
`endif
wire id_debug_en = debug_addr == 32'h8010;
always @(posedge debug_clk) begin
	if(debug_wr & id_debug_en) begin
		p_rst_n_en <= debug_din[2];
		lxrxps     <= debug_din[3];
	end
		
	if(debug_rd & id_debug_en)
		id_debug_dout <=    {  
                            halflink,   // 24
                            3'b0,       // 23:21
                            lanes,      // 20:16
                            1'b0,       // 15
                            linkbits,   // 14:8
                            1'b0,       // 7
                            ferr_n_2,   // 6
                            p_rst_n_2,  // 5
                            lxtxps,     // 4
                            lxrxps,     // 3
                            p_rst_n_en, // 2
                            fpga_id     // 1:0
                            };
	else
		id_debug_dout <= 32'h0;
    ferr_n_1    <= ferr_n;
    ferr_n_2    <= ferr_n_1;
    p_rst_n_1   <= p_rst_n;
    p_rst_n_2   <= p_rst_n_1;
end

reg [7:0] reset_reg = 0;
always @(posedge extra_clk) begin
	if(init_state < 4)
		reset_reg <= 8'h0;
	else begin
		if(!reset_reg[7])
			reset_reg <= reset_reg + 8'h1;
	end

	p_rst_n_reg <= reset_reg[7];
end

assign p_rst_n = p_rst_n_en ? p_rst_n_reg : 1'bz;

assign debug_dout = hmc_init_state_debug_dout | id_debug_dout;

endmodule


/*
 * Implements SERDES interface. For simulation, we have lxrx and lxtx registered on
 * the rising edge of refclk whereas in hardware it will be registered ~80x-100x
 * every refclk cycle. The hmc_serdes.sv file has its PLL code modified to perform
 * this way as well.
 */
module hmc_pmd #(
    parameter   LANES_REVERSED      = 0,
    parameter   HMC_LINK_NUMBER     = 0    // 0-first link, 1-second link
)(
	// HMC Physical Interface
	input  refclk,
`ifdef XILINX_FPGA
    input  [`LANES-1:0] lxrxp,
    input  [`LANES-1:0] lxrxn,
    output [`LANES-1:0] lxtxp,
    output [`LANES-1:0] lxtxn,
`else
	input  [`LANES-1:0] lxrx,
	output [`LANES-1:0] lxtx,
`endif
	
	// Clocks
    output [`LANES-1:0] rx_clk,
	output tx_clk,
	input  extra_clk,
	
	// Deserialized RX/TX Data
	output [639:0] rx_data,
	input  [639:0] tx_data,
	
	// PLL Locked
	output locked,
	
	// System Reset Signal
	output reset,

    // status / resets
	input  [1:0] button,
	output [3:0] led,

	// Debug Bus
	input  debug_clk,
	input  [31:0] debug_addr,
	input  [31:0] debug_din,
	output reg [31:0] debug_dout = 0,
	input  debug_rd,
	input  debug_wr
);

wire [3:0] init_state;
hmc_init_state hmc_init_state (
	.debug_clk(debug_clk),
	.debug_addr(debug_addr),
	.debug_din(debug_din),
	.debug_rd(debug_rd),
	.debug_wr(debug_wr),
	.init_state(init_state),
	.debug_dout()
);

wire system_reset, pll_locked;
reg [7:0] system_reset_cnt = 0;
always @(posedge extra_clk)
    if(init_state == 4'h0)
        system_reset_cnt <= 8'h0;
	else if(~system_reset_cnt[7])
		system_reset_cnt <= system_reset_cnt + 8'h1;
assign system_reset = system_reset_cnt[7];
		
`ifndef SIMULATION
`ifdef XILINX_FPGA
wire [`LANES-1:0] txpmaresetdone, rxpmaresetdone;
wire [639:0] rx_data_swap, tx_data_swap, rx_data_i, tx_data_i;
reg [639:0] rx_data_0 = 0, rx_data_1 = 0, tx_data_0 = 0, tx_data_1 = 0;
wire gtreset = ~system_reset | button[0];
wire cdr_stable_out;
wire rx_ready, rx_reset, bypass_rx_done, bypass_rx_error;
wire tx_reset, bypass_tx_done, bypass_tx_error;
wire [`LANES-1:0] txprgdivresetdone;
wire tx_ready, tx_done, rx_done;
reg tx_pll_and_datapath_in = 0, tx_datapath_in = 0, rx_pll_and_datapath_in = 0, rx_datapath_in = 0, rx_data_good_in = 1;
reg tx_reset_o = 0, rx_reset_o = 0;
reg rx_start_user_in = 0;
wire rx_clk_o;
reg [`LANES-1:0] rxslide_debug, rxslide_0, rxslide_1;
wire [`LANES-1:0] rxslide = rxslide_0 & ~rxslide_1;
wire [31:0] dut_debug;

generate if (HMC_LINK_NUMBER==0) begin
  gtwizard_ultrascale_0 DUT (            // first link
    .gthrxn_in(lxrxn),
    .gthrxp_in(lxrxp),
    .gthtxn_out(lxtxn),
    .gthtxp_out(lxtxp),
    .gtwiz_userclk_tx_reset_in(~(&txpmaresetdone) | tx_reset_o),
    .gtwiz_userclk_tx_srcclk_out(),
    .gtwiz_userclk_tx_usrclk_out(),
    .gtwiz_userclk_tx_usrclk2_out(tx_clk),
    .gtwiz_userclk_tx_active_out(tx_ready),
    .gtwiz_userclk_rx_reset_in(~(&rxpmaresetdone) | rx_reset_o),
    .gtwiz_userclk_rx_srcclk_out(),
    .gtwiz_userclk_rx_usrclk_out(),
    .gtwiz_userclk_rx_usrclk2_out(rx_clk_o),
    .gtwiz_userclk_rx_active_out(rx_ready),
    .gtwiz_buffbypass_tx_reset_in(tx_reset),
    .gtwiz_buffbypass_tx_start_user_in(1'b0),
    .gtwiz_buffbypass_tx_done_out(bypass_tx_done),
    .gtwiz_buffbypass_tx_error_out(bypass_tx_error),
    .gtwiz_buffbypass_rx_reset_in(rx_reset),
    .gtwiz_buffbypass_rx_start_user_in(rx_start_user_in),
    .gtwiz_buffbypass_rx_done_out(bypass_rx_done),
    .gtwiz_buffbypass_rx_error_out(bypass_rx_error),
    .gtwiz_reset_clk_freerun_in(extra_clk),
    .gtwiz_reset_all_in(gtreset),
    .gtwiz_reset_tx_pll_and_datapath_in(tx_pll_and_datapath_in),
    .gtwiz_reset_tx_datapath_in(tx_datapath_in),
    .gtwiz_reset_rx_pll_and_datapath_in(rx_pll_and_datapath_in),
    .gtwiz_reset_rx_datapath_in(rx_datapath_in),
    //.gtwiz_reset_rx_data_good_in(rx_data_good_in),
    .gtwiz_reset_rx_cdr_stable_out(cdr_stable_out),
    .gtwiz_reset_tx_done_out(tx_done),
    .gtwiz_reset_rx_done_out(rx_done),
    .gtwiz_userdata_tx_in(tx_data_swap),
    .gtwiz_userdata_rx_out(rx_data_swap),
    .gtrefclk00_in({`LANES/4{refclk}}),
    .qpll0outclk_out(),
    .qpll0outrefclk_out(),
    //.qpll1outclk_out(),
    //.qpll1outrefclk_out(),
    .rxslide_in(rxslide),
    .rxpmaresetdone_out(rxpmaresetdone),
    .txpmaresetdone_out(txpmaresetdone),
    .txprgdivresetdone_out(txprgdivresetdone)//, .debug(dut_debug)
);
end else begin
  gtwizard_ultrascale_l3_0 DUT (         // second link, uses different placement constraints
    .gthrxn_in(lxrxn),
    .gthrxp_in(lxrxp),
    .gthtxn_out(lxtxn),
    .gthtxp_out(lxtxp),
    .gtwiz_userclk_tx_reset_in(~(&txpmaresetdone) | tx_reset_o),
    .gtwiz_userclk_tx_srcclk_out(),
    .gtwiz_userclk_tx_usrclk_out(),
    .gtwiz_userclk_tx_usrclk2_out(tx_clk),
    .gtwiz_userclk_tx_active_out(tx_ready),
    .gtwiz_userclk_rx_reset_in(~(&rxpmaresetdone) | rx_reset_o),
    .gtwiz_userclk_rx_srcclk_out(),
    .gtwiz_userclk_rx_usrclk_out(),
    .gtwiz_userclk_rx_usrclk2_out(rx_clk_o),
    .gtwiz_userclk_rx_active_out(rx_ready),
    .gtwiz_buffbypass_tx_reset_in(tx_reset),
    .gtwiz_buffbypass_tx_start_user_in(1'b0),
    .gtwiz_buffbypass_tx_done_out(bypass_tx_done),
    .gtwiz_buffbypass_tx_error_out(bypass_tx_error),
    .gtwiz_buffbypass_rx_reset_in(rx_reset),
    .gtwiz_buffbypass_rx_start_user_in(rx_start_user_in),
    .gtwiz_buffbypass_rx_done_out(bypass_rx_done),
    .gtwiz_buffbypass_rx_error_out(bypass_rx_error),
    .gtwiz_reset_clk_freerun_in(extra_clk),
    .gtwiz_reset_all_in(gtreset),
    .gtwiz_reset_tx_pll_and_datapath_in(tx_pll_and_datapath_in),
    .gtwiz_reset_tx_datapath_in(tx_datapath_in),
    .gtwiz_reset_rx_pll_and_datapath_in(rx_pll_and_datapath_in),
    .gtwiz_reset_rx_datapath_in(rx_datapath_in),
    //.gtwiz_reset_rx_data_good_in(rx_data_good_in),
    .gtwiz_reset_rx_cdr_stable_out(cdr_stable_out),
    .gtwiz_reset_tx_done_out(tx_done),
    .gtwiz_reset_rx_done_out(rx_done),
    .gtwiz_userdata_tx_in(tx_data_swap),
    .gtwiz_userdata_rx_out(rx_data_swap),
    .gtrefclk00_in({`LANES/4{refclk}}),
    .qpll0outclk_out(),
    .qpll0outrefclk_out(),
    //.qpll1outclk_out(),
    //.qpll1outrefclk_out(),
    .rxslide_in(rxslide),
    .rxpmaresetdone_out(rxpmaresetdone),
    .txpmaresetdone_out(txpmaresetdone),
    .txprgdivresetdone_out(txprgdivresetdone)//, .debug(dut_debug)
);
end endgenerate

// if the full link has all of the lanes reversed we need to 
// reverse both rx and tx data buses to compensate.
// Note: this is done on a link-by-link basis
// Note: if the entire 16 lanes are reversed, then we cannot do a half-width
// design on that link
wire [`LINKBITS-1:0] r [`LANES-1:0];
wire [`LINKBITS-1:0] t [`LANES-1:0];

generate if (LANES_REVERSED) begin
link_unpack rx_link_unpack (
	rx_data_swap,
	r[0], r[1], r[2],  r[3],  r[4],  r[5],  r[6],  r[7],
	r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]
);

link_pack rx_link_pack (
	r[15], r[14], r[13], r[12], r[11], r[10], r[9], r[8],
	r[7],  r[6],  r[5],  r[4],  r[3],  r[2],  r[1], r[0],
	rx_data_i
);

link_unpack tx_link_unpack (
	tx_data_i,
	t[0], t[1], t[2],  t[3],  t[4],  t[5],  t[6],  t[7],
	t[8], t[9], t[10], t[11], t[12], t[13], t[14], t[15]
);

link_pack tx_link_pack (
	t[15], t[14], t[13], t[12], t[11], t[10], t[9], t[8],
	t[7],  t[6],  t[5],  t[4],  t[3],  t[2],  t[1], t[0],
	tx_data_swap
);
end else begin
assign tx_data_swap = tx_data_i;
assign rx_data_i = rx_data_swap;
end endgenerate

// The TX buffer bypass controller helper block should be held in reset until the TX user clocking network helper
// block which drives it is active
(* dont_touch = "true" *)
reg tx_bypass_reset_o = 0;
gtwizard_ultrascale_0_example_reset_synchronizer reset_synchronizer_gtwiz_buffbypass_tx_reset_inst (
    .clk_in  (tx_clk),
    .rst_in  (~tx_ready | tx_bypass_reset_o),
    .rst_out (tx_reset)
);

genvar i;
reg rx_bypass_reset_o = 0;
(* dont_touch = "true" *)
gtwizard_ultrascale_0_example_reset_synchronizer reset_synchronizer_gtwiz_buffbypass_rx_reset_0_inst (
.clk_in  (rx_clk_o),
.rst_in  (~rx_ready | rx_bypass_reset_o),
.rst_out (rx_reset)
);

assign rx_clk = {`LANES{rx_clk_o}};

assign pll_locked = init_state >= 4'h1;
assign reset  = !pll_locked;
assign locked = pll_locked; // & tx_ready & &rx_ready;

assign led[0] = gtreset;
assign led[1] = reset;
assign led[2] = locked;
assign led[3] = cdr_stable_out;
/*always @(posedge rx_clk_i) begin
    rx_data_0 <= rx_data_i;
    rx_data_1 <= rx_data_0;
end*/
assign rx_data = rx_data_i;
/*always @(posedge tx_clk) begin
    tx_data_0 <= tx_data;
    tx_data_1 <= tx_data_0;
end*/
assign tx_data_i = tx_data;

/*ila_0 ila_1 (
    .clk(tx_clk),
    .probe0({
        pll_locked,
        gtreset,
        locked,
        reset,
        txpmaresetdone,
        tx_ready,
        tx_data_i[639:0]
    })
);

ila_0 ila_0 (
    .clk(rx_clk_o),
    .probe0(rx_data_i[639:0])
);*/

always @(posedge rx_clk_o) begin
    rxslide_0 <= rxslide_debug;
    rxslide_1 <= rxslide_0;
end

always @(posedge debug_clk) begin
    if(debug_wr & (debug_addr == 32'h8210)) begin
        tx_reset_o <= debug_din[0];
        rx_reset_o <= debug_din[1];
        tx_bypass_reset_o <= debug_din[2];
        rx_bypass_reset_o <= debug_din[3];
        tx_pll_and_datapath_in <= debug_din[4];
        tx_datapath_in <= debug_din[5];
        rx_pll_and_datapath_in <= debug_din[6];
        rx_datapath_in <= debug_din[7];
        rx_data_good_in <= debug_din[8];
        rx_start_user_in <= debug_din[9];
        rxslide_debug <= debug_din[`LANES+9:10];
    end
    if(debug_rd) begin
        case(debug_addr)
        32'h8208: debug_dout <= {txpmaresetdone, rxpmaresetdone, rx_ready, 1'b0, reset, locked, pll_locked, gtreset, tx_ready, &rx_ready, cdr_stable_out};
        32'h820C: debug_dout <= {txprgdivresetdone[0], 4'h0, tx_done, bypass_tx_done, bypass_tx_error, rx_done, bypass_rx_done, bypass_rx_error};
        32'h8210: debug_dout <= {rxslide_debug, rx_start_user_in, rx_data_good_in, rx_datapath_in, rx_pll_and_datapath_in, tx_datapath_in, tx_pll_and_datapath_in, rx_bypass_reset_o, tx_bypass_reset_o, rx_reset_o, tx_reset_o};
        32'h8214: debug_dout <= dut_debug;
        32'h8218: debug_dout <= txprgdivresetdone;
        default: debug_dout <= 32'h0;
        endcase
    end else
        debug_dout <= 32'h0;
end
`else
wire	tx_ready;
wire	rx_ready;
wire	reconfig_busy;

low_latency_10g_1ch DUT (
	.refclk_in_clk(refclk),	
	.clk_50_clk(extra_clk), 
	.refclk_reset_reset_n(system_reset),
	.clk_50_reset_reset_n(system_reset),
	.xcvr_low_latency_phy_0_tx_serial_data_export(lxtx),		
	.xcvr_low_latency_phy_0_rx_serial_data_export(lxrx),		
	.xcvr_low_latency_phy_0_tx_ready_export(tx_ready),       
	.xcvr_low_latency_phy_0_rx_ready_export(rx_ready),       
	.xcvr_low_latency_phy_0_pll_locked_export(pll_locked),
	.alt_xcvr_reconfig_0_reconfig_busy_reconfig_busy(reconfig_busy),
	.rx_data(rx_data),
	.tx_data(tx_data),
	.rx_clk(rx_clk),
	.tx_clk(tx_clk)
);
assign reset  = !pll_locked;
assign locked = pll_locked & tx_ready & rx_ready;
`endif
`else
assign reset = ~system_reset;
reg rx_clk_ = 0;
reg [639:0] rx_data_ = 0;
reg locked_ = 0;

assign rx_clk = {16{rx_clk_}};
assign rx_data = rx_data_;
assign locked = locked_;

integer j;

reg [5:0] count = 0;
reg [`LINKBITS-1:0] rx [`LANES-1:0];
always @(posedge refclk) begin
	if(count == (`LINKBITS-1)) begin
		count <= 0;
		rx_clk_ <= 1;
	end else begin
		if(count == ((`LINKBITS/2)-1)) rx_clk_ <= 0;
		count <= count + 1;
	end
	
	for(j = 0; j < `LANES; j = j + 1) begin
		rx[j] <= {lxrx[j], rx[j][`LINKBITS-1:1]};
	end
end

wire [639:0] rx_data_0;
link_pack link_pack (
	rx[0], rx[1], rx[2],  rx[3],  rx[4],  rx[5],  rx[6],  rx[7], `ifndef HALFLINK
	rx[8], rx[9], rx[10], rx[11], rx[12], rx[13], rx[14], rx[15], `endif
	rx_data_0
);
always @(posedge rx_clk) rx_data_ <= rx_data_0;

assign tx_clk = rx_clk_;
always @(posedge refclk) begin
	locked_ <= #1000 1;
end

wire [`LINKBITS-1:0] tx [`LANES-1:0];
link_unpack link_unpack (
	tx_data,
	tx[0], tx[1], tx[2],  tx[3],  tx[4],  tx[5],  tx[6],  tx[7] `ifndef HALFLINK ,
	tx[8], tx[9], tx[10], tx[11], tx[12], tx[13], tx[14], tx[15] `endif
);

reg tx_clk_0 = 0;
reg  [`LINKBITS-1:0] tx_0 [`LANES-1:0];
always @(posedge refclk) begin
	tx_clk_0 <= tx_clk;
	
	if(tx_clk & ~tx_clk_0) begin
		for(j = 0; j < `LANES; j = j + 1) begin
			tx_0[j] <= tx[j];
		end
	end else begin
		for(j = 0; j < `LANES; j = j + 1) begin
			tx_0[j] <= {1'b0, tx_0[j][`LINKBITS-1:1]};
		end
	end
end

assign lxtx[0]  = tx_0[0][0];
assign lxtx[1]  = tx_0[1][0];
assign lxtx[2]  = tx_0[2][0];
assign lxtx[3]  = tx_0[3][0];
assign lxtx[4]  = tx_0[4][0];
assign lxtx[5]  = tx_0[5][0];
assign lxtx[6]  = tx_0[6][0];
assign lxtx[7]  = tx_0[7][0];
`ifndef HALFLINK
assign lxtx[8]  = tx_0[8][0];
assign lxtx[9]  = tx_0[9][0];
assign lxtx[10] = tx_0[10][0];
assign lxtx[11] = tx_0[11][0];
assign lxtx[12] = tx_0[12][0];
assign lxtx[13] = tx_0[13][0];
assign lxtx[14] = tx_0[14][0];
assign lxtx[15] = tx_0[15][0];
`endif
`endif

endmodule


/*
 * Implements descrambling for the HMC controller PMA by capturing the
 * state of the transmitting descrambler and then checking the next
 * 40 bits transmitted with what is expected to verify that the scramblers
 * are synced.
 */
module hmc_descrambler (
	// Clock
	input  [`LANES-1:0] rx_clk,
	
	// Reset
	input  rx_reset,
	
	// RX Input from PMD
	input  [639:0] rx_data_i,
	
	// RX Output to PCS
	output [639:0] rx_data_o,
	
	// Asserts when the descrambler is synchronized
	output reg [`LANES-1:0] descrambler_locked = 0,
	output reg [`LANES-1:0] descrambler_inverted = 0,
	
	input  debug_clk,
    input  [31:0] debug_addr,
    input  [31:0] debug_din,
    input  debug_rd,
    input  debug_wr,
    output reg [31:0] debug_dout = 32'h0
);

wire [`LINKBITS-1:0] l [`LANES-1:0];
reg [`LINKBITS-1:0] l_0 [`LANES-1:0];
link_unpack link_unpack (
	rx_data_i,
	l[0], l[1], l[2],  l[3],  l[4],  l[5],  l[6],  l[7] `ifndef HALFLINK ,
	l[8], l[9], l[10], l[11], l[12], l[13], l[14], l[15] `endif
);

reg  [3:0] state [`LANES-1:0];
reg  [`LANES-1:0] inv = 0;
reg  [7:0] match [`LANES-1:0];
wire [7:0] newmatch [`LANES-1:0];
wire [7:0] newmatch_inv [`LANES-1:0];
reg  [`LANES-1:0] inverted;
reg  [`LINKBITS-1:0] rx_data_i_0 [`LANES-1:0];
reg  [`LINKBITS-1:0] rx_data_i_1 [`LANES-1:0];
reg  [`LANES-1:0] locked = 0;
wire [`LINKBITS-1:0] scramble [`LANES-1:0];
wire [14:0] state_o [`LANES-1:0];
wire [`LANES-1:0] rx_reset_sync;

`ifdef ENABLE_DESCRAMBLER_SLIP
reg [`LANES-1:0] slip_up_debug = 0, slip_up_0 = 0, slip_up_1 = 0;
reg [`LANES-1:0] slip_down_debug = 0, slip_down_0 = 0, slip_down_1 = 0;
wire [`LANES-1:0] slip_up = slip_up_0 & ~slip_up_1;
wire [`LANES-1:0] slip_down = slip_down_0 & ~slip_down_1;

always @(posedge debug_clk) begin
    if(debug_wr & (debug_addr == 32'h8F00)) begin
        slip_up_debug <= debug_din[`LANES-1:0];
        slip_down_debug <= debug_din[`LANES+15:16];
    end
    if(debug_rd & (debug_addr == 32'h8F00)) begin
        debug_dout[`LANES-1:0] <= slip_up_debug;
        debug_dout[`LANES+15:16] <= slip_down_debug;
    end else
        debug_dout <= 0;
end
`endif

genvar i;
reg [`LINKBITS-1:0] o_0 [`LANES-1:0];
reg [`LINKBITS-1:0] o [`LANES-1:0];
generate for(i = 0; i < `LANES; i = i + 1) begin : scr_x15
`ifdef ENABLE_DESCRAMBLER_SLIP
	always @(posedge rx_clk[i]) begin
	   slip_up_0[i] <= slip_up_debug[i];
	   slip_up_1[i] <= slip_up_0[i];
	   slip_down_0[i] <= slip_down_debug[i];
	   slip_down_1[i] <= slip_down_0[i];
	end 
`endif
	
	resetctl resetctl (
		.clk(rx_clk[i]),
		.rst_i(rx_reset),
		.rst_o(rx_reset_sync[i])
	);

	scr_x15_parallel #(15) scr_x15_parallel (
		.state_i(inv[i] ? ~rx_data_i_0[i][`LINKBITS-1:`LINKBITS-15] : rx_data_i_0[i][`LINKBITS-1:`LINKBITS-15]),
		.state_o(state_o[i]),
		.o(),
		.slip_up(0),
		.slip_down(0)
	);

	scr_x15 scr_x15 (
		.clk(rx_clk[i]),
		.reset(~locked[i] | (state[i] == 1)),
		.seed(state_o[i]),
		.o(scramble[i]),
`ifdef ENABLE_DESCRAMBLER_SLIP
		.slip_up(slip_up[i]),
        .slip_down(slip_down[i])
`else
        .slip_up(0),
        .slip_down(0)
`endif
	);

	assign newmatch[i] = {match[i][6:0], inv[i] ? scramble[i] == ~rx_data_i_1[i] : scramble[i] == rx_data_i_1[i]};
	always @(posedge rx_clk[i]) begin
		l_0[i]         <= l[i];
		rx_data_i_0[i] <= l_0[i];
		rx_data_i_1[i] <= rx_data_i_0[i];
		
		if(rx_reset_sync[i]) begin
			inverted[i] <= 0;
			locked[i]   <= 0;
			state[i]    <= 0;
			match[i]    <= 0;
		end else if(~locked[i]) begin
			if(state[i] == 0) inv[i] <= ~inv[i];
			state[i] <= state[i] + 4'h1;
			match[i] <= newmatch[i];
			if((state[i] == 4'hf) & (newmatch[i] == 8'b11111111) & |state_o[i]) begin
				inverted[i] <= inv[i];
				locked[i]   <= 1;
			end
		end

		if(rx_reset_sync[i]) begin
			o_0[i] <= {`LANES/2{2'b01}};
		end else if(descrambler_locked[i]) begin
			if(descrambler_inverted[i])
				o_0[i] <= ~rx_data_i_1[i] ^ scramble[i];
			else
				o_0[i] <= rx_data_i_1[i] ^ scramble[i];
		end
		o[i] <= o_0[i];
		descrambler_locked[i]   <= locked[i];
		descrambler_inverted[i] <= inverted[i];
	end
	
end endgenerate

link_pack link_pack (
	o[0], o[1], o[2],  o[3],  o[4],  o[5],  o[6],  o[7], `ifndef HALFLINK
	o[8], o[9], o[10], o[11], o[12], o[13], o[14], o[15], `endif
	rx_data_o
);

endmodule


/*
 * Implements scrambling on the TX link
 */
module hmc_scrambler (
	// Clock
	input  tx_clk,
	
	// Reset
	input  tx_reset,
	
	// TX Output to PMD
	output [639:0] tx_data_o,
	
	// TX Input from PCS
	input  [639:0] tx_data_i
);

wire [14:0] seeds [`LANES-1:0];
assign seeds[0]  = 15'h4d56;
assign seeds[1]  = 15'h47ff;
assign seeds[2]  = 15'h75b8;
assign seeds[3]  = 15'h1e18;
assign seeds[4]  = 15'h2e10;
assign seeds[5]  = 15'h3eb2;
assign seeds[6]  = 15'h4302;
assign seeds[7]  = 15'h1380;
`ifndef HALFLINK
assign seeds[8]  = 15'h3eb3;
assign seeds[9]  = 15'h2769;
assign seeds[10] = 15'h4580;
assign seeds[11] = 15'h5665;
assign seeds[12] = 15'h6318;
assign seeds[13] = 15'h6014;
assign seeds[14] = 15'h077b;
assign seeds[15] = 15'h261f;
`endif
wire [`LINKBITS-1:0] scramble [`LANES-1:0];
reg [`LINKBITS-1:0] o [`LANES-1:0];

wire [`LINKBITS-1:0] l [`LANES-1:0];
reg [`LINKBITS-1:0] l_0 [`LANES-1:0];
link_unpack link_unpack (
	tx_data_i,
	l[0], l[1], l[2],  l[3],  l[4],  l[5],  l[6],  l[7] `ifndef HALFLINK ,
	l[8], l[9], l[10], l[11], l[12], l[13], l[14], l[15] `endif
);

wire tx_reset_sync;
resetctl resetctl (
	.clk(tx_clk),
	.rst_i(tx_reset),
	.rst_o(tx_reset_sync)
);

genvar i;
generate for(i = 0; i < `LANES; i = i + 1) begin : scr_x15_parallel
	scr_x15 scr_x15 (
		.clk(tx_clk),
		.reset(tx_reset_sync),
		.seed(seeds[i]),
		.o(scramble[i])
	);

	always @(posedge tx_clk) begin
		l_0[i] <= l[i];
		o[i] <= scramble[i] ^ l_0[i];
	end
end endgenerate

link_pack link_pack (
	o[0], o[1], o[2],  o[3],  o[4],  o[5],  o[6],  o[7], `ifndef HALFLINK
	o[8], o[9], o[10], o[11], o[12], o[13], o[14], o[15], `endif
	tx_data_o
);

endmodule


/*
 * Sends the link training sequence on the TX link between
 * when descrambler_locked is asserted and until trained is
 * asserted. Once trained is asserted it begins transmitting
 * tx_data_i.
 */
module hmc_tx_link_trainer (
    input  extra_clk,
    
	// Clock
	input  tx_clk,
	
	// Signals when to begin Training Sequence
	input  descrambler_locked,
	
	// TX Input Bus to pipe through data from PCS when we aren't training
	input  [639:0] tx_data_i,
	
	// TX Output Bus to send Training Sequence
	output [639:0] tx_data_o,
	
	// Signals when to end Training Sequence
	input  ready
);

(* KEEP *)
wire tx_reset_sync;
resetctl resetctl (
	.clk(tx_clk),
	.rst_i(~descrambler_locked),
	.rst_o(tx_reset_sync)
);

(* KEEP *)
wire tx_ready_reset_sync;
resetctl ready_resetctl (
	.clk(tx_clk),
	.rst_i(ready),
	.rst_o(tx_ready_reset_sync)
);

reg [31:0] sec_reg = 0;
reg sec_rst = 0;
always @(posedge extra_clk) begin
    if(sec_reg >= 50000000) begin
        sec_reg <= 0;
        sec_rst <= 1;
    end else begin
        sec_reg <= sec_reg + 1;
        sec_rst <= 0;
    end
end

reg sec_rst_0 = 0, sec_rst_1 = 0;
(* KEEP *) reg [31:0] tx_clk_count = 0;
(* KEEP *) reg [31:0] tx_clk_count_per_second = 0;
always @(posedge tx_clk) begin
    if(sec_rst_0 & ~sec_rst_1) begin
        tx_clk_count <= 0;
        tx_clk_count_per_second <= tx_clk_count;
    end else
        tx_clk_count <= tx_clk_count + 1;
    sec_rst_0 <= sec_rst;
    sec_rst_1 <= sec_rst_0;
end

(* KEEP *) reg [127:0] tx_data_reg0, tx_data_reg1, tx_data_reg2, tx_data_reg3, tx_data_reg4;
(* KEEP *) reg tx_data_trig = 0;
always @(posedge tx_clk) begin
    tx_data_reg0 <= tx_data_i[127:0];
    tx_data_reg1 <= tx_data_i[255:128];
    tx_data_reg2 <= tx_data_i[383:256];
    tx_data_reg3 <= tx_data_i[511:384];
    tx_data_reg4 <= tx_data_i[639:512];
    tx_data_trig <= {tx_data_i[517:512], tx_data_i[389:384], tx_data_i[261:256], tx_data_i[133:128], tx_data_i[5:0]} != 30'h0;
end

/*ila_0 ila_1 (
    .clk(tx_clk),
    .probe0({tx_clk_count_per_second, tx_clk_count, tx_data_trig, tx_data_reg4, tx_data_reg3, tx_data_reg2, tx_data_reg1, tx_data_reg0})
);*/

wire [`LINKBITS-1:0] train [`LANES-1:0];
reg [`LINKBITS-1:0] o [`LANES-1:0];

wire [`LINKBITS-1:0] l [`LANES-1:0];
link_interleave_unpack link_interleave_unpack (
	tx_data_i,
	l[0], l[1], l[2],  l[3],  l[4],  l[5],  l[6],  l[7] `ifndef HALFLINK ,
	l[8], l[9], l[10], l[11], l[12], l[13], l[14], l[15] `endif
);

genvar i;
generate for(i = 0; i < `LANES; i = i + 1) begin :tx_train_x40
	tx_train_x40 #((i == 0) ? `LANE_FIRST : (i == (`LANES-1)) ? `LANE_LAST : `LANE_MID) tx_train_x40 (
		.clk(tx_clk),
		.reset(tx_reset_sync),
        .ready(tx_ready_reset_sync),
		.o(train[i])
	);

	always @(posedge tx_clk) begin
		o[i] <= /*tx_ready_reset_sync ?*/ l[i] | train[i];
	end
end endgenerate

link_pack link_pack (
	o[0], o[1], o[2],  o[3],  o[4],  o[5],  o[6],  o[7], `ifndef HALFLINK
	o[8], o[9], o[10], o[11], o[12], o[13], o[14], o[15], `endif
	tx_data_o
);

`ifdef UNDEF
(* KEEP *)
reg [639:0] tx_data_reg = 0;
(* KEEP *)
reg [639:0] tx_data_i_reg = 0;
always @(posedge tx_clk) begin
    tx_data_i_reg <= tx_data_i;
    tx_data_reg <= tx_data_o;
end

ila_0 ila_0 (
    .clk(tx_clk),
    .probe0({
        tx_reset_sync,
        tx_ready_reset_sync,
        tx_data_reg,
        tx_data_i_reg
    })
);
`endif

endmodule


module hmc_pma (
	// Clocks
	input  [`LANES-1:0] rx_clk_i,
	input  tx_clk_i,
	output rx_clk_o,
	output tx_clk_o,
	
	// Reset
	input  locked,
	input  reset,
	
	// Data Streams From PMD
	input  [639:0] pmd_rx_data,
	output [639:0] pmd_tx_data,

	// Data Streams To PCS
	output [639:0] pcs_rx_data,
	input  [639:0] pcs_tx_data,
	
	// Asserted when the Link is Trained
	output trained,
	
    // status / resets
    input  [1:0] button,
    output [3:0] led,

    // just a random, slow clock
    input  extra_clk,

	// Debug Bus
	input  debug_clk,
	input  [31:0] debug_addr,
	input  [31:0] debug_din,
	output [31:0] debug_dout,
	input  debug_rd,
	input  debug_wr
);

(* dont_touch="true" *) wire [3:0] init_state;
hmc_init_state hmc_init_state (
	.debug_clk(debug_clk),
	.debug_addr(debug_addr),
	.debug_din(debug_din),
	.debug_rd(debug_rd),
	.debug_wr(debug_wr),
	.init_state(init_state),
	.debug_dout()
);

// when pmd is locked we begin syncing our descrambler and assert descrambler_locked when all links are synced
wire [`LANES-1:0] descrambler_locked, descrambler_inverted;
wire descrambler_lanes_locked = descrambler_locked[`LANES-1:0] == {`LANES{1'b1}};
reg [10:0] descrambler_all_locked;
always @(posedge rx_clk_o) descrambler_all_locked <= {descrambler_all_locked[9:0], descrambler_lanes_locked};
wire [639:0] rx_data_0;
wire [31:0] descrambler_debug_dout;
hmc_descrambler hmc_descrambler (
	.rx_clk(rx_clk_i),
	.rx_reset(~locked | (init_state < 8)),
	.rx_data_i(pmd_rx_data),
	.rx_data_o(rx_data_0),
	.descrambler_locked(descrambler_locked),
	.descrambler_inverted(descrambler_inverted),
	.debug_clk(debug_clk),
    .debug_addr(debug_addr),
    .debug_din(debug_din),
    .debug_rd(debug_rd),
    .debug_wr(debug_wr),
    .debug_dout(descrambler_debug_dout)
);

// when pmd is locked we begin outputting scrambled data (defaults to NULL FLITs), we output training data until link is trained when we switch over to pcs tx data
wire [639:0] tx_data_0;
hmc_scrambler hmc_scrambler (
	.tx_clk(tx_clk_i),
	.tx_reset(reset | (init_state < 6)),
	.tx_data_o(pmd_tx_data),
	.tx_data_i(tx_data_0)
);

wire [639:0] rx_data_1, tx_data_1;
wire training_ready, training_timeout;
wire [`LANES-1:0] training_error;
wire [31:0] bonder_debug_dout;
hmc_sync_bonder hmc_bonder (
    .extra_clk(extra_clk),
	.rx_clk_s(rx_clk_i),
	.rx_data_s(rx_data_0),
	.tx_clk_s(tx_clk_i),
	.tx_data_s(tx_data_0),
	.rx_clk_u(rx_clk_o),
	.rx_data_u(rx_data_1),
	.tx_clk_u(tx_clk_o),
	.tx_data_u(tx_data_1),
	.tx_reset(~descrambler_all_locked[0]  | (init_state < 8)),
	.rx_reset(~descrambler_all_locked[10] | (init_state < 10)),
	.ready(training_ready),
	.trained(trained),
	.training_error(training_error),
	.timeout(training_timeout),
	.debug_clk(debug_clk),
    .debug_addr(debug_addr),
    .debug_din(debug_din),
    .debug_rd(debug_rd),
    .debug_wr(debug_wr),
    .debug_dout(bonder_debug_dout)
);
/*assign rx_clk_o = rx_clk_i[0];
assign rx_data_1 = rx_data_0;
assign tx_clk_o = tx_clk_i;
assign tx_data_0 = tx_data_1;
//assign trained = training_ready;
assign training_error = 0;
assign training_timeout = 0;*/

// this lets software train our HMC link during link bringup
// -during normal operation, this is a pass-through (tx side) with 1 cycle of
// latency.
// -this is passive on the RX side, as it just listens to the outgoing RX
// traffic (but we use that RX data during bringup)
wire        [639:0]                 pcs_tx_data_1;
wire        [31:0]                  trainer_debug_dout;
hmc_soft_trainer trainer (
    .tx_clk                         (tx_clk_o),
    .tx_data_i                      (pcs_tx_data),
    .tx_data_o                      (pcs_tx_data_1),

    .rx_clk                         (rx_clk_o),
    .rx_data_i                      (pcs_rx_data),
    
    .rst                            (~trained),
   
    .debug_clk                      (debug_clk),
    .debug_addr                     (debug_addr),
    .debug_din                      (debug_din),
    .debug_rd                       (debug_rd),
    .debug_wr                       (debug_wr),
    .debug_dout                     (trainer_debug_dout)
);

assign pcs_rx_data = rx_data_1;

// when descrambler_locked is asserted we begin transmitting TS1 sequences until trained goes high (indicating rx link is trained)
hmc_tx_link_trainer hmc_tx_link_trainer (
    .extra_clk(extra_clk),
	.tx_clk(tx_clk_o),
	.descrambler_locked(descrambler_all_locked[10] & (init_state >= 9)),
	.tx_data_i(pcs_tx_data_1),
	.tx_data_o(tx_data_1),
	.ready(training_ready)
);

reg [31:0] pma_debug_dout = 0;
wire debug_en = debug_addr[31:8] == 24'h81;
always @(posedge debug_clk) begin
/*    if(debug_en & debug_wr & (debug_addr[7:0] == 1)) begin
        trained <= debug_din[0];
        training_ready <= debug_din[1];
    end*/

	if(debug_en & debug_rd) begin
		case(debug_addr[7:2])
		0: pma_debug_dout <= {descrambler_inverted, descrambler_locked};
		1: pma_debug_dout <= {training_error, 6'h0, descrambler_all_locked[1], descrambler_lanes_locked, 5'h0, training_timeout, training_ready, trained};
		default: pma_debug_dout <= 32'h0;
		endcase
	end else
		pma_debug_dout <= 32'h0;
end

assign debug_dout = pma_debug_dout | descrambler_debug_dout | bonder_debug_dout | trainer_debug_dout;

assign led[0] = reset;
assign led[1] = locked;
assign led[2] = descrambler_locked[`LANES-1:0] == {`LANES{1'b1}};
assign led[3] = trained;

endmodule


/*
 * Implements full HMC PHY interface which includes:
 * - PMD (serdes)
 * - PMA (scrambling/training)
 */
module hmc_phy #(
    parameter   LANES_REVERSED      = 0,
    parameter   HMC_LINK_NUMBER     = 0
)(
	// HMC Physical Interface
	input  refclk,
`ifdef XILINX_FPGA
    input  [`LANES-1:0] lxrxp,
    input  [`LANES-1:0] lxrxn,
    output [`LANES-1:0] lxtxp,
    output [`LANES-1:0] lxtxn,
`else
	input  [`LANES-1:0] lxrx,
	output [`LANES-1:0] lxtx,
`endif

	input         extra_clk,
	output        hmc_trained,
	
	// 640-bit RX Stream
	output rx_clk,
	output [639:0] rx_data,
	
	// 640-bit TX Stream
	output tx_clk,
	input  [639:0] tx_data,
    
    // status lights / resets
    // Note: if not used, just tie button to 2'h0
    input  [1:0] button,
    output [7:0] led,

	// Debug Bus
	input  debug_clk,
	input  [31:0] debug_addr,
	input  [31:0] debug_din,
	output [31:0] debug_dout,
	input  debug_rd,
	input  debug_wr
);

wire [639:0] hmc_pmd_rx_data, hmc_pmd_tx_data;
wire hmc_locked, hmc_reset;
wire [31:0] hmc_pmd_debug_dout;
wire [`LANES-1:0] rx_clk_s;
wire tx_clk_s;
hmc_pmd #(
    .LANES_REVERSED                 (LANES_REVERSED),
    .HMC_LINK_NUMBER                (HMC_LINK_NUMBER)
) hmc_pmd (
	.refclk(refclk),
`ifdef XILINX_FPGA
	.lxrxp(lxrxp),
	.lxrxn(lxrxn),
	.lxtxp(lxtxp),
	.lxtxn(lxtxn),
`else
    .lxrx(lxrx),
    .lxtx(lxtx),
`endif
	.rx_clk(rx_clk_s),
	.tx_clk(tx_clk_s),
	.extra_clk(extra_clk),
	.rx_data(hmc_pmd_rx_data),
	.tx_data(hmc_pmd_tx_data),
	.locked(hmc_locked),
	.reset(hmc_reset),
    .button(2'b0/*button*/),
    .led(led[3:0]),
	.debug_clk(debug_clk),
	.debug_addr(debug_addr),
	.debug_din(debug_din),
	.debug_dout(hmc_pmd_debug_dout),
	.debug_rd(debug_rd),
	.debug_wr(debug_wr)
);

wire [639:0] hmc_pcs_rx_data, hmc_pcs_tx_data;
wire [31:0] hmc_pma_debug_dout;
hmc_pma hmc_pma (
	.rx_clk_i(rx_clk_s),
	.tx_clk_i(tx_clk_s),
	.rx_clk_o(rx_clk),
	.tx_clk_o(tx_clk),
	.locked(hmc_locked),
	.reset(hmc_reset/* | button[1]*/),
	.pmd_rx_data(hmc_pmd_rx_data),
	.pmd_tx_data(hmc_pmd_tx_data),
	.pcs_rx_data(rx_data),
	.pcs_tx_data(tx_data),
	.trained(hmc_trained),
    .button(2'b0/*button*/),
    .led(led[7:4]),
    .extra_clk(extra_clk),
	.debug_clk(debug_clk),
	.debug_addr(debug_addr),
	.debug_din(debug_din),
	.debug_dout(hmc_pma_debug_dout),
	.debug_rd(debug_rd),
	.debug_wr(debug_wr)
);

assign debug_dout = hmc_pmd_debug_dout | hmc_pma_debug_dout;

endmodule
