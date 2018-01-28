// reg_list.vh

`define GUPS_MAGIC_NUM                          32'H47555053 // GUPS IN ASCII
`define GUPS_VERSION_NUM                        32'H00020000 // VERISON 2.0.0

`define REG_GUPS_MAGIC(X)                       ((X) + 32'HFFF0)
`define REG_GUPS_VERSION(X)                     ((X) + 32'HFFF4)

`define REG_GUPS_CONTROL(X)                     ((X) + 32'H0000)
`define REG_GUPS_ITERATION_LIMIT(X)             ((X) + 32'H0004)
`define REG_GUPS_BURST_SIZE(X)                  ((X) + 32'H0008)
`define REG_GUPS_N_READ0(X)                     ((X) + 32'H0010)
`define REG_GUPS_N_READ1(X)                     ((X) + 32'H0014)
`define REG_GUPS_N_WRITE0(X)                    ((X) + 32'H0018)
`define REG_GUPS_N_WRITE1(X)                    ((X) + 32'H001C)
`define REG_GUPS_N_READ_DATA0(X)                ((X) + 32'H0020)
`define REG_GUPS_N_READ_DATA1(X)                ((X) + 32'H0024)

`define REG_GUPS_RD_TAG_BASE_ADDR(X)            ((X) + 32'H0100)
`define REG_GUPS_TAG_CONTROL(X)                 ((X) + 32'H0000)
`define REG_GUPS_TAG_WRITE(X)                   ((X) + 32'H0004)
`define REG_GUPS_TAG_USAGE(X)                   ((X) + 32'H0008)
`define REG_GUPS_TAG_MAX_LIFE(X)                ((X) + 32'H000C)
`define REG_GUPS_TAG_N_LOST(X)                  ((X) + 32'H0010)
`define REG_GUPS_TAG_LOST(X)                    ((X) + 32'H0014)
`define REG_GUPS_TAG_MIN_LATENCY_STOP(X)        ((X) + 32'H0018)
`define REG_GUPS_TAG_MIN_LATENCY(X)             ((X) + 32'H0020)
`define REG_GUPS_TAG_MAX_LATENCY(X)             ((X) + 32'H0024)
`define REG_GUPS_TAG_SUM_LATENCY0(X)            ((X) + 32'H0028)
`define REG_GUPS_TAG_SUM_LATENCY1(X)            ((X) + 32'H002C)

`define REG_GUPS_ADDR_GEN_BASE_ADDR(X)          ((X) + 32'H1000)
`define REG_GUPS_DATA_GEN0_BASE_ADDR(X)         ((X) + 32'H1100)
`define REG_GUPS_DATA_GEN1_BASE_ADDR(X)         ((X) + 32'H1200)

`define REG_GUPS_DATA_GEN_CONTROL(X)            ((X) + 32'H0000)
`define REG_GUPS_DATA_GEN_MASK0(X)              ((X) + 32'H0010)
`define REG_GUPS_DATA_GEN_MASK1(X)              ((X) + 32'H0014)
`define REG_GUPS_DATA_GEN_ANTI_MASK0(X)         ((X) + 32'H0018)
`define REG_GUPS_DATA_GEN_ANTI_MASK1(X)         ((X) + 32'H001C)
`define REG_GUPS_DATA_GEN_LINEAR_START0(X)      ((X) + 32'H0020)
`define REG_GUPS_DATA_GEN_LINEAR_START1(X)      ((X) + 32'H0024)
`define REG_GUPS_DATA_GEN_LINEAR_END0(X)        ((X) + 32'H0028)
`define REG_GUPS_DATA_GEN_LINEAR_END1(X)        ((X) + 32'H002C)
`define REG_GUPS_DATA_GEN_LINEAR_IV0(X)         ((X) + 32'H0030)
`define REG_GUPS_DATA_GEN_LINEAR_IV1(X)         ((X) + 32'H0034)
`define REG_GUPS_DATA_GEN_LINEAR_STEP(X)        ((X) + 32'H0038)
`define REG_GUPS_DATA_GEN_LFSR_FB0(X)           ((X) + 32'H0040)
`define REG_GUPS_DATA_GEN_LFSR_FB1(X)           ((X) + 32'H0044)
`define REG_GUPS_DATA_GEN_LFSR_IV0(X)           ((X) + 32'H0048)
`define REG_GUPS_DATA_GEN_LFSR_IV1(X)           ((X) + 32'H004C)

`define REG_GUPS_HMC_TEST_CONTROL(X)            ((X) + 32'H0200)
`define REG_GUPS_HMC_TEST_COMMAND(X)            ((X) + 32'H0204)
`define REG_GUPS_HMC_TEST_ADDR(X)               ((X) + 32'H0208)
`define REG_GUPS_HMC_TEST_SIZE(X)               ((X) + 32'H020C)
`define REG_GUPS_HMC_TEST_TAG(X)                ((X) + 32'H0210)
`define REG_GUPS_HMC_TEST_RD_DATA_BRAM_ADDR(X)  ((X) + 32'H0214)
`define REG_GUPS_HMC_TEST_RD_COUNT(X)           ((X) + 32'H0218)
`define REG_GUPS_HMC_TEST_WR_DATA0(X)           ((X) + 32'H0220)
`define REG_GUPS_HMC_TEST_WR_DATA1(X)           ((X) + 32'H0224)
`define REG_GUPS_HMC_TEST_WR_DATA2(X)           ((X) + 32'H0228)
`define REG_GUPS_HMC_TEST_WR_DATA3(X)           ((X) + 32'H022C)
`define REG_GUPS_HMC_TEST_RD_DATA0(X)           ((X) + 32'H0230)
`define REG_GUPS_HMC_TEST_RD_DATA1(X)           ((X) + 32'H0234)
`define REG_GUPS_HMC_TEST_RD_DATA2(X)           ((X) + 32'H0238)
`define REG_GUPS_HMC_TEST_RD_DATA3(X)           ((X) + 32'H023C)
`define REG_GUPS_HMC_TEST_RD_TAG(X)             ((X) + 32'H0240)
`define REG_GUPS_HMC_TEST_BRAM_WR_ADDR(X)       ((X) + 32'H0244)

`define PICO_READ(X,Y)                          if (PicoRd && PicoAddr==(X)) begin Y end
`define PICO_WRITE(X,Y)                         if (PicoWr && PicoAddr==(X)) begin Y end

`define PBREG(S,W) logic [(W)-1:0] S, S``_pb, S``_pbq

