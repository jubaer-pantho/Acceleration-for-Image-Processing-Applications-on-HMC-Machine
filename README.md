# Acceleration-of-Image-Processing-Library-Kernels-on-a-Hybrid-Memory-Cube-Computer

This work presents an HMC controller suitable for accelerating image processing applications on an HMC enabled CPU

The system is built on a host processor with 4 Micron AC-510 board attached to it through PCIe connections. Each unit features a Xilinx Kintex Ultrascale (XCVU060) FPGAs and an HMC memory 

Frameworks Used (Provided by Micron):
HMC_release_4.0
picocomputing 5.6.0.0




How to run:
1. Load the bitfile
2. Go to software directory
3. command: <./process 0>
4. Wait !!! Change the byte size in the writeram and readram function to get faster results. 

To build the Vivado Project:
1. Take the files under firmware directory
2. Replace the files in the 'GUPS' project with these ones. 


System Behavior:
The program reads the input image and inverts it on the FPGA. The inverted image is then read back to the desktop machine and displayed.


Disclaimer:
The image processing libraries used in this work are collected from the following link:
http://csce.uark.edu/~jgauch/
