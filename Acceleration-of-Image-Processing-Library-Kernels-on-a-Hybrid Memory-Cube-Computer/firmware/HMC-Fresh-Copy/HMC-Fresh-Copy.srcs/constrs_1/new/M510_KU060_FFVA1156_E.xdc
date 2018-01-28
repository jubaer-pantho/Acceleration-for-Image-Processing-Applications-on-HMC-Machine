##-----------------------------------------------------------------------------
##
## (c) Copyright 2012-2012 Xilinx, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES.
##
##-----------------------------------------------------------------------------
##
## Project    : Ultrascale FPGA Gen3 Integrated Block for PCI Express
## File       : xilinx_pcie3_uscale_ep_x8g2.xdc
## Version    : 3.1
##-----------------------------------------------------------------------------
#
# User Configuration
# Link Width   - x8
# Link Speed   - Gen2
# Family       - virtexu
# Part         - xcvu095
# Package      - ffvd1924
# Speed grade  - -2
# PCIe Block   - X0Y0
###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 10.000 -name sys_clk [get_ports sys_clk_p]
set_false_path -from [get_ports sys_reset_n]

###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 5.000 -name extra_clk [get_ports extra_clk_p]

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################
set_property PACKAGE_PIN AK31 [get_ports extra_clk_p]
set_property IOSTANDARD LVDS [get_ports extra_clk_p]
set_property PACKAGE_PIN AK32 [get_ports extra_clk_n]
set_property IOSTANDARD LVDS [get_ports extra_clk_n]

#LED
set_property IOSTANDARD LVCMOS18 [get_ports {led_r[0]}]
set_property PACKAGE_PIN D11 [get_ports {led_r[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_g[0]}]
set_property PACKAGE_PIN B11 [get_ports {led_g[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_b[0]}]
set_property PACKAGE_PIN B10 [get_ports {led_b[0]}]

# TODO: in the future, we should probably set an output delay for these
#set_output_delay -clock [get_clocks extra_clk] 0 [get_ports {led_r[0]}]
#set_output_delay -clock [get_clocks extra_clk] 0 [get_ports {led_g[0]}]
#set_output_delay -clock [get_clocks extra_clk] 0 [get_ports {led_b[0]}]

###############################################################################
# User Physical Constraints
###############################################################################

#Pblock for PicoFramework
create_pblock pblock_PicoFramework
add_cells_to_pblock [get_pblocks pblock_PicoFramework] [get_cells -quiet [list PicoFramework]]
resize_pblock [get_pblocks pblock_PicoFramework] -add {SLICE_X124Y0:SLICE_X142Y110}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB18_X15Y0:RAMB18_X17Y43}
resize_pblock [get_pblocks pblock_PicoFramework] -add {RAMB36_X15Y0:RAMB36_X17Y21}

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################
##### SYS RESET###########
set_property LOC PCIE_3_1_X0Y0 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property PACKAGE_PIN K22 [get_ports sys_reset_n]
set_property PULLUP true [get_ports sys_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports sys_reset_n]

##### REFCLK_IBUF###########
set_property PACKAGE_PIN AB5 [get_ports sys_clk_n]
set_property LOC BUFG_GT_X1Y36 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_pclk]
set_property LOC BUFG_GT_X1Y37 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_userclk]
set_property LOC BUFG_GT_X1Y38 [get_cells PicoFramework/core/pcie3_ultrascale_0_i/inst/gt_top_i/phy_clk_i/bufg_gt_coreclk]

###############################################################################
# Flash Programming Settings: Uncomment as required by your design
# Items below between < > must be updated with correct values to work properly.
###############################################################################

# these are some general configuration settings
# in the future, these should probably be in their own XDC file
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
# this is just a dummy code that we want to be able to read when we load up the FPGA
#set_property BITSTREAM.CONFIG.USERID 0xCAFE0850 [current_design]
#
# SPI Flash Programming
set_property CONFIG_MODE SPIx8 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]
# Example PROM Generation command that should be executed from the Tcl Console
#write_cfgmem -format mcs -interface spix4 -size 128 -loadbit "up 0x0 <inputBitfile.bit>" <outputBitfile.bit>


