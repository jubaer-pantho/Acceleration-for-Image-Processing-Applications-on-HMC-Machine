// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps
`include "hmc_def.vh"

module usr2flit #(parameter name = "", parameter verbose = 0, parameter PORT = 0) (
    input               clk,
    input               rst,

    input               user_clk,
    input               cmd_valid,
    output              cmd_ready,
    input    [5:0]      tag,
    input    [3:0]      cmd,
    input   [33:0]      addr,
    input    [3:0]      size,

    input  [127:0]      wr_data,
    input               wr_data_valid,
    output              wr_data_ready,

    output [127:0]      dout,
    output              flit_valid,
    input               flit_ready,
    output   [3:0]      flit_remain,
    output              flit_sof,
    output              flit_eof
);

    wire posted, atomic, add8, bwr, wr;
    wire [3:0] int_size;
    assign posted = cmd[3];
    assign atomic = cmd[2];
    assign add8   = cmd[1];
    assign bwr    = cmd[2:1] == 2'b01;
    assign wr     = cmd != `HMC_CMD_RD;
    assign int_size = |cmd[2:1] ? 4'h1 : size;
    
    // need to buffer the output to improve timing
    wire    [127:0]     dout_pre1;
    wire                flit_valid_pre1;
    wire                flit_ready_pre1;
    wire    [3:0]       flit_remain_pre1;
    wire                flit_sof_pre1;
    wire                flit_eof_pre1;

    // this channel handles both reads and writes
    rw_channel_w_crc # (
        .PORT(PORT),
        .VERBOSE(verbose)
    ) rwc (
        .clk(clk),
        .rst(rst),
        .user_clk(user_clk),
        .cmd_valid(cmd_valid),
        .cmd_ready(cmd_ready),
        .cub(3'h0),
        .tag(tag),
        .posted(posted),
        .mode(1'b0),
        .bwr(bwr),
        .atomic(atomic),
        .add8(add8),
        .addr(addr),
        .size(int_size),
        .wr(wr),
        .wr_data(wr_data),
        .wr_data_valid(wr_data_valid),
        .wr_data_ready(wr_data_ready),
        .dout(dout_pre1),
        .flit_valid(flit_valid_pre1),
        .flit_ready(flit_ready_pre1),
        .flit_remain(flit_remain_pre1),
        .sof(flit_sof_pre1),
        .eof(flit_eof_pre1)
    );

    // this buffer is here to improve timing by breaking the flit_ready
    // backpressure chain. this adds a little extra buffering and >= 1 cycle
    // of extra latency, but it should greatly improve the timing in this
    // system
    dual_buf #(
        .WIDTH                      (1+1+4+128)
    ) flit_buf (
        .clk                        (clk),
        .rst                        (rst),

        .data                       ({
                                    dout_pre1,
                                    flit_remain_pre1,
                                    flit_sof_pre1,
                                    flit_eof_pre1
                                    }),
        .data_valid                 (flit_valid_pre1),
        .data_ready                 (flit_ready_pre1),

        .q                          ({
                                    dout,
                                    flit_remain,
                                    flit_sof,
                                    flit_eof
                                    }),
        .q_valid                    (flit_valid),
        .q_ready                    (flit_ready)
    );

    reg [31:0] flit_count = 1;
    always @ (posedge clk) begin
        if (verbose) begin
            if (cmd_valid & cmd_ready) begin
                if (cmd[0]) $display("[%t] usr2flit latched last_offset %d", $time, size);
            end
            if (flit_valid && flit_ready) begin
                $display("[%t] FLIT COUNT: %d", $time, flit_count);
                flit_count <= flit_count + 1;
            end
        end
    end

endmodule
