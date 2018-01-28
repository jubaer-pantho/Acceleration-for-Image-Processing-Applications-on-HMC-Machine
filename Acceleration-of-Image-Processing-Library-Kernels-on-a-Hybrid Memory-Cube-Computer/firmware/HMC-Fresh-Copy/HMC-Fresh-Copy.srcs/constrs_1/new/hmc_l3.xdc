
# L3

set_property package_pin   R30       [get_ports hmc1_refclkn]
set_property package_pin   R29       [get_ports hmc1_refclkp]

# HMC Power Save Pins
set_property PACKAGE_PIN   A15       [get_ports hmc1_lxrxps]
set_property IOSTANDARD    LVCMOS18  [get_ports hmc1_lxrxps]
set_property PACKAGE_PIN   C16       [get_ports hmc1_lxtxps]
set_property IOSTANDARD    LVCMOS18  [get_ports hmc1_lxtxps]

# HMC Control Signals
#set_property PACKAGE_PIN   D15       [get_ports p_rst_n]
#set_property IOSTANDARD    LVCMOS18  [get_ports p_rst_n]
#set_property PACKAGE_PIN   A19       [get_ports ferr_n]
#set_property IOSTANDARD    LVCMOS18  [get_ports ferr_n]

# HMC I2C
#set_property PACKAGE_PIN   B14       [get_ports hmc_scl]
#set_property IOSTANDARD    LVCMOS18  [get_ports hmc_scl]
#set_property PULLUP        true      [get_ports hmc_scl]
#set_property PACKAGE_PIN   A14       [get_ports hmc_sda]
#set_property IOSTANDARD    LVCMOS18  [get_ports hmc_sda]
#set_property PULLUP        true      [get_ports hmc_sda]

# TODO: these pins might get removed in the future
#set_property PACKAGE_PIN   B15       [get_ports cub[0]]
#set_property PACKAGE_PIN   C14       [get_ports cub[1]]
#set_property PACKAGE_PIN   B19       [get_ports cub[2]]
#set_property IOSTANDARD    LVCMOS18  [get_ports cub[*]]

#set_property PACKAGE_PIN   B17       [get_ports trst_n]
#set_property IOSTANDARD    LVCMOS18  [get_ports trst_n]

# QUESTION: not using these pins?
# set_property PACKAGE_PIN   C18       [get_ports hmc_tck]
# set_property IOSTANDARD    LVCMOS18  [get_ports hmc_tck]
# set_property PACKAGE_PIN   D16       [get_ports hmc_tdi]
# set_property IOSTANDARD    LVCMOS18  [get_ports hmc_tdi]
# set_property PACKAGE_PIN   C19       [get_ports hmc_tdo]
# set_property IOSTANDARD    LVCMOS18  [get_ports hmc_tdo]
# set_property PACKAGE_PIN   A17       [get_ports hmc_tms]
# set_property IOSTANDARD    LVCMOS18  [get_ports hmc_tms]

# set_property PACKAGE_PIN   AP18      [get_ports clk_nrst[0]]
# set_property PACKAGE_PIN   AM17      [get_ports clk_nrst[1]]
# set_property IOSTANDARD    LVCMOS18  [get_ports clk_nrst[*]]

# UltraScale FPGAs Transceivers Wizard IP core-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y12
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y12 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin R34 [get_ports gthrxn_in[0]]
#set_property package_pin R33 [get_ports gthrxp_in[0]]
#set_property package_pin T32 [get_ports gthtxn_out[0]]
#set_property package_pin T31 [get_ports gthtxp_out[0]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y13
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin N34 [get_ports gthrxn_in[1]]
#set_property package_pin N33 [get_ports gthrxp_in[1]]
#set_property package_pin P32 [get_ports gthtxn_out[1]]
#set_property package_pin P31 [get_ports gthtxp_out[1]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y14
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin L34 [get_ports gthrxn_in[2]]
#set_property package_pin L33 [get_ports gthrxp_in[2]]
#set_property package_pin M32 [get_ports gthtxn_out[2]]
#set_property package_pin M31 [get_ports gthtxp_out[2]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y15
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y15 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin J34 [get_ports gthrxn_in[3]]
#set_property package_pin J33 [get_ports gthrxp_in[3]]
#set_property package_pin K32 [get_ports gthtxn_out[3]]
#set_property package_pin K31 [get_ports gthtxp_out[3]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y16
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y16 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin G34 [get_ports gthrxn_in[4]]
#set_property package_pin G33 [get_ports gthrxp_in[4]]
#set_property package_pin H32 [get_ports gthtxn_out[4]]
#set_property package_pin H31 [get_ports gthtxp_out[4]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y17
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y17 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin F32 [get_ports gthrxn_in[5]]
#set_property package_pin F31 [get_ports gthrxp_in[5]]
#set_property package_pin G30 [get_ports gthtxn_out[5]]
#set_property package_pin G29 [get_ports gthtxp_out[5]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y18
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y18 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin E34 [get_ports gthrxn_in[6]]
#set_property package_pin E33 [get_ports gthrxp_in[6]]
#set_property package_pin D32 [get_ports gthtxn_out[6]]
#set_property package_pin D31 [get_ports gthtxp_out[6]]

# Commands for enabled transceiver GTHE3_CHANNEL_X0Y19
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X0Y19 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[4].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin C34 [get_ports gthrxn_in[7]]
#set_property package_pin C33 [get_ports gthrxp_in[7]]
#set_property package_pin B32 [get_ports gthtxn_out[7]]
#set_property package_pin B31 [get_ports gthtxp_out[7]]

