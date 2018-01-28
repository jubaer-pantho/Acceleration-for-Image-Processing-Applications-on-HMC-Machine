/*
* File Name     : AXIToHMC.v
*
* Description   : This is a communication bridge that converts an AXI protocol
*                 (driven by user logic) over to the HMC protocol.  Note that
*                 this does not do any clock crossing.
*                                  
*                 Note: our standard arbitration for read/write commands is
*                 fixed with the reads having the priority
*                 Note: we send the write response immediately after sending
*                 the write command.
*                 Note: we do not do any read response re-ordering.  Reads may
*                 come back out of order.
*                 Note: we do not create the 'axi_rlast' signal
*                 Note: we do not pay attention to the axi_bready signal
*                 Note: we do not pay attention to the axi_rready signal, so
*                 user code must be ready to accept read data
*
* Copyright     : 2015, Micron Inc.
*/

// Need HMC_CMD_RD and HMC_CMD_WR from hmc_def
`ifdef ENABLE_HMC
    `include "hmc_def.vh"
`else
    `define HMC_CMD_RD      0
    `define HMC_CMD_WR      0
`endif

module AXIToHMC #(
    parameter C_AXI_ID_WIDTH    = 6, 
    parameter C_AXI_ADDR_WIDTH  = 32, 
    parameter STREAM_DATA_WIDTH = 128,
    parameter UPSIZE_RATIO      = 1,
    parameter LOG_UPSIZE_RATIO  = 0,
    
    // don't change parameters below this line
    parameter C_AXI_DATA_WIDTH  = UPSIZE_RATIO * STREAM_DATA_WIDTH
)
(
    input                                   clk,
    input                                   rst,

    output                                  axi_awready,
    input                                   axi_awvalid,  
    input       [C_AXI_ID_WIDTH-1:0]        axi_awid,   
    input       [C_AXI_ADDR_WIDTH-1:0]      axi_awaddr,
    input       [7:0]                       axi_awlen,   
    input       [2:0]                       axi_awsize,  
    input       [1:0]                       axi_awburst,
    input                                   axi_awlock,   
    input       [3:0]                       axi_awcache,  
    input       [2:0]                       axi_awprot,   
    input       [3:0]                       axi_awqos,  
    
    input       [STREAM_DATA_WIDTH-1:0]     axi_wdata,
    input       [STREAM_DATA_WIDTH/8-1:0]   axi_wstrb,
    output                                  axi_wready,
    input                                   axi_wvalid,
    input                                   axi_wlast,
    
    output      [C_AXI_ID_WIDTH-1:0]        axi_bid,
    output      [1:0]                       axi_bresp,
    output                                  axi_bvalid,
    input                                   axi_bready,
     
    output                                  axi_arready,
    input                                   axi_arvalid,
    input       [C_AXI_ID_WIDTH-1:0]        axi_arid,
    input       [C_AXI_ADDR_WIDTH-1:0]      axi_araddr,
    input       [7:0]                       axi_arlen,
    input       [2:0]                       axi_arsize,
    input       [1:0]                       axi_arburst,
    input                                   axi_arlock,
    input       [3:0]                       axi_arcache,
    input       [2:0]                       axi_arprot,
    input       [3:0]                       axi_arqos,

    output      [C_AXI_ID_WIDTH-1:0]        axi_rid,
    output      [1:0]                       axi_rresp,
    output      [STREAM_DATA_WIDTH-1:0]     axi_rdata,
    output                                  axi_rlast,
    output                                  axi_rvalid,
    input                                   axi_rready,

    // Standard HMC Interface
    output                          hmc_clk,
    output                          hmc_cmd_valid,
    input                           hmc_cmd_ready,
    output      [3:0]               hmc_cmd,
    output      [33:0]              hmc_addr,
    output      [3:0]               hmc_size,
    output      [5:0]               hmc_tag,

    output      [127:0]             hmc_wr_data,
    output                          hmc_wr_data_valid,
    input                           hmc_wr_data_ready,
                                        
    input       [127:0]             hmc_rd_data,
    input       [5:0]               hmc_rd_data_tag,
    input                           hmc_rd_data_valid,
    input       [6:0]               hmc_errstat,
    input                           hmc_dinv
);

    // just use the AXI 'clk' as the clock for our HMC interface
    assign  hmc_clk                 = clk;

    // write data is a really easy interface
    assign  hmc_wr_data             = axi_wdata;
    assign  hmc_wr_data_valid       = axi_wvalid;
    assign  axi_wready              = hmc_wr_data_ready;

    // read data is a really easy interface
    assign  axi_rid                 = hmc_rd_data_tag;
    assign  axi_rresp               = |hmc_errstat;
    assign  axi_rdata               = hmc_rd_data;
    assign  axi_rlast               = 0;
    assign  axi_rvalid              = hmc_rd_data_valid & !hmc_dinv;
    
    // write response is sent back to the input AXI interface as soon as we
    // accept a write command
    assign  axi_bvalid              = axi_awvalid & axi_awready;
    assign  axi_bresp               = 'h0;
    assign  axi_bid                 = axi_awid;

    // now we just have to arbitrate our AXI commands onto the HMC interface
    // to make things easy, we always give priority to the reads
    assign  axi_arready             = hmc_cmd_ready;
    assign  axi_awready             = hmc_cmd_ready & ~axi_arvalid;
    assign  hmc_cmd_valid           = axi_arvalid | axi_awvalid;
    assign  hmc_cmd                 = axi_arvalid ? `HMC_CMD_RD     : `HMC_CMD_WR;
    assign  hmc_addr                = axi_arvalid ? axi_araddr      : axi_awaddr;
    assign  hmc_size                = axi_arvalid ? axi_arlen + 1   : axi_awlen + 1;
    assign  hmc_tag                 = axi_arvalid ? axi_arid        : axi_awid;

endmodule
