onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib gtwizard_ultrascale_l3_0_opt

do {wave.do}

view wave
view structure
view signals

do {gtwizard_ultrascale_l3_0.udo}

run -all

quit -force
