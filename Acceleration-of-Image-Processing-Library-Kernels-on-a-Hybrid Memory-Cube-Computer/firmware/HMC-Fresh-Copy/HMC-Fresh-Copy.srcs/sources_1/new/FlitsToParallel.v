/*
* File Name     : FlitsToParallel.v
*
* Description   : This module accepts a serial stream of flits that form
*                 a packet.  We then pack them onto a parallel bus, which is
*                 most likely 5 FLITS wide.  We also know that we will be
*                 dumping our FLIT data onto the output bus for 2 cycles out
*                 of a 10 cycle period (i.e. 8 dead cycles, 2 valid cycles).
*                 
*                 The 'load' input is the one that tells us that we have
*                 access to the output bus.  This is asserted 1 cycles before
*                 our data should appear at the output.  For example, if load
*                 is asserted at t=0, our output data MUST be valid at t=1 and
*                 t=2.  Note that load will NOT be asserted at t=1. Note that
*                 LOAD_LAT specifies the number of cycles from the
*                 assertion of 'load' to when the data should be sampled at
*                 the output (must be >= 1).
*                 
*                 There are many different ways to pack flits onto our wide
*                 bus, but this is how we do it. The basic concept is simple,
*                 and we keep the datapath for the 128-bit FLITs pretty
*                 trivial.  We maintain a memory, which
*                 we call our flit_mem.  We write this memory with serial flit
*                 data, and we read it out in parallel.  We use a write
*                 pointer to track which entry in the memory should get
*                 written next.
*                 
*                 As we mentioned in the previous section, we keep the
*                 datapath for the FLITS really simple.  Whenever we are going
*                 to accept a new FLIT, we write it into our flit_mem at the
*                 location pointed to by our write pointer (no questions
*                 asked).  Later (after the assertion of the 'load' input) we
*                 will first read the LS 5 entries of flit_mem onto the output
*                 data bus.  In the next cycle, we read the MS 5 entries of
*                 flit_mem onto the output data bus.  Note that we are ONLY
*                 talking about the data thus far, not the sideband signals
*                 (e.g. sof, eof, len, etc.).  In this manner, the datapath
*                 through this module is very simple.
*                 
*                 One thing that we need to be very careful about is the
*                 assertion of the load signal, which could happen at any
*                 time.  We need to make sure that we will NEVER output any
*                 partial packets.  We do this through careful control of the
*                 present_map, sof_map, and eof_map flags, which is why the
*                 control logic in this module cannot be as simple as the
*                 datapath.
*                 
*                 To ensure that we don't output any partial packets, we keep
*                 2 separate books (i.e. versions of the pkt_map, sof_map,
*                 eof_map, etc. registers).  We call the first one the 'new'
*                 books, which contains brand new packets that we are
*                 accepting into this module from the input.  The flit data
*                 flows right into our flit memory (flit_mem), but the
*                 sideband data flows into our '_new' books until we have
*                 received the full packet.  Upon receipt of a full packet, we
*                 hand off the sideband signals to a production ready version
*                 of the sideband signals that we call the '_reg' books.
*                 
*                 The '_reg' books have to be perfect at all times, because
*                 load could be asserted in any clock cycle, and we have to be
*                 ready to output our current data 1 cycle after load is
*                 asserted.  That's why we need a separate version of the
*                 books, which are allowed to be in a funky state while we are 
*                 accepting a next packet.
*
*                 Note that this is specifically designed for N_FLITS=5,
*                 BUF_SIZE=10, and number of active data beats=2.
*
* Assumptions   : A1) If our present_map bit for a particular flit is not set,
*                     the output data (on our dout bus) can be non-zero, and
*                     it will be masked off by something later down the
*                     pipeline.
*                 A2) whenever we are granted access to the output data bus,
*                     we get it for exactly 2 clock cycles.
*                 A3) we can dump data (non-zero data) onto the output bus,
*                     even if its not our turn. i.e. our output data can be
*                     non-zero, and whatever usually looks at our output data
*                     will just ignore the data if its not our turn
*                 A4) if we are accepting a multi-flit packet on the input,
*                     it's possible to see dead cycles between valid FLITs
*
* Copyright     : 2015, Micron Inc.
*/
module FlitsToParallel #(
    parameter   N_FLITS             = 5,
    parameter   BUF_SIZE            = 10,
    parameter   LOAD_LAT            = 2,
    parameter   NAME                = "FlitsToParallel",
    parameter   VERBOSE             = 1
)
(
    input                           clk,
    input                           rst,
    
    input                           flit_valid,
    output                          flit_ready,
    input       [127:0]             flit,
    input       [3:0]               flit_remain,
    input                           flit_sof,
    input                           flit_eof,

    output  reg [639:0]             dout,
    output  reg [N_FLITS-1:0]       present_map,
    output  reg [N_FLITS-1:0]       sof_map,
    output  reg [N_FLITS-1:0]       eof_map,
    output  reg [N_FLITS*4-1:0]     len,
    output      [N_FLITS*4-1:0]     len_eof,
    output  reg                     pkt_carry,
    input                           load
);

    //////////////////////
    // INTERNAL SIGNALS //
    //////////////////////
    
    // these are registered versions of the inputs. notice that we don't have
    // any backpressure built into this. we therefore consider these to be
    // qualified signals, hence the '_q' suffix.
    reg                             flit_valid_q    = 0;
    reg         [127:0]             flit_q          = 'h0;
    reg         [3:0]               flit_remain_q   = 'h0;
    reg                             flit_sof_q      = 0;
    reg                             flit_eof_q      = 0;

    // this is our registered version of the 'load' input
    // Note that we index this by the number of cycles of latency with
    // respect to the input.  for example, load_q[0] is the same as load,
    // while load_q[1] is 1 cycle delayed
    reg         [LOAD_LAT:0]        load_in         = 0;
    reg         [LOAD_LAT:0]        load_q          = 0;

    // this is the memory that we use as our serial write, parallel read
    // memory.  we write our flits into this memory (at the entry pointed to
    // by the wrptr), and we read multiple flits out in the same clock cycle
    // (when load is asserted).  Since we need to read 5 FLITS at a time, this
    // will likely be implemented in LUTs.
    reg         [127:0]             flit_mem        [0:BUF_SIZE-1];
    integer                         f;
    
    // these are the mask bits that we maintain (before we output them). we
    // pretty much keep these in lock-step with the data in the shifter. the
    // only difference is that once we output our parallel flits, we better
    // clear out the respective bits from these registers
    reg         [BUF_SIZE-1:0]      pkt_map_buf     = 0;
    reg         [BUF_SIZE-1:0]      sof_map_buf     = 0;
    reg         [BUF_SIZE-1:0]      eof_map_buf     = 0;
    reg         [BUF_SIZE*4-1:0]    len_buf         = 0;
    reg         [BUF_SIZE-1:0]      carry_buf       = 0;
    
    // these are the same sideband flags as shown in the previous block, but
    // these are a separate set of flags for partial packets that have not yet
    // fully been accepted yet
    reg         [BUF_SIZE-1:0]      pkt_map_new     = 0;
    reg         [BUF_SIZE-1:0]      sof_map_new     = 0;
    reg         [BUF_SIZE-1:0]      eof_map_new     = 0;
    reg         [BUF_SIZE*4-1:0]    len_new         = 0;
    reg         [BUF_SIZE-1:0]      carry_new       = 0;
    
    // this is the full version of the signals shown in the previous block.
    // the reason that we need this is because we include the inputs (e.g.
    // flit_valid, flit_sof, flit_eof) in this, whereas they were omitted from
    // the 'new' buffers
    wire        [BUF_SIZE-1:0]      next_pkt_map_new;
    wire        [BUF_SIZE-1:0]      next_sof_map_new;
    wire        [BUF_SIZE-1:0]      next_eof_map_new;
    wire        [BUF_SIZE*4-1:0]    next_len_new;
    wire        [BUF_SIZE-1:0]      next_carry_new;

    // this flag tells us if our pkt_map_new, sof_map_new, eof_map_new, etc.
    // registers ONLY contain full packets
    // Note: we consider an empty register as containing only full packets
    reg                             only_full_pkts  = 1;

    // this flag tells us if our '_new' register have ANY flits, not just full
    // packets
    reg                             has_new_pkts    = 0;

    // this flag tells us when we should load the next packet data from
    // next_pkt_map_new, next_sof_map_new, etc. into the respective buffers
    wire                            pass_new_to_buf;

    // this is a bitmap that we will use when clearing the output pkt_map,
    // sof_map, and eof_map registers. if a bit is set for this regster, we
    // want to clear the respective bit in ALL of these:
    // -pkt_map
    // -sof_map
    // -eof_map
    // -carry
    reg         [BUF_SIZE-1:0]      map_clear       = 0;
    reg         [4*BUF_SIZE-1:0]    len_clear       = 0;
    integer                         l;
    integer                         b;

    // this pointer tracks the next entry in flit_mem that should be written.
    // this pointer gets cleared to 0 whenever load is asserted
    // Note: wrptr_len uses more bits, because we use that one when shifting
    // our len register, which uses 4 bits per entry (hence the 2 extra bits
    // in our write pointer for that register).
    reg         [3:0]               wrptr           = 0;
    reg         [3:0]               wrptr_1         = 0;
    wire        [5:0]               wrptr_len       = wrptr;
    
    // this is basically the inverse of the write pointer.  this tracks the
    // number of free entries that still exist in our memory.
    reg         [3:0]               num_free        = 0;
    
    // this flag tracks whether we are in the middle of a packet or not
    reg                             mid_packet      = 0;
    reg                             mid_packet_1    = 0;

    // this flag tells when we should reset our write pointer.  this is
    // primarily driven by the 'load' input, but there may be some special
    // cases where we don't want to reset the pointer back to 0, even if load
    // is asserted
    wire                            clear_wrptr;

    // just a debugging flag that tells us when we just loaded some new data
    // into the memory (1 cycle ago)
    reg                             flit_loaded     = 0;
    
    // this flag tells us if we are about to start a multi-flit packet. it can
    // be very useful, mostly for flow control stuff.
    wire                            start_multi_flit;

    // just a simple helper flag that gets asserted if we are accepting a new
    // flit on the very input to this module
    wire                            accepting_flit;

    //////////////
    // DATAPATH //
    //////////////

    // WRITING

    // we first register our input flit data, assuming that we are ready to
    // accept it.  after this point, we are going to write flit_mem, no
    // questions asked.
    // Note: this pipeline register should greatly improve timing
    always @ (posedge clk) begin
        if (rst) begin
            flit_valid_q            <= 0;
            flit_q                  <= 'hX;
            flit_remain_q           <= 'hX;
            flit_sof_q              <= 'hX;
            flit_eof_q              <= 'hX;
        end else if (accepting_flit) begin
            flit_valid_q            <= 1;
            flit_q                  <= flit;
            flit_remain_q           <= flit_remain;
            flit_sof_q              <= flit_sof;
            flit_eof_q              <= flit_eof;
        end else begin
            flit_valid_q            <= 0;
            flit_q                  <= 'hX;
            flit_remain_q           <= 'hX;
            flit_sof_q              <= 'hX;
            flit_eof_q              <= 'hX;
        end
    end

    // we don't try to compute any of the sideband data here. we just simply
    // write our normal 128-bit data to our memory in this section.
    // Note: we assume the wrptr is governing the first register stage in this
    // module. that's why we use a 1 cycle delayed version of that write
    // pointer to actually write this memory
    always @ (posedge clk) begin
        if (flit_valid_q) begin
            flit_mem    [wrptr_1]   <= flit_q;
        end
    end

    // READING

    // reading data out of this memory is quite simple. we just read out of
    // our flit buffer.
    // TODO: it might help timing here if we could pipeline this datapath
    // a bit more, but that would require that our arbiter asserts the 'load'
    // signal >= 1 cycle earlier
    always @ (posedge clk) begin
        if (rst) begin
            dout                    <= 'hX;
            present_map             <= 'h0;
            sof_map                 <= 'h0;
            eof_map                 <= 'h0;
            len                     <= 'hX;
            pkt_carry               <= 0;
        end else if (load_q[1]) begin
            dout                    <= {
                                        flit_mem    [9],
                                        flit_mem    [8],
                                        flit_mem    [7],
                                        flit_mem    [6],
                                        flit_mem    [5]
                                       };
            present_map             <= pkt_map_buf  [9:5];
            sof_map                 <= sof_map_buf  [9:5];
            eof_map                 <= eof_map_buf  [9:5];
            len                     <= len_buf      [10*4-1:5*4];
            pkt_carry               <= 0;
        end else begin
            dout                    <= {
                                        flit_mem    [4],
                                        flit_mem    [3],
                                        flit_mem    [2],
                                        flit_mem    [1],
                                        flit_mem    [0]
                                       };
            present_map             <= pkt_map_buf  [4:0];
            sof_map                 <= sof_map_buf  [4:0];
            eof_map                 <= eof_map_buf  [4:0];
            len                     <= len_buf      [5*4-1:0*4];
            pkt_carry               <= carry_buf    [4];
        end
    end

    /////////////
    // CONTROL //
    /////////////

    // maintain our write pointer here. this is kinda complicated.  basically,
    // if we are accepting a new flit, we should probably increment the write
    // pointer.  the complicated part is, "how do we know when we should reset
    // the write pointer to the start of our buffer?" check out the
    // clear_wrptr signal for that discussion.
    always @ (posedge clk) begin
        if (rst) begin
            wrptr                   <= 0;
            num_free                <= BUF_SIZE;
        end else if (clear_wrptr) begin
            wrptr                   <= 0;
            num_free                <= BUF_SIZE;
        end else if (accepting_flit) begin
            wrptr                   <= wrptr + 1;
            num_free                <= num_free - 1;
        end
        wrptr_1                     <= wrptr;
    end

    // here we track the sideband flags for ALL incoming packets. we make sure
    // that we receive an entire packet before we update ANY of the '_map'
    // registers (e.g. pkt_map, sof_map, eof_map). the purpose of this stage
    // is so we NEVER output any partial packets. Note that the output has
    // ZERO knowledge of these.  they will never see the light of day until
    // they are first passed to the pkt_map_buf, sof_map_buf, eof_map_buf,
    // etc. registers, which are the REAL, production-ready versions of these
    // signals
    always @ (posedge clk) begin
        if (rst) begin
            pkt_map_new             <= 'h0;
            sof_map_new             <= 'h0;
            eof_map_new             <= 'h0;
            len_new                 <= 'h0;
            carry_new               <= 'h0;
            only_full_pkts          <= 1;
            has_new_pkts            <= 0;
        end else if (pass_new_to_buf) begin
            pkt_map_new             <= accepting_flit ? next_pkt_map_new    : 'h0;
            sof_map_new             <= accepting_flit ? next_sof_map_new    : 'h0;
            eof_map_new             <= accepting_flit ? next_eof_map_new    : 'h0;
            len_new                 <= accepting_flit ? next_len_new        : 'h0;
            carry_new               <= accepting_flit ? next_carry_new      : 'h0;
            only_full_pkts          <= accepting_flit ? flit_eof            : 1;
            has_new_pkts            <= accepting_flit;
        end else if (accepting_flit) begin
            pkt_map_new             <= pkt_map_new  |   next_pkt_map_new;
            sof_map_new             <= sof_map_new  |   next_sof_map_new;
            eof_map_new             <= eof_map_new  |   next_eof_map_new;
            len_new                 <= len_new      |   next_len_new;
            carry_new               <= carry_new    |   next_carry_new;
            only_full_pkts          <= flit_eof;
            has_new_pkts            <= 1;
        end
    end
    
    // in this section, we maintain our actual sideband flags, which are
    // totally ready to be outputted (whenever 'load' is asserted). we only
    // update these flags once a FULL packet has been received on the input.
    // that's how we prevent sending out partial packets.
    // Note: I think we run into problems here if we update these around the
    // time when 'load' is asserted
    always @ (posedge clk) begin
        if (rst) begin
            pkt_map_buf             <= 'h0;
            sof_map_buf             <= 'h0;
            eof_map_buf             <= 'h0;
            len_buf                 <= 'h0;
            carry_buf               <= 'h0;
        end else if (pass_new_to_buf) begin
            pkt_map_buf             <= (pkt_map_buf & ~map_clear) | pkt_map_new;
            sof_map_buf             <= (sof_map_buf & ~map_clear) | sof_map_new;
            eof_map_buf             <= (eof_map_buf & ~map_clear) | eof_map_new;
            len_buf                 <= (len_buf     & ~len_clear) | len_new;
            carry_buf               <= (carry_buf   & ~map_clear) | carry_new;
        end else begin
            pkt_map_buf             <= pkt_map_buf  & ~map_clear;
            sof_map_buf             <= sof_map_buf  & ~map_clear;
            eof_map_buf             <= eof_map_buf  & ~map_clear;
            len_buf                 <= len_buf      & ~len_clear;
            carry_buf               <= carry_buf    & ~map_clear;
        end
    end

    // basically, we can always accept new data into our memory as
    // long as our memory has room for it. we do however need to be careful
    // that we will not be overwriting some valid entries (need to look at
    // both pkt_buf & pkt_new to see all the valid entries).
    // we also need to be careful to not accept more data if that would result 
    // in a R/W collision.
    // Note: we assume flit_remain will always be < BUF_SIZE
    assign  flit_ready              = (flit_remain <= num_free);

    /////////////
    // HELPERS //
    /////////////

    // this section computes a bunch of status flags and registers that don't
    // directly drive any datapath or directly control the flow of data.
    // however, these make the control logic much simpler.

    // this flag just says if we are accepting a new flit on the input
    // it's pretty simple logic, but it's easier to have something like this
    // than to say 'flit_valid & flit_ready' EVERYWHERE
    assign  accepting_flit          = flit_valid & flit_ready;
    
    // when we add data into the pkt_map_new, sof_map_new, eof_map_new, etc.
    // buffers (above) we need to make sure we first shift that new data into
    // the correct position (as defined by the write pointer).  we try to do
    // that cleanly here.
    assign  next_pkt_map_new        = ( flit_valid      <<  wrptr);
    assign  next_sof_map_new        = ( flit_sof        <<  wrptr);
    assign  next_eof_map_new        = ( flit_eof        <<  wrptr);
    assign  next_len_new            = ( flit_remain     << (wrptr_len<<2));
    assign  next_carry_new          = ((flit_remain!=1) <<  wrptr);

    // we know that we can pass our data from pkt_map_new, sof_map_new,
    // eof_map_new, etc. registers to pkt_map_buf, sof_map_buf, eof_map_buf,
    // etc. (respectively) when this flag is asserted. the reason that we have
    // to pay attention to the load signal here is in case we have a packet
    // that we are trying to hand from '_new' to '_buf' that spans multiple
    // data beats.  we MUST ensure that we correctly output our entire new
    // packet, not just the FLITs that happen to be on the 2nd data beat.
    // Note: this assumes a read latency of 1. if that changes, we will likely
    // have to update this logic.
    assign  pass_new_to_buf         = only_full_pkts & ~load_q[0];

    // register our load input and form a register (load_q) such that we can
    // address it based upon the number of cycles of latency that we want.
    // think of load_in as just a simple shift register for the 'load' input
    always @ (posedge clk) begin
        if (rst) begin
            load_in                 <= 0;
        end else begin
            load_in                 <= (load_in << 1) | load;
        end
    end
    always @ (*) begin
        load_q                      =  (load_in << 1) | load;
    end

    // this combinational bus just helps us to determine which bits of the
    // sideband signals (sof, pkt, eof) should get cleared.  Note that we
    // should clear those signals when they are read out of our memory (i.e.
    // when load_q[0] or load_q[1] is asserted).
    always @ (*) begin
        map_clear                   = 'h0;
        if (load_q[0]) begin
            map_clear   [4:0]       = pkt_map_buf   [4:0];
        end else if (load_q[1]) begin
            map_clear   [9:5]       = pkt_map_buf   [9:5];
        end
    end

    // this is really similar to the map clear, but it's designed for the
    // len[] array, which is 4 bits per entry. we therefore stretch each bit
    // from map_clear into 4 bits of len_clear
    always @ (*) begin
        for (l=0; l<BUF_SIZE; l=l+1) begin
            for (b=0; b<4; b=b+1) begin
                len_clear   [4*l+b] = map_clear [l];
            end
        end
    end

    // this flags tells when its safe to reset the write pointer to the start
    // of our memory. we better make sure that we don't reset this until we
    // are sure that our data (currently in our memory) is not going to be
    // overwritten (i.e. lost). also, we need to be very careful to not break
    // up packets by clearing the write pointer to 0 before we have
    // accepted an entire packet. i.e. we don't want the first part of our
    // packet at the end of our buffer w/ the end of the packet at the start
    // of our buffer.
    assign  clear_wrptr             = load_q[0] & ~accepting_flit & ~has_new_pkts;

    // we know we are about to start a multi-flit packet if we are accepting
    // a flit into our memory and the eof bit is not set
    assign  start_multi_flit        = accepting_flit & ~flit_eof;
    
    // this flag is just a status signal that tracks whether we are currently
    // in the middle of a packet or not.  it gets asserted when we accept the
    // first FLIT of a packet that is not also the last FLIT of a packet.  it
    // then clears to 0 when we accept the last FLIT of a packet.
    always @ (posedge clk) begin
        if (rst) begin
            mid_packet              <= 0;
        end else if (accepting_flit && !flit_eof) begin
            mid_packet              <= 1;
        end else if (accepting_flit) begin
            mid_packet              <= 0;
        end
        mid_packet_1                <= mid_packet;
    end

    ///////////
    // DEBUG //
    ///////////
    
    // print out our flit memory when something interesting happens
    always @ (posedge clk) begin
        if (VERBOSE) begin
            if (load_q[0] && pkt_map_buf[4:0]!=0) begin
                $display("[%t] %m sending out flits [4:0]", $time);
                print_buf(4,0);
            end else if (load_q[1] && pkt_map_buf[9:5]!=0) begin
                $display("[%t] %m sending out flits [9:5]", $time);
                print_buf(9,5);
            end
            if (accepting_flit) begin
                $display("[%t] %m about to load a new flit into our packet buffer: wrptr=%0d", $time, wrptr);
                $display("[%t] %m new flit = %032h sof=%0d eof=%0d len=%x", $time, flit, flit_sof, flit_eof, flit_remain);
            end
            if (flit_loaded) begin
                print_buf(9,0);
            end
            if (clear_wrptr && wrptr!=0) begin
                $display("[%t] %m clearing wrptr to 0", $time);
            end
        end
        flit_loaded                 <= flit_valid_q;
    end

    /* 
     * prints the contents of our flit memory and the sideband signals (pkt, sof, eof bits).
     * prints:
     *  flit_mem    [ls]
     *  flit_mem    [ls+1]
     *  ...
     *  flit_mem    [ms-1]
     *  flit_mem    [ms]
     */
    task print_buf;
        input   integer ms;
        input   integer ls;
        integer         j;
        reg [3:0]       this_len;
        begin
            $display("[%t] %m : print_buf", $time);
            $display("[%t] %m :\t#\tflit\t\t\t\t\t\t\t\tpkt\tsof\teof\tlen\tcarry", $time);
            for (j=ls; j<=ms; j=j+1) begin
                this_len = len_buf[4*j+:4];
                $display("[%t] %m :\t[%0d]\t%032x\t%0d\t%0d\t%0d\t%0d\t%0d", $time, j, flit_mem[j], pkt_map_buf[j], sof_map_buf[j], eof_map_buf[j], this_len, carry_buf[j]);
            end
        end
    endtask

    // initialize our memory so that simulation looks pretty
    initial begin
        for (f=0; f<BUF_SIZE; f=f+1) begin
            flit_mem    [f]         = 'h0;
        end
    end

    //////////////////
    // HOUSEKEEPING //
    //////////////////

    // Note: the len_eof bus is no longer used by anything in this system, so
    // we just tie it to 0 in order to keep a consistent interface
    assign  len_eof                 = 'h0;

endmodule
