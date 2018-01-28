module picobus_to_i2c (
	// PicoBus
	input  PicoClk,
	input  PicoRst,
	input  [31:0] PicoAddr,
	input  [127:0] PicoDataIn,
	input  PicoWr,
	input  PicoRd,
	output [127:0] PicoDataOut,

	// HMC I2C
	inout  scl,
	inout  sda,
	
	// HMC Power I2C
	inout  hmc_power_scl,
	inout  hmc_power_sda,
	
	// Stratix Power I2C
	inout  stratix_power_scl,
	inout  stratix_power_sda,
	
	// Temp I2C
	inout  stratix_temp_scl,
	inout  stratix_temp_sda,
	
	// Total System Power
	inout  system_power_scl,
	inout  system_power_sda,

	input  clk,
	input  rst,
	output [15:0] addr,
	output [31:0] write_data,
	output read,
	output write,
	input  [31:0] read_data

);

wire [31:0] HMCPicoDataOut, HMCPowerPicoDataOut, StratixPowerPicoDataOut, StratixTempPicoDataOut, SystemPowerPicoDataOut;
assign PicoDataOut[31:0] = HMCPicoDataOut | HMCPowerPicoDataOut | StratixPowerPicoDataOut | StratixTempPicoDataOut | SystemPowerPicoDataOut;
assign PicoDataOut[127:32] = 96'h0;

// Slave I2C Peripheral
wire slave_scl_pad_i, slave_scl_pad_o, slave_scl_padoen_o;
wire slave_sda_pad_i, slave_sda_pad_o, slave_sda_padoen_o;
I2CSlave #(
    .I2C_ADR(0),
    .ADDR_WIDTH(16),
    .DATA_WIDTH(32)
) I2CSlave (
    .scl_pad_i(slave_scl_pad_i),
    .scl_pad_o(slave_scl_pad_o),
    .scl_padoen_o(slave_scl_padoen_o),
    .sda_pad_i(slave_sda_pad_i),
    .sda_pad_o(slave_sda_pad_o),
    .sda_padoen_o(slave_sda_padoen_o),

    .clk(clk),
    .rst(rst),
    .addr(addr),
    .write_data(write_data),
    .read(read),
    .write(write),
    .read_data(read_data)
);

// HMC I2C
wire scl_pad_i, scl_pad_o, scl_padoen_o;
wire sda_pad_i, sda_pad_o, sda_padoen_o;
PicoBusToI2C #(32'h80000000) pb2i2c_hmc (
    .scl_pad_i(scl_pad_i),
    .scl_pad_o(scl_pad_o),
    .scl_padoen_o(scl_padoen_o),
    .sda_pad_i(sda_pad_i),
    .sda_pad_o(sda_pad_o),
    .sda_padoen_o(sda_padoen_o),
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn[31:0]),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(HMCPicoDataOut)
);

assign scl = scl_padoen_o ? scl_pad_o : slave_scl_padoen_o ? slave_scl_pad_o : 1'bz;
assign scl_pad_i = scl;
assign slave_scl_pad_i = scl;
assign sda = sda_padoen_o ? sda_pad_o : slave_sda_padoen_o ? slave_sda_pad_o : 1'bz;
assign sda_pad_i = sda;
assign slave_sda_pad_i = sda;

// HMC Power I2C
wire hmc_power_scl_pad_i, hmc_power_scl_pad_o, hmc_power_scl_padoen_o;
wire hmc_power_sda_pad_i, hmc_power_sda_pad_o, hmc_power_sda_padoen_o;
PicoBusToI2C #(32'h80000100) pb2i2c_hmc_power (
    .scl_pad_i(hmc_power_scl_pad_i),
    .scl_pad_o(hmc_power_scl_pad_o),
    .scl_padoen_o(hmc_power_scl_padoen_o),
    .sda_pad_i(hmc_power_sda_pad_i),
    .sda_pad_o(hmc_power_sda_pad_o),
    .sda_padoen_o(hmc_power_sda_padoen_o),
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn[31:0]),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(HMCPowerPicoDataOut)
);
assign hmc_power_scl = hmc_power_scl_padoen_o ? hmc_power_scl_pad_o : 1'bz;
assign hmc_power_scl_pad_i = hmc_power_scl;
assign hmc_power_sda = hmc_power_sda_padoen_o ? hmc_power_sda_pad_o : 1'bz;
assign hmc_power_sda_pad_i = hmc_power_sda;

// Stratix Power I2C
wire stratix_power_scl_pad_i, stratix_power_scl_pad_o, stratix_power_scl_padoen_o;
wire stratix_power_sda_pad_i, stratix_power_sda_pad_o, stratix_power_sda_padoen_o;
PicoBusToI2C #(32'h80000200) pb2_i2c_fpga_power (
    .scl_pad_i(stratix_power_scl_pad_i),
    .scl_pad_o(stratix_power_scl_pad_o),
    .scl_padoen_o(stratix_power_scl_padoen_o),
    .sda_pad_i(stratix_power_sda_pad_i),
    .sda_pad_o(stratix_power_sda_pad_o),
    .sda_padoen_o(stratix_power_sda_padoen_o),
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn[31:0]),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(StratixPowerPicoDataOut)
);
assign stratix_power_scl = stratix_power_scl_padoen_o ? stratix_power_scl_pad_o : 1'bz;
assign stratix_power_scl_pad_i = stratix_power_scl;
assign stratix_power_sda = stratix_power_sda_padoen_o ? stratix_power_sda_pad_o : 1'bz;
assign stratix_power_sda_pad_i = stratix_power_sda;

// Stratix Temp I2C
wire stratix_temp_scl_pad_i, stratix_temp_scl_pad_o, stratix_temp_scl_padoen_o;
wire stratix_temp_sda_pad_i, stratix_temp_sda_pad_o, stratix_temp_sda_padoen_o;
PicoBusToI2C #(32'h80000300) pb2i2c_temp (
    .scl_pad_i(stratix_temp_scl_pad_i),
    .scl_pad_o(stratix_temp_scl_pad_o),
    .scl_padoen_o(stratix_temp_scl_padoen_o),
    .sda_pad_i(stratix_temp_sda_pad_i),
    .sda_pad_o(stratix_temp_sda_pad_o),
    .sda_padoen_o(stratix_temp_sda_padoen_o),
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn[31:0]),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(StratixTempPicoDataOut)
);
assign stratix_temp_scl = stratix_temp_scl_padoen_o ? stratix_temp_scl_pad_o : 1'bz;
assign stratix_temp_scl_pad_i = stratix_temp_scl;
assign stratix_temp_sda = stratix_temp_sda_padoen_o ? stratix_temp_sda_pad_o : 1'bz;
assign stratix_temp_sda_pad_i = stratix_temp_sda;

// System Power I2C
wire system_power_scl_pad_i, system_power_scl_pad_o, system_power_scl_padoen_o;
wire system_power_sda_pad_i, system_power_sda_pad_o, system_power_sda_padoen_o;
PicoBusToI2C #(32'h80000400) pb2i2c_system_power (
    .scl_pad_i(system_power_scl_pad_i),
    .scl_pad_o(system_power_scl_pad_o),
    .scl_padoen_o(system_power_scl_padoen_o),
    .sda_pad_i(system_power_sda_pad_i),
    .sda_pad_o(system_power_sda_pad_o),
    .sda_padoen_o(system_power_sda_padoen_o),
    .PicoClk(PicoClk),
    .PicoRst(PicoRst),
    .PicoAddr(PicoAddr),
    .PicoDataIn(PicoDataIn[31:0]),
    .PicoRd(PicoRd),
    .PicoWr(PicoWr),
    .PicoDataOut(SystemPowerPicoDataOut)
);
assign system_power_scl = system_power_scl_padoen_o ? system_power_scl_pad_o : 1'bz;
assign system_power_scl_pad_i = system_power_scl;
assign system_power_sda = system_power_sda_padoen_o ? system_power_sda_pad_o : 1'bz;
assign system_power_sda_pad_i = system_power_sda;


endmodule
