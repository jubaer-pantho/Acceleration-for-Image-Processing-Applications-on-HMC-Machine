onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L gtwizard_ultrascale_v1_6_1 -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.gtwizard_ultrascale_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {gtwizard_ultrascale_0.udo}

run -all

quit -force
