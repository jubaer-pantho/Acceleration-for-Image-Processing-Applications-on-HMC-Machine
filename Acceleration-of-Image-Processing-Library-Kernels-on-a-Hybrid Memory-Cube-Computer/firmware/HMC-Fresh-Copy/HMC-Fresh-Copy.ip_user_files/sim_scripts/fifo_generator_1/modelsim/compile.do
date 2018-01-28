vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

