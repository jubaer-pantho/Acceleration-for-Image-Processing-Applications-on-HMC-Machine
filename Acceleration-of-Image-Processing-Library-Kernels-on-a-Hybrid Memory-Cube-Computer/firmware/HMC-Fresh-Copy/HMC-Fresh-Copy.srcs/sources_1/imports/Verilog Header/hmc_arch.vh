// hmc_arch.vh
// this is where we list board-dependent architectural stuff
// Note: in particular, we should list if we are building using a half-width
// link or not 
// Note: default is to run full-width link using Altera toolchain

// rely upon our PicoDefines header file to tell us which board we are running
// on
`ifndef SIMULATION
`include "PicoDefines.v"
`endif

// EX-800
`ifdef PICO_MODEL_EX800

// M-510
`elsif PICO_MODEL_M510
    `define HALFLINK
`endif


