onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib async_fifo144_prim_opt

do {wave.do}

view wave
view structure
view signals

do {async_fifo144_prim.udo}

run -all

quit -force
