/*
 * File Name     : hmc_tx_buffer.v
 * 
 * Description   : This is a first-word-fall through FIFO that we use as our
 *                 transmit buffer.  This is a pretty simple FIFO, except for
 *                 the following:
 *                 1) in the event that this FIFO starts to fill up, due to
 *                 greater inflow than outflow, we assert a warning flag
 *                 (half_full) that tells the input to this FIFO to slow down.
 *                 2) in the event that we need to resend some of our TX
 *                 packets, we will get a start_retry flag asserted.  When
 *                 that happens, we assume that our downstream stuff does not
 *                 care about the data we are currently holding at the output
 *                 (dout).
 *                 3) When we get a start_retry, we should flag our current
 *                 location (in order to resume normal operation) and we
 *                 should roll our FIFO back to the spot pointed to by
 *                 start_retry_rp ASAP.
 *                
 * Copyright     : 2013, Pico Computing, Inc.
 */

module hmc_tx_buffer #(
    parameter name          = "",               // we'll preface our debugging display()s with this string
    parameter verbose       = 0,                // print out a bunch of info?
    parameter W             = 1                 // this is the width of the input data bus
)
(
    input                   clk,                // clock that this entire fifo is synchronous to
    input                   rst,                // synchronous reset

    input       [7:0]       start_retry_rp,
    input                   start_retry_valid,

    input       [W-1:0]     din,                // data to be written into the FIfo
    input                   wr_en,              // write enable signal
    output                  full,               // full status signal

    output  reg             half_full=0,

    output  reg [W-1:0]     dout,               // output data
    output  reg             dout_retry,         // is dout resent, or original data?
    output  reg             dout_retry_start,   // first beat of a retry
    output  reg             dout_retry_end,     // last beat of a retry
    input                   rd_en,              // read enable signal
    output  reg             empty=1             // empty status signal
);

    localparam DEPTH        = 256;

    reg     kickoff_retry;

    reg [7:0] rdptr = 0, wrptr = 0, fresh_ptr;
    wire[7:0] next_wrptr = wrptr + 1;
    wire[7:0] fullness = wrptr - rdptr;
    reg [W-1:0] bram [DEPTH-1:0];
    wire [7:0]  next_rdptr = rdptr + 1;
    // zero fifo contents for sim.
    integer i;
    initial begin
        for(i = 0; i < DEPTH; i = i + 1) bram[i] = 0;
    end

    // these are some status / control signals that we use when reading from
    // the bram 
    wire                bram_rd_en;
    wire                bram_empty;

    // this is my bram output register
    // i.e. when we read from the BRAM, the data goes into this register
    // Note: this is NOT my final output register
    reg     [W-1:0]     bram_dout;
    reg                 bram_dout_empty;
    wire                load_bram_dout;

    // these are my retry flags that are at the same timestep as the bram_dout
    // register
    reg                 dout_retry_pre1         = 0;
    reg                 dout_retry_start_pre1   = 0;
    reg                 dout_retry_end_pre1     = 0;

    // this control signal tells us when we are trying to load new data (from
    // the bram_dout reg) into our output register
    wire                load_dout;

    // in the event of a retry, we need to know where our new data starts
    // (data that has not yet been sent). we need to know this in order to
    // assert dout_retry_end at the same time as the last retried data. this
    // really only matters because we must be careful with our token counting
    // in the hmc_packet_issue; retried packets don't reduce our current token
    // count, because we have already accounted for those packets
    reg     [7:0]       bram_dout_rdptr;
    reg     [7:0]       dout_rdptr;

    // this flag remembers if our tx buffer EVER went full (since reset)
    // in the future, we might want to hang this on something like the PicoBus
    reg                 full_latched            = 0;

    // detect if we ever have a write error
    // we consider it a write error if we ever try to write to this buffer
    // when it's full
    reg                 wr_err_latched          = 0;

    // To control the read datapath, we need to manage the following flags
    // 1) rdptr 
    //      this is the read pointer. it refers to the next location in the
    //      BRAM that should be read. this has 0 knowledge of the output
    //      registers
    // 3) bram_empty
    //      this should be asserted whenever we have 0 valid entries in our
    //      bram. this has NO knowledge of the output buffers
    // 2) bram_out_empty
    //      our bram_out register has 1 cycle of read latency from the bram.
    //      this empty flag tells us if that register currently has any valid
    //      data or not
    // 3) empty
    //      our dout register has >= 2 cycles of read latency from the bram.
    //      this flag tells us if that register currently has any valid data
    //      or not
    assign  bram_empty  = (rdptr == wrptr);
    
    // fifo writing
    // Note: we assume that some other logic will ensure that this FIFO never
    // goes truly full.  we therefore can remove the !full condition from our
    // write statement, which should improve the timing on the input to this
    // buffer quite a bit.
    // Note: even though we don't do anything preventative if we were to
    // somehow go full, we do still detect that condition (see full_latched).
    always @(posedge clk) begin
        if(rst) begin
            wrptr <= 0;
        end else if(wr_en) begin
            bram[wrptr] <= din;
            wrptr <= next_wrptr;
        end
    end
    
    // our read datapath is a bit more complicated than the write. we try to
    // implement a first-word-fall-through FIFO here with 2 output registers.
    // we want 2 output registers (read latency from the BRAM to the output of
    // this module = 2) because the read timing out of the BRAM sucks.

    // fifo reading
    always @(posedge clk) begin
        if(rst) begin
            rdptr       <= 0;
            bram_dout           <= 'hX;
            bram_dout_rdptr     <= 'hX;
            bram_dout_empty     <= 1;
            dout_retry_pre1         <= 0;
            dout_retry_start_pre1   <= 0;
            dout_retry_end_pre1     <= 0;
        end else if (start_retry_valid) begin
            // we don't actually output any data this cycle, but we indicate (to ourself) that we're retrying, and
            //   mark that point at which the fresh data starts. in effect, we're doing a bit of the bookkeeping for
            //   the rest of the pipeline because it's convenient to do it here. that info is passed downstream by the
            //   dout_retry* signals.
            // (the reason for this is that the altera tools will not infer a bram if there's any combinational stuff
            //    feeding the address of the ram, even if the output is registered.)
            fresh_ptr           <= ~empty ? dout_rdptr : ~bram_dout_empty ? bram_dout_rdptr : rdptr;
            rdptr               <= start_retry_rp;
            bram_dout           <= 'hX;
            bram_dout_rdptr     <= 'hX;
            bram_dout_empty     <= 1;
            dout_retry_pre1     <= 1;
            kickoff_retry       <= 1;
            if (verbose) $display("[%t] %s : rewinding rdptr to 0x%x+1 for start_retry_valid. fresh_ptr:0x%x", $time, name, start_retry_rp, next_rdptr);
        end else if(bram_rd_en) begin
            rdptr               <= bram_empty ? rdptr : next_rdptr;
            bram_dout           <= bram[rdptr];
            bram_dout_rdptr     <= rdptr;
            bram_dout_empty     <= bram_empty;
            kickoff_retry       <= 0;
            dout_retry_start_pre1   <= kickoff_retry;
            dout_retry_end_pre1     <= 0;
            if (rdptr == fresh_ptr) begin
                if (dout_retry_pre1 && verbose)
                    $display("[%t] %s : data is fresh (non-retried) from this beat forward.", $time, name);
                dout_retry_pre1     <= 0;
            end
            if (dout_retry_pre1 && next_rdptr == fresh_ptr) begin
                dout_retry_end_pre1 <= 1;
            end
        end
    end
    assign  bram_rd_en          = bram_dout_empty | load_dout;
    
    // output register
    // this is our final output register.  from a high-level, it's pretty
    // simple.  whenever this register is empty or the output is reading the
    // data that we have within the dout register, we try to grab some new
    // data from the bram_dout register. the bram_dout register may have valid
    // data, or it may be empty...
    // when a retry comes along, we immediately stop what we are doing and
    // wait for some retry data to come from our BRAM. we assume someone else
    // makes sure that we didn't just break up a long packet (if that even
    // matters)
    always @ (posedge clk) begin
        if (rst) begin
            dout                <= 'hX;
            empty               <= 1;
            dout_rdptr          <= 'hX;
            dout_retry          <= 0;
            dout_retry_start    <= 0;
            dout_retry_end      <= 0;
        end else if (start_retry_valid) begin
            dout                <= 'hX;
            empty               <= 1;
            dout_rdptr          <= 'hX;
            dout_retry          <= 0;
            dout_retry_start    <= 0;
            dout_retry_end      <= 0;
        end else if (load_dout) begin
            dout                <= bram_dout;
            empty               <= bram_dout_empty;
            dout_rdptr          <= bram_dout_rdptr;
            dout_retry          <= dout_retry_pre1;
            dout_retry_start    <= dout_retry_start_pre1;
            dout_retry_end      <= dout_retry_end_pre1;
        end
    end
    assign  load_dout           = rd_en | empty;

    // flag creation
    assign full = next_wrptr == rdptr;
    always @ (posedge clk) begin
        // we don't need to worry too much about the cycle accuracy of the
        // half_full flag, because there's probably no harm in 1 cycle of
        // latency on a half full flag
        half_full               <= fullness[7];

        // -detect if full EVER gets asserted.  if so, we better remember, just
        // like an elephant
        // -detect if we ever tried to write to the memory when it was full
        if (rst) begin
            full_latched        <= 0;
            wr_err_latched      <= 0;
        end else if (full) begin
            full_latched        <= 1;
            if (wr_en) begin
                wr_err_latched  <= 1;
            end
        end
    end

    // debug print statements
    // -check that all empty and full signals are the same for all FIFOs
    // -check if we ever read from an empty fifo
    // -check if we ever write to a full fifo
    always @ (posedge clk) begin
        //$display("[%t] %s : tx buffer fullness: 0x%x, wrptr: 0x%x, rdptr: 0x%x, wr_en:%d, full:%d", $time, name, fullness, wrptr, rdptr, wr_en, full);
        if (verbose) begin
            if (wr_en && full)  $display("[%t] %s : wrote to a full fifo", $time, name);
            //if (rd_en && empty) $display("[%t] %s : read from an empty fifo", $time, name);
            if (wr_en & ~full) $display("[%t] %s : writing to tx_buffer addr 0x%x: 0x%x", $time, name, wrptr, din>>(W-640));
            if (rd_en & ~empty) $display("[%t] %s : reading from tx_buffer addr 0x%x: 0x%x", $time, name, rdptr, bram[rdptr]>>(W-640));
        end
    end

endmodule
