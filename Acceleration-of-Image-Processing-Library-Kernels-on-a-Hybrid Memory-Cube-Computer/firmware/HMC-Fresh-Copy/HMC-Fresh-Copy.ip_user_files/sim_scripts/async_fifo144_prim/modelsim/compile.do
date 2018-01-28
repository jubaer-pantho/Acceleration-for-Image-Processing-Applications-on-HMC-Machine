vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../HMC-Fresh-Copy.srcs/sources_1/ip/async_fifo144_prim/async_fifo144_prim_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

