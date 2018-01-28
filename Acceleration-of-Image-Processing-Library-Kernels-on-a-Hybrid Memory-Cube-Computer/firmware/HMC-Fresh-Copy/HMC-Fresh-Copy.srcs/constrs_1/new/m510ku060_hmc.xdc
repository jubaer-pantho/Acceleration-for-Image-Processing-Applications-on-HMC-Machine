
# L2

set_property package_pin   M5        [get_ports hmc_refclkn]
set_property package_pin   M6        [get_ports hmc_refclkp]

# HMC Power Save Pins
set_property PACKAGE_PIN   B16       [get_ports lxrxps]
set_property IOSTANDARD    LVCMOS18  [get_ports lxrxps]
set_property PACKAGE_PIN   D19       [get_ports lxtxps]
set_property IOSTANDARD    LVCMOS18  [get_ports lxtxps]

# HMC Control Signals
set_property PACKAGE_PIN   D15       [get_ports p_rst_n]
set_property IOSTANDARD    LVCMOS18  [get_ports p_rst_n]
set_property PACKAGE_PIN   A19       [get_ports ferr_n]
set_property IOSTANDARD    LVCMOS18  [get_ports ferr_n]

# HMC I2C
set_property PACKAGE_PIN   B14       [get_ports scl]
set_property IOSTANDARD    LVCMOS18  [get_ports scl]
set_property PULLUP        true      [get_ports scl]
set_property PACKAGE_PIN   A14       [get_ports sda]
set_property IOSTANDARD    LVCMOS18  [get_ports sda]
set_property PULLUP        true      [get_ports sda]

# TODO: these pins might get removed in the future
set_property PACKAGE_PIN   B15       [get_ports cub[0]]
set_property PACKAGE_PIN   C14       [get_ports cub[1]]
set_property PACKAGE_PIN   B19       [get_ports cub[2]]
set_property IOSTANDARD    LVCMOS18  [get_ports cub[*]]

set_property PACKAGE_PIN   B17       [get_ports trst_n]
set_property IOSTANDARD    LVCMOS18  [get_ports trst_n]

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

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y12 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin M1 [get_ports gthrxn_in[0]]
#set_property package_pin M2 [get_ports gthrxp_in[0]]
#set_property package_pin N3 [get_ports gthtxn_out[0]]
#set_property package_pin N4 [get_ports gthtxp_out[0]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y13
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin K1 [get_ports gthrxn_in[1]]
#set_property package_pin K2 [get_ports gthrxp_in[1]]
#set_property package_pin L3 [get_ports gthtxn_out[1]]
#set_property package_pin L4 [get_ports gthtxp_out[1]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y14
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin H1 [get_ports gthrxn_in[2]]
#set_property package_pin H2 [get_ports gthrxp_in[2]]
#set_property package_pin J3 [get_ports gthtxn_out[2]]
#set_property package_pin J4 [get_ports gthtxp_out[2]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y15
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y15 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[27].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin F1 [get_ports gthrxn_in[3]]
#set_property package_pin F2 [get_ports gthrxp_in[3]]
#set_property package_pin G3 [get_ports gthtxn_out[3]]
#set_property package_pin G4 [get_ports gthtxp_out[3]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y16
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y16 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[28].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin E3 [get_ports gthrxn_in[4]]
#set_property package_pin E4 [get_ports gthrxp_in[4]]
#set_property package_pin F5 [get_ports gthtxn_out[4]]
#set_property package_pin F6 [get_ports gthtxp_out[4]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y17
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y17 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[28].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin D1 [get_ports gthrxn_in[5]]
#set_property package_pin D2 [get_ports gthrxp_in[5]]
#set_property package_pin D5 [get_ports gthtxn_out[5]]
#set_property package_pin D6 [get_ports gthtxp_out[5]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y18
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y18 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[28].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin B1 [get_ports gthrxn_in[6]]
#set_property package_pin B2 [get_ports gthrxp_in[6]]
#set_property package_pin C3 [get_ports gthtxn_out[6]]
#set_property package_pin C4 [get_ports gthtxp_out[6]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y19
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y19 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[28].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin A3 [get_ports gthrxn_in[7]]
#set_property package_pin A4 [get_ports gthrxp_in[7]]
#set_property package_pin B5 [get_ports gthtxn_out[7]]
#set_property package_pin B6 [get_ports gthtxp_out[7]]

