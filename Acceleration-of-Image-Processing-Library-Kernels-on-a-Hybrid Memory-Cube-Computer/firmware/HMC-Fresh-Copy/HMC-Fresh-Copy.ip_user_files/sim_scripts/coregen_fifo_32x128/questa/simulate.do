onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib coregen_fifo_32x128_opt

do {wave.do}

view wave
view structure
view signals

do {coregen_fifo_32x128.udo}

run -all

quit -force
