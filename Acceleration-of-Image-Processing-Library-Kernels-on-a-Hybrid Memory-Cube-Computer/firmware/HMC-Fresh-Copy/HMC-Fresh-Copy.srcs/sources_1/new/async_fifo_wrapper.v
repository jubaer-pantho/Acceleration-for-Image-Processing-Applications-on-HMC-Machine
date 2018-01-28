/* async_fifo_wrapper.v
 * Copyright 2013 Pico Computing, Inc.
 *
 * This is a platform- and sim-agnostic wrapper for an async FIFO. It includes a sim model, and callouts to vendor FIFO
 * macros for synthesis.
 *
 * The depth is currently fixed at 512, just like the basic hard FPGA FIFOs.
 *
 * This module does very basic grouping of multiple hard 144-bit FIFOs in synthesis to handle W>144. Presumably the tools
 * will trim off the unused portions of any hard 144-bit FIFOs we instantiate, so this is actually pretty efficient.
 */

`timescale 1ns / 1ps

module async_fifo_wrapper #(
    parameter verbose = 0,
    parameter W = 144,                  // data width of the fifo
    parameter FWFT = 1,                 // first word fallthrough. MUST be 1.
    parameter PACKET_MODE = 0           // '1' for packet mode, where we hold each packet till we've seen its tail (last signal high).
    ) (
    input               aclr,

    // write side
    input               wrclk,
    input               wrreq,
    input  [W-1:0]      data,
    input               wrlast,         // last beat of a packet. only used when PACKET_MODE==1
    output              wrfull,

    // read side
    input               rdclk,
    input               rdreq,
    output [W-1:0]      q,
    output              rdlast,         //XXX:connect this! // last beat of a packet. only used when PACKET_MODE==1
    output              rdempty
    );

    // we'll build up the requested fifo width (W) out of blocks this size
    localparam integer BLOCK_SIZE = 144;
    // this is the number of bits used to store the packet size in PACKET_MODE==1.
    // (largest allowed packet is 2**PKT_SIZE_W -1 beats.)
    localparam integer PKT_SIZE_W = 4; // good for up to 15-beat packets.

    // round up W to the nearest multiple of BLOCK_SIZE
    localparam integer N_BLOCKS = (W+BLOCK_SIZE-1)/BLOCK_SIZE;
    localparam integer W_PADDED  = BLOCK_SIZE * N_BLOCKS;

    // create full, padded input/output busses for the data, to make the assignments inside the genloop easier.
    wire [W_PADDED-1:0] din_padded = data;
    wire [W_PADDED-1:0] dout_padded;
    assign q = dout_padded[W-1:0];

    // we'll gather the full/empty signals from each of the fifos, and then aggregate them.
    // even though all the fifos are in sync in simulation, hardware propagation times can vary for hard fifos.
    wire [N_BLOCKS-1:0] wrfull_block, rdempty_block;
    assign wrfull = |wrfull_block;

    genvar i;

    generate if (PACKET_MODE == 1) begin
        // we need to hold packet data till we have the _entire_ packet. we'll use a separate fifo to pass this
        // info from the write to read side. we count up the size of each packet as it's coming in the write side,
        // and when it's complete (wrlast asserted) we write the size to this fifo. on the read side, the size showing
        // up in this sideband fifo signals that we can release the packet from the main fifo. we'll count down
        // the size so we can mark the last beat correctly as we send it out.

        // note that this mode involves changing the way the rdempty signal signal behaves, so rdempty generation is
        // inside this if/else(PACKET_MODE) block. (wrfull doesn't change, so it's done above, outside this block.)

        // the required depth of this pkt_size_fifo varies hugely with the async clock ratio between rd/wr clocks,
        // and the way backpressure is used.
        // if rdclk is faster, and rdreq always high when !rdempty, then we only need to hold ~2 items in here,
        // since packets will never accumulate. otherwise, the worst case is that every packet is just a single
        // beat and rdreq is low for a long time. then pkt_size_fifo needs to be as deep as the main fifo.

        reg [PKT_SIZE_W-1:0]    wr_pkt_size;
        always @(posedge wrclk or aclr) begin
            if (aclr) begin
                wr_pkt_size     <= 'h1;
            end else begin
                if (wrreq && ~wrfull) begin
                    if (verbose) $display("[%t] %m writing. wrlast:%d, wr_pkt_size:%d, 0x%x", $time, wrlast, wr_pkt_size, data);
                    if (wrlast)
                        wr_pkt_size <= 'h1;
                    else
                        wr_pkt_size <= wr_pkt_size + 1;
                end
            end
        end

        reg  [PKT_SIZE_W-1:0]   rd_pkt_size;
        wire [PKT_SIZE_W-1:0]   pkt_size_fifo_dout;
        wire                    pkt_size_fifo_empty;
        wire                    rd_start_new_pkt = ~pkt_size_fifo_empty && (rd_pkt_size == 0 || (rd_pkt_size == 1 && rdreq));
        assign rdempty = rd_pkt_size == 0;
        assign rdlast = rd_pkt_size == 1;
        always @(posedge rdclk or aclr) begin
            if (aclr) begin
                rd_pkt_size     <= 'h0;
            end else begin
                if (rd_start_new_pkt) begin
                    if (verbose) $display("[%t] %m reading new pkt. size:%d", $time, pkt_size_fifo_dout);
                    rd_pkt_size <= pkt_size_fifo_dout;
                end else if (rd_pkt_size != 0 && rdreq) begin
                    rd_pkt_size <= rd_pkt_size - 1;
                end
                if (rdreq && ~rdempty && verbose) $display("[%t] %m reading. rd_pkt_size:%d 0x%x", $time, rd_pkt_size, q);
            end
        end

        // going recursive :-)
        async_fifo_wrapper #(.W(PKT_SIZE_W), .FWFT(1), .verbose(0)) pkt_size_fifo (
            .aclr(aclr),

            .wrclk(wrclk),
            .wrreq(wrreq && wrlast && ~wrfull),
            .data(wr_pkt_size),

            .rdclk(rdclk),
            .rdreq(rd_start_new_pkt),
            .q(pkt_size_fifo_dout),
            .rdempty(pkt_size_fifo_empty)
            );
    end else begin
        // PACKET_MODE==0: just a normal fifo.

        // we'll gather the full/empty signals from each of the fifos, and then aggregate them.
        // even though all the fifos are in sync in simulation, hardware propagation times can vary for hard fifos.
        assign rdempty = |rdempty_block;
    end endgenerate // PACKET_MODE

    // instantiate the actual fifo(s).
    // note that we place extra guards on the rd/wr signals here, since even if the underlying fifo has the guard built in,
    // we may have a more inclusive concept of full/empty for the fifos as a whole, and the guard should be based on that.
    generate for (i=0; i < N_BLOCKS; i = i+1) begin:genloop
    `ifdef SIMULATION
        simple_sim_async_fifo #(.W(BLOCK_SIZE), .verbose(1)) f (
    `else
        async_fifo144 f (
    `endif
            .aclr(aclr),
            .wrclk(wrclk),
            .wrreq(wrreq && ~wrfull),
            .data(din_padded[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]),
            .wrfull(wrfull_block[i]),
            .rdclk(rdclk),
            .rdreq(rdreq && ~rdempty),
            .q(dout_padded[(i+1)*BLOCK_SIZE-1:i*BLOCK_SIZE]),
            .rdempty(rdempty_block[i])
            );
    end endgenerate

endmodule

module simple_sim_async_fifo #(
    parameter verbose = 0,
    parameter W = 144,
    parameter FWFT = 1 // the ONLY supported value is 1
    ) (
    input aclr,
    input wrclk,
    input rdclk,
    input [W-1:0] data,
    input rdreq,
    input wrreq,
    output rdempty,
    output wrfull,
    output [W-1:0] q
    );

    reg [8:0] rdptr = 0, wrptr = 0;
    reg [W-1:0] bram [511:0];
    integer i;
    initial begin
    for(i = 0; i < 512; i = i + 1) bram[i] = 0;
    end

    assign q = aclr ? {W{1'b0}} : bram[rdptr];

    always @(posedge wrclk) if (wrreq && verbose) $display("[%t] %m : async_fifo wrreq: 0x%x, wrfull:%d, rdempty:%d, ptrs:0x%x,0x%x", $time, data, wrfull, rdempty, wrptr, rdptr);

    always @(posedge wrclk) begin
        if(aclr) begin
            wrptr <= 0;
        end else if(wrreq & ~wrfull) begin
            bram[wrptr] <= data;
            wrptr <= wrptr + 1;
            //if (verbose) $display("[%t] %m : writing 0x%x", $time, data);
        end
    end

    always @(posedge rdclk) begin
        //if (~rdempty) $display("[%t] %m : async_fifo ~rdempty: 0x%x, wrfull:%d, rdempty:%d, ptrs:0x%x,0x%x", $time, bram[rdptr], wrfull, rdempty, wrptr, rdptr);
        if(aclr) begin
            rdptr <= 0;
            //q <= 0;
        end else if(rdreq & ~rdempty) begin
            //q <= bram[rdptr];
            rdptr <= rdptr + 1;
            if (verbose) $display("[%t] %m : reading (rdptr:0x%x) 0x%x", $time, rdptr, q);
        end
    end

    // dodge most of the issues with not using true gray code counters by delaying these computations.
    assign #1 rdempty = rdptr == wrptr;
    assign #1 wrfull = (wrptr + 1) == rdptr;
endmodule
