// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
// Date        : Wed Dec 13 20:44:48 2017
// Host        : micron-ubuntu running 64-bit Ubuntu 14.04.2 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/hmc/Desktop/pantho/HMC-Fresh-Copy/HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_sim_netlist.v
// Design      : coregen_fifo_32x128
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku060-ffva1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "coregen_fifo_32x128,fifo_generator_v13_0_1,{}" *) (* core_generation_info = "coregen_fifo_32x128,fifo_generator_v13_0_1,{x_ipProduct=Vivado 2015.4,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=fifo_generator,x_ipVersion=13.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=VERILOG,C_COMMON_CLOCK=1,C_COUNT_TYPE=0,C_DATA_COUNT_WIDTH=6,C_DEFAULT_VALUE=BlankString,C_DIN_WIDTH=128,C_DOUT_RST_VAL=0,C_DOUT_WIDTH=128,C_ENABLE_RLOCS=0,C_FAMILY=kintexu,C_FULL_FLAGS_RST_VAL=1,C_HAS_ALMOST_EMPTY=0,C_HAS_ALMOST_FULL=0,C_HAS_BACKUP=0,C_HAS_DATA_COUNT=0,C_HAS_INT_CLK=0,C_HAS_MEMINIT_FILE=0,C_HAS_OVERFLOW=0,C_HAS_RD_DATA_COUNT=0,C_HAS_RD_RST=0,C_HAS_RST=1,C_HAS_SRST=0,C_HAS_UNDERFLOW=0,C_HAS_VALID=0,C_HAS_WR_ACK=0,C_HAS_WR_DATA_COUNT=0,C_HAS_WR_RST=0,C_IMPLEMENTATION_TYPE=0,C_INIT_WR_PNTR_VAL=0,C_MEMORY_TYPE=2,C_MIF_FILE_NAME=BlankString,C_OPTIMIZATION_MODE=0,C_OVERFLOW_LOW=0,C_PRELOAD_LATENCY=0,C_PRELOAD_REGS=1,C_PRIM_FIFO_TYPE=512x72,C_PROG_EMPTY_THRESH_ASSERT_VAL=4,C_PROG_EMPTY_THRESH_NEGATE_VAL=5,C_PROG_EMPTY_TYPE=0,C_PROG_FULL_THRESH_ASSERT_VAL=31,C_PROG_FULL_THRESH_NEGATE_VAL=30,C_PROG_FULL_TYPE=0,C_RD_DATA_COUNT_WIDTH=6,C_RD_DEPTH=32,C_RD_FREQ=1,C_RD_PNTR_WIDTH=5,C_UNDERFLOW_LOW=0,C_USE_DOUT_RST=1,C_USE_ECC=0,C_USE_EMBEDDED_REG=0,C_USE_PIPELINE_REG=0,C_POWER_SAVING_MODE=0,C_USE_FIFO16_FLAGS=0,C_USE_FWFT_DATA_COUNT=1,C_VALID_LOW=0,C_WR_ACK_LOW=0,C_WR_DATA_COUNT_WIDTH=6,C_WR_DEPTH=32,C_WR_FREQ=1,C_WR_PNTR_WIDTH=5,C_WR_RESPONSE_LATENCY=1,C_MSGON_VAL=1,C_ENABLE_RST_SYNC=1,C_EN_SAFETY_CKT=0,C_ERROR_INJECTION_TYPE=0,C_SYNCHRONIZER_STAGE=2,C_INTERFACE_TYPE=0,C_AXI_TYPE=1,C_HAS_AXI_WR_CHANNEL=1,C_HAS_AXI_RD_CHANNEL=1,C_HAS_SLAVE_CE=0,C_HAS_MASTER_CE=0,C_ADD_NGC_CONSTRAINT=0,C_USE_COMMON_OVERFLOW=0,C_USE_COMMON_UNDERFLOW=0,C_USE_DEFAULT_SETTINGS=0,C_AXI_ID_WIDTH=1,C_AXI_ADDR_WIDTH=32,C_AXI_DATA_WIDTH=64,C_AXI_LEN_WIDTH=8,C_AXI_LOCK_WIDTH=1,C_HAS_AXI_ID=0,C_HAS_AXI_AWUSER=0,C_HAS_AXI_WUSER=0,C_HAS_AXI_BUSER=0,C_HAS_AXI_ARUSER=0,C_HAS_AXI_RUSER=0,C_AXI_ARUSER_WIDTH=1,C_AXI_AWUSER_WIDTH=1,C_AXI_WUSER_WIDTH=1,C_AXI_BUSER_WIDTH=1,C_AXI_RUSER_WIDTH=1,C_HAS_AXIS_TDATA=1,C_HAS_AXIS_TID=0,C_HAS_AXIS_TDEST=0,C_HAS_AXIS_TUSER=1,C_HAS_AXIS_TREADY=1,C_HAS_AXIS_TLAST=0,C_HAS_AXIS_TSTRB=0,C_HAS_AXIS_TKEEP=0,C_AXIS_TDATA_WIDTH=8,C_AXIS_TID_WIDTH=1,C_AXIS_TDEST_WIDTH=1,C_AXIS_TUSER_WIDTH=4,C_AXIS_TSTRB_WIDTH=1,C_AXIS_TKEEP_WIDTH=1,C_WACH_TYPE=0,C_WDCH_TYPE=0,C_WRCH_TYPE=0,C_RACH_TYPE=0,C_RDCH_TYPE=0,C_AXIS_TYPE=0,C_IMPLEMENTATION_TYPE_WACH=1,C_IMPLEMENTATION_TYPE_WDCH=1,C_IMPLEMENTATION_TYPE_WRCH=1,C_IMPLEMENTATION_TYPE_RACH=1,C_IMPLEMENTATION_TYPE_RDCH=1,C_IMPLEMENTATION_TYPE_AXIS=1,C_APPLICATION_TYPE_WACH=0,C_APPLICATION_TYPE_WDCH=0,C_APPLICATION_TYPE_WRCH=0,C_APPLICATION_TYPE_RACH=0,C_APPLICATION_TYPE_RDCH=0,C_APPLICATION_TYPE_AXIS=0,C_PRIM_FIFO_TYPE_WACH=512x36,C_PRIM_FIFO_TYPE_WDCH=1kx36,C_PRIM_FIFO_TYPE_WRCH=512x36,C_PRIM_FIFO_TYPE_RACH=512x36,C_PRIM_FIFO_TYPE_RDCH=1kx36,C_PRIM_FIFO_TYPE_AXIS=1kx18,C_USE_ECC_WACH=0,C_USE_ECC_WDCH=0,C_USE_ECC_WRCH=0,C_USE_ECC_RACH=0,C_USE_ECC_RDCH=0,C_USE_ECC_AXIS=0,C_ERROR_INJECTION_TYPE_WACH=0,C_ERROR_INJECTION_TYPE_WDCH=0,C_ERROR_INJECTION_TYPE_WRCH=0,C_ERROR_INJECTION_TYPE_RACH=0,C_ERROR_INJECTION_TYPE_RDCH=0,C_ERROR_INJECTION_TYPE_AXIS=0,C_DIN_WIDTH_WACH=32,C_DIN_WIDTH_WDCH=64,C_DIN_WIDTH_WRCH=2,C_DIN_WIDTH_RACH=32,C_DIN_WIDTH_RDCH=64,C_DIN_WIDTH_AXIS=1,C_WR_DEPTH_WACH=16,C_WR_DEPTH_WDCH=1024,C_WR_DEPTH_WRCH=16,C_WR_DEPTH_RACH=16,C_WR_DEPTH_RDCH=1024,C_WR_DEPTH_AXIS=1024,C_WR_PNTR_WIDTH_WACH=4,C_WR_PNTR_WIDTH_WDCH=10,C_WR_PNTR_WIDTH_WRCH=4,C_WR_PNTR_WIDTH_RACH=4,C_WR_PNTR_WIDTH_RDCH=10,C_WR_PNTR_WIDTH_AXIS=10,C_HAS_DATA_COUNTS_WACH=0,C_HAS_DATA_COUNTS_WDCH=0,C_HAS_DATA_COUNTS_WRCH=0,C_HAS_DATA_COUNTS_RACH=0,C_HAS_DATA_COUNTS_RDCH=0,C_HAS_DATA_COUNTS_AXIS=0,C_HAS_PROG_FLAGS_WACH=0,C_HAS_PROG_FLAGS_WDCH=0,C_HAS_PROG_FLAGS_WRCH=0,C_HAS_PROG_FLAGS_RACH=0,C_HAS_PROG_FLAGS_RDCH=0,C_HAS_PROG_FLAGS_AXIS=0,C_PROG_FULL_TYPE_WACH=0,C_PROG_FULL_TYPE_WDCH=0,C_PROG_FULL_TYPE_WRCH=0,C_PROG_FULL_TYPE_RACH=0,C_PROG_FULL_TYPE_RDCH=0,C_PROG_FULL_TYPE_AXIS=0,C_PROG_FULL_THRESH_ASSERT_VAL_WACH=1023,C_PROG_FULL_THRESH_ASSERT_VAL_WDCH=1023,C_PROG_FULL_THRESH_ASSERT_VAL_WRCH=1023,C_PROG_FULL_THRESH_ASSERT_VAL_RACH=1023,C_PROG_FULL_THRESH_ASSERT_VAL_RDCH=1023,C_PROG_FULL_THRESH_ASSERT_VAL_AXIS=1023,C_PROG_EMPTY_TYPE_WACH=0,C_PROG_EMPTY_TYPE_WDCH=0,C_PROG_EMPTY_TYPE_WRCH=0,C_PROG_EMPTY_TYPE_RACH=0,C_PROG_EMPTY_TYPE_RDCH=0,C_PROG_EMPTY_TYPE_AXIS=0,C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH=1022,C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH=1022,C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH=1022,C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH=1022,C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH=1022,C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS=1022,C_REG_SLICE_MODE_WACH=0,C_REG_SLICE_MODE_WDCH=0,C_REG_SLICE_MODE_WRCH=0,C_REG_SLICE_MODE_RACH=0,C_REG_SLICE_MODE_RDCH=0,C_REG_SLICE_MODE_AXIS=0}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* x_core_info = "fifo_generator_v13_0_1,Vivado 2015.4" *) 
(* NotValidForBitStream *)
module coregen_fifo_32x128
   (clk,
    rst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) input clk;
  input rst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [127:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [127:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rst;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [5:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [5:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [5:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "6" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "128" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "32" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "128" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "kintexu" *) 
  (* C_FULL_FLAGS_RST_VAL = "1" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "0" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "2" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "4" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "5" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "31" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "30" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "6" *) 
  (* C_RD_DEPTH = "32" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "5" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "1" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "6" *) 
  (* C_WR_DEPTH = "32" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "5" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  coregen_fifo_32x128_fifo_generator_v13_0_1 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[5:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[5:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[5:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule

(* ORIG_REF_NAME = "dmem" *) 
module coregen_fifo_32x128_dmem
   (Q,
    clk,
    E,
    din,
    \gc0.count_d1_reg[4] ,
    \gcc0.gc0.count_d1_reg[4] ,
    ram_empty_fb_i_reg,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] );
  output [127:0]Q;
  input clk;
  input [0:0]E;
  input [127:0]din;
  input [4:0]\gc0.count_d1_reg[4] ;
  input [4:0]\gcc0.gc0.count_d1_reg[4] ;
  input [0:0]ram_empty_fb_i_reg;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;

  wire [0:0]E;
  wire [127:0]Q;
  wire RAM_reg_0_31_0_5_n_0;
  wire RAM_reg_0_31_0_5_n_1;
  wire RAM_reg_0_31_0_5_n_10;
  wire RAM_reg_0_31_0_5_n_11;
  wire RAM_reg_0_31_0_5_n_12;
  wire RAM_reg_0_31_0_5_n_13;
  wire RAM_reg_0_31_0_5_n_2;
  wire RAM_reg_0_31_0_5_n_3;
  wire RAM_reg_0_31_0_5_n_4;
  wire RAM_reg_0_31_0_5_n_5;
  wire RAM_reg_0_31_0_5_n_6;
  wire RAM_reg_0_31_0_5_n_7;
  wire RAM_reg_0_31_0_5_n_8;
  wire RAM_reg_0_31_0_5_n_9;
  wire RAM_reg_0_31_12_17_n_0;
  wire RAM_reg_0_31_12_17_n_1;
  wire RAM_reg_0_31_12_17_n_10;
  wire RAM_reg_0_31_12_17_n_11;
  wire RAM_reg_0_31_12_17_n_12;
  wire RAM_reg_0_31_12_17_n_13;
  wire RAM_reg_0_31_12_17_n_2;
  wire RAM_reg_0_31_12_17_n_3;
  wire RAM_reg_0_31_12_17_n_4;
  wire RAM_reg_0_31_12_17_n_5;
  wire RAM_reg_0_31_12_17_n_6;
  wire RAM_reg_0_31_12_17_n_7;
  wire RAM_reg_0_31_12_17_n_8;
  wire RAM_reg_0_31_12_17_n_9;
  wire RAM_reg_0_31_18_23_n_0;
  wire RAM_reg_0_31_18_23_n_1;
  wire RAM_reg_0_31_18_23_n_10;
  wire RAM_reg_0_31_18_23_n_11;
  wire RAM_reg_0_31_18_23_n_12;
  wire RAM_reg_0_31_18_23_n_13;
  wire RAM_reg_0_31_18_23_n_2;
  wire RAM_reg_0_31_18_23_n_3;
  wire RAM_reg_0_31_18_23_n_4;
  wire RAM_reg_0_31_18_23_n_5;
  wire RAM_reg_0_31_18_23_n_6;
  wire RAM_reg_0_31_18_23_n_7;
  wire RAM_reg_0_31_18_23_n_8;
  wire RAM_reg_0_31_18_23_n_9;
  wire RAM_reg_0_31_24_29_n_0;
  wire RAM_reg_0_31_24_29_n_1;
  wire RAM_reg_0_31_24_29_n_10;
  wire RAM_reg_0_31_24_29_n_11;
  wire RAM_reg_0_31_24_29_n_12;
  wire RAM_reg_0_31_24_29_n_13;
  wire RAM_reg_0_31_24_29_n_2;
  wire RAM_reg_0_31_24_29_n_3;
  wire RAM_reg_0_31_24_29_n_4;
  wire RAM_reg_0_31_24_29_n_5;
  wire RAM_reg_0_31_24_29_n_6;
  wire RAM_reg_0_31_24_29_n_7;
  wire RAM_reg_0_31_24_29_n_8;
  wire RAM_reg_0_31_24_29_n_9;
  wire RAM_reg_0_31_30_35_n_0;
  wire RAM_reg_0_31_30_35_n_1;
  wire RAM_reg_0_31_30_35_n_10;
  wire RAM_reg_0_31_30_35_n_11;
  wire RAM_reg_0_31_30_35_n_12;
  wire RAM_reg_0_31_30_35_n_13;
  wire RAM_reg_0_31_30_35_n_2;
  wire RAM_reg_0_31_30_35_n_3;
  wire RAM_reg_0_31_30_35_n_4;
  wire RAM_reg_0_31_30_35_n_5;
  wire RAM_reg_0_31_30_35_n_6;
  wire RAM_reg_0_31_30_35_n_7;
  wire RAM_reg_0_31_30_35_n_8;
  wire RAM_reg_0_31_30_35_n_9;
  wire RAM_reg_0_31_36_41_n_0;
  wire RAM_reg_0_31_36_41_n_1;
  wire RAM_reg_0_31_36_41_n_10;
  wire RAM_reg_0_31_36_41_n_11;
  wire RAM_reg_0_31_36_41_n_12;
  wire RAM_reg_0_31_36_41_n_13;
  wire RAM_reg_0_31_36_41_n_2;
  wire RAM_reg_0_31_36_41_n_3;
  wire RAM_reg_0_31_36_41_n_4;
  wire RAM_reg_0_31_36_41_n_5;
  wire RAM_reg_0_31_36_41_n_6;
  wire RAM_reg_0_31_36_41_n_7;
  wire RAM_reg_0_31_36_41_n_8;
  wire RAM_reg_0_31_36_41_n_9;
  wire RAM_reg_0_31_42_47_n_0;
  wire RAM_reg_0_31_42_47_n_1;
  wire RAM_reg_0_31_42_47_n_10;
  wire RAM_reg_0_31_42_47_n_11;
  wire RAM_reg_0_31_42_47_n_12;
  wire RAM_reg_0_31_42_47_n_13;
  wire RAM_reg_0_31_42_47_n_2;
  wire RAM_reg_0_31_42_47_n_3;
  wire RAM_reg_0_31_42_47_n_4;
  wire RAM_reg_0_31_42_47_n_5;
  wire RAM_reg_0_31_42_47_n_6;
  wire RAM_reg_0_31_42_47_n_7;
  wire RAM_reg_0_31_42_47_n_8;
  wire RAM_reg_0_31_42_47_n_9;
  wire RAM_reg_0_31_48_53_n_0;
  wire RAM_reg_0_31_48_53_n_1;
  wire RAM_reg_0_31_48_53_n_10;
  wire RAM_reg_0_31_48_53_n_11;
  wire RAM_reg_0_31_48_53_n_12;
  wire RAM_reg_0_31_48_53_n_13;
  wire RAM_reg_0_31_48_53_n_2;
  wire RAM_reg_0_31_48_53_n_3;
  wire RAM_reg_0_31_48_53_n_4;
  wire RAM_reg_0_31_48_53_n_5;
  wire RAM_reg_0_31_48_53_n_6;
  wire RAM_reg_0_31_48_53_n_7;
  wire RAM_reg_0_31_48_53_n_8;
  wire RAM_reg_0_31_48_53_n_9;
  wire RAM_reg_0_31_54_59_n_0;
  wire RAM_reg_0_31_54_59_n_1;
  wire RAM_reg_0_31_6_11_n_0;
  wire RAM_reg_0_31_6_11_n_1;
  wire RAM_reg_0_31_6_11_n_10;
  wire RAM_reg_0_31_6_11_n_11;
  wire RAM_reg_0_31_6_11_n_12;
  wire RAM_reg_0_31_6_11_n_13;
  wire RAM_reg_0_31_6_11_n_2;
  wire RAM_reg_0_31_6_11_n_3;
  wire RAM_reg_0_31_6_11_n_4;
  wire RAM_reg_0_31_6_11_n_5;
  wire RAM_reg_0_31_6_11_n_6;
  wire RAM_reg_0_31_6_11_n_7;
  wire RAM_reg_0_31_6_11_n_8;
  wire RAM_reg_0_31_6_11_n_9;
  wire clk;
  wire [127:0]din;
  wire [4:0]\gc0.count_d1_reg[4] ;
  wire [4:0]\gcc0.gc0.count_d1_reg[4] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ;
  wire [0:0]ram_empty_fb_i_reg;
  wire [1:0]NLW_RAM_reg_0_31_0_5_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_12_17_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_18_23_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_24_29_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_30_35_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_36_41_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_42_47_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_48_53_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOE_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOF_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOG_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_54_59_DOH_UNCONNECTED;
  wire [1:0]NLW_RAM_reg_0_31_6_11_DOH_UNCONNECTED;

  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_0_5
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[1:0]),
        .DIB(din[3:2]),
        .DIC(din[5:4]),
        .DID(din[7:6]),
        .DIE(din[9:8]),
        .DIF(din[11:10]),
        .DIG(din[13:12]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_0_5_n_0,RAM_reg_0_31_0_5_n_1}),
        .DOB({RAM_reg_0_31_0_5_n_2,RAM_reg_0_31_0_5_n_3}),
        .DOC({RAM_reg_0_31_0_5_n_4,RAM_reg_0_31_0_5_n_5}),
        .DOD({RAM_reg_0_31_0_5_n_6,RAM_reg_0_31_0_5_n_7}),
        .DOE({RAM_reg_0_31_0_5_n_8,RAM_reg_0_31_0_5_n_9}),
        .DOF({RAM_reg_0_31_0_5_n_10,RAM_reg_0_31_0_5_n_11}),
        .DOG({RAM_reg_0_31_0_5_n_12,RAM_reg_0_31_0_5_n_13}),
        .DOH(NLW_RAM_reg_0_31_0_5_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_12_17
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[29:28]),
        .DIB(din[31:30]),
        .DIC(din[33:32]),
        .DID(din[35:34]),
        .DIE(din[37:36]),
        .DIF(din[39:38]),
        .DIG(din[41:40]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_12_17_n_0,RAM_reg_0_31_12_17_n_1}),
        .DOB({RAM_reg_0_31_12_17_n_2,RAM_reg_0_31_12_17_n_3}),
        .DOC({RAM_reg_0_31_12_17_n_4,RAM_reg_0_31_12_17_n_5}),
        .DOD({RAM_reg_0_31_12_17_n_6,RAM_reg_0_31_12_17_n_7}),
        .DOE({RAM_reg_0_31_12_17_n_8,RAM_reg_0_31_12_17_n_9}),
        .DOF({RAM_reg_0_31_12_17_n_10,RAM_reg_0_31_12_17_n_11}),
        .DOG({RAM_reg_0_31_12_17_n_12,RAM_reg_0_31_12_17_n_13}),
        .DOH(NLW_RAM_reg_0_31_12_17_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_18_23
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[43:42]),
        .DIB(din[45:44]),
        .DIC(din[47:46]),
        .DID(din[49:48]),
        .DIE(din[51:50]),
        .DIF(din[53:52]),
        .DIG(din[55:54]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_18_23_n_0,RAM_reg_0_31_18_23_n_1}),
        .DOB({RAM_reg_0_31_18_23_n_2,RAM_reg_0_31_18_23_n_3}),
        .DOC({RAM_reg_0_31_18_23_n_4,RAM_reg_0_31_18_23_n_5}),
        .DOD({RAM_reg_0_31_18_23_n_6,RAM_reg_0_31_18_23_n_7}),
        .DOE({RAM_reg_0_31_18_23_n_8,RAM_reg_0_31_18_23_n_9}),
        .DOF({RAM_reg_0_31_18_23_n_10,RAM_reg_0_31_18_23_n_11}),
        .DOG({RAM_reg_0_31_18_23_n_12,RAM_reg_0_31_18_23_n_13}),
        .DOH(NLW_RAM_reg_0_31_18_23_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_24_29
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[57:56]),
        .DIB(din[59:58]),
        .DIC(din[61:60]),
        .DID(din[63:62]),
        .DIE(din[65:64]),
        .DIF(din[67:66]),
        .DIG(din[69:68]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_24_29_n_0,RAM_reg_0_31_24_29_n_1}),
        .DOB({RAM_reg_0_31_24_29_n_2,RAM_reg_0_31_24_29_n_3}),
        .DOC({RAM_reg_0_31_24_29_n_4,RAM_reg_0_31_24_29_n_5}),
        .DOD({RAM_reg_0_31_24_29_n_6,RAM_reg_0_31_24_29_n_7}),
        .DOE({RAM_reg_0_31_24_29_n_8,RAM_reg_0_31_24_29_n_9}),
        .DOF({RAM_reg_0_31_24_29_n_10,RAM_reg_0_31_24_29_n_11}),
        .DOG({RAM_reg_0_31_24_29_n_12,RAM_reg_0_31_24_29_n_13}),
        .DOH(NLW_RAM_reg_0_31_24_29_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_30_35
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[71:70]),
        .DIB(din[73:72]),
        .DIC(din[75:74]),
        .DID(din[77:76]),
        .DIE(din[79:78]),
        .DIF(din[81:80]),
        .DIG(din[83:82]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_30_35_n_0,RAM_reg_0_31_30_35_n_1}),
        .DOB({RAM_reg_0_31_30_35_n_2,RAM_reg_0_31_30_35_n_3}),
        .DOC({RAM_reg_0_31_30_35_n_4,RAM_reg_0_31_30_35_n_5}),
        .DOD({RAM_reg_0_31_30_35_n_6,RAM_reg_0_31_30_35_n_7}),
        .DOE({RAM_reg_0_31_30_35_n_8,RAM_reg_0_31_30_35_n_9}),
        .DOF({RAM_reg_0_31_30_35_n_10,RAM_reg_0_31_30_35_n_11}),
        .DOG({RAM_reg_0_31_30_35_n_12,RAM_reg_0_31_30_35_n_13}),
        .DOH(NLW_RAM_reg_0_31_30_35_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_36_41
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[85:84]),
        .DIB(din[87:86]),
        .DIC(din[89:88]),
        .DID(din[91:90]),
        .DIE(din[93:92]),
        .DIF(din[95:94]),
        .DIG(din[97:96]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_36_41_n_0,RAM_reg_0_31_36_41_n_1}),
        .DOB({RAM_reg_0_31_36_41_n_2,RAM_reg_0_31_36_41_n_3}),
        .DOC({RAM_reg_0_31_36_41_n_4,RAM_reg_0_31_36_41_n_5}),
        .DOD({RAM_reg_0_31_36_41_n_6,RAM_reg_0_31_36_41_n_7}),
        .DOE({RAM_reg_0_31_36_41_n_8,RAM_reg_0_31_36_41_n_9}),
        .DOF({RAM_reg_0_31_36_41_n_10,RAM_reg_0_31_36_41_n_11}),
        .DOG({RAM_reg_0_31_36_41_n_12,RAM_reg_0_31_36_41_n_13}),
        .DOH(NLW_RAM_reg_0_31_36_41_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_42_47
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[99:98]),
        .DIB(din[101:100]),
        .DIC(din[103:102]),
        .DID(din[105:104]),
        .DIE(din[107:106]),
        .DIF(din[109:108]),
        .DIG(din[111:110]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_42_47_n_0,RAM_reg_0_31_42_47_n_1}),
        .DOB({RAM_reg_0_31_42_47_n_2,RAM_reg_0_31_42_47_n_3}),
        .DOC({RAM_reg_0_31_42_47_n_4,RAM_reg_0_31_42_47_n_5}),
        .DOD({RAM_reg_0_31_42_47_n_6,RAM_reg_0_31_42_47_n_7}),
        .DOE({RAM_reg_0_31_42_47_n_8,RAM_reg_0_31_42_47_n_9}),
        .DOF({RAM_reg_0_31_42_47_n_10,RAM_reg_0_31_42_47_n_11}),
        .DOG({RAM_reg_0_31_42_47_n_12,RAM_reg_0_31_42_47_n_13}),
        .DOH(NLW_RAM_reg_0_31_42_47_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_48_53
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[113:112]),
        .DIB(din[115:114]),
        .DIC(din[117:116]),
        .DID(din[119:118]),
        .DIE(din[121:120]),
        .DIF(din[123:122]),
        .DIG(din[125:124]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_48_53_n_0,RAM_reg_0_31_48_53_n_1}),
        .DOB({RAM_reg_0_31_48_53_n_2,RAM_reg_0_31_48_53_n_3}),
        .DOC({RAM_reg_0_31_48_53_n_4,RAM_reg_0_31_48_53_n_5}),
        .DOD({RAM_reg_0_31_48_53_n_6,RAM_reg_0_31_48_53_n_7}),
        .DOE({RAM_reg_0_31_48_53_n_8,RAM_reg_0_31_48_53_n_9}),
        .DOF({RAM_reg_0_31_48_53_n_10,RAM_reg_0_31_48_53_n_11}),
        .DOG({RAM_reg_0_31_48_53_n_12,RAM_reg_0_31_48_53_n_13}),
        .DOH(NLW_RAM_reg_0_31_48_53_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_54_59
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[127:126]),
        .DIB({1'b0,1'b0}),
        .DIC({1'b0,1'b0}),
        .DID({1'b0,1'b0}),
        .DIE({1'b0,1'b0}),
        .DIF({1'b0,1'b0}),
        .DIG({1'b0,1'b0}),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_54_59_n_0,RAM_reg_0_31_54_59_n_1}),
        .DOB(NLW_RAM_reg_0_31_54_59_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM_reg_0_31_54_59_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM_reg_0_31_54_59_DOD_UNCONNECTED[1:0]),
        .DOE(NLW_RAM_reg_0_31_54_59_DOE_UNCONNECTED[1:0]),
        .DOF(NLW_RAM_reg_0_31_54_59_DOF_UNCONNECTED[1:0]),
        .DOG(NLW_RAM_reg_0_31_54_59_DOG_UNCONNECTED[1:0]),
        .DOH(NLW_RAM_reg_0_31_54_59_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 RAM_reg_0_31_6_11
       (.ADDRA(\gc0.count_d1_reg[4] ),
        .ADDRB(\gc0.count_d1_reg[4] ),
        .ADDRC(\gc0.count_d1_reg[4] ),
        .ADDRD(\gc0.count_d1_reg[4] ),
        .ADDRE(\gc0.count_d1_reg[4] ),
        .ADDRF(\gc0.count_d1_reg[4] ),
        .ADDRG(\gc0.count_d1_reg[4] ),
        .ADDRH(\gcc0.gc0.count_d1_reg[4] ),
        .DIA(din[15:14]),
        .DIB(din[17:16]),
        .DIC(din[19:18]),
        .DID(din[21:20]),
        .DIE(din[23:22]),
        .DIF(din[25:24]),
        .DIG(din[27:26]),
        .DIH({1'b0,1'b0}),
        .DOA({RAM_reg_0_31_6_11_n_0,RAM_reg_0_31_6_11_n_1}),
        .DOB({RAM_reg_0_31_6_11_n_2,RAM_reg_0_31_6_11_n_3}),
        .DOC({RAM_reg_0_31_6_11_n_4,RAM_reg_0_31_6_11_n_5}),
        .DOD({RAM_reg_0_31_6_11_n_6,RAM_reg_0_31_6_11_n_7}),
        .DOE({RAM_reg_0_31_6_11_n_8,RAM_reg_0_31_6_11_n_9}),
        .DOF({RAM_reg_0_31_6_11_n_10,RAM_reg_0_31_6_11_n_11}),
        .DOG({RAM_reg_0_31_6_11_n_12,RAM_reg_0_31_6_11_n_13}),
        .DOH(NLW_RAM_reg_0_31_6_11_DOH_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(E));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[0] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_1),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[100] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_3),
        .Q(Q[100]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[101] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_2),
        .Q(Q[101]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[102] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_5),
        .Q(Q[102]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[103] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_4),
        .Q(Q[103]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[104] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_7),
        .Q(Q[104]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[105] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_6),
        .Q(Q[105]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[106] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_9),
        .Q(Q[106]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[107] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_8),
        .Q(Q[107]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[108] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_11),
        .Q(Q[108]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[109] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_10),
        .Q(Q[109]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[10] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_11),
        .Q(Q[10]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[110] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_13),
        .Q(Q[110]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[111] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_12),
        .Q(Q[111]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[112] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_1),
        .Q(Q[112]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[113] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_0),
        .Q(Q[113]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[114] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_3),
        .Q(Q[114]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[115] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_2),
        .Q(Q[115]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[116] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_5),
        .Q(Q[116]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[117] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_4),
        .Q(Q[117]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[118] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_7),
        .Q(Q[118]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[119] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_6),
        .Q(Q[119]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[11] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_10),
        .Q(Q[11]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[120] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_9),
        .Q(Q[120]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[121] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_8),
        .Q(Q[121]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[122] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_11),
        .Q(Q[122]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[123] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_10),
        .Q(Q[123]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[124] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_13),
        .Q(Q[124]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[125] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_48_53_n_12),
        .Q(Q[125]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[126] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_54_59_n_1),
        .Q(Q[126]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[127] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_54_59_n_0),
        .Q(Q[127]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[12] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_13),
        .Q(Q[12]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[13] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_12),
        .Q(Q[13]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[14] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_1),
        .Q(Q[14]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[15] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_0),
        .Q(Q[15]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[16] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_3),
        .Q(Q[16]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[17] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_2),
        .Q(Q[17]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[18] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_5),
        .Q(Q[18]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[19] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_4),
        .Q(Q[19]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[1] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_0),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[20] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_7),
        .Q(Q[20]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[21] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_6),
        .Q(Q[21]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[22] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_9),
        .Q(Q[22]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[23] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_8),
        .Q(Q[23]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[24] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_11),
        .Q(Q[24]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[25] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_10),
        .Q(Q[25]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[26] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_13),
        .Q(Q[26]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[27] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_6_11_n_12),
        .Q(Q[27]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[28] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_1),
        .Q(Q[28]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[29] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_0),
        .Q(Q[29]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[2] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_3),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[30] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_3),
        .Q(Q[30]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[31] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_2),
        .Q(Q[31]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[32] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_5),
        .Q(Q[32]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[33] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_4),
        .Q(Q[33]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[34] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_7),
        .Q(Q[34]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[35] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_6),
        .Q(Q[35]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[36] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_9),
        .Q(Q[36]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[37] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_8),
        .Q(Q[37]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[38] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_11),
        .Q(Q[38]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[39] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_10),
        .Q(Q[39]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[3] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_2),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[40] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_13),
        .Q(Q[40]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[41] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_12_17_n_12),
        .Q(Q[41]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[42] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_1),
        .Q(Q[42]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[43] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_0),
        .Q(Q[43]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[44] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_3),
        .Q(Q[44]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[45] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_2),
        .Q(Q[45]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[46] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_5),
        .Q(Q[46]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[47] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_4),
        .Q(Q[47]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[48] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_7),
        .Q(Q[48]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[49] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_6),
        .Q(Q[49]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[4] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_5),
        .Q(Q[4]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[50] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_9),
        .Q(Q[50]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[51] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_8),
        .Q(Q[51]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[52] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_11),
        .Q(Q[52]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[53] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_10),
        .Q(Q[53]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[54] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_13),
        .Q(Q[54]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[55] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_18_23_n_12),
        .Q(Q[55]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[56] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_1),
        .Q(Q[56]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[57] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_0),
        .Q(Q[57]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[58] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_3),
        .Q(Q[58]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[59] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_2),
        .Q(Q[59]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[5] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_4),
        .Q(Q[5]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[60] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_5),
        .Q(Q[60]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[61] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_4),
        .Q(Q[61]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[62] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_7),
        .Q(Q[62]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[63] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_6),
        .Q(Q[63]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[64] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_9),
        .Q(Q[64]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[65] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_8),
        .Q(Q[65]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[66] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_11),
        .Q(Q[66]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[67] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_10),
        .Q(Q[67]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[68] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_13),
        .Q(Q[68]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[69] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_24_29_n_12),
        .Q(Q[69]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[6] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_7),
        .Q(Q[6]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[70] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_1),
        .Q(Q[70]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[71] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_0),
        .Q(Q[71]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[72] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_3),
        .Q(Q[72]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[73] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_2),
        .Q(Q[73]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[74] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_5),
        .Q(Q[74]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[75] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_4),
        .Q(Q[75]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[76] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_7),
        .Q(Q[76]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[77] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_6),
        .Q(Q[77]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[78] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_9),
        .Q(Q[78]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[79] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_8),
        .Q(Q[79]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[7] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_6),
        .Q(Q[7]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[80] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_11),
        .Q(Q[80]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[81] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_10),
        .Q(Q[81]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[82] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_13),
        .Q(Q[82]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[83] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_30_35_n_12),
        .Q(Q[83]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[84] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_1),
        .Q(Q[84]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[85] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_0),
        .Q(Q[85]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[86] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_3),
        .Q(Q[86]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[87] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_2),
        .Q(Q[87]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[88] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_5),
        .Q(Q[88]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[89] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_4),
        .Q(Q[89]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[8] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_9),
        .Q(Q[8]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[90] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_7),
        .Q(Q[90]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[91] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_6),
        .Q(Q[91]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[92] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_9),
        .Q(Q[92]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[93] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_8),
        .Q(Q[93]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[94] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_11),
        .Q(Q[94]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[95] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_10),
        .Q(Q[95]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[96] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_13),
        .Q(Q[96]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[97] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_36_41_n_12),
        .Q(Q[97]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[98] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_1),
        .Q(Q[98]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[99] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_42_47_n_0),
        .Q(Q[99]));
  FDCE #(
    .INIT(1'b0)) 
    \gpr1.dout_i_reg[9] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] ),
        .D(RAM_reg_0_31_0_5_n_8),
        .Q(Q[9]));
endmodule

(* ORIG_REF_NAME = "fifo_generator_ramfifo" *) 
module coregen_fifo_32x128_fifo_generator_ramfifo
   (empty,
    full,
    dout,
    clk,
    rst,
    rd_en,
    din,
    wr_en);
  output empty;
  output full;
  output [127:0]dout;
  input clk;
  input rst;
  input rd_en;
  input [127:0]din;
  input wr_en;

  wire RD_RST;
  wire RST;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire \gntv_or_sync_fifo.gl0.rd_n_1 ;
  wire \gntv_or_sync_fifo.gl0.rd_n_8 ;
  wire \gntv_or_sync_fifo.gl0.wr_n_7 ;
  wire \gwss.wsts/ram_full_comb ;
  wire [4:0]p_0_out;
  wire [4:0]p_10_out;
  wire [4:0]p_11_out;
  wire p_16_out;
  wire p_1_out;
  wire p_5_out;
  wire rd_en;
  wire [4:0]rd_pntr_plus1;
  wire rst;
  wire rst_full_ff_i;
  wire rst_full_gen_i;
  wire rstblk_n_4;
  wire wr_en;

  coregen_fifo_32x128_rd_logic \gntv_or_sync_fifo.gl0.rd 
       (.E(\gntv_or_sync_fifo.gl0.rd_n_1 ),
        .Q(RD_RST),
        .clk(clk),
        .empty(empty),
        .\gc0.count_d1_reg[4] (rd_pntr_plus1),
        .\gcc0.gc0.count_d1_reg[4] (\gntv_or_sync_fifo.gl0.wr_n_7 ),
        .\gcc0.gc0.count_d1_reg[4]_0 (p_10_out),
        .\gcc0.gc0.count_reg[4] (p_11_out),
        .\goreg_dm.dout_i_reg[127] (p_5_out),
        .\gpr1.dout_i_reg[1] (p_0_out),
        .p_1_out(p_1_out),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gl0.rd_n_8 ),
        .ram_full_comb(\gwss.wsts/ram_full_comb ),
        .rd_en(rd_en),
        .rst_full_gen_i(rst_full_gen_i),
        .wr_en(wr_en));
  coregen_fifo_32x128_wr_logic \gntv_or_sync_fifo.gl0.wr 
       (.AR(RST),
        .E(p_16_out),
        .Q(p_11_out),
        .clk(clk),
        .full(full),
        .\gc0.count_reg[4] (rd_pntr_plus1),
        .\gpr1.dout_i_reg[1] (p_10_out),
        .\gpregsm1.curr_fwft_state_reg[1] (\gntv_or_sync_fifo.gl0.rd_n_8 ),
        .p_1_out(p_1_out),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gl0.wr_n_7 ),
        .ram_full_comb(\gwss.wsts/ram_full_comb ),
        .rst_full_ff_i(rst_full_ff_i),
        .wr_en(wr_en));
  coregen_fifo_32x128_memory \gntv_or_sync_fifo.mem 
       (.E(p_16_out),
        .Q(rstblk_n_4),
        .clk(clk),
        .din(din),
        .dout(dout),
        .\gc0.count_d1_reg[4] (p_0_out),
        .\gcc0.gc0.count_d1_reg[4] (p_10_out),
        .\gpregsm1.curr_fwft_state_reg[1] (p_5_out),
        .ram_empty_fb_i_reg(\gntv_or_sync_fifo.gl0.rd_n_1 ));
  coregen_fifo_32x128_reset_blk_ramfifo__parameterized0 rstblk
       (.AR(RST),
        .Q({RD_RST,rstblk_n_4}),
        .clk(clk),
        .rst(rst),
        .rst_full_ff_i(rst_full_ff_i),
        .rst_full_gen_i(rst_full_gen_i));
endmodule

(* ORIG_REF_NAME = "fifo_generator_top" *) 
module coregen_fifo_32x128_fifo_generator_top
   (empty,
    full,
    dout,
    clk,
    rst,
    rd_en,
    din,
    wr_en);
  output empty;
  output full;
  output [127:0]dout;
  input clk;
  input rst;
  input rd_en;
  input [127:0]din;
  input wr_en;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rst;
  wire wr_en;

  coregen_fifo_32x128_fifo_generator_ramfifo \grf.rf 
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en));
endmodule

(* C_ADD_NGC_CONSTRAINT = "0" *) (* C_APPLICATION_TYPE_AXIS = "0" *) (* C_APPLICATION_TYPE_RACH = "0" *) 
(* C_APPLICATION_TYPE_RDCH = "0" *) (* C_APPLICATION_TYPE_WACH = "0" *) (* C_APPLICATION_TYPE_WDCH = "0" *) 
(* C_APPLICATION_TYPE_WRCH = "0" *) (* C_AXIS_TDATA_WIDTH = "8" *) (* C_AXIS_TDEST_WIDTH = "1" *) 
(* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TKEEP_WIDTH = "1" *) (* C_AXIS_TSTRB_WIDTH = "1" *) 
(* C_AXIS_TUSER_WIDTH = "4" *) (* C_AXIS_TYPE = "0" *) (* C_AXI_ADDR_WIDTH = "32" *) 
(* C_AXI_ARUSER_WIDTH = "1" *) (* C_AXI_AWUSER_WIDTH = "1" *) (* C_AXI_BUSER_WIDTH = "1" *) 
(* C_AXI_DATA_WIDTH = "64" *) (* C_AXI_ID_WIDTH = "1" *) (* C_AXI_LEN_WIDTH = "8" *) 
(* C_AXI_LOCK_WIDTH = "1" *) (* C_AXI_RUSER_WIDTH = "1" *) (* C_AXI_TYPE = "1" *) 
(* C_AXI_WUSER_WIDTH = "1" *) (* C_COMMON_CLOCK = "1" *) (* C_COUNT_TYPE = "0" *) 
(* C_DATA_COUNT_WIDTH = "6" *) (* C_DEFAULT_VALUE = "BlankString" *) (* C_DIN_WIDTH = "128" *) 
(* C_DIN_WIDTH_AXIS = "1" *) (* C_DIN_WIDTH_RACH = "32" *) (* C_DIN_WIDTH_RDCH = "64" *) 
(* C_DIN_WIDTH_WACH = "32" *) (* C_DIN_WIDTH_WDCH = "64" *) (* C_DIN_WIDTH_WRCH = "2" *) 
(* C_DOUT_RST_VAL = "0" *) (* C_DOUT_WIDTH = "128" *) (* C_ENABLE_RLOCS = "0" *) 
(* C_ENABLE_RST_SYNC = "1" *) (* C_EN_SAFETY_CKT = "0" *) (* C_ERROR_INJECTION_TYPE = "0" *) 
(* C_ERROR_INJECTION_TYPE_AXIS = "0" *) (* C_ERROR_INJECTION_TYPE_RACH = "0" *) (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
(* C_ERROR_INJECTION_TYPE_WACH = "0" *) (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
(* C_FAMILY = "kintexu" *) (* C_FULL_FLAGS_RST_VAL = "1" *) (* C_HAS_ALMOST_EMPTY = "0" *) 
(* C_HAS_ALMOST_FULL = "0" *) (* C_HAS_AXIS_TDATA = "1" *) (* C_HAS_AXIS_TDEST = "0" *) 
(* C_HAS_AXIS_TID = "0" *) (* C_HAS_AXIS_TKEEP = "0" *) (* C_HAS_AXIS_TLAST = "0" *) 
(* C_HAS_AXIS_TREADY = "1" *) (* C_HAS_AXIS_TSTRB = "0" *) (* C_HAS_AXIS_TUSER = "1" *) 
(* C_HAS_AXI_ARUSER = "0" *) (* C_HAS_AXI_AWUSER = "0" *) (* C_HAS_AXI_BUSER = "0" *) 
(* C_HAS_AXI_ID = "0" *) (* C_HAS_AXI_RD_CHANNEL = "1" *) (* C_HAS_AXI_RUSER = "0" *) 
(* C_HAS_AXI_WR_CHANNEL = "1" *) (* C_HAS_AXI_WUSER = "0" *) (* C_HAS_BACKUP = "0" *) 
(* C_HAS_DATA_COUNT = "0" *) (* C_HAS_DATA_COUNTS_AXIS = "0" *) (* C_HAS_DATA_COUNTS_RACH = "0" *) 
(* C_HAS_DATA_COUNTS_RDCH = "0" *) (* C_HAS_DATA_COUNTS_WACH = "0" *) (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
(* C_HAS_DATA_COUNTS_WRCH = "0" *) (* C_HAS_INT_CLK = "0" *) (* C_HAS_MASTER_CE = "0" *) 
(* C_HAS_MEMINIT_FILE = "0" *) (* C_HAS_OVERFLOW = "0" *) (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
(* C_HAS_PROG_FLAGS_RACH = "0" *) (* C_HAS_PROG_FLAGS_RDCH = "0" *) (* C_HAS_PROG_FLAGS_WACH = "0" *) 
(* C_HAS_PROG_FLAGS_WDCH = "0" *) (* C_HAS_PROG_FLAGS_WRCH = "0" *) (* C_HAS_RD_DATA_COUNT = "0" *) 
(* C_HAS_RD_RST = "0" *) (* C_HAS_RST = "1" *) (* C_HAS_SLAVE_CE = "0" *) 
(* C_HAS_SRST = "0" *) (* C_HAS_UNDERFLOW = "0" *) (* C_HAS_VALID = "0" *) 
(* C_HAS_WR_ACK = "0" *) (* C_HAS_WR_DATA_COUNT = "0" *) (* C_HAS_WR_RST = "0" *) 
(* C_IMPLEMENTATION_TYPE = "0" *) (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
(* C_IMPLEMENTATION_TYPE_RDCH = "1" *) (* C_IMPLEMENTATION_TYPE_WACH = "1" *) (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
(* C_IMPLEMENTATION_TYPE_WRCH = "1" *) (* C_INIT_WR_PNTR_VAL = "0" *) (* C_INTERFACE_TYPE = "0" *) 
(* C_MEMORY_TYPE = "2" *) (* C_MIF_FILE_NAME = "BlankString" *) (* C_MSGON_VAL = "1" *) 
(* C_OPTIMIZATION_MODE = "0" *) (* C_OVERFLOW_LOW = "0" *) (* C_POWER_SAVING_MODE = "0" *) 
(* C_PRELOAD_LATENCY = "0" *) (* C_PRELOAD_REGS = "1" *) (* C_PRIM_FIFO_TYPE = "512x72" *) 
(* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
(* C_PRIM_FIFO_TYPE_WACH = "512x36" *) (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL = "4" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
(* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "5" *) (* C_PROG_EMPTY_TYPE = "0" *) 
(* C_PROG_EMPTY_TYPE_AXIS = "0" *) (* C_PROG_EMPTY_TYPE_RACH = "0" *) (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
(* C_PROG_EMPTY_TYPE_WACH = "0" *) (* C_PROG_EMPTY_TYPE_WDCH = "0" *) (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL = "31" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
(* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) (* C_PROG_FULL_THRESH_NEGATE_VAL = "30" *) (* C_PROG_FULL_TYPE = "0" *) 
(* C_PROG_FULL_TYPE_AXIS = "0" *) (* C_PROG_FULL_TYPE_RACH = "0" *) (* C_PROG_FULL_TYPE_RDCH = "0" *) 
(* C_PROG_FULL_TYPE_WACH = "0" *) (* C_PROG_FULL_TYPE_WDCH = "0" *) (* C_PROG_FULL_TYPE_WRCH = "0" *) 
(* C_RACH_TYPE = "0" *) (* C_RDCH_TYPE = "0" *) (* C_RD_DATA_COUNT_WIDTH = "6" *) 
(* C_RD_DEPTH = "32" *) (* C_RD_FREQ = "1" *) (* C_RD_PNTR_WIDTH = "5" *) 
(* C_REG_SLICE_MODE_AXIS = "0" *) (* C_REG_SLICE_MODE_RACH = "0" *) (* C_REG_SLICE_MODE_RDCH = "0" *) 
(* C_REG_SLICE_MODE_WACH = "0" *) (* C_REG_SLICE_MODE_WDCH = "0" *) (* C_REG_SLICE_MODE_WRCH = "0" *) 
(* C_SYNCHRONIZER_STAGE = "2" *) (* C_UNDERFLOW_LOW = "0" *) (* C_USE_COMMON_OVERFLOW = "0" *) 
(* C_USE_COMMON_UNDERFLOW = "0" *) (* C_USE_DEFAULT_SETTINGS = "0" *) (* C_USE_DOUT_RST = "1" *) 
(* C_USE_ECC = "0" *) (* C_USE_ECC_AXIS = "0" *) (* C_USE_ECC_RACH = "0" *) 
(* C_USE_ECC_RDCH = "0" *) (* C_USE_ECC_WACH = "0" *) (* C_USE_ECC_WDCH = "0" *) 
(* C_USE_ECC_WRCH = "0" *) (* C_USE_EMBEDDED_REG = "0" *) (* C_USE_FIFO16_FLAGS = "0" *) 
(* C_USE_FWFT_DATA_COUNT = "1" *) (* C_USE_PIPELINE_REG = "0" *) (* C_VALID_LOW = "0" *) 
(* C_WACH_TYPE = "0" *) (* C_WDCH_TYPE = "0" *) (* C_WRCH_TYPE = "0" *) 
(* C_WR_ACK_LOW = "0" *) (* C_WR_DATA_COUNT_WIDTH = "6" *) (* C_WR_DEPTH = "32" *) 
(* C_WR_DEPTH_AXIS = "1024" *) (* C_WR_DEPTH_RACH = "16" *) (* C_WR_DEPTH_RDCH = "1024" *) 
(* C_WR_DEPTH_WACH = "16" *) (* C_WR_DEPTH_WDCH = "1024" *) (* C_WR_DEPTH_WRCH = "16" *) 
(* C_WR_FREQ = "1" *) (* C_WR_PNTR_WIDTH = "5" *) (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
(* C_WR_PNTR_WIDTH_RACH = "4" *) (* C_WR_PNTR_WIDTH_RDCH = "10" *) (* C_WR_PNTR_WIDTH_WACH = "4" *) 
(* C_WR_PNTR_WIDTH_WDCH = "10" *) (* C_WR_PNTR_WIDTH_WRCH = "4" *) (* C_WR_RESPONSE_LATENCY = "1" *) 
(* ORIG_REF_NAME = "fifo_generator_v13_0_1" *) 
module coregen_fifo_32x128_fifo_generator_v13_0_1
   (backup,
    backup_marker,
    clk,
    rst,
    srst,
    wr_clk,
    wr_rst,
    rd_clk,
    rd_rst,
    din,
    wr_en,
    rd_en,
    prog_empty_thresh,
    prog_empty_thresh_assert,
    prog_empty_thresh_negate,
    prog_full_thresh,
    prog_full_thresh_assert,
    prog_full_thresh_negate,
    int_clk,
    injectdbiterr,
    injectsbiterr,
    sleep,
    dout,
    full,
    almost_full,
    wr_ack,
    overflow,
    empty,
    almost_empty,
    valid,
    underflow,
    data_count,
    rd_data_count,
    wr_data_count,
    prog_full,
    prog_empty,
    sbiterr,
    dbiterr,
    wr_rst_busy,
    rd_rst_busy,
    m_aclk,
    s_aclk,
    s_aresetn,
    m_aclk_en,
    s_aclk_en,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awregion,
    s_axi_awuser,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wuser,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_buser,
    s_axi_bvalid,
    s_axi_bready,
    m_axi_awid,
    m_axi_awaddr,
    m_axi_awlen,
    m_axi_awsize,
    m_axi_awburst,
    m_axi_awlock,
    m_axi_awcache,
    m_axi_awprot,
    m_axi_awqos,
    m_axi_awregion,
    m_axi_awuser,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wid,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wlast,
    m_axi_wuser,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bid,
    m_axi_bresp,
    m_axi_buser,
    m_axi_bvalid,
    m_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arregion,
    s_axi_aruser,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_ruser,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_arid,
    m_axi_araddr,
    m_axi_arlen,
    m_axi_arsize,
    m_axi_arburst,
    m_axi_arlock,
    m_axi_arcache,
    m_axi_arprot,
    m_axi_arqos,
    m_axi_arregion,
    m_axi_aruser,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rid,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rlast,
    m_axi_ruser,
    m_axi_rvalid,
    m_axi_rready,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    axi_aw_injectsbiterr,
    axi_aw_injectdbiterr,
    axi_aw_prog_full_thresh,
    axi_aw_prog_empty_thresh,
    axi_aw_data_count,
    axi_aw_wr_data_count,
    axi_aw_rd_data_count,
    axi_aw_sbiterr,
    axi_aw_dbiterr,
    axi_aw_overflow,
    axi_aw_underflow,
    axi_aw_prog_full,
    axi_aw_prog_empty,
    axi_w_injectsbiterr,
    axi_w_injectdbiterr,
    axi_w_prog_full_thresh,
    axi_w_prog_empty_thresh,
    axi_w_data_count,
    axi_w_wr_data_count,
    axi_w_rd_data_count,
    axi_w_sbiterr,
    axi_w_dbiterr,
    axi_w_overflow,
    axi_w_underflow,
    axi_w_prog_full,
    axi_w_prog_empty,
    axi_b_injectsbiterr,
    axi_b_injectdbiterr,
    axi_b_prog_full_thresh,
    axi_b_prog_empty_thresh,
    axi_b_data_count,
    axi_b_wr_data_count,
    axi_b_rd_data_count,
    axi_b_sbiterr,
    axi_b_dbiterr,
    axi_b_overflow,
    axi_b_underflow,
    axi_b_prog_full,
    axi_b_prog_empty,
    axi_ar_injectsbiterr,
    axi_ar_injectdbiterr,
    axi_ar_prog_full_thresh,
    axi_ar_prog_empty_thresh,
    axi_ar_data_count,
    axi_ar_wr_data_count,
    axi_ar_rd_data_count,
    axi_ar_sbiterr,
    axi_ar_dbiterr,
    axi_ar_overflow,
    axi_ar_underflow,
    axi_ar_prog_full,
    axi_ar_prog_empty,
    axi_r_injectsbiterr,
    axi_r_injectdbiterr,
    axi_r_prog_full_thresh,
    axi_r_prog_empty_thresh,
    axi_r_data_count,
    axi_r_wr_data_count,
    axi_r_rd_data_count,
    axi_r_sbiterr,
    axi_r_dbiterr,
    axi_r_overflow,
    axi_r_underflow,
    axi_r_prog_full,
    axi_r_prog_empty,
    axis_injectsbiterr,
    axis_injectdbiterr,
    axis_prog_full_thresh,
    axis_prog_empty_thresh,
    axis_data_count,
    axis_wr_data_count,
    axis_rd_data_count,
    axis_sbiterr,
    axis_dbiterr,
    axis_overflow,
    axis_underflow,
    axis_prog_full,
    axis_prog_empty);
  input backup;
  input backup_marker;
  input clk;
  input rst;
  input srst;
  input wr_clk;
  input wr_rst;
  input rd_clk;
  input rd_rst;
  input [127:0]din;
  input wr_en;
  input rd_en;
  input [4:0]prog_empty_thresh;
  input [4:0]prog_empty_thresh_assert;
  input [4:0]prog_empty_thresh_negate;
  input [4:0]prog_full_thresh;
  input [4:0]prog_full_thresh_assert;
  input [4:0]prog_full_thresh_negate;
  input int_clk;
  input injectdbiterr;
  input injectsbiterr;
  input sleep;
  output [127:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output valid;
  output underflow;
  output [5:0]data_count;
  output [5:0]rd_data_count;
  output [5:0]wr_data_count;
  output prog_full;
  output prog_empty;
  output sbiterr;
  output dbiterr;
  output wr_rst_busy;
  output rd_rst_busy;
  input m_aclk;
  input s_aclk;
  input s_aresetn;
  input m_aclk_en;
  input s_aclk_en;
  input [0:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input [0:0]s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input [3:0]s_axi_awqos;
  input [3:0]s_axi_awregion;
  input [0:0]s_axi_awuser;
  input s_axi_awvalid;
  output s_axi_awready;
  input [0:0]s_axi_wid;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input [0:0]s_axi_wuser;
  input s_axi_wvalid;
  output s_axi_wready;
  output [0:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output [0:0]s_axi_buser;
  output s_axi_bvalid;
  input s_axi_bready;
  output [0:0]m_axi_awid;
  output [31:0]m_axi_awaddr;
  output [7:0]m_axi_awlen;
  output [2:0]m_axi_awsize;
  output [1:0]m_axi_awburst;
  output [0:0]m_axi_awlock;
  output [3:0]m_axi_awcache;
  output [2:0]m_axi_awprot;
  output [3:0]m_axi_awqos;
  output [3:0]m_axi_awregion;
  output [0:0]m_axi_awuser;
  output m_axi_awvalid;
  input m_axi_awready;
  output [0:0]m_axi_wid;
  output [63:0]m_axi_wdata;
  output [7:0]m_axi_wstrb;
  output m_axi_wlast;
  output [0:0]m_axi_wuser;
  output m_axi_wvalid;
  input m_axi_wready;
  input [0:0]m_axi_bid;
  input [1:0]m_axi_bresp;
  input [0:0]m_axi_buser;
  input m_axi_bvalid;
  output m_axi_bready;
  input [0:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input [0:0]s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input [3:0]s_axi_arqos;
  input [3:0]s_axi_arregion;
  input [0:0]s_axi_aruser;
  input s_axi_arvalid;
  output s_axi_arready;
  output [0:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output [0:0]s_axi_ruser;
  output s_axi_rvalid;
  input s_axi_rready;
  output [0:0]m_axi_arid;
  output [31:0]m_axi_araddr;
  output [7:0]m_axi_arlen;
  output [2:0]m_axi_arsize;
  output [1:0]m_axi_arburst;
  output [0:0]m_axi_arlock;
  output [3:0]m_axi_arcache;
  output [2:0]m_axi_arprot;
  output [3:0]m_axi_arqos;
  output [3:0]m_axi_arregion;
  output [0:0]m_axi_aruser;
  output m_axi_arvalid;
  input m_axi_arready;
  input [0:0]m_axi_rid;
  input [63:0]m_axi_rdata;
  input [1:0]m_axi_rresp;
  input m_axi_rlast;
  input [0:0]m_axi_ruser;
  input m_axi_rvalid;
  output m_axi_rready;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [3:0]m_axis_tuser;
  input axi_aw_injectsbiterr;
  input axi_aw_injectdbiterr;
  input [3:0]axi_aw_prog_full_thresh;
  input [3:0]axi_aw_prog_empty_thresh;
  output [4:0]axi_aw_data_count;
  output [4:0]axi_aw_wr_data_count;
  output [4:0]axi_aw_rd_data_count;
  output axi_aw_sbiterr;
  output axi_aw_dbiterr;
  output axi_aw_overflow;
  output axi_aw_underflow;
  output axi_aw_prog_full;
  output axi_aw_prog_empty;
  input axi_w_injectsbiterr;
  input axi_w_injectdbiterr;
  input [9:0]axi_w_prog_full_thresh;
  input [9:0]axi_w_prog_empty_thresh;
  output [10:0]axi_w_data_count;
  output [10:0]axi_w_wr_data_count;
  output [10:0]axi_w_rd_data_count;
  output axi_w_sbiterr;
  output axi_w_dbiterr;
  output axi_w_overflow;
  output axi_w_underflow;
  output axi_w_prog_full;
  output axi_w_prog_empty;
  input axi_b_injectsbiterr;
  input axi_b_injectdbiterr;
  input [3:0]axi_b_prog_full_thresh;
  input [3:0]axi_b_prog_empty_thresh;
  output [4:0]axi_b_data_count;
  output [4:0]axi_b_wr_data_count;
  output [4:0]axi_b_rd_data_count;
  output axi_b_sbiterr;
  output axi_b_dbiterr;
  output axi_b_overflow;
  output axi_b_underflow;
  output axi_b_prog_full;
  output axi_b_prog_empty;
  input axi_ar_injectsbiterr;
  input axi_ar_injectdbiterr;
  input [3:0]axi_ar_prog_full_thresh;
  input [3:0]axi_ar_prog_empty_thresh;
  output [4:0]axi_ar_data_count;
  output [4:0]axi_ar_wr_data_count;
  output [4:0]axi_ar_rd_data_count;
  output axi_ar_sbiterr;
  output axi_ar_dbiterr;
  output axi_ar_overflow;
  output axi_ar_underflow;
  output axi_ar_prog_full;
  output axi_ar_prog_empty;
  input axi_r_injectsbiterr;
  input axi_r_injectdbiterr;
  input [9:0]axi_r_prog_full_thresh;
  input [9:0]axi_r_prog_empty_thresh;
  output [10:0]axi_r_data_count;
  output [10:0]axi_r_wr_data_count;
  output [10:0]axi_r_rd_data_count;
  output axi_r_sbiterr;
  output axi_r_dbiterr;
  output axi_r_overflow;
  output axi_r_underflow;
  output axi_r_prog_full;
  output axi_r_prog_empty;
  input axis_injectsbiterr;
  input axis_injectdbiterr;
  input [9:0]axis_prog_full_thresh;
  input [9:0]axis_prog_empty_thresh;
  output [10:0]axis_data_count;
  output [10:0]axis_wr_data_count;
  output [10:0]axis_rd_data_count;
  output axis_sbiterr;
  output axis_dbiterr;
  output axis_overflow;
  output axis_underflow;
  output axis_prog_full;
  output axis_prog_empty;

  wire \<const0> ;
  wire \<const1> ;
  wire axi_ar_injectdbiterr;
  wire axi_ar_injectsbiterr;
  wire [3:0]axi_ar_prog_empty_thresh;
  wire [3:0]axi_ar_prog_full_thresh;
  wire axi_aw_injectdbiterr;
  wire axi_aw_injectsbiterr;
  wire [3:0]axi_aw_prog_empty_thresh;
  wire [3:0]axi_aw_prog_full_thresh;
  wire axi_b_injectdbiterr;
  wire axi_b_injectsbiterr;
  wire [3:0]axi_b_prog_empty_thresh;
  wire [3:0]axi_b_prog_full_thresh;
  wire axi_r_injectdbiterr;
  wire axi_r_injectsbiterr;
  wire [9:0]axi_r_prog_empty_thresh;
  wire [9:0]axi_r_prog_full_thresh;
  wire axi_w_injectdbiterr;
  wire axi_w_injectsbiterr;
  wire [9:0]axi_w_prog_empty_thresh;
  wire [9:0]axi_w_prog_full_thresh;
  wire axis_injectdbiterr;
  wire axis_injectsbiterr;
  wire [9:0]axis_prog_empty_thresh;
  wire [9:0]axis_prog_full_thresh;
  wire backup;
  wire backup_marker;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire injectdbiterr;
  wire injectsbiterr;
  wire int_clk;
  wire m_aclk;
  wire m_aclk_en;
  wire m_axi_arready;
  wire m_axi_awready;
  wire [0:0]m_axi_bid;
  wire [1:0]m_axi_bresp;
  wire [0:0]m_axi_buser;
  wire m_axi_bvalid;
  wire [63:0]m_axi_rdata;
  wire [0:0]m_axi_rid;
  wire m_axi_rlast;
  wire [1:0]m_axi_rresp;
  wire [0:0]m_axi_ruser;
  wire m_axi_rvalid;
  wire m_axi_wready;
  wire m_axis_tready;
  wire [4:0]prog_empty_thresh;
  wire [4:0]prog_empty_thresh_assert;
  wire [4:0]prog_empty_thresh_negate;
  wire [4:0]prog_full_thresh;
  wire [4:0]prog_full_thresh_assert;
  wire [4:0]prog_full_thresh_negate;
  wire rd_clk;
  wire rd_en;
  wire rd_rst;
  wire rst;
  wire s_aclk;
  wire s_aclk_en;
  wire s_aresetn;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  wire [0:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire [0:0]s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire [3:0]s_axi_arqos;
  wire [3:0]s_axi_arregion;
  wire [2:0]s_axi_arsize;
  wire [0:0]s_axi_aruser;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [0:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire [0:0]s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire [3:0]s_axi_awqos;
  wire [3:0]s_axi_awregion;
  wire [2:0]s_axi_awsize;
  wire [0:0]s_axi_awuser;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_rready;
  wire [63:0]s_axi_wdata;
  wire [0:0]s_axi_wid;
  wire s_axi_wlast;
  wire [7:0]s_axi_wstrb;
  wire [0:0]s_axi_wuser;
  wire s_axi_wvalid;
  wire [7:0]s_axis_tdata;
  wire [0:0]s_axis_tdest;
  wire [0:0]s_axis_tid;
  wire [0:0]s_axis_tkeep;
  wire s_axis_tlast;
  wire [0:0]s_axis_tstrb;
  wire [3:0]s_axis_tuser;
  wire s_axis_tvalid;
  wire srst;
  wire wr_clk;
  wire wr_en;
  wire wr_rst;

  assign almost_empty = \<const0> ;
  assign almost_full = \<const0> ;
  assign axi_ar_data_count[4] = \<const0> ;
  assign axi_ar_data_count[3] = \<const0> ;
  assign axi_ar_data_count[2] = \<const0> ;
  assign axi_ar_data_count[1] = \<const0> ;
  assign axi_ar_data_count[0] = \<const0> ;
  assign axi_ar_dbiterr = \<const0> ;
  assign axi_ar_overflow = \<const0> ;
  assign axi_ar_prog_empty = \<const1> ;
  assign axi_ar_prog_full = \<const0> ;
  assign axi_ar_rd_data_count[4] = \<const0> ;
  assign axi_ar_rd_data_count[3] = \<const0> ;
  assign axi_ar_rd_data_count[2] = \<const0> ;
  assign axi_ar_rd_data_count[1] = \<const0> ;
  assign axi_ar_rd_data_count[0] = \<const0> ;
  assign axi_ar_sbiterr = \<const0> ;
  assign axi_ar_underflow = \<const0> ;
  assign axi_ar_wr_data_count[4] = \<const0> ;
  assign axi_ar_wr_data_count[3] = \<const0> ;
  assign axi_ar_wr_data_count[2] = \<const0> ;
  assign axi_ar_wr_data_count[1] = \<const0> ;
  assign axi_ar_wr_data_count[0] = \<const0> ;
  assign axi_aw_data_count[4] = \<const0> ;
  assign axi_aw_data_count[3] = \<const0> ;
  assign axi_aw_data_count[2] = \<const0> ;
  assign axi_aw_data_count[1] = \<const0> ;
  assign axi_aw_data_count[0] = \<const0> ;
  assign axi_aw_dbiterr = \<const0> ;
  assign axi_aw_overflow = \<const0> ;
  assign axi_aw_prog_empty = \<const1> ;
  assign axi_aw_prog_full = \<const0> ;
  assign axi_aw_rd_data_count[4] = \<const0> ;
  assign axi_aw_rd_data_count[3] = \<const0> ;
  assign axi_aw_rd_data_count[2] = \<const0> ;
  assign axi_aw_rd_data_count[1] = \<const0> ;
  assign axi_aw_rd_data_count[0] = \<const0> ;
  assign axi_aw_sbiterr = \<const0> ;
  assign axi_aw_underflow = \<const0> ;
  assign axi_aw_wr_data_count[4] = \<const0> ;
  assign axi_aw_wr_data_count[3] = \<const0> ;
  assign axi_aw_wr_data_count[2] = \<const0> ;
  assign axi_aw_wr_data_count[1] = \<const0> ;
  assign axi_aw_wr_data_count[0] = \<const0> ;
  assign axi_b_data_count[4] = \<const0> ;
  assign axi_b_data_count[3] = \<const0> ;
  assign axi_b_data_count[2] = \<const0> ;
  assign axi_b_data_count[1] = \<const0> ;
  assign axi_b_data_count[0] = \<const0> ;
  assign axi_b_dbiterr = \<const0> ;
  assign axi_b_overflow = \<const0> ;
  assign axi_b_prog_empty = \<const1> ;
  assign axi_b_prog_full = \<const0> ;
  assign axi_b_rd_data_count[4] = \<const0> ;
  assign axi_b_rd_data_count[3] = \<const0> ;
  assign axi_b_rd_data_count[2] = \<const0> ;
  assign axi_b_rd_data_count[1] = \<const0> ;
  assign axi_b_rd_data_count[0] = \<const0> ;
  assign axi_b_sbiterr = \<const0> ;
  assign axi_b_underflow = \<const0> ;
  assign axi_b_wr_data_count[4] = \<const0> ;
  assign axi_b_wr_data_count[3] = \<const0> ;
  assign axi_b_wr_data_count[2] = \<const0> ;
  assign axi_b_wr_data_count[1] = \<const0> ;
  assign axi_b_wr_data_count[0] = \<const0> ;
  assign axi_r_data_count[10] = \<const0> ;
  assign axi_r_data_count[9] = \<const0> ;
  assign axi_r_data_count[8] = \<const0> ;
  assign axi_r_data_count[7] = \<const0> ;
  assign axi_r_data_count[6] = \<const0> ;
  assign axi_r_data_count[5] = \<const0> ;
  assign axi_r_data_count[4] = \<const0> ;
  assign axi_r_data_count[3] = \<const0> ;
  assign axi_r_data_count[2] = \<const0> ;
  assign axi_r_data_count[1] = \<const0> ;
  assign axi_r_data_count[0] = \<const0> ;
  assign axi_r_dbiterr = \<const0> ;
  assign axi_r_overflow = \<const0> ;
  assign axi_r_prog_empty = \<const1> ;
  assign axi_r_prog_full = \<const0> ;
  assign axi_r_rd_data_count[10] = \<const0> ;
  assign axi_r_rd_data_count[9] = \<const0> ;
  assign axi_r_rd_data_count[8] = \<const0> ;
  assign axi_r_rd_data_count[7] = \<const0> ;
  assign axi_r_rd_data_count[6] = \<const0> ;
  assign axi_r_rd_data_count[5] = \<const0> ;
  assign axi_r_rd_data_count[4] = \<const0> ;
  assign axi_r_rd_data_count[3] = \<const0> ;
  assign axi_r_rd_data_count[2] = \<const0> ;
  assign axi_r_rd_data_count[1] = \<const0> ;
  assign axi_r_rd_data_count[0] = \<const0> ;
  assign axi_r_sbiterr = \<const0> ;
  assign axi_r_underflow = \<const0> ;
  assign axi_r_wr_data_count[10] = \<const0> ;
  assign axi_r_wr_data_count[9] = \<const0> ;
  assign axi_r_wr_data_count[8] = \<const0> ;
  assign axi_r_wr_data_count[7] = \<const0> ;
  assign axi_r_wr_data_count[6] = \<const0> ;
  assign axi_r_wr_data_count[5] = \<const0> ;
  assign axi_r_wr_data_count[4] = \<const0> ;
  assign axi_r_wr_data_count[3] = \<const0> ;
  assign axi_r_wr_data_count[2] = \<const0> ;
  assign axi_r_wr_data_count[1] = \<const0> ;
  assign axi_r_wr_data_count[0] = \<const0> ;
  assign axi_w_data_count[10] = \<const0> ;
  assign axi_w_data_count[9] = \<const0> ;
  assign axi_w_data_count[8] = \<const0> ;
  assign axi_w_data_count[7] = \<const0> ;
  assign axi_w_data_count[6] = \<const0> ;
  assign axi_w_data_count[5] = \<const0> ;
  assign axi_w_data_count[4] = \<const0> ;
  assign axi_w_data_count[3] = \<const0> ;
  assign axi_w_data_count[2] = \<const0> ;
  assign axi_w_data_count[1] = \<const0> ;
  assign axi_w_data_count[0] = \<const0> ;
  assign axi_w_dbiterr = \<const0> ;
  assign axi_w_overflow = \<const0> ;
  assign axi_w_prog_empty = \<const1> ;
  assign axi_w_prog_full = \<const0> ;
  assign axi_w_rd_data_count[10] = \<const0> ;
  assign axi_w_rd_data_count[9] = \<const0> ;
  assign axi_w_rd_data_count[8] = \<const0> ;
  assign axi_w_rd_data_count[7] = \<const0> ;
  assign axi_w_rd_data_count[6] = \<const0> ;
  assign axi_w_rd_data_count[5] = \<const0> ;
  assign axi_w_rd_data_count[4] = \<const0> ;
  assign axi_w_rd_data_count[3] = \<const0> ;
  assign axi_w_rd_data_count[2] = \<const0> ;
  assign axi_w_rd_data_count[1] = \<const0> ;
  assign axi_w_rd_data_count[0] = \<const0> ;
  assign axi_w_sbiterr = \<const0> ;
  assign axi_w_underflow = \<const0> ;
  assign axi_w_wr_data_count[10] = \<const0> ;
  assign axi_w_wr_data_count[9] = \<const0> ;
  assign axi_w_wr_data_count[8] = \<const0> ;
  assign axi_w_wr_data_count[7] = \<const0> ;
  assign axi_w_wr_data_count[6] = \<const0> ;
  assign axi_w_wr_data_count[5] = \<const0> ;
  assign axi_w_wr_data_count[4] = \<const0> ;
  assign axi_w_wr_data_count[3] = \<const0> ;
  assign axi_w_wr_data_count[2] = \<const0> ;
  assign axi_w_wr_data_count[1] = \<const0> ;
  assign axi_w_wr_data_count[0] = \<const0> ;
  assign axis_data_count[10] = \<const0> ;
  assign axis_data_count[9] = \<const0> ;
  assign axis_data_count[8] = \<const0> ;
  assign axis_data_count[7] = \<const0> ;
  assign axis_data_count[6] = \<const0> ;
  assign axis_data_count[5] = \<const0> ;
  assign axis_data_count[4] = \<const0> ;
  assign axis_data_count[3] = \<const0> ;
  assign axis_data_count[2] = \<const0> ;
  assign axis_data_count[1] = \<const0> ;
  assign axis_data_count[0] = \<const0> ;
  assign axis_dbiterr = \<const0> ;
  assign axis_overflow = \<const0> ;
  assign axis_prog_empty = \<const1> ;
  assign axis_prog_full = \<const0> ;
  assign axis_rd_data_count[10] = \<const0> ;
  assign axis_rd_data_count[9] = \<const0> ;
  assign axis_rd_data_count[8] = \<const0> ;
  assign axis_rd_data_count[7] = \<const0> ;
  assign axis_rd_data_count[6] = \<const0> ;
  assign axis_rd_data_count[5] = \<const0> ;
  assign axis_rd_data_count[4] = \<const0> ;
  assign axis_rd_data_count[3] = \<const0> ;
  assign axis_rd_data_count[2] = \<const0> ;
  assign axis_rd_data_count[1] = \<const0> ;
  assign axis_rd_data_count[0] = \<const0> ;
  assign axis_sbiterr = \<const0> ;
  assign axis_underflow = \<const0> ;
  assign axis_wr_data_count[10] = \<const0> ;
  assign axis_wr_data_count[9] = \<const0> ;
  assign axis_wr_data_count[8] = \<const0> ;
  assign axis_wr_data_count[7] = \<const0> ;
  assign axis_wr_data_count[6] = \<const0> ;
  assign axis_wr_data_count[5] = \<const0> ;
  assign axis_wr_data_count[4] = \<const0> ;
  assign axis_wr_data_count[3] = \<const0> ;
  assign axis_wr_data_count[2] = \<const0> ;
  assign axis_wr_data_count[1] = \<const0> ;
  assign axis_wr_data_count[0] = \<const0> ;
  assign data_count[5] = \<const0> ;
  assign data_count[4] = \<const0> ;
  assign data_count[3] = \<const0> ;
  assign data_count[2] = \<const0> ;
  assign data_count[1] = \<const0> ;
  assign data_count[0] = \<const0> ;
  assign dbiterr = \<const0> ;
  assign m_axi_araddr[31] = \<const0> ;
  assign m_axi_araddr[30] = \<const0> ;
  assign m_axi_araddr[29] = \<const0> ;
  assign m_axi_araddr[28] = \<const0> ;
  assign m_axi_araddr[27] = \<const0> ;
  assign m_axi_araddr[26] = \<const0> ;
  assign m_axi_araddr[25] = \<const0> ;
  assign m_axi_araddr[24] = \<const0> ;
  assign m_axi_araddr[23] = \<const0> ;
  assign m_axi_araddr[22] = \<const0> ;
  assign m_axi_araddr[21] = \<const0> ;
  assign m_axi_araddr[20] = \<const0> ;
  assign m_axi_araddr[19] = \<const0> ;
  assign m_axi_araddr[18] = \<const0> ;
  assign m_axi_araddr[17] = \<const0> ;
  assign m_axi_araddr[16] = \<const0> ;
  assign m_axi_araddr[15] = \<const0> ;
  assign m_axi_araddr[14] = \<const0> ;
  assign m_axi_araddr[13] = \<const0> ;
  assign m_axi_araddr[12] = \<const0> ;
  assign m_axi_araddr[11] = \<const0> ;
  assign m_axi_araddr[10] = \<const0> ;
  assign m_axi_araddr[9] = \<const0> ;
  assign m_axi_araddr[8] = \<const0> ;
  assign m_axi_araddr[7] = \<const0> ;
  assign m_axi_araddr[6] = \<const0> ;
  assign m_axi_araddr[5] = \<const0> ;
  assign m_axi_araddr[4] = \<const0> ;
  assign m_axi_araddr[3] = \<const0> ;
  assign m_axi_araddr[2] = \<const0> ;
  assign m_axi_araddr[1] = \<const0> ;
  assign m_axi_araddr[0] = \<const0> ;
  assign m_axi_arburst[1] = \<const0> ;
  assign m_axi_arburst[0] = \<const0> ;
  assign m_axi_arcache[3] = \<const0> ;
  assign m_axi_arcache[2] = \<const0> ;
  assign m_axi_arcache[1] = \<const0> ;
  assign m_axi_arcache[0] = \<const0> ;
  assign m_axi_arid[0] = \<const0> ;
  assign m_axi_arlen[7] = \<const0> ;
  assign m_axi_arlen[6] = \<const0> ;
  assign m_axi_arlen[5] = \<const0> ;
  assign m_axi_arlen[4] = \<const0> ;
  assign m_axi_arlen[3] = \<const0> ;
  assign m_axi_arlen[2] = \<const0> ;
  assign m_axi_arlen[1] = \<const0> ;
  assign m_axi_arlen[0] = \<const0> ;
  assign m_axi_arlock[0] = \<const0> ;
  assign m_axi_arprot[2] = \<const0> ;
  assign m_axi_arprot[1] = \<const0> ;
  assign m_axi_arprot[0] = \<const0> ;
  assign m_axi_arqos[3] = \<const0> ;
  assign m_axi_arqos[2] = \<const0> ;
  assign m_axi_arqos[1] = \<const0> ;
  assign m_axi_arqos[0] = \<const0> ;
  assign m_axi_arregion[3] = \<const0> ;
  assign m_axi_arregion[2] = \<const0> ;
  assign m_axi_arregion[1] = \<const0> ;
  assign m_axi_arregion[0] = \<const0> ;
  assign m_axi_arsize[2] = \<const0> ;
  assign m_axi_arsize[1] = \<const0> ;
  assign m_axi_arsize[0] = \<const0> ;
  assign m_axi_aruser[0] = \<const0> ;
  assign m_axi_arvalid = \<const0> ;
  assign m_axi_awaddr[31] = \<const0> ;
  assign m_axi_awaddr[30] = \<const0> ;
  assign m_axi_awaddr[29] = \<const0> ;
  assign m_axi_awaddr[28] = \<const0> ;
  assign m_axi_awaddr[27] = \<const0> ;
  assign m_axi_awaddr[26] = \<const0> ;
  assign m_axi_awaddr[25] = \<const0> ;
  assign m_axi_awaddr[24] = \<const0> ;
  assign m_axi_awaddr[23] = \<const0> ;
  assign m_axi_awaddr[22] = \<const0> ;
  assign m_axi_awaddr[21] = \<const0> ;
  assign m_axi_awaddr[20] = \<const0> ;
  assign m_axi_awaddr[19] = \<const0> ;
  assign m_axi_awaddr[18] = \<const0> ;
  assign m_axi_awaddr[17] = \<const0> ;
  assign m_axi_awaddr[16] = \<const0> ;
  assign m_axi_awaddr[15] = \<const0> ;
  assign m_axi_awaddr[14] = \<const0> ;
  assign m_axi_awaddr[13] = \<const0> ;
  assign m_axi_awaddr[12] = \<const0> ;
  assign m_axi_awaddr[11] = \<const0> ;
  assign m_axi_awaddr[10] = \<const0> ;
  assign m_axi_awaddr[9] = \<const0> ;
  assign m_axi_awaddr[8] = \<const0> ;
  assign m_axi_awaddr[7] = \<const0> ;
  assign m_axi_awaddr[6] = \<const0> ;
  assign m_axi_awaddr[5] = \<const0> ;
  assign m_axi_awaddr[4] = \<const0> ;
  assign m_axi_awaddr[3] = \<const0> ;
  assign m_axi_awaddr[2] = \<const0> ;
  assign m_axi_awaddr[1] = \<const0> ;
  assign m_axi_awaddr[0] = \<const0> ;
  assign m_axi_awburst[1] = \<const0> ;
  assign m_axi_awburst[0] = \<const0> ;
  assign m_axi_awcache[3] = \<const0> ;
  assign m_axi_awcache[2] = \<const0> ;
  assign m_axi_awcache[1] = \<const0> ;
  assign m_axi_awcache[0] = \<const0> ;
  assign m_axi_awid[0] = \<const0> ;
  assign m_axi_awlen[7] = \<const0> ;
  assign m_axi_awlen[6] = \<const0> ;
  assign m_axi_awlen[5] = \<const0> ;
  assign m_axi_awlen[4] = \<const0> ;
  assign m_axi_awlen[3] = \<const0> ;
  assign m_axi_awlen[2] = \<const0> ;
  assign m_axi_awlen[1] = \<const0> ;
  assign m_axi_awlen[0] = \<const0> ;
  assign m_axi_awlock[0] = \<const0> ;
  assign m_axi_awprot[2] = \<const0> ;
  assign m_axi_awprot[1] = \<const0> ;
  assign m_axi_awprot[0] = \<const0> ;
  assign m_axi_awqos[3] = \<const0> ;
  assign m_axi_awqos[2] = \<const0> ;
  assign m_axi_awqos[1] = \<const0> ;
  assign m_axi_awqos[0] = \<const0> ;
  assign m_axi_awregion[3] = \<const0> ;
  assign m_axi_awregion[2] = \<const0> ;
  assign m_axi_awregion[1] = \<const0> ;
  assign m_axi_awregion[0] = \<const0> ;
  assign m_axi_awsize[2] = \<const0> ;
  assign m_axi_awsize[1] = \<const0> ;
  assign m_axi_awsize[0] = \<const0> ;
  assign m_axi_awuser[0] = \<const0> ;
  assign m_axi_awvalid = \<const0> ;
  assign m_axi_bready = \<const0> ;
  assign m_axi_rready = \<const0> ;
  assign m_axi_wdata[63] = \<const0> ;
  assign m_axi_wdata[62] = \<const0> ;
  assign m_axi_wdata[61] = \<const0> ;
  assign m_axi_wdata[60] = \<const0> ;
  assign m_axi_wdata[59] = \<const0> ;
  assign m_axi_wdata[58] = \<const0> ;
  assign m_axi_wdata[57] = \<const0> ;
  assign m_axi_wdata[56] = \<const0> ;
  assign m_axi_wdata[55] = \<const0> ;
  assign m_axi_wdata[54] = \<const0> ;
  assign m_axi_wdata[53] = \<const0> ;
  assign m_axi_wdata[52] = \<const0> ;
  assign m_axi_wdata[51] = \<const0> ;
  assign m_axi_wdata[50] = \<const0> ;
  assign m_axi_wdata[49] = \<const0> ;
  assign m_axi_wdata[48] = \<const0> ;
  assign m_axi_wdata[47] = \<const0> ;
  assign m_axi_wdata[46] = \<const0> ;
  assign m_axi_wdata[45] = \<const0> ;
  assign m_axi_wdata[44] = \<const0> ;
  assign m_axi_wdata[43] = \<const0> ;
  assign m_axi_wdata[42] = \<const0> ;
  assign m_axi_wdata[41] = \<const0> ;
  assign m_axi_wdata[40] = \<const0> ;
  assign m_axi_wdata[39] = \<const0> ;
  assign m_axi_wdata[38] = \<const0> ;
  assign m_axi_wdata[37] = \<const0> ;
  assign m_axi_wdata[36] = \<const0> ;
  assign m_axi_wdata[35] = \<const0> ;
  assign m_axi_wdata[34] = \<const0> ;
  assign m_axi_wdata[33] = \<const0> ;
  assign m_axi_wdata[32] = \<const0> ;
  assign m_axi_wdata[31] = \<const0> ;
  assign m_axi_wdata[30] = \<const0> ;
  assign m_axi_wdata[29] = \<const0> ;
  assign m_axi_wdata[28] = \<const0> ;
  assign m_axi_wdata[27] = \<const0> ;
  assign m_axi_wdata[26] = \<const0> ;
  assign m_axi_wdata[25] = \<const0> ;
  assign m_axi_wdata[24] = \<const0> ;
  assign m_axi_wdata[23] = \<const0> ;
  assign m_axi_wdata[22] = \<const0> ;
  assign m_axi_wdata[21] = \<const0> ;
  assign m_axi_wdata[20] = \<const0> ;
  assign m_axi_wdata[19] = \<const0> ;
  assign m_axi_wdata[18] = \<const0> ;
  assign m_axi_wdata[17] = \<const0> ;
  assign m_axi_wdata[16] = \<const0> ;
  assign m_axi_wdata[15] = \<const0> ;
  assign m_axi_wdata[14] = \<const0> ;
  assign m_axi_wdata[13] = \<const0> ;
  assign m_axi_wdata[12] = \<const0> ;
  assign m_axi_wdata[11] = \<const0> ;
  assign m_axi_wdata[10] = \<const0> ;
  assign m_axi_wdata[9] = \<const0> ;
  assign m_axi_wdata[8] = \<const0> ;
  assign m_axi_wdata[7] = \<const0> ;
  assign m_axi_wdata[6] = \<const0> ;
  assign m_axi_wdata[5] = \<const0> ;
  assign m_axi_wdata[4] = \<const0> ;
  assign m_axi_wdata[3] = \<const0> ;
  assign m_axi_wdata[2] = \<const0> ;
  assign m_axi_wdata[1] = \<const0> ;
  assign m_axi_wdata[0] = \<const0> ;
  assign m_axi_wid[0] = \<const0> ;
  assign m_axi_wlast = \<const0> ;
  assign m_axi_wstrb[7] = \<const0> ;
  assign m_axi_wstrb[6] = \<const0> ;
  assign m_axi_wstrb[5] = \<const0> ;
  assign m_axi_wstrb[4] = \<const0> ;
  assign m_axi_wstrb[3] = \<const0> ;
  assign m_axi_wstrb[2] = \<const0> ;
  assign m_axi_wstrb[1] = \<const0> ;
  assign m_axi_wstrb[0] = \<const0> ;
  assign m_axi_wuser[0] = \<const0> ;
  assign m_axi_wvalid = \<const0> ;
  assign m_axis_tdata[7] = \<const0> ;
  assign m_axis_tdata[6] = \<const0> ;
  assign m_axis_tdata[5] = \<const0> ;
  assign m_axis_tdata[4] = \<const0> ;
  assign m_axis_tdata[3] = \<const0> ;
  assign m_axis_tdata[2] = \<const0> ;
  assign m_axis_tdata[1] = \<const0> ;
  assign m_axis_tdata[0] = \<const0> ;
  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const0> ;
  assign m_axis_tlast = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[3] = \<const0> ;
  assign m_axis_tuser[2] = \<const0> ;
  assign m_axis_tuser[1] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign m_axis_tvalid = \<const0> ;
  assign overflow = \<const0> ;
  assign prog_empty = \<const0> ;
  assign prog_full = \<const0> ;
  assign rd_data_count[5] = \<const0> ;
  assign rd_data_count[4] = \<const0> ;
  assign rd_data_count[3] = \<const0> ;
  assign rd_data_count[2] = \<const0> ;
  assign rd_data_count[1] = \<const0> ;
  assign rd_data_count[0] = \<const0> ;
  assign rd_rst_busy = \<const0> ;
  assign s_axi_arready = \<const0> ;
  assign s_axi_awready = \<const0> ;
  assign s_axi_bid[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_buser[0] = \<const0> ;
  assign s_axi_bvalid = \<const0> ;
  assign s_axi_rdata[63] = \<const0> ;
  assign s_axi_rdata[62] = \<const0> ;
  assign s_axi_rdata[61] = \<const0> ;
  assign s_axi_rdata[60] = \<const0> ;
  assign s_axi_rdata[59] = \<const0> ;
  assign s_axi_rdata[58] = \<const0> ;
  assign s_axi_rdata[57] = \<const0> ;
  assign s_axi_rdata[56] = \<const0> ;
  assign s_axi_rdata[55] = \<const0> ;
  assign s_axi_rdata[54] = \<const0> ;
  assign s_axi_rdata[53] = \<const0> ;
  assign s_axi_rdata[52] = \<const0> ;
  assign s_axi_rdata[51] = \<const0> ;
  assign s_axi_rdata[50] = \<const0> ;
  assign s_axi_rdata[49] = \<const0> ;
  assign s_axi_rdata[48] = \<const0> ;
  assign s_axi_rdata[47] = \<const0> ;
  assign s_axi_rdata[46] = \<const0> ;
  assign s_axi_rdata[45] = \<const0> ;
  assign s_axi_rdata[44] = \<const0> ;
  assign s_axi_rdata[43] = \<const0> ;
  assign s_axi_rdata[42] = \<const0> ;
  assign s_axi_rdata[41] = \<const0> ;
  assign s_axi_rdata[40] = \<const0> ;
  assign s_axi_rdata[39] = \<const0> ;
  assign s_axi_rdata[38] = \<const0> ;
  assign s_axi_rdata[37] = \<const0> ;
  assign s_axi_rdata[36] = \<const0> ;
  assign s_axi_rdata[35] = \<const0> ;
  assign s_axi_rdata[34] = \<const0> ;
  assign s_axi_rdata[33] = \<const0> ;
  assign s_axi_rdata[32] = \<const0> ;
  assign s_axi_rdata[31] = \<const0> ;
  assign s_axi_rdata[30] = \<const0> ;
  assign s_axi_rdata[29] = \<const0> ;
  assign s_axi_rdata[28] = \<const0> ;
  assign s_axi_rdata[27] = \<const0> ;
  assign s_axi_rdata[26] = \<const0> ;
  assign s_axi_rdata[25] = \<const0> ;
  assign s_axi_rdata[24] = \<const0> ;
  assign s_axi_rdata[23] = \<const0> ;
  assign s_axi_rdata[22] = \<const0> ;
  assign s_axi_rdata[21] = \<const0> ;
  assign s_axi_rdata[20] = \<const0> ;
  assign s_axi_rdata[19] = \<const0> ;
  assign s_axi_rdata[18] = \<const0> ;
  assign s_axi_rdata[17] = \<const0> ;
  assign s_axi_rdata[16] = \<const0> ;
  assign s_axi_rdata[15] = \<const0> ;
  assign s_axi_rdata[14] = \<const0> ;
  assign s_axi_rdata[13] = \<const0> ;
  assign s_axi_rdata[12] = \<const0> ;
  assign s_axi_rdata[11] = \<const0> ;
  assign s_axi_rdata[10] = \<const0> ;
  assign s_axi_rdata[9] = \<const0> ;
  assign s_axi_rdata[8] = \<const0> ;
  assign s_axi_rdata[7] = \<const0> ;
  assign s_axi_rdata[6] = \<const0> ;
  assign s_axi_rdata[5] = \<const0> ;
  assign s_axi_rdata[4] = \<const0> ;
  assign s_axi_rdata[3] = \<const0> ;
  assign s_axi_rdata[2] = \<const0> ;
  assign s_axi_rdata[1] = \<const0> ;
  assign s_axi_rdata[0] = \<const0> ;
  assign s_axi_rid[0] = \<const0> ;
  assign s_axi_rlast = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_ruser[0] = \<const0> ;
  assign s_axi_rvalid = \<const0> ;
  assign s_axi_wready = \<const0> ;
  assign s_axis_tready = \<const0> ;
  assign sbiterr = \<const0> ;
  assign underflow = \<const0> ;
  assign valid = \<const0> ;
  assign wr_ack = \<const0> ;
  assign wr_data_count[5] = \<const0> ;
  assign wr_data_count[4] = \<const0> ;
  assign wr_data_count[3] = \<const0> ;
  assign wr_data_count[2] = \<const0> ;
  assign wr_data_count[1] = \<const0> ;
  assign wr_data_count[0] = \<const0> ;
  assign wr_rst_busy = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  coregen_fifo_32x128_fifo_generator_v13_0_1_synth inst_fifo_gen
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_en(rd_en),
        .rst(rst),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .wr_en(wr_en));
endmodule

(* ORIG_REF_NAME = "fifo_generator_v13_0_1_synth" *) 
module coregen_fifo_32x128_fifo_generator_v13_0_1_synth
   (dout,
    empty,
    full,
    rd_en,
    s_aclk,
    clk,
    rst,
    din,
    wr_en,
    s_aresetn);
  output [127:0]dout;
  output empty;
  output full;
  input rd_en;
  input s_aclk;
  input clk;
  input rst;
  input [127:0]din;
  input wr_en;
  input s_aresetn;

  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rst;
  wire s_aclk;
  wire s_aresetn;
  wire wr_en;

  coregen_fifo_32x128_fifo_generator_top \gconvfifo.rf 
       (.clk(clk),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en));
  coregen_fifo_32x128_reset_blk_ramfifo \reset_gen_cc.rstblk_cc 
       (.s_aclk(s_aclk),
        .s_aresetn(s_aresetn));
endmodule

(* ORIG_REF_NAME = "memory" *) 
module coregen_fifo_32x128_memory
   (dout,
    clk,
    E,
    din,
    \gc0.count_d1_reg[4] ,
    \gcc0.gc0.count_d1_reg[4] ,
    ram_empty_fb_i_reg,
    Q,
    \gpregsm1.curr_fwft_state_reg[1] );
  output [127:0]dout;
  input clk;
  input [0:0]E;
  input [127:0]din;
  input [4:0]\gc0.count_d1_reg[4] ;
  input [4:0]\gcc0.gc0.count_d1_reg[4] ;
  input [0:0]ram_empty_fb_i_reg;
  input [0:0]Q;
  input [0:0]\gpregsm1.curr_fwft_state_reg[1] ;

  wire [0:0]E;
  wire [0:0]Q;
  wire clk;
  wire [127:0]din;
  wire [127:0]dout;
  wire [127:0]dout_i;
  wire [4:0]\gc0.count_d1_reg[4] ;
  wire [4:0]\gcc0.gc0.count_d1_reg[4] ;
  wire [0:0]\gpregsm1.curr_fwft_state_reg[1] ;
  wire [0:0]ram_empty_fb_i_reg;

  coregen_fifo_32x128_dmem \gdm.dm 
       (.E(E),
        .Q(dout_i),
        .clk(clk),
        .din(din),
        .\gc0.count_d1_reg[4] (\gc0.count_d1_reg[4] ),
        .\gcc0.gc0.count_d1_reg[4] (\gcc0.gc0.count_d1_reg[4] ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] (Q),
        .ram_empty_fb_i_reg(ram_empty_fb_i_reg));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[0] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[0]),
        .Q(dout[0]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[100] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[100]),
        .Q(dout[100]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[101] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[101]),
        .Q(dout[101]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[102] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[102]),
        .Q(dout[102]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[103] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[103]),
        .Q(dout[103]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[104] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[104]),
        .Q(dout[104]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[105] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[105]),
        .Q(dout[105]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[106] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[106]),
        .Q(dout[106]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[107] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[107]),
        .Q(dout[107]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[108] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[108]),
        .Q(dout[108]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[109] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[109]),
        .Q(dout[109]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[10] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[10]),
        .Q(dout[10]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[110] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[110]),
        .Q(dout[110]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[111] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[111]),
        .Q(dout[111]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[112] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[112]),
        .Q(dout[112]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[113] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[113]),
        .Q(dout[113]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[114] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[114]),
        .Q(dout[114]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[115] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[115]),
        .Q(dout[115]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[116] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[116]),
        .Q(dout[116]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[117] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[117]),
        .Q(dout[117]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[118] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[118]),
        .Q(dout[118]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[119] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[119]),
        .Q(dout[119]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[11] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[11]),
        .Q(dout[11]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[120] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[120]),
        .Q(dout[120]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[121] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[121]),
        .Q(dout[121]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[122] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[122]),
        .Q(dout[122]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[123] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[123]),
        .Q(dout[123]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[124] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[124]),
        .Q(dout[124]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[125] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[125]),
        .Q(dout[125]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[126] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[126]),
        .Q(dout[126]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[127] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[127]),
        .Q(dout[127]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[12] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[12]),
        .Q(dout[12]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[13] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[13]),
        .Q(dout[13]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[14] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[14]),
        .Q(dout[14]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[15] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[15]),
        .Q(dout[15]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[16] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[16]),
        .Q(dout[16]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[17] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[17]),
        .Q(dout[17]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[18] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[18]),
        .Q(dout[18]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[19] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[19]),
        .Q(dout[19]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[1] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[1]),
        .Q(dout[1]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[20] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[20]),
        .Q(dout[20]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[21] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[21]),
        .Q(dout[21]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[22] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[22]),
        .Q(dout[22]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[23] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[23]),
        .Q(dout[23]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[24] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[24]),
        .Q(dout[24]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[25] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[25]),
        .Q(dout[25]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[26] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[26]),
        .Q(dout[26]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[27] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[27]),
        .Q(dout[27]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[28] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[28]),
        .Q(dout[28]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[29] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[29]),
        .Q(dout[29]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[2] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[2]),
        .Q(dout[2]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[30] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[30]),
        .Q(dout[30]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[31] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[31]),
        .Q(dout[31]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[32] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[32]),
        .Q(dout[32]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[33] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[33]),
        .Q(dout[33]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[34] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[34]),
        .Q(dout[34]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[35] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[35]),
        .Q(dout[35]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[36] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[36]),
        .Q(dout[36]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[37] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[37]),
        .Q(dout[37]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[38] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[38]),
        .Q(dout[38]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[39] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[39]),
        .Q(dout[39]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[3] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[3]),
        .Q(dout[3]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[40] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[40]),
        .Q(dout[40]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[41] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[41]),
        .Q(dout[41]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[42] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[42]),
        .Q(dout[42]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[43] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[43]),
        .Q(dout[43]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[44] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[44]),
        .Q(dout[44]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[45] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[45]),
        .Q(dout[45]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[46] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[46]),
        .Q(dout[46]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[47] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[47]),
        .Q(dout[47]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[48] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[48]),
        .Q(dout[48]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[49] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[49]),
        .Q(dout[49]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[4] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[4]),
        .Q(dout[4]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[50] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[50]),
        .Q(dout[50]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[51] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[51]),
        .Q(dout[51]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[52] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[52]),
        .Q(dout[52]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[53] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[53]),
        .Q(dout[53]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[54] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[54]),
        .Q(dout[54]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[55] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[55]),
        .Q(dout[55]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[56] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[56]),
        .Q(dout[56]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[57] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[57]),
        .Q(dout[57]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[58] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[58]),
        .Q(dout[58]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[59] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[59]),
        .Q(dout[59]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[5] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[5]),
        .Q(dout[5]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[60] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[60]),
        .Q(dout[60]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[61] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[61]),
        .Q(dout[61]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[62] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[62]),
        .Q(dout[62]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[63] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[63]),
        .Q(dout[63]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[64] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[64]),
        .Q(dout[64]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[65] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[65]),
        .Q(dout[65]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[66] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[66]),
        .Q(dout[66]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[67] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[67]),
        .Q(dout[67]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[68] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[68]),
        .Q(dout[68]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[69] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[69]),
        .Q(dout[69]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[6] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[6]),
        .Q(dout[6]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[70] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[70]),
        .Q(dout[70]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[71] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[71]),
        .Q(dout[71]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[72] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[72]),
        .Q(dout[72]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[73] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[73]),
        .Q(dout[73]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[74] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[74]),
        .Q(dout[74]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[75] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[75]),
        .Q(dout[75]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[76] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[76]),
        .Q(dout[76]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[77] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[77]),
        .Q(dout[77]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[78] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[78]),
        .Q(dout[78]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[79] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[79]),
        .Q(dout[79]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[7] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[7]),
        .Q(dout[7]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[80] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[80]),
        .Q(dout[80]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[81] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[81]),
        .Q(dout[81]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[82] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[82]),
        .Q(dout[82]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[83] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[83]),
        .Q(dout[83]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[84] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[84]),
        .Q(dout[84]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[85] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[85]),
        .Q(dout[85]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[86] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[86]),
        .Q(dout[86]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[87] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[87]),
        .Q(dout[87]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[88] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[88]),
        .Q(dout[88]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[89] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[89]),
        .Q(dout[89]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[8] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[8]),
        .Q(dout[8]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[90] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[90]),
        .Q(dout[90]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[91] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[91]),
        .Q(dout[91]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[92] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[92]),
        .Q(dout[92]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[93] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[93]),
        .Q(dout[93]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[94] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[94]),
        .Q(dout[94]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[95] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[95]),
        .Q(dout[95]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[96] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[96]),
        .Q(dout[96]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[97] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[97]),
        .Q(dout[97]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[98] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[98]),
        .Q(dout[98]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[99] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[99]),
        .Q(dout[99]));
  FDCE #(
    .INIT(1'b0)) 
    \goreg_dm.dout_i_reg[9] 
       (.C(clk),
        .CE(\gpregsm1.curr_fwft_state_reg[1] ),
        .CLR(Q),
        .D(dout_i[9]),
        .Q(dout[9]));
endmodule

(* ORIG_REF_NAME = "rd_bin_cntr" *) 
module coregen_fifo_32x128_rd_bin_cntr
   (Q,
    ram_full_comb,
    ram_empty_fb_i_reg,
    \gpr1.dout_i_reg[1] ,
    p_1_out,
    rst_full_gen_i,
    E,
    p_2_out,
    \gcc0.gc0.count_d1_reg[4] ,
    wr_en,
    \gcc0.gc0.count_reg[4] ,
    \gcc0.gc0.count_d1_reg[4]_0 ,
    ram_empty_fb_i_reg_0,
    clk,
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] );
  output [4:0]Q;
  output ram_full_comb;
  output ram_empty_fb_i_reg;
  output [4:0]\gpr1.dout_i_reg[1] ;
  input p_1_out;
  input rst_full_gen_i;
  input [0:0]E;
  input p_2_out;
  input \gcc0.gc0.count_d1_reg[4] ;
  input wr_en;
  input [4:0]\gcc0.gc0.count_reg[4] ;
  input [4:0]\gcc0.gc0.count_d1_reg[4]_0 ;
  input [0:0]ram_empty_fb_i_reg_0;
  input clk;
  input [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;

  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire \gcc0.gc0.count_d1_reg[4] ;
  wire [4:0]\gcc0.gc0.count_d1_reg[4]_0 ;
  wire [4:0]\gcc0.gc0.count_reg[4] ;
  wire [4:0]\gpr1.dout_i_reg[1] ;
  wire [0:0]\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ;
  wire p_1_out;
  wire p_2_out;
  wire [4:0]plusOp;
  wire ram_empty_fb_i_reg;
  wire [0:0]ram_empty_fb_i_reg_0;
  wire ram_full_comb;
  wire ram_full_i_i_2_n_0;
  wire ram_full_i_i_3_n_0;
  wire ram_full_i_i_4_n_0;
  wire ram_full_i_i_5_n_0;
  wire ram_full_i_i_6_n_0;
  wire rst_full_gen_i;
  wire wr_en;

  LUT1 #(
    .INIT(2'h1)) 
    \gc0.count[0]_i_1 
       (.I0(Q[0]),
        .O(plusOp[0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \gc0.count[1]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(plusOp[1]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gc0.count[2]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \gc0.count[3]_i_1 
       (.I0(Q[3]),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(Q[2]),
        .O(plusOp[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \gc0.count[4]_i_1 
       (.I0(Q[4]),
        .I1(Q[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[3]),
        .O(plusOp[4]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[0] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[0]),
        .Q(\gpr1.dout_i_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[1] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[1]),
        .Q(\gpr1.dout_i_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[2] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[2]),
        .Q(\gpr1.dout_i_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[3] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[3]),
        .Q(\gpr1.dout_i_reg[1] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_d1_reg[4] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(Q[4]),
        .Q(\gpr1.dout_i_reg[1] [4]));
  FDPE #(
    .INIT(1'b1)) 
    \gc0.count_reg[0] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .D(plusOp[0]),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[1] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[2] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[3] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[3]),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gc0.count_reg[4] 
       (.C(clk),
        .CE(ram_empty_fb_i_reg_0),
        .CLR(\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] ),
        .D(plusOp[4]),
        .Q(Q[4]));
  LUT5 #(
    .INIT(32'hCFCF88CF)) 
    ram_empty_fb_i_i_1
       (.I0(ram_full_i_i_2_n_0),
        .I1(p_2_out),
        .I2(\gcc0.gc0.count_d1_reg[4] ),
        .I3(wr_en),
        .I4(p_1_out),
        .O(ram_empty_fb_i_reg));
  LUT5 #(
    .INIT(32'h08FF080C)) 
    ram_full_i_i_1
       (.I0(ram_full_i_i_2_n_0),
        .I1(p_1_out),
        .I2(rst_full_gen_i),
        .I3(E),
        .I4(ram_full_i_i_3_n_0),
        .O(ram_full_comb));
  LUT5 #(
    .INIT(32'hFFFF6FF6)) 
    ram_full_i_i_2
       (.I0(\gcc0.gc0.count_d1_reg[4]_0 [1]),
        .I1(\gpr1.dout_i_reg[1] [1]),
        .I2(\gcc0.gc0.count_d1_reg[4]_0 [2]),
        .I3(\gpr1.dout_i_reg[1] [2]),
        .I4(ram_full_i_i_4_n_0),
        .O(ram_full_i_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000000000002002)) 
    ram_full_i_i_3
       (.I0(wr_en),
        .I1(p_1_out),
        .I2(\gcc0.gc0.count_reg[4] [4]),
        .I3(\gpr1.dout_i_reg[1] [4]),
        .I4(ram_full_i_i_5_n_0),
        .I5(ram_full_i_i_6_n_0),
        .O(ram_full_i_i_3_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    ram_full_i_i_4
       (.I0(\gpr1.dout_i_reg[1] [0]),
        .I1(\gcc0.gc0.count_d1_reg[4]_0 [0]),
        .I2(\gcc0.gc0.count_d1_reg[4]_0 [4]),
        .I3(\gpr1.dout_i_reg[1] [4]),
        .I4(\gcc0.gc0.count_d1_reg[4]_0 [3]),
        .I5(\gpr1.dout_i_reg[1] [3]),
        .O(ram_full_i_i_4_n_0));
  LUT4 #(
    .INIT(16'h6FF6)) 
    ram_full_i_i_5
       (.I0(\gpr1.dout_i_reg[1] [1]),
        .I1(\gcc0.gc0.count_reg[4] [1]),
        .I2(\gpr1.dout_i_reg[1] [0]),
        .I3(\gcc0.gc0.count_reg[4] [0]),
        .O(ram_full_i_i_5_n_0));
  LUT4 #(
    .INIT(16'h6FF6)) 
    ram_full_i_i_6
       (.I0(\gpr1.dout_i_reg[1] [2]),
        .I1(\gcc0.gc0.count_reg[4] [2]),
        .I2(\gpr1.dout_i_reg[1] [3]),
        .I3(\gcc0.gc0.count_reg[4] [3]),
        .O(ram_full_i_i_6_n_0));
endmodule

(* ORIG_REF_NAME = "rd_fwft" *) 
module coregen_fifo_32x128_rd_fwft
   (empty,
    E,
    \gc0.count_reg[0] ,
    ram_empty_fb_i_reg,
    \goreg_dm.dout_i_reg[127] ,
    clk,
    Q,
    p_2_out,
    rd_en);
  output empty;
  output [0:0]E;
  output [0:0]\gc0.count_reg[0] ;
  output ram_empty_fb_i_reg;
  output [0:0]\goreg_dm.dout_i_reg[127] ;
  input clk;
  input [0:0]Q;
  input p_2_out;
  input rd_en;

  wire [0:0]E;
  wire [0:0]Q;
  wire clk;
  wire [0:0]curr_fwft_state;
  wire empty;
  wire empty_fwft_fb;
  wire empty_fwft_i0;
  wire [0:0]\gc0.count_reg[0] ;
  wire [0:0]\goreg_dm.dout_i_reg[127] ;
  wire \gpregsm1.curr_fwft_state[0]_i_1_n_0 ;
  wire \gpregsm1.curr_fwft_state[1]_i_1_n_0 ;
  wire \gpregsm1.curr_fwft_state_reg_n_0_[1] ;
  wire p_2_out;
  wire ram_empty_fb_i_reg;
  wire rd_en;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_fb_reg
       (.C(clk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q),
        .Q(empty_fwft_fb));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hF320)) 
    empty_fwft_i_i_1
       (.I0(rd_en),
        .I1(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I2(curr_fwft_state),
        .I3(empty_fwft_fb),
        .O(empty_fwft_i0));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(empty_fwft_i0),
        .PRE(Q),
        .Q(empty));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h4555)) 
    \gc0.count_d1[4]_i_1 
       (.I0(p_2_out),
        .I1(rd_en),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(\gc0.count_reg[0] ));
  LUT3 #(
    .INIT(8'h8A)) 
    \goreg_dm.dout_i[127]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(rd_en),
        .I2(curr_fwft_state),
        .O(\goreg_dm.dout_i_reg[127] ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h4555)) 
    \gpr1.dout_i[127]_i_1 
       (.I0(p_2_out),
        .I1(rd_en),
        .I2(curr_fwft_state),
        .I3(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hBA)) 
    \gpregsm1.curr_fwft_state[0]_i_1 
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(rd_en),
        .I2(curr_fwft_state),
        .O(\gpregsm1.curr_fwft_state[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h40FF)) 
    \gpregsm1.curr_fwft_state[1]_i_1 
       (.I0(rd_en),
        .I1(curr_fwft_state),
        .I2(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I3(p_2_out),
        .O(\gpregsm1.curr_fwft_state[1]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(Q),
        .D(\gpregsm1.curr_fwft_state[0]_i_1_n_0 ),
        .Q(curr_fwft_state));
  (* equivalent_register_removal = "no" *) 
  FDCE #(
    .INIT(1'b0)) 
    \gpregsm1.curr_fwft_state_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(Q),
        .D(\gpregsm1.curr_fwft_state[1]_i_1_n_0 ),
        .Q(\gpregsm1.curr_fwft_state_reg_n_0_[1] ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h08)) 
    ram_empty_fb_i_i_4
       (.I0(\gpregsm1.curr_fwft_state_reg_n_0_[1] ),
        .I1(curr_fwft_state),
        .I2(rd_en),
        .O(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "rd_logic" *) 
module coregen_fifo_32x128_rd_logic
   (empty,
    E,
    \gc0.count_d1_reg[4] ,
    ram_full_comb,
    ram_empty_fb_i_reg,
    \gpr1.dout_i_reg[1] ,
    \goreg_dm.dout_i_reg[127] ,
    clk,
    Q,
    rd_en,
    p_1_out,
    rst_full_gen_i,
    \gcc0.gc0.count_d1_reg[4] ,
    wr_en,
    \gcc0.gc0.count_reg[4] ,
    \gcc0.gc0.count_d1_reg[4]_0 );
  output empty;
  output [0:0]E;
  output [4:0]\gc0.count_d1_reg[4] ;
  output ram_full_comb;
  output ram_empty_fb_i_reg;
  output [4:0]\gpr1.dout_i_reg[1] ;
  output [0:0]\goreg_dm.dout_i_reg[127] ;
  input clk;
  input [0:0]Q;
  input rd_en;
  input p_1_out;
  input rst_full_gen_i;
  input \gcc0.gc0.count_d1_reg[4] ;
  input wr_en;
  input [4:0]\gcc0.gc0.count_reg[4] ;
  input [4:0]\gcc0.gc0.count_d1_reg[4]_0 ;

  wire [0:0]E;
  wire [0:0]Q;
  wire clk;
  wire empty;
  wire [4:0]\gc0.count_d1_reg[4] ;
  wire \gcc0.gc0.count_d1_reg[4] ;
  wire [4:0]\gcc0.gc0.count_d1_reg[4]_0 ;
  wire [4:0]\gcc0.gc0.count_reg[4] ;
  wire [0:0]\goreg_dm.dout_i_reg[127] ;
  wire [4:0]\gpr1.dout_i_reg[1] ;
  wire \gr1.rfwft_n_2 ;
  wire p_1_out;
  wire p_2_out;
  wire ram_empty_fb_i_reg;
  wire ram_full_comb;
  wire rd_en;
  wire rpntr_n_6;
  wire rst_full_gen_i;
  wire wr_en;

  coregen_fifo_32x128_rd_fwft \gr1.rfwft 
       (.E(E),
        .Q(Q),
        .clk(clk),
        .empty(empty),
        .\gc0.count_reg[0] (\gr1.rfwft_n_2 ),
        .\goreg_dm.dout_i_reg[127] (\goreg_dm.dout_i_reg[127] ),
        .p_2_out(p_2_out),
        .ram_empty_fb_i_reg(ram_empty_fb_i_reg),
        .rd_en(rd_en));
  coregen_fifo_32x128_rd_status_flags_ss \grss.rsts 
       (.Q(Q),
        .clk(clk),
        .p_2_out(p_2_out),
        .ram_empty_fb_i_reg_0(rpntr_n_6));
  coregen_fifo_32x128_rd_bin_cntr rpntr
       (.E(E),
        .Q(\gc0.count_d1_reg[4] ),
        .clk(clk),
        .\gcc0.gc0.count_d1_reg[4] (\gcc0.gc0.count_d1_reg[4] ),
        .\gcc0.gc0.count_d1_reg[4]_0 (\gcc0.gc0.count_d1_reg[4]_0 ),
        .\gcc0.gc0.count_reg[4] (\gcc0.gc0.count_reg[4] ),
        .\gpr1.dout_i_reg[1] (\gpr1.dout_i_reg[1] ),
        .\ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] (Q),
        .p_1_out(p_1_out),
        .p_2_out(p_2_out),
        .ram_empty_fb_i_reg(rpntr_n_6),
        .ram_empty_fb_i_reg_0(\gr1.rfwft_n_2 ),
        .ram_full_comb(ram_full_comb),
        .rst_full_gen_i(rst_full_gen_i),
        .wr_en(wr_en));
endmodule

(* ORIG_REF_NAME = "rd_status_flags_ss" *) 
module coregen_fifo_32x128_rd_status_flags_ss
   (p_2_out,
    ram_empty_fb_i_reg_0,
    clk,
    Q);
  output p_2_out;
  input ram_empty_fb_i_reg_0;
  input clk;
  input [0:0]Q;

  wire [0:0]Q;
  wire clk;
  wire p_2_out;
  wire ram_empty_fb_i_reg_0;

  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_empty_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_empty_fb_i_reg_0),
        .PRE(Q),
        .Q(p_2_out));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module coregen_fifo_32x128_reset_blk_ramfifo
   (s_aclk,
    s_aresetn);
  input s_aclk;
  input s_aresetn;

  wire inverted_reset;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d3;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg2;
  wire s_aclk;
  wire s_aresetn;

  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(inverted_reset),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(inverted_reset),
        .Q(rst_d3));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(inverted_reset),
        .Q(rst_rd_reg2));
  LUT1 #(
    .INIT(2'h1)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_i_1 
       (.I0(s_aresetn),
        .O(inverted_reset));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(inverted_reset),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(inverted_reset),
        .Q(rst_wr_reg2));
endmodule

(* ORIG_REF_NAME = "reset_blk_ramfifo" *) 
module coregen_fifo_32x128_reset_blk_ramfifo__parameterized0
   (rst_full_ff_i,
    rst_full_gen_i,
    AR,
    Q,
    clk,
    rst);
  output rst_full_ff_i;
  output rst_full_gen_i;
  output [0:0]AR;
  output [1:0]Q;
  input clk;
  input rst;

  wire [0:0]AR;
  wire [1:0]Q;
  wire clk;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ;
  wire \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ;
  wire rd_rst_asreg;
  wire rd_rst_asreg_d2;
  wire rst;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_d3;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_rd_reg2;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg1;
  (* async_reg = "true" *) (* msgon = "true" *) wire rst_wr_reg2;
  wire wr_rst_asreg;
  wire wr_rst_asreg_d2;

  assign rst_full_ff_i = rst_d2;
  assign rst_full_gen_i = rst_d3;
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(rst),
        .Q(rst_d1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_d1),
        .PRE(rst),
        .Q(rst_d2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b1)) 
    \grstd1.grst_full.grst_f.rst_d3_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_d2),
        .PRE(rst),
        .Q(rst_d3));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rd_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_d2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .Q(rd_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1 
       (.I0(rd_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.rd_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_asreg_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.rd_rst_asreg_i_1_n_0 ),
        .PRE(rst_rd_reg2),
        .Q(rd_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1 
       (.I0(rd_rst_asreg),
        .I1(rd_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ),
        .Q(Q[0]));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.rd_rst_reg_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.rd_rst_reg[2]_i_1_n_0 ),
        .Q(Q[1]));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(rst),
        .Q(rst_rd_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_rd_reg2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_rd_reg1),
        .PRE(rst),
        .Q(rst_rd_reg2));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(rst),
        .Q(rst_wr_reg1));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* msgon = "true" *) 
  FDPE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.rst_wr_reg2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(rst_wr_reg1),
        .PRE(rst),
        .Q(rst_wr_reg2));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg 
       (.C(clk),
        .CE(1'b1),
        .D(wr_rst_asreg),
        .Q(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_d2_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .Q(wr_rst_asreg_d2),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1 
       (.I0(wr_rst_asreg),
        .I1(\ngwrdrst.grst.g7serrst.wr_rst_asreg_d1_reg_n_0 ),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ));
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_asreg_reg 
       (.C(clk),
        .CE(1'b1),
        .D(\ngwrdrst.grst.g7serrst.wr_rst_asreg_i_1_n_0 ),
        .PRE(rst_wr_reg2),
        .Q(wr_rst_asreg));
  LUT2 #(
    .INIT(4'h2)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1 
       (.I0(wr_rst_asreg),
        .I1(wr_rst_asreg_d2),
        .O(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    \ngwrdrst.grst.g7serrst.wr_rst_reg_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(1'b0),
        .PRE(\ngwrdrst.grst.g7serrst.wr_rst_reg[1]_i_1_n_0 ),
        .Q(AR));
endmodule

(* ORIG_REF_NAME = "wr_bin_cntr" *) 
module coregen_fifo_32x128_wr_bin_cntr
   (Q,
    ram_empty_fb_i_reg,
    \gpr1.dout_i_reg[1] ,
    \gc0.count_reg[4] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    E,
    clk,
    AR);
  output [4:0]Q;
  output ram_empty_fb_i_reg;
  output [4:0]\gpr1.dout_i_reg[1] ;
  input [4:0]\gc0.count_reg[4] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input [0:0]E;
  input clk;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire [4:0]\gc0.count_reg[4] ;
  wire [4:0]\gpr1.dout_i_reg[1] ;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire [4:0]plusOp__0;
  wire ram_empty_fb_i_i_3_n_0;
  wire ram_empty_fb_i_reg;

  LUT1 #(
    .INIT(2'h1)) 
    \gcc0.gc0.count[0]_i_1 
       (.I0(Q[0]),
        .O(plusOp__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \gcc0.gc0.count[1]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .O(plusOp__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gcc0.gc0.count[2]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(plusOp__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \gcc0.gc0.count[3]_i_1 
       (.I0(Q[3]),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(Q[2]),
        .O(plusOp__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \gcc0.gc0.count[4]_i_1 
       (.I0(Q[4]),
        .I1(Q[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[3]),
        .O(plusOp__0[4]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_d1_reg[0] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(Q[0]),
        .Q(\gpr1.dout_i_reg[1] [0]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_d1_reg[1] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(Q[1]),
        .Q(\gpr1.dout_i_reg[1] [1]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_d1_reg[2] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(Q[2]),
        .Q(\gpr1.dout_i_reg[1] [2]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_d1_reg[3] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(Q[3]),
        .Q(\gpr1.dout_i_reg[1] [3]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_d1_reg[4] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(Q[4]),
        .Q(\gpr1.dout_i_reg[1] [4]));
  FDPE #(
    .INIT(1'b1)) 
    \gcc0.gc0.count_reg[0] 
       (.C(clk),
        .CE(E),
        .D(plusOp__0[0]),
        .PRE(AR),
        .Q(Q[0]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_reg[1] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(plusOp__0[1]),
        .Q(Q[1]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_reg[2] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(plusOp__0[2]),
        .Q(Q[2]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_reg[3] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(plusOp__0[3]),
        .Q(Q[3]));
  FDCE #(
    .INIT(1'b0)) 
    \gcc0.gc0.count_reg[4] 
       (.C(clk),
        .CE(E),
        .CLR(AR),
        .D(plusOp__0[4]),
        .Q(Q[4]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBEFFFFBE)) 
    ram_empty_fb_i_i_2
       (.I0(ram_empty_fb_i_i_3_n_0),
        .I1(\gpr1.dout_i_reg[1] [4]),
        .I2(\gc0.count_reg[4] [4]),
        .I3(\gpr1.dout_i_reg[1] [3]),
        .I4(\gc0.count_reg[4] [3]),
        .I5(\gpregsm1.curr_fwft_state_reg[1] ),
        .O(ram_empty_fb_i_reg));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    ram_empty_fb_i_i_3
       (.I0(\gpr1.dout_i_reg[1] [0]),
        .I1(\gc0.count_reg[4] [0]),
        .I2(\gc0.count_reg[4] [2]),
        .I3(\gpr1.dout_i_reg[1] [2]),
        .I4(\gc0.count_reg[4] [1]),
        .I5(\gpr1.dout_i_reg[1] [1]),
        .O(ram_empty_fb_i_i_3_n_0));
endmodule

(* ORIG_REF_NAME = "wr_logic" *) 
module coregen_fifo_32x128_wr_logic
   (p_1_out,
    full,
    Q,
    ram_empty_fb_i_reg,
    \gpr1.dout_i_reg[1] ,
    E,
    ram_full_comb,
    clk,
    rst_full_ff_i,
    \gc0.count_reg[4] ,
    \gpregsm1.curr_fwft_state_reg[1] ,
    wr_en,
    AR);
  output p_1_out;
  output full;
  output [4:0]Q;
  output ram_empty_fb_i_reg;
  output [4:0]\gpr1.dout_i_reg[1] ;
  output [0:0]E;
  input ram_full_comb;
  input clk;
  input rst_full_ff_i;
  input [4:0]\gc0.count_reg[4] ;
  input \gpregsm1.curr_fwft_state_reg[1] ;
  input wr_en;
  input [0:0]AR;

  wire [0:0]AR;
  wire [0:0]E;
  wire [4:0]Q;
  wire clk;
  wire full;
  wire [4:0]\gc0.count_reg[4] ;
  wire [4:0]\gpr1.dout_i_reg[1] ;
  wire \gpregsm1.curr_fwft_state_reg[1] ;
  wire p_1_out;
  wire ram_empty_fb_i_reg;
  wire ram_full_comb;
  wire rst_full_ff_i;
  wire wr_en;

  coregen_fifo_32x128_wr_status_flags_ss \gwss.wsts 
       (.E(E),
        .clk(clk),
        .full(full),
        .p_1_out(p_1_out),
        .ram_full_comb(ram_full_comb),
        .rst_full_ff_i(rst_full_ff_i),
        .wr_en(wr_en));
  coregen_fifo_32x128_wr_bin_cntr wpntr
       (.AR(AR),
        .E(E),
        .Q(Q),
        .clk(clk),
        .\gc0.count_reg[4] (\gc0.count_reg[4] ),
        .\gpr1.dout_i_reg[1] (\gpr1.dout_i_reg[1] ),
        .\gpregsm1.curr_fwft_state_reg[1] (\gpregsm1.curr_fwft_state_reg[1] ),
        .ram_empty_fb_i_reg(ram_empty_fb_i_reg));
endmodule

(* ORIG_REF_NAME = "wr_status_flags_ss" *) 
module coregen_fifo_32x128_wr_status_flags_ss
   (p_1_out,
    full,
    E,
    ram_full_comb,
    clk,
    rst_full_ff_i,
    wr_en);
  output p_1_out;
  output full;
  output [0:0]E;
  input ram_full_comb;
  input clk;
  input rst_full_ff_i;
  input wr_en;

  wire [0:0]E;
  wire clk;
  wire full;
  wire p_1_out;
  wire ram_full_comb;
  wire rst_full_ff_i;
  wire wr_en;

  LUT2 #(
    .INIT(4'h2)) 
    \gcc0.gc0.count_d1[4]_i_1 
       (.I0(wr_en),
        .I1(p_1_out),
        .O(E));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_fb_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_full_comb),
        .PRE(rst_full_ff_i),
        .Q(p_1_out));
  (* equivalent_register_removal = "no" *) 
  FDPE #(
    .INIT(1'b1)) 
    ram_full_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(ram_full_comb),
        .PRE(rst_full_ff_i),
        .Q(full));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
