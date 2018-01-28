onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib pcie3_ultrascale_0_opt

do {wave.do}

view wave
view structure
view signals

do {pcie3_ultrascale_0.udo}

run -all

quit -force
