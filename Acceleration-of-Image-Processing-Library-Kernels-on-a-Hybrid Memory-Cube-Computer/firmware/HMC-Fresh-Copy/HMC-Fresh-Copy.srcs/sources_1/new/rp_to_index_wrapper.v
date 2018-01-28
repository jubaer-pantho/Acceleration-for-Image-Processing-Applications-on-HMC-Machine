/*
* File Name     : rp_to_index_wrapper.v
*
* Description   : This is mainly just a wrapper for the rp_to_index module.
*                 The only thing that we do here is we enable our system to
*                 maintain an internal FRP that is larger than our RRP without
*                 loss of data.
*
*                 We do this by setting the RRP_W (in the standard rp_to_index
*                 module) equal to the FRP_W.  TODO
*
* Assumptions   : 1) FRP_W >= RRP_W
*
* Copyright     : 2015, Micron Inc.
*/
module rp_to_index_wrapper #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter INX_W         = 9,                // the width of our tx buffer index (index into a tx buffer row)
    parameter FRP_W         = 10,               // width of our internal forward retry pointers
    parameter RRP_W         = 8,                // width of our return retry pointers
    parameter BASE_ADDR     = 32'h4000,         // base address for the debug bus
    // DO NOT MODIFY BELOW THIS LINE
    parameter TOT_FRP_W     = FLITS*FRP_W       // width of all frps on our input bus
)
(
    input                   clk,
    input                   rst,

    // these are the new FRPs for packets that we are going to transmit
    input   [TOT_FRP_W-1:0] new_frps,
    input   [FLITS-1:0]     new_frps_map,
    input   [INX_W-1:0]     new_frps_buf_inx,
    input                   new_frps_valid,

    // these are our original FRPs that have been returned by the HMC
    // our slave captured these as RRPs and is now giving them to us
    // Note: assume these have already been synchronized to the tx_clk domain
    input   [7:0]           rx_rrp,
    input                   rx_rrp_valid,

    // this is the retry RRP value that we get from our RX datapath (when the
    // HMC sends IRTRY packets to our controller)
    input   [RRP_W-1:0]     rrp_in,
    input                   rrp_in_valid,

    // this is the buffer index that we have looked up for rrp_in
    // we also echo the rrp that we used to look this up
    output  [INX_W-1:0]     inx_out,
    output  [RRP_W-1:0]     rrp_out,
    output                  inx_out_valid,
    output  [FLITS-1:0]     replay_mask_out,

    // Debug Bus
    input                   debug_clk,
    input   [31:0]          debug_addr,
    input   [31:0]          debug_din,
    output  [31:0]          debug_dout,
    input                   debug_rd,
    input                   debug_wr
);
    ////////////////
    // PARAMETERS //
    ////////////////
    
    // this is our prefix width
    localparam  PREFIX_W    = FRP_W - RRP_W;
    
    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////

    // this is the RP prefix register that we need to maintain
    reg     [PREFIX_W-1:0]  rrp_prefix              = 0;
    reg     [PREFIX_W-1:0]  rrp_prefix_1;
    reg     [PREFIX_W-1:0]  rrp_prefix_2;
    wire    [PREFIX_W-1:0]  next_rrp_prefix         = rrp_prefix + 1;
    
    // latch our received rrp, so we know when it rolls over
    reg     [RRP_W-1:0]     rrp_latched             = 0;
    reg     [RRP_W-1:0]     rrp_latched_1;
    reg     [RRP_W-1:0]     rrp_latched_2;

    // this is the RP that we drive to our rp_to_index module
    reg     [FRP_W-1:0]     rrp_muxed;
    reg                     rrp_in_valid_1          = 0;

    // this lets us drive the rrp_muxed from software
    reg     [FRP_W-1:0]     rrp_soft;
    reg     [FRP_W-1:0]     rrp_soft_1;
    reg     [FRP_W-1:0]     rrp_soft_2;
    reg                     rrp_soft_valid          = 0;
    reg                     rrp_soft_valid_1        = 0;
    reg                     rrp_soft_valid_2        = 0;
    reg                     soft_override           = 0;
    reg                     soft_override_1         = 0;
    reg                     soft_override_2         = 0;

    // debug bus stuff
    reg     [31:0]          debug_dout_internal     = 0;
    wire    [31:0]          debug_dout_rp_to_index;

    ///////////
    // LOGIC //
    ///////////

    // -if we are using an internal FRP that is larger than the RRP on the
    // link, it is impossible to find the correct tx buffer location using
    // that smaller RRP
    // -we therefore use a prefix register to know which RRP to pass to the
    // rp_to_index module
    // example: FRP_W=9, RRP_W=8. if we receive rrp_in=1, do we pass
    // {1'b0, 8'h1} or
    // {1'b1, 8'h1}
    // to the rp_to_index module
    // -Now we will instead pass
    // {rrp_prefix, 8'h1}
    // -our prefix only needs to increment when our rrp rolls over
    // Note: we might need to detect rollover when rrp_in_valid is
    // asserted, but that requires further investigation.  if rrp_latched will
    // be updated before rrp_in_valid is asserted, then we don't have to
    // worry about that rollover case
    always @ (posedge clk) begin
        if (rst) begin
            rrp_prefix      <= 0;
        end else if (rx_rrp_valid && 
                    (rx_rrp < rrp_latched)) begin
            rrp_prefix      <= next_rrp_prefix;
            if (verbose) $display("[%t] %m rx_rrp=%x, rrp_latched=%x, updating rrp_prefix to %x", $time, rx_rrp, rrp_latched, next_rrp_prefix);
        end 
    end

    // need to remember our most recently received RRP so we can detect when
    // this thing rolls over
    always @ (posedge clk) begin
        if (rst) begin
            rrp_latched     <= 0;
        end else if (rx_rrp_valid) begin
            rrp_latched     <= rx_rrp;
            //if (verbose) $display("[%t] %m latching new rx_rrp value from %x to %x", $time, rrp_latched, rx_rrp);
        end
    end

    // this mux lets us either drive the rp_to_index inputs from the input to
    // this wrapper or from a register that we set via software
    // Note: the default behavior is to let the input rp's flow directly to
    // the rp_to_index module's inputs
    always @ (posedge clk) begin
        if (rst) begin
            rrp_muxed       <= 'hX;
            rrp_in_valid_1  <= 0;
        end else if (soft_override_2) begin
            rrp_muxed       <= rrp_soft_2;
            rrp_in_valid_1  <= rrp_soft_valid_2;
        end else begin
            rrp_muxed       <=  {
                                    rrp_prefix, 
                                    rrp_in
                                };
            rrp_in_valid_1  <= rrp_in_valid;
        end
        rrp_soft_1          <= rrp_soft;
        rrp_soft_2          <= rrp_soft_1;
        rrp_soft_valid_1    <= rrp_soft_valid;
        rrp_soft_valid_2    <= rrp_soft_valid_1;
        soft_override_1     <= soft_override;
        soft_override_2     <= soft_override_1;
    end

    /////////////////
    // RP TO INDEX //
    /////////////////
    
    // we only do a couple of special things when we instantiate the
    // rp_to_index module
    // 1) we set the RRP_W equal to the FRP_W
    // 2) we use our prefix when we pass the retry pointer
    rp_to_index #(
        .name               ({name,".rp_to_index"}  ),
        .verbose            (verbose                ),
        .FLITS              (FLITS                  ),
        .INX_W              (INX_W                  ),
        .FRP_W              (FRP_W                  ),
        .RRP_W              (FRP_W                  )
    ) rp_to_index_inst (
        .clk                (clk                    ),
        .rst                (rst                    ),
        
        .debug_clk          (debug_clk),
        .debug_rd           (debug_rd),
        .debug_wr           (debug_wr),
        .debug_addr         (debug_addr),
        .debug_din          (debug_din),
        .debug_dout         (debug_dout_rp_to_index),
        
        .new_frps           (new_frps               ),
        .new_frps_map       (new_frps_map           ),
        .new_frps_buf_inx   (new_frps_buf_inx       ),
        .new_frps_valid     (new_frps_valid         ),

        .rrp_in             (rrp_muxed              ),
        .rrp_in_valid       (rrp_in_valid_1         ),

        .inx_out            (inx_out                ),
        .rrp_out            (rrp_out                ),
        .inx_out_valid      (inx_out_valid          ),
        .replay_mask_out    (replay_mask_out        )
    );

    ///////////
    // DEBUG //
    ///////////

    // count the number of retries
    reg         [31:0]      cnt_retry;
    reg         [31:0]      cnt_retry_1;
    reg         [31:0]      cnt_retry_2;

    // remember the last input RP that was requested
    reg         [7:0]       rrp_in_latched;
    reg         [7:0]       rrp_in_latched_1;
    reg         [7:0]       rrp_in_latched_2;

    // remember the last expanded RP that we passed to the rp_to_index module
    reg         [31:0]      rrp_full_latched;
    reg         [31:0]      rrp_full_latched_1;
    reg         [31:0]      rrp_full_latched_2;

    // remember the last index + mask that came out of the rp_to_index module
    reg         [31:0]      out_latched;
    reg         [31:0]      out_latched_1;
    reg         [31:0]      out_latched_2;

    // count the number of indices that come out of the rp_to_index module
    reg         [31:0]      cnt_inx_out;
    reg         [31:0]      cnt_inx_out_1;
    reg         [31:0]      cnt_inx_out_2;

    // just expose the current value of some signals to the debug bus too
    reg         [31:0]      status;
    reg         [31:0]      status_1;
    reg         [31:0]      status_2;

    // all of our debug counters + latches here
    always @ (posedge clk) begin
        if (rst) begin
            cnt_retry       <= 'h0;
            cnt_inx_out     <= 'h0;
        end else begin
            cnt_retry       <= cnt_retry    + rrp_in_valid_1;
            cnt_inx_out     <= cnt_inx_out  + inx_out_valid;
        end
        if (rrp_in_valid_1) begin
            rrp_in_latched  <= rrp_muxed;
            rrp_full_latched<= rrp_muxed;
        end
        if (inx_out_valid) begin
            out_latched     <=  {
                                    inx_out,            // 25:16
                                    3'h0,               // 15:13
                                    replay_mask_out,    // 12:8
                                    rrp_out             // 7:0
                                };
        end
        status              <=  {
                                    4'h0,               // 31:16
                                    3'h0,               // 27:25
                                    inx_out_valid,      // 24
                                    3'h0,               // 23:21
                                    rx_rrp_valid,       // 20
                                    2'h0,               // 19:18
                                    rrp_in_valid_1,     // 17
                                    rrp_in_valid,       // 16
                                    16'h0               // 15:0
                                };
    end

    // synchronize over to the debug bus
    always @ (posedge debug_clk) begin
        cnt_retry_1         <= cnt_retry;
        cnt_retry_2         <= cnt_retry_1;

        rrp_in_latched_1    <= rrp_in_latched;
        rrp_in_latched_2    <= rrp_in_latched_1;

        rrp_full_latched_1  <= rrp_full_latched;
        rrp_full_latched_2  <= rrp_full_latched_1;

        out_latched_1       <= out_latched;
        out_latched_2       <= out_latched_1;

        cnt_inx_out_1       <= cnt_inx_out;
        cnt_inx_out_2       <= cnt_inx_out_1;
        
        status_1            <= status;
        status_2            <= status;

        rrp_prefix_1        <= rrp_prefix;
        rrp_prefix_2        <= rrp_prefix_1;

        rrp_latched_1       <= rrp_latched;
        rrp_latched_2       <= rrp_latched_1;
    end

    ///////////////
    // DEBUG BUS //
    ///////////////

    // just need to do reads in this module
    always @ (posedge debug_clk) begin
        if (debug_wr) begin
            debug_dout_internal <= 'h0;
            case (debug_addr)
                (BASE_ADDR+32'h60): rrp_soft            <= debug_din;
                (BASE_ADDR+32'h70): rrp_soft_valid      <= debug_din[0];
                (BASE_ADDR+32'h80): soft_override       <= debug_din[0];
            endcase
        end else if (debug_rd) begin
            debug_dout_internal <= 'h0;
            case (debug_addr)
                (BASE_ADDR+32'h00): debug_dout_internal <= status_2;
                (BASE_ADDR+32'h10): debug_dout_internal <= cnt_retry_2;
                (BASE_ADDR+32'h20): debug_dout_internal <= cnt_inx_out_2;
                (BASE_ADDR+32'h30): debug_dout_internal <= rrp_in_latched_2;
                (BASE_ADDR+32'h40): debug_dout_internal <= rrp_full_latched_2;
                (BASE_ADDR+32'h50): debug_dout_internal <= out_latched_2;
                (BASE_ADDR+32'h60): debug_dout_internal <= rrp_soft;
                (BASE_ADDR+32'h70): debug_dout_internal <= rrp_soft_valid;
                (BASE_ADDR+32'h80): debug_dout_internal <= soft_override;
                (BASE_ADDR+32'h90): debug_dout_internal <= rrp_prefix_2;
                (BASE_ADDR+32'hA0): debug_dout_internal <= rrp_latched_2;
            endcase
        end else begin
            debug_dout_internal <= 'h0;
        end
    end

    // just OR the output data together to assemble our final output data
    assign  debug_dout      =   debug_dout_internal     |
                                debug_dout_rp_to_index  ;
endmodule
