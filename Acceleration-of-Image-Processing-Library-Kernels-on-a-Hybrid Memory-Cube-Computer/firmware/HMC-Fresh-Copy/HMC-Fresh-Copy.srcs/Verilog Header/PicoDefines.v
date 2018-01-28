// PicoDefines.v - here we configure the base firmware for our project

// This includes a placeholder "user" module that you will replace with your code.
// To use your own module, just change the name from PicoBus128_counter to your
//   module's name, and then add the file to your ISE project.

//`define USER_MODULE_NAME gups_wrapper
`define USER_MODULE_NAME newGupsWrapper
`define XILINX_FPGA


`define ENABLE_HMC
`define PICOBUS_WIDTH 32

// User Definitions
`define GUPS_USE_HMC y

// We define the type of FPGA and card we're using.
`define PICO_MODEL_M510
`define PICO_FPGA_KU060

`include "BasePicoDefines.v"


