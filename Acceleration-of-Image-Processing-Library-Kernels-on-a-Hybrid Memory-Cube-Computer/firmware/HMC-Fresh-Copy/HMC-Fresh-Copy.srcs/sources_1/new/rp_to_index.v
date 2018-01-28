/*
* File Name     : rp_to_index.v
*
* Author        : Corey Olson
*
* Description   : This module stores buffer indices, which are addressable by
*                 retry pointers.  During normal operation, we accept up to
*                 'FLITS' retry pointers and a single buffer index.  In the
*                 event of a retry, we will need to find the right buffer
*                 index for a given retry pointer. We also generate a replay
*                 mask when we find that buffer index, which asserts a bit if
*                 that flit should be replayed.
*
*                 We store our tx buffer locations in a simple memory, called
*                 'inx_mem', which is addressable by FRP or RRP.  For simplicity,
*                 we originally instantiated a full memory for each FLIT in our
*                 design.  This results in some wasted space (we have
*                 FLITS*(1<<RRP) entries instead of the minimum 1<<RRP
*                 entries), but let's not worry about that right now (since
*                 the total size is still only about 2k bits).
*
*                 Storing our tx buffer locations is pretty easy w/ FLITS
*                 memories.  If a FLIT has a valid FRP, we just write the tx
*                 buffer index to that FLIT's memory at address FRP.
*
*                 Reading the tx buffer index gets more complicated with FLITS
*                 parallel memories, since we don't know which one holds the
*                 current data.  We use a separate memory, called 'flit_mem',
*                 to store that information.  Note that our flit_mem is
*                 required to have FLITS write ports, in case we have 1 valid
*                 FRP on each FLIT in a single data beat.
*
*                 Due to the many write ports required, we split our flit_mem
*                 out into at least 'FLITS' memories.  Conversely from our
*                 'inx_mem', this time we do not have any extra data, as we now
*                 partition our address space for our flit_mem instead of
*                 having multiple copies of the entire memory.  Since we know
*                 that our writes in the same data beat will always be to
*                 sequential addresses, we partition our 'flit_mem' address
*                 space in a strided fashion.
*                 
*                 When we need to write new FRPs, we must first determine
*                 which 'flit_mem' partition they should target.  If we were
*                 to break our 'flit_mem' into exactly FLITS partitions, it
*                 would be very difficult to determine which partition an FRP
*                 should hit (e.g. if FLITS=5) without doing a full mod
*                 operation.  We instead break our flit_mem into
*                 1<<clogb2(FLITS) partitions (e.g. 8 partitions if FLITS=5).
*                 This makes determining the target partition quite easy for
*                 both reading and writing.
*
*                 After implementing the flit_mem, we realized that we can
*                 partition the 'inx_mem' in the same fashion.  This results in
*                 each partition being written AT MOST once per data beat, and
*                 we can easily identify which partition has the correct data
*                 when we need to read it.  We still need the 'flit_mem' in
*                 order to generate our output data mask, but we no longer
*                 have a read dependency between 'flit_mem' and 'inx_mem'.
*                 Partitioning 'inx_mem' in this fashion also saves us a lot of
*                 memory.  Before we had FLITS copies of 'inx_mem', but if we
*                 partition the address space, we only have 1 copy of 'inx_mem'.
*                 For example, if FLITS=5 and FRP_W=8, our total usage for
*                 'inx_mem' goes from ~11kb to ~2kb.
*                 
* Assumptions   : 1) Latency is not much of an issue for writing new FRPs or
*                    looking up a buffer index.
*                 2) We need to write a single buffer index for up to 'FLITS'
*                    FRPs each cycle.
*                 3) We will never overwrite an FRP location before we have
*                    used it, but someone else manages this.
*                 4) If we need to write > 1 FRP in a single data beat, they
*                    will be to FRPs that differ by < clogb2(FLITS)
*                    
* Optimizations : 1) We can probably get away with NUM_MEM / 2 memories
*                   ('inx_mem') here, because I think we can have 2 write ports
*                   per BRAM.
*
* Copyright     : 2014, Pico Computing, Inc.
*/

`include "hmc_def.vh"
`include "hmc_cfg.vh"

// we should uncomment the next line if we want to unconditionally write to
// our memories (flit_mem, inx_mem) every cycle.  otherwise we only write to
// the memories when new_frps_valid is asserted
//`define UNCONDITIONAL_WRITE

module rp_to_index #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter FLITS         = 5,                // the number of flits received on each beat
    parameter INX_W         = 9,                // the width of our buffer index
    parameter FRP_W         = 8,                // width of our forward retry pointers
    parameter RRP_W         = 8,                // width of our return retry pointers
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

    // this is the latched RRP value, which we need to look up when we need to
    // start a retry
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

    // this is the number of bits required to store our flit number
    localparam  F_W         = clogb2(FLITS);

    // this is the number of flit mem partitions that I need
    localparam  NUM_MEM     = 1<<F_W;

    // this is the number of address bits for each flit mem
    localparam  MEM_ADDR_W  = RRP_W - F_W;

    ///////////////
    // FUNCTIONS //
    ///////////////
    // computes ceil( log( x ) )
    function integer clogb2;
        input [31:0] value;
        begin
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
                value = value >> 1;
            end
        end
    endfunction
    
    // this accepts an FRP or RRP and determines which memory we should
    // either read or write
    function    [F_W-1:0]       RPToMem;
        input   [FRP_W-1:0]     rp;
        begin
            RPToMem             = rp & ((1<<F_W)-1);
        end
    endfunction
    
    // this accepts an FRP or RRP and computes the target address within
    // a flit memory partition
    function    [MEM_ADDR_W-1:0] RPToMemAddr;
        input   [FRP_W-1:0]     rp;
        begin
            RPToMemAddr         = rp >> F_W;
        end
    endfunction

    `include "hmc_func.h.v"

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////

    // we register some inputs here to ease timing
    // these are all the FRPs that we might need to write
    reg     [FRP_W-1:0]     frps_1      [0:FLITS-1];
    reg     [FLITS-1:0]     frps_we_1   = 0;
    reg     [INX_W-1:0]     frps_inx_1;
    reg     [F_W-1:0]       m_target_1  [0:FLITS-1];

    // we need to figure out which inx_mem our flit number should get written
    // to, based upon the frp
    // Note: in a single data beat, each inx_mem will be written by at MOST
    // 1 FRP
    reg     [F_W-1:0]       fm_src_2    [0:NUM_MEM-1];
    reg     [MEM_ADDR_W-1:0]fm_addr_2   [0:NUM_MEM-1];
    reg     [0:0]           fm_we_2     [0:NUM_MEM-1];
    (* keep = "true" *)
    reg     [INX_W-1:0]     frps_inx_2  [0:NUM_MEM-1];

    // we need a memory that will tell us which flit was the source for this
    // RRP.  we need that information in order to generate our output mask.
    // we may need to do up to 'FLITS' writes to this memory per clock cycle,
    // but we assume each partition will be written at MOST once per data
    // beat.
    // -assuming FLITS=5 and RRP_W=8, then this will take < 1k bits
    //reg     [F_W-1:0]       flit_mem    [0:(1<<MEM_ADDR_W)-1]   [0:NUM_MEM-1];

    // we partition our tx buffer index memory up the same way that we did our
    // flit memory.  in this way, we can guarantee that each partition will be
    // written at most once per clock cycle.  also, when we get a retry
    // request, we can easily determine which of these partitions has the
    // correct tx buffer index
    // -assuming INX_W=9 and RRP_W=8, then this will take about 2k bits total
    reg     [INX_W-1:0]     inx_mem     [0:(1<<MEM_ADDR_W)-1]   [0:NUM_MEM-1];

    // this is for the read datapath
    // we will first register the RRP (read pointer)
    // in order to compute our tx buffer index and our output flit mask, we
    // first must figure out which partition holds the valid data for this
    // given RRP.  We do that by computing rrp_in_m_1.  we also compute which
    // address within that partition to read (rrp_in_m_addr_1).
    // after we have the read address, we read all flit memory and tx buffer
    // index memory partitions in parallel.  we then select the right
    // partition using the computed partition number (select the right flit
    // number and tx buffer index). after that, we just need to compute our
    // output flit mask
    
    // these have 1 cycle of latency with respect to the input
    reg     [F_W-1:0]       rrp_in_m_1;
    reg     [MEM_ADDR_W-1:0]rrp_in_m_addr_1;

    // these have 2 cycles of latency with respect to the input
    reg     [F_W-1:0]       rrp_in_m_2;
    reg     [MEM_ADDR_W-1:0]rrp_in_m_addr_2;
    
    // these have 3 cycles of latency with respect to the input
    reg     [F_W-1:0]       flit_num    [0:NUM_MEM-1];
    reg     [INX_W-1:0]     inx         [0:NUM_MEM-1];
    reg     [F_W-1:0]       rrp_in_m_3;

    // these have 4 cycles of latency with respect to the input
    wire    [F_W-1:0]       flit_num_1  [0:NUM_MEM-1];
    wire    [INX_W-1:0]     inx_1       [0:NUM_MEM-1];
    reg     [F_W-1:0]       rrp_in_m_4;
    
    // these have 5 cycles of latency with respect to the input
    reg     [F_W-1:0]       flit_num_2;
    reg     [INX_W-1:0]     inx_2;
    
    // these have 6 cycles of latency with respect to the input
    reg     [INX_W-1:0]     inx_3;
    reg     [FLITS-1:0]     replay_mask;

    // 2 of our outputs are simply the delayed version of the rrp_in_valid
    // and the rrp_in signals
    // the suffix of these signals determines the latency (e.g. _1 = 1 cycle
    // of latency with respect to the rrp_in and rrp_in_valid signals)
    wire    [RRP_W-1:0]     rrp_in_0        = rrp_in;
    wire                    rrp_in_valid_0  = rrp_in_valid;
    reg     [RRP_W-1:0]     rrp_in_1;
    reg                     rrp_in_valid_1  = 0;
    reg     [RRP_W-1:0]     rrp_in_2;
    reg                     rrp_in_valid_2  = 0;
    reg     [RRP_W-1:0]     rrp_in_3;
    reg                     rrp_in_valid_3  = 0;
    reg     [RRP_W-1:0]     rrp_in_4;
    reg                     rrp_in_valid_4  = 0;
    reg     [RRP_W-1:0]     rrp_in_5;
    reg                     rrp_in_valid_5  = 0;
    reg     [RRP_W-1:0]     rrp_in_6;
    reg                     rrp_in_valid_6  = 0;
    
    integer                 f;

    /////////////////////////
    // REGISTER THE INPUTS //
    /////////////////////////

    // this is just here to ease timing in the system.  in the future, we may
    // want to even add some more pipelining to the write path
    always @ (posedge clk) begin

        // let's apply the frp_valid signal to our write enables
        if (new_frps_valid) begin
            frps_we_1       <= new_frps_map;
            if (verbose) $display("[%t] %s : cycle0 : Accepting new frps: map = 0x%0h, tx buf index = 0x%0h", $realtime, name, new_frps_map, new_frps_buf_inx);
        end else begin
            frps_we_1       <= 0;
        end
        
        // break the frps out into a 2D structure
        for (f=0; f<FLITS; f=f+1) begin
            frps_1  [f]     <= new_frps >> (f*FRP_W);
            if (new_frps_valid && new_frps_map[f] && verbose) $display("[%t] %s : cycle0 : Accepting new frp [%0d] = 0x%0h", $realtime, name, f, (new_frps>>(f*FRP_W)) & ((1<<FRP_W)-1));
        end
        
        // just register the buffer index that we will write for each of these
        // frps
        frps_inx_1          <= new_frps_buf_inx;
        for (f=0; f<NUM_MEM; f=f+1) begin
            frps_inx_2  [f] <= frps_inx_1;
        end
        
        // register our rrp in and rrp read signal
        rrp_in_1            <= rrp_in_0;
        rrp_in_2            <= rrp_in_1;
        rrp_in_3            <= rrp_in_2;
        rrp_in_4            <= rrp_in_3;
        rrp_in_5            <= rrp_in_4;
        rrp_in_6            <= rrp_in_5;
        if (rst) begin
            rrp_in_valid_1  <= 0;
            rrp_in_valid_2  <= 0;
            rrp_in_valid_3  <= 0;
            rrp_in_valid_4  <= 0;
            rrp_in_valid_5  <= 0;
            rrp_in_valid_6  <= 0;
        end else begin
            rrp_in_valid_1  <= rrp_in_valid_0;
            rrp_in_valid_2  <= rrp_in_valid_1;
            rrp_in_valid_3  <= rrp_in_valid_2;
            rrp_in_valid_4  <= rrp_in_valid_3;
            rrp_in_valid_5  <= rrp_in_valid_4;
            rrp_in_valid_6  <= rrp_in_valid_5;
        end
        if (rrp_in_valid && verbose) $display("[%t] %s : cycle0 : Retry seen! Accepting command to fetch buf index for RRP = 0x%0h", $realtime, name, rrp_in);
    end

    /////////////////////////
    // WRITE TO THE MEMORY //
    /////////////////////////
    
    // this is how we chop up our memory address space
    // go through each flit and determine which memory it should target
    // based upon the FRP
    always @ (*) begin
        for (f=0; f<FLITS; f=f+1) begin
            m_target_1      [f]                 = RPToMem(frps_1[f]);
        end
    end

    // here is where we compute the write enables, addresses, and data for our
    // memories
    // since we are targeting 1<<clogb2(FLITS) memories and we have FLITS
    // flits, now we have to remember which flit was the source flit.
    // that's no longer a static value.
    always @ (posedge clk) begin
        // start by clearing out the write enables for all the flit memories,
        // so we don't write things 2 cycles in a row (unless we mean to)
        for (f=0; f<NUM_MEM; f=f+1) begin
            fm_src_2        [f]                 <= 'hX;
            fm_addr_2       [f]                 <= 'hX;
            fm_we_2         [f]                 <= 0;
        end
        // now go through each flit and determine which flit memory we should
        // target
        for (f=0; f<FLITS; f=f+1) begin
            if (frps_we_1[f]) begin
                fm_src_2    [m_target_1[f]]     <= f;
                fm_addr_2   [m_target_1[f]]     <= RPToMemAddr(frps_1[f]);
                fm_we_2     [m_target_1[f]]     <= 1;
                if (verbose) $display("[%t] %s : cycle1 : Flit [%0d] with FRP 0x%0h targeting flit memory %0d at address 0x%0h", $realtime, name, f, frps_1[f], m_target_1[f], RPToMemAddr(frps_1[f]));
            end
        end
`ifdef UNCONDITIONAL_WRITE
        // if we want an unconditional write, then we should just set all the
        // write enables to 1
        for (f=0; f<NUM_MEM; f=f+1) begin
            fm_we_2         [f]                 <= 1;
        end
`endif
    end

    // now we can actually write our flit memory based upon the src flit
    // numbers that we computed (above)
    // Note: we use a BRAM module here, because the tools were having some
    // serious troubles inferring a block memory
    genvar m;
    generate for(m=0; m<NUM_MEM; m=m+1) begin: create_flit_mem
        BRAM #(
            .DATA_WIDTH             (F_W),
            .DATA_DEPTH             (1<<MEM_ADDR_W),
            .LOG_DATA_DEPTH         (MEM_ADDR_W),
            .LATCH_INPUT            ("YES")
        ) flit_mem (
            .wr_clk                 (clk),
            .wr_addr                (fm_addr_2  [m]),
            .wr_data                (fm_src_2   [m]),
            .wr_en                  (fm_we_2    [m]),

            .rd_clk                 (clk),
            .rd_addr                (rrp_in_m_addr_2),
            .rd_data                (flit_num_1 [m])
        );
    end endgenerate

    // we have NUM_MEM partitions, but at most FLITS of them will be written
    // in a given cycle. we do know that all partitions written in the same
    // cycle will be writing the same value
    generate for(m=0; m<NUM_MEM; m=m+1) begin: create_inx_mem
        BRAM #(
            .DATA_WIDTH             (INX_W),
            .DATA_DEPTH             (1<<MEM_ADDR_W),
            .LOG_DATA_DEPTH         (MEM_ADDR_W),
            .LATCH_INPUT            ("YES")
        ) inx_mem (
            .wr_clk                 (clk),
            .wr_addr                (fm_addr_2  [m]),
            .wr_data                (frps_inx_2 [m]),
            .wr_en                  (fm_we_2    [m]),

            .rd_clk                 (clk),
            .rd_addr                (rrp_in_m_addr_2),
            .rd_data                (inx_1      [m])
        );
    end endgenerate

    //////////////////////////
    // READ FROM THE MEMORY //
    //////////////////////////

    // when we get an rrp at the input, we should compute which flit memory we
    // will need to read from
    always @ (posedge clk) begin
        rrp_in_m_1          <= RPToMem      (rrp_in);
        rrp_in_m_2          <= rrp_in_m_1;
        rrp_in_m_3          <= rrp_in_m_2;
        rrp_in_m_4          <= rrp_in_m_3;
        rrp_in_m_addr_1     <= RPToMemAddr  (rrp_in);
        rrp_in_m_addr_2     <= rrp_in_m_addr_1;
        if (rrp_in_valid_1 && verbose) $display("[%t] %s : cycle1 : retry RRP = 0x%0h, target flit mem = %0d at address 0x%0h", $realtime, name, rrp_in_1, rrp_in_m_1, rrp_in_m_addr_1);
    end

    // we must first read from our flit_mem to get the flit number
    // in parallel, we read from rrp_in from all flit memories
    // we will then use the correct flit number (read out of flit_mem) to
    // select the right tx buffer address (read from mem)
    always @ (posedge clk) begin
        
        // read from all the flit memories and the tx buffer memories in parallel
        // Note: we do this in flit_mem and inx_mem (above)

        // select which of the flit memories we care about
        flit_num_2          <= flit_num_1                   [rrp_in_m_4];
        inx_2               <= inx_1                        [rrp_in_m_4];
        if (rrp_in_valid_5 && verbose) $display("[%t] %s : cycle5 : found our valid index 0x%0h from src flit %0d for RRP 0x%0h", $realtime, name, inx_2, flit_num_2, rrp_in_5);

        // here we are computing a replay mask based upon the flit number that
        // we looked up
        replay_mask         <= FillLeft5(1<<flit_num_2);
        inx_3               <= inx_2;

        if (inx_out_valid && verbose) $display("[%t] %s : cycle6 : RRP 0x%0h maps to buf index = 0x%0h, replay mask = 0x%0h", $realtime, name, rrp_out, inx_out, replay_mask_out);
    end

    // now we assign our output signals
    assign  rrp_out         = rrp_in_6;
    assign  inx_out         = inx_3;
    assign  inx_out_valid   = rrp_in_valid_6;
    assign  replay_mask_out = replay_mask;

    ///////////
    // DEBUG //
    ///////////

    // for now, we don't worry about the debug bus.  in the future, we may
    // want to let the debug bus probe this system
    assign  debug_dout      = 'h0;

endmodule
