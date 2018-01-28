vlib work
vlib msim

vlib msim/gtwizard_ultrascale_v1_6_1
vlib msim/xil_defaultlib

vmap gtwizard_ultrascale_v1_6_1 msim/gtwizard_ultrascale_v1_6_1
vmap xil_defaultlib msim/xil_defaultlib

vlog -work gtwizard_ultrascale_v1_6_1 -64 -incr \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_bit_synchronizer.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gthe3_cpll_cal.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gthe3_cpll_cal_freq_counter.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_buffbypass_rx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_buffbypass_tx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_reset.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_userclk_rx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_userclk_tx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_userdata_rx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_gtwiz_userdata_tx.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_reset_synchronizer.v" \
"../../../ipstatic/gtwizard_ultrascale_v1_6_1/hdl/verilog/gtwizard_ultrascale_v1_6_reset_inv_synchronizer.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_v1_6_gthe3_channel.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gthe3_channel_wrapper.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_v1_6_gthe3_common.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gthe3_common_wrapper.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gtwizard_gthe3.v" \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0_gtwizard_top.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/gtwizard_ultrascale_0/sim/gtwizard_ultrascale_0.v" \

vlog -work xil_defaultlib "glbl.v"

