// hmc_cfg.vh - configuration settings for the HMC controller
// Copyright 2014 Pico Computing, Inc.



// enable a pkt_stat module that will monitor all rx traffic, before error checking, retry, etc.
// (e.g. this will see IRTRY packets, whereas the post-retry pkt_stat module won't.)
//`define ENABLE_PKT_STAT

// enable a pkt_stat module that looks at known-good packets after retries and error checking.
//`define ENABLE_PKT_STAT_POST_RETRY



// this turns on one flit logger each for the RX and TX traffic at the boundary between the controller and the HMC.
// (i.e. - this does not monitor any of the internal traffic in the controller.)
//`define ENABLE_BOUNDARY_FLIT_LOGGERS

// this turns on one flit logger for each TX and RX port
//`define ENABLE_PORT_FLIT_LOGGERS

// this turns on ALL possible flit_logger modules.
// this will cause a big increase in the size of the controller!
//`define ENABLE_ALL_FLIT_LOGGERS

// the number of elements to capture in the flit_loggers. the storage will be block rams.
// beware that the width of the data (> 700b) makes for a sensitive adjustment here.
`ifndef FLIT_LOGGER_DEPTH
    `define FLIT_LOGGER_DEPTH 512
`endif

`ifdef ENABLE_ALL_FLIT_LOGGERS
    `ifndef ENABLE_BOUNDARY_FLIT_LOGGERS
        `define ENABLE_BOUNDARY_FLIT_LOGGERS
    `endif
    `ifndef ENABLE_PORT_FLIT_LOGGERS
        `define ENABLE_PORT_FLIT_LOGGERS
    `endif
`endif



// enable error-injection points on the rx and tx interfaces of the controller, to simulate line errors.
// (useful for testing retry functionality, etc.)
//`define ENABLE_ERROR_INJECTORS



// enable the RX crc check.
`define ENABLE_RX_CRC










/****************************************************
 * Simulation-only overrides                        *
 * You probably don't need to change these settings *
 ****************************************************/

`ifdef SIMULATION
    `ifndef ENABLE_PKT_STAT
        `define ENABLE_PKT_STAT
    `endif
    `ifndef ENABLE_PKT_STAT_POST_RETRY
        `define ENABLE_PKT_STAT_POST_RETRY
    `endif
    `ifndef ENABLE_ERROR_INJECTORS
        `define ENABLE_ERROR_INJECTORS
    `endif
    `ifndef ENABLE_VERIFY_GC_TX
        `define ENABLE_VERIFY_GC_TX
    `endif
    `ifndef ENABLE_VERIFY_FLOW_CONTROL
        `define ENABLE_VERIFY_FLOW_CONTROL
    `endif
    `ifndef ENABLE_VERIFY_FIND_PKTS
        `define ENABLE_VERIFY_FIND_PKTS
    `endif
`endif //SIMULATION

