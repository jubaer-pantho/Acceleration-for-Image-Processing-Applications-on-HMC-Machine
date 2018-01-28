/*
* File Name     : rw_channel_wcrc.v
*
* Author        : Corey Olson
*
* Description   : This is just a wrapper module for the rw channel.  The
*                 only difference is that we have now removed the CRC from the
*                 rw channel, and we have placed it in this module.
*                 
*                 In this module, we want to compute the CRC without any flow
*                 control (to improve timing).  Therefore, we have the output
*                 from our rw channel flow through the CRC computation
*                 without any flow control.  We use a FIFO right before the
*                 output of this module to guarantee that we won't lose any
*                 data.
*                 
*                 Note that the CRC computed in this module does not include
*                 the final FLIT of a packet.  That must be added in later in
*                 the TX pipeline (in hmc_crc_seq_add).
*                 
*                 Note: the output FIFO in this module adds a LOT of extra
*                 buffering in our controller.  This might greatly increase
*                 the required size of the tx_buffer.
*
* Copyright     : 2015, Pico Computing, Inc.
*/
module rw_channel_w_crc # (
    parameter   PORT                = 1,
    parameter   NAME                = "rw_channel_w_crc",
    parameter   VERBOSE             = 1
) (
    input clk,
    input rst,

    input               user_clk,
    input               cmd_valid,
    output              cmd_ready,
    input    [2:0]      cub,    /* not used yet */
    input    [5:0]      tag,
    input               posted,
    input               mode,
    input               bwr,
    input               atomic,
    input               add8, // high: dual 8-byte add; low: single 16-byte add
    input   [33:0]      addr,
    input    [3:0]      size,
    input               wr,

    input  [127:0]      wr_data,
    input               wr_data_valid,
    output              wr_data_ready,

    output [127:0]  dout,
    output          flit_valid,
    input           flit_ready,
    output [3:0]    flit_remain,
    output          sof,
    output          eof
);
    
    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // synchronize the rst over to the user clock domain
    reg                 user_rst_1      = 0;
    reg                 user_rst_2      = 0;

    // after the rw channel
    wire    [127:0]     rw_dout;
    wire                rw_flit_valid;
    wire                rw_flit_ready;
    wire    [3:0]       rw_flit_remain;
    wire                rw_sof;
    wire                rw_eof;

    // we register all the signals from the rw channel module by 1 cycle
    // before feeding them into the CRC stuff
    reg     [127:0]     rw_dout_1;
    reg                 rw_flit_valid_1;
    reg     [3:0]       rw_flit_remain_1;
    reg                 rw_sof_1;
    reg                 rw_eof_1;
    
    // these are the crc's that we compute
    // this is the input to the crc module and the output from that module
    // we need to clear the input to 0 before the start of each packet
    reg     [31:0]      crc_i               = 0;
    wire    [31:0]      crc_o;
    
    // for most of these signals, this is just a pipeline stage. however, for
    // the dout, this is actually a mux.  we need to select the dout for most
    // of the data, but for our eof flit, we need to mux in our newly computed
    // crc
    reg     [127:0]     mux_dout;
    reg     [3:0]       mux_flit_remain;
    reg                 mux_sof;
    reg                 mux_eof;
    reg                 mux_valid;
    
    // registered versions of the signals above (to improve timing)
    reg     [127:0]     mux_dout_1;
    reg     [3:0]       mux_flit_remain_1;
    reg                 mux_sof_1;
    reg                 mux_eof_1;
    reg                 mux_valid_1;

    // our full and empty status signals for our output fifo
    wire                output_full;
    wire                output_almost_full;
    wire                output_empty;

    /////////////////
    // SYNCHRONIZE //
    /////////////////

    // sync the hmc node reset over to the user clock domain
    always @ (posedge user_clk) begin
        user_rst_1      <= rst;
        user_rst_2      <= user_rst_1;
    end

    ///////////////////
    // RW CHANNEL //
    ///////////////////

    // this is pretty much just the standard rw channel module, but we have
    // ripped out the CRC and tail information.
    // Note: we assume that the rw channel will never start a new packet
    // when flit_ready is low, but it may complete the current packet when
    // flit_ready gets deasserted
    rw_channel #(
        .PORT           (PORT),
        .VERBOSE        (VERBOSE)
    ) rw_channel (
        .clk            (user_clk),
        .rst            (user_rst_2),
        .cmd_valid      (cmd_valid),
        .cmd_ready      (cmd_ready),
        .cub            (cub),
        .tag            (tag),
        .posted         (posted),
        .mode           (mode),
        .bwr            (bwr),
        .wr             (wr),
        .atomic         (atomic),
        .add8           (add8),
        .addr           (addr),
        .size           (size),
        .wr_data        (wr_data),
        .wr_data_valid  (wr_data_valid),
        .wr_data_ready  (wr_data_ready),
        .dout           (rw_dout),
        .flit_valid     (rw_flit_valid),
        .flit_ready     (rw_flit_ready),
        .flit_remain    (rw_flit_remain),
        .sof            (rw_sof),
        .eof            (rw_eof)
    );
    assign  rw_flit_ready   = ~output_almost_full;

    // register the rw channel outputs to improve timing
    always @ (posedge user_clk) begin
        rw_dout_1           <= rw_dout;
        rw_flit_valid_1     <= rw_flit_valid;
        rw_flit_remain_1    <= rw_flit_remain;
        rw_sof_1            <= rw_sof;
        rw_eof_1            <= rw_eof;
    end

    /////////
    // CRC //
    /////////

    // we have moved the CRC here so we can completely avoid the flow control
    // (valid/ready) signals. it seems that we need to do this in order to
    // meet timing at 375 MHz
    hmc_crc hmc_crc (
        .data               (rw_dout_1),
        .crc_i              (crc_i),
        .crc_o              (crc_o)
    );

    // the block preceding this one computes the CRC, given 128-bit data and
    // a 32-bit current CRC as inputs.  this block remembers the current CRC
    // value to feed back to the input of the hmc_crc.
    // -we must start each packet with a CRC=0
    // Note: if we are still having trouble with timing in the CRC stuff, we
    // could require that the rw channel outputs 0s if it does not have
    // valid data.
    always @ (posedge user_clk) begin
        if (user_rst_2 || rw_eof_1) begin
            crc_i           <= 0;
        end else if (rw_flit_valid_1) begin
            crc_i           <= crc_o;
        end
    end
    
    // mux in the crc
    // for most of the packet, we just want to grab the whole flit
    // however, for the tail flit, we want to add the proper tail in,
    // including the CRC
    always @ (posedge user_clk) begin
        if (rw_eof_1) begin
            mux_dout        <= {crc_i, rw_dout_1[95:0]};
        end else begin
            mux_dout        <= rw_dout_1;
        end
        mux_flit_remain     <= rw_flit_remain_1;
        mux_sof             <= rw_sof_1;
        mux_eof             <= rw_eof_1;
        mux_valid           <= rw_flit_valid_1;
    end
    
    // just register all the mux signals 1 more cycle to improve timing
    always @ (posedge user_clk) begin
        mux_dout_1          <= mux_dout;
        mux_flit_remain_1   <= mux_flit_remain;
        mux_sof_1           <= mux_sof;
        mux_eof_1           <= mux_eof;
        mux_valid_1         <= mux_valid;
    end

    /////////////////
    // OUTPUT FIFO //
    /////////////////

    // this FIFO holds >= 1 packet.  we need this output FIFO, because we are
    // trying to ensure that our CRC stuff can be computed w/o flow control
    // (in order to improve timing)
    // Note: our ALMOST_FULL value says that the almostfull output will assert
    // when the FIFO contains >= ALMOST_FULL entries.  we use this to limit
    // the number of entries that this FIFO holds, which should limit the
    // required size increase to the tx buffer. we sized this to be able to
    // hold at least 2 full write packets of max size
    FIFO #(
        .SYNC           (0),
        .DATA_WIDTH     (1+1+4+128),
        .ALMOST_FULL    (20),
        .ALMOST_EMPTY   (4)
    ) output_packet_fifo (
        .rst            (1'b0),  // not used in async mode
        .clk            (1'b0),  // not used in async mode 

        .wr_clk         (user_clk),
        .wr_rst         (user_rst_2),
        .wr_en          (mux_valid_1),
        .din            ({mux_eof_1, mux_sof_1, mux_flit_remain_1, mux_dout_1}),
        .almostfull     (output_almost_full),
        .full           (output_full),

        .rd_clk         (clk),
        .rd_rst         (rst),
        .rd_en          (flit_ready),
        .dout           ({eof, sof, flit_remain, dout}),
        .almostempty    (),
        .empty          (output_empty)
    );
    assign  flit_valid  = ~output_empty;
    
    // watch the full signal on this fifo. ensure that we never try to write
    // this FIFO if it's already full
    always @ (posedge clk) begin
        if (mux_valid && output_full) begin
            $display("Tried to write the output FIFO when it was full in the rw channel module");
            $display("We were operating under the assumption that the output FIFO would never fill up");
            $stop;
        end
    end

endmodule
