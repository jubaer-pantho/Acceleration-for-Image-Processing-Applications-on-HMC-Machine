// hmc_def.vh
// Copyright 2013 Pico Computing, Inc.
`include "hmc_arch.vh"

// controller version number
`define HMC_CTRL_VER        8'h40

/*  packet header format (common fields)
    [5:0]       CMD
    [6]         res
    [10:7]      LNG
    [14:11]     DLN
    [23:15]     TAG
    ( request-specific fields )
    [57:24]     ADDR
    [60:58]     res
    [63:61]     CUB
    ( response-specific fields )
    [32:24]     TGA
    [38:33]     res
    [41:39]     SLID
    [63:42]     res

    packet tail format (common fields)
    [7:0]       RRP
    [15:8]      FRP
    [18:16]     SEQ
    ...
    [31:27]     RTC
    [63:32]     CRC
    ( request-specific fields )
    [23:19]     res
    [26:24]     SLID
    ( response-specific fields )
    [19]        DINV
    [26:20]     ERRSTAT
*/

`define CMD_LEN_FIELD       10:7
`define CMD_DLN_FIELD       14:11

// commands
`define HMC_CMD_NULL        6'b000000
`define HMC_CMD_PRET        6'b000001
`define HMC_CMD_TRET        6'b000010
`define HMC_CMD_IRTRY       6'b000011
`define HMC_CMD_WR16        6'b001000
`define HMC_CMD_WR64        6'b001011
//... mode and non-posted atomics
`define HMC_CMD_P_WR16      6'b011000
`define HMC_CMD_P_WR32      6'b011001
`define HMC_CMD_P_WR48      6'b011010
`define HMC_CMD_P_WR64      6'b011011
`define HMC_CMD_P_WR80      6'b011100
`define HMC_CMD_P_WR96      6'b011101
`define HMC_CMD_P_WR112     6'b011110
`define HMC_CMD_P_WR128     6'b011111
//... posted atomics
`define HMC_CMD_RD16        6'b110000
`define HMC_CMD_RD32        6'b110001
`define HMC_CMD_RD48        6'b110010
`define HMC_CMD_RD64        6'b110011
`define HMC_CMD_RD80        6'b110100
`define HMC_CMD_RD96        6'b110101
`define HMC_CMD_RD112       6'b110110
`define HMC_CMD_RD128       6'b110111
//... mode rd
`define HMC_CMD_RD_RS       6'b111000
`define HMC_CMD_WR_RS       6'b111001
`define HMC_CMD_MD_RD_RS    6'b111010
`define HMC_CMD_MD_WR_RS    6'b111011
//... mode rd/wr resp
`define HMC_CMD_ERROR       6'b111110

// some defines that we need in our PHY based upon the configuration
`ifdef HALFLINK
`define LINKBITS 80
`define LANES 8
`else
`define LINKBITS 40
`define LANES 16
`endif

// user interface commands
`define HMC_CMD_RD          4'b0000     // read
`define HMC_CMD_WR          4'b1001     // posted write
`define HMC_CMD_R_WR        4'b0001     // non posted write
`define HMC_CMD_AT8         4'b1110     // posted atomic dual 8-byte add immediate
`define HMC_CMD_AT16        4'b1100     // posted atomic dual 16-byte add immediate
`define HMC_CMD_R_AT8       4'b0110     // non posted atomic dual 8-byte add immediate
`define HMC_CMD_R_AT16      4'b0100     // non posted atomic dual 16-byte add immediate
`define HMC_CMD_BW          4'b1010     // posted bit write
`define HMC_CMD_R_BW        4'b0010     // non posted bit write

// user interface commands
// (as listed in the user guide)
`define HMC_CMD_WR_NP       `HMC_CMD_R_WR
`define HMC_CMD_BW_NP       `HMC_CMD_R_BW
`define HMC_CMD_A16         `HMC_CMD_AT16
`define HMC_CMD_A16_NP      `HMC_CMD_R_AT16
`define HMC_CMD_A8          `HMC_CMD_AT8
`define HMC_CMD_A8_NP       `HMC_CMD_R_AT8


