# Clocks
# ----------------------------------------------------------------------------------------------------------------------
create_clock -name REFCLK -period 6.667 [ get_ports hmc_refclkp ]
set_clock_groups -group [get_clocks REFCLK -include_generated_clocks] -asynchronous

create_clock -name REFCLK1 -period 6.667 [ get_ports hmc1_refclkp ]
set_clock_groups -group [get_clocks REFCLK1 -include_generated_clocks] -asynchronous

# Asynchronous Clock Groups
# ----------------------------------------------------------------------------------------------------------------------
set_clock_groups -asynchronous \
    -group [get_clocks hmc_tx_clk] \
    -group [get_clocks hmc_rx_clk]

# False path constraints
# ----------------------------------------------------------------------------------------------------------------------

# don't worry about the timing to the RST signal on the FIFOs
# we will take great care to ensure that those resets are held long enough, 
# and that we don't start sending data too any FIFO too quickly after reset is de-asserted
set_false_path  -to [get_pins -hierarchical -filter {NAME =~ *__fifo__*/RST}]

# don't worry about the reset signals in the hmc_node.
# we will be sure to hold those resets long enough
#set_false_path -from [get_pins -hierarchical -filter {NAME =~ *hmc_node/rst_q3_tx_reg/C}]
#set_false_path -from [get_pins -hierarchical -filter {NAME =~ *hmc_node/rst_q2_reg/C}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *hmc_node/rx_rst_q2_reg/C}]


set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *gtwiz_userclk_tx_inst/*gtwiz_userclk_tx_active_out_reg}]
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *gtwiz_userclk_rx_inst/*gtwiz_userclk_rx_active_out_reg}]

# Input and Output Pin Delays
# ----------------------------------------------------------------------------------------------------------------------

# TODO: in the future, we should probably add output delays and input delays here
#set_output_delay -clock [get_clocks user_picoclk] 0 [get_ports lxrxps]
#set_output_delay -clock [get_clocks user_picoclk] 0 [get_ports p_rst_n]
#set_output_delay -clock [get_clocks user_picoclk] 0 [get_ports scl]
#set_output_delay -clock [get_clocks user_picoclk] 0 [get_ports sda]
#set_input_delay -clock [get_clocks user_picoclk] 0 [get_ports lxtxps]
#set_input_delay -clock [get_clocks user_picoclk] 0 [get_ports p_rst_n]
#set_input_delay -clock [get_clocks user_picoclk] 0 [get_ports scl]
#set_input_delay -clock [get_clocks user_picoclk] 0 [get_ports sda]
