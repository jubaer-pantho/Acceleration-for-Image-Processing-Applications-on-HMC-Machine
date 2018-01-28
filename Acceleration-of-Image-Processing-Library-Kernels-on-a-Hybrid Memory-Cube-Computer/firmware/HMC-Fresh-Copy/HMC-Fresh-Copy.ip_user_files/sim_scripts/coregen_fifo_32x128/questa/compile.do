vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/coregen_fifo_32x128/coregen_fifo_32x128_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

