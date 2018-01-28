// sim_util.v
// Copyright 2014 Pico Computing, Inc.

// Utility functions for simulation

`include "reg_list.vh"

// this is the standard HMC system bringup
// if you just want to run the standard test, call this task
// if you want to do something special here, you will have to call your own
// tasks
task do_standard_bringup;
    input   [31:0]      tokens;
    begin
        
        // initialization stuff
        sim_init();
        
        // get the system in a "nice" state before we bring it up
        gups_rst(1);
        set_controller_rst(1);

        // bring up the link
        do_hmc_link_bringup();

        // release the reset to the controller
        set_controller_rst(0);
       
        // the original testbench injected 31 tokens 7 times, so we keep that
        // same number here
        inject_tokens(tokens);
    end
endtask

/*
 * this task provides an historical interface for check_sim_passed.
 * It calls check_sim_passed2 with some inputs set to defaults.
 * All the error checking is done in check_sim_passed2
 */
task check_sim_passed;
    input   integer runtime;
    input   integer tokens;
    input   integer tags;
    input   integer ports;
    input   integer size;
    input           do_reads;
    input           do_writes;
    output          passed;

    check_sim_passed2(
                      runtime,     // runtime
                      tokens,      // tokens
                      tags,        // tags
                      ports,       // ports, ie modules
                      size,        // size
                      do_reads,    // do_reads
                      do_writes,   // do_writes
                      0,           // tx_retries_expected
                      0,           // rx_retries_expected
                      0,           // expected_num_errstat_responses
                      8'h00,       // expected_errstat_response
                      passed
                     );
endtask

/*
 * this task attempts to verify the following things, in order to determine if
 * a simulation passed or failed.  Note that we compute an expected number of
 * reads and writes, based upon the input arguments, which we call 'e'.  We
 * also compute an acceptable delta, which we call 'd', which is the
 * acceptable difference between the number of reads and writes.
 * 1) number of reads per port >= e
 * 2) number of writes per port >= e
 * 3) number of writes within d of number of reads per port
 * 4) number of aggregate reads >= E
 * 5) number of aggregate writes >= E
 * 6) ports that are supposed to be disabled have 0 reads or writes
 * 7) verify no errors detected, retries detected if expected
 * 8) verify no retries detected if not expected, or retries occurred if expected
 * 9) verify basics
 *10) verify TX retry 
 *11) verify RX retry 
 *12) verify error_status responses 
 */
task check_sim_passed2;
    input   integer runtime;
    input   integer tokens;
    input   integer tags;
    input   integer ports;
    input   integer size;
    input           do_reads;
    input           do_writes;
    input   [31:0]  tx_retries_expected;   
    input   [31:0]  rx_retries_expected;   
    input   [31:0]  expected_num_errstat_responses;
    input   [7:0]   expected_errstat_response;
    output          passed;

    reg     [31:0]  max_dev;

    reg     [31:0]  e_reads;
    reg     [31:0]  e_writes;
    reg     [31:0]  reads       [1:5];
    reg     [31:0]  writes      [1:5];

    reg     [31:0]  E_reads;
    reg     [31:0]  E_writes;
    reg     [31:0]  ag_reads;
    reg     [31:0]  ag_writes;

    reg     [31:0]  n_retries;
    reg     [31:0]  n_err;
    reg     [31:0]  num;

    integer         p;

    reg     [31:0]  junk1;
    reg     [31:0]  junk2;

    reg             basics_passed, tx_retries_passed, rx_retries_passed, err_stat_passed; 

    begin
        // we start by setting passed = 1
        // as we test more stuff, we will only ever set passed to 0, if
        // something fails. we will never set it back to 1
        passed = 1;

        // compute our e, E, and d values here
        get_exp_rw      (runtime,   tokens, tags,   ports,  size,   do_reads,   do_writes,  e_reads,    e_writes);
        get_max_dev     (runtime,   tokens, tags,   ports,  size,   do_reads,   do_writes,  max_dev);
        get_exp_agg_rw  (runtime,   tokens, tags,   ports,  size,   do_reads,   do_writes,  e_reads,    e_writes,   E_reads,    E_writes);

        // get the number of reads + writes for each port
        // compute the aggregate number of reads + writes too
        // 1) verify number of reads per port >= e
        // 2) verify number of writes per port >= e
        // 3) verify number of writes within d of number of reads per port
        ag_reads    = 0;
        ag_writes   = 0;
        for (p=1; p<=ports; p=p+1) begin
            get_num_rw  (p, reads[p], writes[p]);
            ag_reads    = ag_reads  + reads [p];
            ag_writes   = ag_writes + writes[p];
            if ((reads[p]<e_reads) || (writes[p]<e_writes) || ((do_reads & do_writes) & ((writes[p]+max_dev)<reads[p]))) begin
                if (reads [p]<e_reads)
                    $display("Error: port %0d reads (0x%0h) is less than the expected value (0x%0h)",  p, reads [p], e_reads);
                if (writes[p]<e_writes) 
                    $display("Error: port %0d writes (0x%0h) is less than the expected value (0x%0h)", p, writes[p], e_writes);
                if ((do_reads & do_writes) & (writes[p]+max_dev)<reads[p])
                    $display("Error: port %0d difference between reads (0x%0h) and writes (0x%0h) is greater than the max deviation (0x%0h)", p, reads[p], writes[p], max_dev);
                passed = 0;
            end
        end

        // 4) verify number of aggregate reads >= E
        if (ag_reads < E_reads) begin
            $display("Error: aggregate number of reads (0x%0h) did not surpass the expected number of aggregate reads (0x%0h)", ag_reads, E_reads);
            passed = 0;
        end
        
        // 5) verify number of aggregate writes >= E
        if (ag_writes < E_writes) begin
            $display("Error: aggregate number of writes (0x%0h) did not surpass the expected number of aggregate writes (0x%0h)", ag_writes, E_writes);
            passed = 0;
        end

        // 6) verify ports that are supposed to be disabled have 0 reads or writes
        for (p=ports+1; p<=5; p=p+1) begin
            get_num_rw  (p, junk1, junk2);
            if (junk1>0 || junk2>0) begin
                $display("Error: disabled port %0d had 0x%0h %0s", p, junk1>0?junk1:junk2, junk1>0?"reads":"writes");
                passed = 0;
            end
        end
 
        // 7) verify no errors detected
        get_num_errors  (n_err);
        if (n_err > 0) begin
            $display("Error: detected %0d errors in the pkt_stat module", n_err);
            passed = 0;
        end

        // 8) verify retries occurred if expected or none if not expected
        // IRTRY packets will be received by the controller on an RX error or a TX error
        // number of IRTRY packets, lumps START_RETRY and CLEAR_ERR_ABORT IRTRY packets together, reg C080h
        get_num_retries (n_retries);

        if ((n_retries == 0) && ((tx_retries_expected  > 0) ||  (rx_retries_expected  > 0))) begin   
            $display("Error: detected %0d retries in the pkt_stat module (reg 0xC080) but retries were expected", n_retries);
            passed = 0;
        end

        if  ((n_retries  > 0) && ((tx_retries_expected == 0) &&  (rx_retries_expected == 0))) begin
            $display("Error: detected %0d retries in the pkt_stat module (reg 0xC080) but no retries were expected", n_retries);
            passed = 0;
        end

        // 9) verify basics
        verify_basics   (
                         tx_retries_expected, 
                         rx_retries_expected, 
                         basics_passed
                        );
        if (basics_passed == 0)
            passed = 0;

        // 10) verify TX retries 
        verify_tx_retry (
                         tx_retries_expected, 
                         tx_retries_passed
                        );
        if (tx_retries_passed == 0)
            passed = 0;

        //11) verify RX retries 
        verify_rx_retry (
                         rx_retries_expected, 
                         rx_retries_passed
                        );
        if (rx_retries_passed == 0)
            passed = 0;

        // 12) check errstat responses
        check_errstats (
                        expected_num_errstat_responses,
                        expected_errstat_response, 
                        err_stat_passed
                       );
        if (err_stat_passed == 0)
            passed = 0;
    end
endtask

/*
 * this task returns the number of reads and write for a single port
 */
task get_num_rw;
    input   integer port;
    output  [31:0]  num_reads;
    output  [31:0]  num_writes;
    begin
        $display("Reading the number of reads + writes for port %0d", port);
        do_debug_rd_save(`REG_GUPS_N_READ0  (32'ha00000 | port << 16), num_reads);
        do_debug_rd_save(`REG_GUPS_N_WRITE0 (32'ha00000 | port << 16), num_writes);
    end
endtask

/*
 * this task computes the expected number of reads and writes based upon the
 * input parameters.  Note that this should be treated as a lower bound, not
 * an absolute value.
 */
task get_exp_rw;
    input   integer runtime;
    input   integer tokens;
    input   integer tags;
    input   integer ports;
    input   integer size;
    input           do_reads;
    input           do_writes;
    output  integer e_reads;
    output  integer e_writes;
    begin
        // TODO: do a better computation in the future. Since various simulations can
        // have different clock frequencies it is difficult to use the runtime to predict
        // how many reads or writes should have been issued without knowing the clock
        // period.  For now assume the simulation runs at least long enough to use all
        // the tags once for reads and writes.
        e_reads     = do_reads  ? tags/2 : 0;
        e_writes    = do_writes ? tags/2 : 0;
    end
endtask

/*
 * this task computes the expected number of aggregate reads and writes
 */
task get_exp_agg_rw;
    input   integer runtime;
    input   integer tokens;
    input   integer tags;
    input   integer ports;
    input   integer size;
    input           do_reads;
    input           do_writes;
    input   integer e_reads;
    input   integer e_writes;
    output  integer E_reads;
    output  integer E_writes;
    begin
        // for now, we assume that the aggreate is just going to be the number
        // of ports times the expected value for a single port
        E_reads     = ports * e_reads;
        E_writes    = ports * e_writes;
    end
endtask

/*
 * this task computes the max allowed deviation between the number of reads
 * and number of writes for a single port
 */
task get_max_dev;
    input   integer runtime;
    input   integer tokens;
    input   integer tags;
    input   integer ports;
    input   integer size;
    input           do_reads;
    input           do_writes;
    output  integer d;
    begin
        // we know that reads are not issued unless we have >= 1 free tag, and
        // writes are issued as soon as reads complete. worst case would be
        // when all reads have been issued and we haven't issued any writes
        // yet.
        d = tags;
    end
endtask

/*
 * this task returns the number of retries that we have seen in our system
 * TODO: read the number of retries that we see in our packet_issue module
 */
task get_num_retries;
    output  [31:0]  num;
    reg     [31:0]  retry;
    begin
        $display("Reading the number of retries from the pkt_stat module");
        do_debug_rd_save(32'hc080, num);
    end
endtask

/*
 * this task verifies that we don't have anything catastrophic going on in our system
 * Assumes controller may be stopped or running and has been brought up (hmc linked), 
 * out of reset and has had > 0 tokens injected.
 */
task verify_basics;
    input   [31:0]  tx_retries_expected;
    input   [31:0]  rx_retries_expected;
    output          passed;
    reg     [31:0]  num;
    integer         j, addr;
    begin

        // start by setting passed = 1, set passed to 0 if
        // something fails. we will never set it back to 1
        passed = 1;

        // 404  - controller should not be in reset - ls 2 bits should be 0
        do_debug_rd_save(32'h404, num);
        if ((num & 32'h03) != 0) begin
            $display("Error: HMC Controller shouldn't be in reset when calling verify_basics, reg 0x404 = 0x%08h", num);
            passed = 0;
        end

        // 40c  - injected tokens - should be > 0
        do_debug_rd_save(32'h40c, num);
        if (num == 0) begin
            $display("Error: must inject >= 1 token before calling verify_basics, reg 0x40C = 0x%08h", num);
            passed = 0;
        end

        // verify tcr wrap latch is not set, bit[10] must be 0, reg 430h
        do_debug_rd_save(32'h430, num);
        if ((num & 32'h0400) != 0) begin
            $display("Error: tcr wrap latch bit is set in bit 10 of reg 0x430 =0x%08h", num);
            passed = 0;
        end

        // verify no data was dropped that was supposed to hit the tx buffer, reg 714 should be zero
        do_debug_rd_save(32'h714, num);
        if (num  != 0) begin
            $display("Error: Dropped some data that was supposed to hit the TX buffer, reg 0x714h = 0x%08h", num);
            passed = 0;
        end

        // look for errors after the grand_central_tx module
        for (addr = 32'hD200; addr < 32'hD270; addr = addr + 32'h10) begin
            do_debug_rd_save(addr, num);
            if (num != 0) begin
                $display("Error: detected %0d malformed packets after the grand_central_tx module, reg 0x%0h.", num, addr);
                passed = 0;
            end
        end

        // verify that we don't have any errors after the flow_control module
        // in our TX pipeline
        // Note: its ok to have errors here if we injected any TX errors
        for (addr = 32'hD500; addr < 32'hD570; addr = addr + 32'h10) begin
            do_debug_rd_save(addr, num);
            if (num != 0) begin
                if (tx_retries_expected == 0) begin 
                    $display("Error: detected %0d malformed packets in our controller, reg 0x%h, and TX retries were not expected.", num, addr);
                    passed = 0;
                end else begin
                    $display("Info: detected %0d malformed packets in our controller, reg 0x%h, but TX retries were expected, ok", num, addr);
                end
            end
        end
        
        // verify that we don't have any errors after the find_pkts module
        // in our RX pipeline
        // Note: its ok to have errors here if we injected any RX errors
        for (addr = 32'hD800; addr < 32'hD870; addr = addr + 32'h10) begin
            do_debug_rd_save(addr, num);
            if (num != 0) begin
                if (rx_retries_expected == 0) begin 
                    $display("Error: detected %0d malformed packets in our controller, reg 0x%h, and RX retries were not expected.", num, addr);
                    passed = 0;
                end else begin
                    $display("Info: detected %0d malformed packets in our controller, reg 0x%h, but RX retries were expected, ok", num, addr);
                end
            end
        end
    end
endtask

/*
 * this task checks TX retry registers to verify retries occurred if expected
 * or no retries occurred if not expected.                                
 * 1) Number of tx retries equals number expected, reg 454h
 * 2) Start retry valid count equals number expected, reg 70Ch
 */
task verify_tx_retry;
    input   [31:0]  tx_retries_expected;
    output          passed;
    reg     [31:0]  num;
    begin

        // start by setting passed = 1, set passed to 0 if
        // something fails. we will never set it back to 1
        passed = 1;

        // 1) Verify number of tx retries in our packet issue equals number expected, reg 454h
        do_debug_rd_save(32'h454, num);
        if (num != tx_retries_expected) begin  
            $display("Error: detected %0d tx retries (reg 0x454) but %0d retries were expected", num, tx_retries_expected);
            passed = 0;
        end

        // 2) Verify start retry valid count equals number expected, reg 70Ch
        do_debug_rd_save(32'h70C, num);
        if (num != tx_retries_expected) begin  
            $display("Error: detected %0d tx retries (reg 0x70C) but %0d retries were expected", num, tx_retries_expected);
            passed = 0;
        end
    end
endtask

/*
 * this task checks RX retry registers to verify retries occurred if expected
 * or no retries occurred if not expected.                                
 * 1) Number of rx retries equals number expected, reg 458h
 * 2) Rx error abort count equals number expected, reg 71Ch
 */
task verify_rx_retry;
    input   [31:0]  rx_retries_expected;
    output          passed;
    reg     [31:0]  num;
    begin

        // start by setting passed = 1, set passed to 0 if
        // something fails. we will never set it back to 1
        passed = 1;

        // 1) Verify number of rx retries in our packet issue equals number expected, reg 458h
        do_debug_rd_save(32'h458, num);
        if (num != rx_retries_expected) begin  
            $display("Error: detected %0d rx retries (reg 0x458) but %0d retries were expected", num, rx_retries_expected);
            passed = 0;
        end

        // 2) Verify rx error abort count equals number expected, reg 71Ch
        do_debug_rd_save(32'h71C, num);
        if (num != rx_retries_expected) begin  
            $display("Error: detected %0d rx error abort count (reg 0x71C) but %0d retries were expected", num, rx_retries_expected);
            passed = 0;
        end
    end
endtask

/*
 * This task reads the number of error status responses detected in the errstat module
   and compares it to zero if no error status responses are expected or non-zero if
   if they are expected. It also reads the first error response code latched by the 
   errstat module and compares it to the expected response code passed into the task. 
 */
task check_errstats;
    input   [31:0]  expected_num_errstat_responses;
    input   [7:0]   expected_errstat_response;
    output          passed;
    reg     [31:0]  num;
    reg     [31:0]  response;
    begin

        // start by setting passed = 1, set passed to 0 if
        // something fails. we will never set it back to 1
        passed = 1;

        $display("Reading the number of err_stat responses from the errstat module");
        do_debug_rd_save(32'h0900, num);

        // Check if actual error status response count is positive if error status
        // responses are expeceted or zero if none are expected 
        if (((num == 0) && (expected_num_errstat_responses != 0)) ||
            ((num != 0) && (expected_num_errstat_responses == 0))) begin
            $display("Error: actual number of err_stat responses (%0d) differs from expected number (%0d))", num, expected_num_errstat_responses);
            passed = 0;
        end

        $display("Reading the first err_stat response from the errstat module");
        do_debug_rd_save(32'h0904, response);

        // Check if first error status response equals the expected response
        if (response[7:0] != expected_errstat_response) begin
            $display("Error: actual err_stat response (0x%0h) differs from expected value (0x%0h))", response, expected_errstat_response);
            passed = 0;
        end
    end
endtask

/*
 * this task returns the number of errors detected in the pkt_stat module
 */
task get_num_errors;
    output  [31:0]  num;
    begin
        $display("Reading the number of errors from the pkt_stat module");
        do_debug_rd_save(32'hc040, num);
    end
endtask

// this is the first thing that we are going to run here
// anything that must be done at the start of a test should be placed in this
// task
task sim_init;
    begin
        // reset the debug bus
        do_debug_rst();
    end
endtask

// this just controls the powerup reset of the system
// we hold the debug_rst signal asserted for 10 debug_clk cycles
task do_debug_rst;
    begin
        $display("[%t] Sending powerup reset signal to FPGA fabric", $time);
        debug_rst   <= 0;
        #10;
        // we assume that debug_rst is synchronous to debug_clk, so we assert
        // and de-assert it synchronous to the positive edge of the clock
        @ (posedge debug_clk);
        debug_rst   <= 1;
        // we assume that 10 debug_clk cycles is enough for everything (that
        // needs to) to see the debug_rst signal asserted
        repeat(10) @ (posedge debug_clk);
        debug_rst   <= 0;
    end
endtask

// this writes the reset pin in hmc_init
// this writes lxrxps and p_rst_n_en to 1 in hmc_init
task do_hmc_init_rst;
    begin
        $display("[%t] driving reset pin in hmc_init", $time);
        do_debug_wr(32'h8010, /*XXX 32'h4*/ 32'hC);
        #10;
    end
endtask

// this writes our p_rst_n signal to a new value
// Note: since p_rst_n is active-low, writing this to a 0 will actually reset
// the HMC
task set_p_rst_n;
    input               new_rst_val;
    begin
        if (new_rst_val)    $display("[%t] Releasing P_RST_N...", $time);
        else                $display("[%t] Asserting P_RST_N...", $time);
        do_debug_wr(32'h8000, {4{new_rst_val}});
        #1000;
    end
endtask

// this manages the bringup of the link between the FPGA and the HMC
// when this is called, we assume:
// 1) the gups modules are in reset
// 2) the controller is in reset
task do_hmc_link_bringup;
    begin
        do_hmc_init_rst();
        set_p_rst_n(0);
        set_p_rst_n(1);
        
        $display("[%t] waiting for link training", $time);
        wait (hmc_trained);
        $display("[%t] hmc_trained!", $time);
        
        // the goal is to hold the controller in reset till AFTER the TRETs have come in from the HMC.
        //   (this is to mimic what happens in hardware, where we need to have the controller in reset during link training.)
        #10000;
    end
endtask

// this writes the controller reset via the debug bus
task set_controller_rst;
    input               new_rst_val;
    begin
        if (new_rst_val)    $display("[%t] putting controller into reset", $time);
        else                $display("[%t] bringing controller out of reset", $time);
        do_debug_wr(32'h404, new_rst_val);
        #1000;
    end
endtask

// this injects tokens by writing to the PicoBus
// we then verify the number of tokens that we injected by reading a register
// from the PicoBus
task inject_tokens;
    input   [31:0]      num_to_inject;
    reg     [31:0]      total;
    reg     [31:0]      num_injected;
    reg     [31:0]      curr_to_inject;
    begin
        // inject the tokens
        total = num_to_inject;
        while (total > 0) begin
            // TODO: the original sim had the max injection per write = 31,
            // while the software has this set to 15.  we use 31 to replicate
            // the original sim, but in the future, we might want to change
            // this to 15
            curr_to_inject = total > 31 ? 31 : total;
            $display("[%t] injecting %d tokens", $time, curr_to_inject);
            do_debug_wr(32'h480, curr_to_inject);
            total = total - curr_to_inject;
        end
        // verify the number of tokens that we injected
        // tcr is the LS 10 bits of address 0x430 (in hmc_packet_issue).
        // Note: it turns out that we can't verify the number of tokens
        // injected, because there is NO guarantee that the hmc_node is
        // stopped when we are injecting them
        //do_debug_rd_save(32'h430, num_injected);
        //num_injected = num_injected & 32'h3FF;
        //if (num_injected != num_to_inject) begin
        //    $display("Test Result: FAILURE (wrong number of tokens seen)");
        //    $display("[%t] INFO: we injected %d tokens, but we read this back as %d", $time, num_to_inject, num_injected);
        //    $stop;
        //end
    end
endtask

// this poorly-named function runs gups with the default values.
// please use run_gups() henceforth. (or create run_gups_defaults() if you want a no-questions-asked version.)
task do_standard_test;
    begin
        run_gups(5 /*#ports*/, 1 /*size*/);
    end
endtask

// set up and kick off a gups test, and leave it running.
task start_gups_test;
    input   [31:0]  n_modules;              // how many gups modules should we setup? (range: 1-5)
    input   [31:0]  size;                   // pkt size in flits (range: 1-8)
    begin

        // all the parameters for the gups_setup task are defined immediately
        // above gups_setup (in this same file).
        // feel free to change those parameters as you wish
        //$display("[%t] Setting up our GUPS modules", $time);
        gups_setup(n_modules, size);
        #5000;

        // let the test run for a bit
        $display("\n[%t] Starting our standard test...\n", $time);
    end
endtask

// set up and kick off a gups sweep test, and leave it running.
task start_gups_w_params;
    input   [31:0]  n_modules;              // how many gups modules should we setup? (range: 1-5)
    input   [31:0]  size;                   // pkt size in flits (range: 1-8)
    input   [31:0]  tags;                   // number of tags (range 1-64
    input           do_reads;
    input           do_writes;
    begin

        gups_setup_w_params(n_modules, size, tags, do_reads, do_writes);
        #5000;

        // let the test run for a bit
        $display("\n[%t] Starting our sweep test...\n", $time);
    end
endtask

// stop a currently-running gups test and print out some stats about it.
task finish_gups_test;
    begin
        // print out some debugging info
        $display("[%t] Standard Test Complete. Gathering some stats", $time);
       
        // stop all the gups modules at the end of the test, so we can get
        // a snapshot of the system, versus a snapshot of the system that is
        // already running
        // Note: basically we do this to make sure that the number of reads
        // matches the number of writes, and that all tags / tokens get
        // returned
        gups_stop();

        // when we start playing games with tokens, it can take a LONG time for things to settle down after we tell the user modules to stop.
        #200000;

        // TODO: why do we need this?
        $display("[%t] rx_log2 logged data:", $time);
        do_debug_wr(32'hfc0000, 32'h1); // load the first word into the output registers so we can read it.
        do_debug_rd(32'hfc0084);
        do_debug_rd(32'hfc0088);
        do_debug_rd(32'hfc008c);
        do_debug_rd(32'hfc0090);
        for (i=0; i <= 32'h5c; i=i+4) begin
            do_debug_rd(32'hfc0000 | i);
        end
        // advance a few words into the buffer, then check the rd_addr to make sure it's advanced.
        do_debug_wr(32'hfc0000, 32'h1);
        do_debug_wr(32'hfc0000, 32'h1);
        do_debug_wr(32'hfc0000, 32'h1);
        do_debug_wr(32'hfc0000, 32'h1);
        do_debug_rd(32'hfc0084);

        // print out the data from the pkt_stat module
        pkt_stat();

        // print out the stats data from our GUPS user modules
        gups_stats();
        #10;
    end
endtask

// this just runs a fairly standard gups simulation
// before this is called, we assume:
// 1) the controller is in reset
// 2) the gups modules are in reset
// 3) do_hmc_link_bringup has been called
// 4) the controller reset has been released
task run_gups;
    input   [31:0]  n_modules;              // how many gups modules should we setup? (range: 1-5)
    input   [31:0]  size;                   // pkt size in flits (range: 1-8)
    begin
        start_gups_test(n_modules, size);
        #50000;
        finish_gups_test();
    end
endtask

// this prints out some stats that we collect in the pkt_stat module
task pkt_stat;
    begin
        $display("[%t] Packet statistics (from pkt_stat) module", $time);
        #10 $display("RD_RESP:");
        do_debug_rd(32'hc000); // # of read response (lower 32-bit)

        #10 $display("WR_RESP:");
        do_debug_rd(32'hc010); // # of write response (lower 32-bit)
        #10 $display("MD_RD_RESP:");
        do_debug_rd(32'hc020); // # of mode read response (lower 32-bit)
        #10 $display("MD_WR_RESP:");
        do_debug_rd(32'hc030); // # of mode write response (lower 32-bit)
        #10 $display("ERR_RESP:");
        do_debug_rd(32'hc040); // # of error response (lower 32-bit)
        #10 $display("NULL FLOW:");
        do_debug_rd(32'hc050); // # of null flow commands (lower 32-bit)
        #10 $display("PRET FLOW:");
        do_debug_rd(32'hc060); // # of pret flow commands (lower 32-bit)
        #10 $display("TRET FLOW:");
        do_debug_rd(32'hc070); // # of tret flow commands (lower 32-bit)
        #10 $display("IRTRY FLOW:");
        do_debug_rd(32'hc080); // # of init retry flow commands (lower 32-bit)
        #10 $display("TOTAL:");
        do_debug_rd(32'hc090); // total # of pkt head (lower 32-bit)
        // unrecognized pkt = total # of pkt heads - sum of all valid pkt heads
    end
endtask

// this prints out some debug info from either the hmc_top or hmc_node
task hmc_stat;
    begin
        do_debug_rd(32'h400);
        do_debug_rd(32'h404);
        do_debug_rd(32'h408);

        do_debug_rd(32'h430);
        do_debug_rd(32'h434);
        do_debug_rd(32'h438);
        do_debug_rd(32'h43c);
        do_debug_rd(32'h440);
        do_debug_rd(32'h444);
        do_debug_rd(32'h450);
        do_debug_rd(32'h454);
        do_debug_rd(32'h458);
        do_debug_rd(32'h460);
        do_debug_rd(32'h464);
        do_debug_rd(32'h468);
        
        do_debug_rd(32'h704);
        do_debug_rd(32'h708);
        do_debug_rd(32'h70c);
        do_debug_rd(32'h710);
        do_debug_rd(32'h714);
        do_debug_rd(32'h718);
        do_debug_rd(32'h71c);
        
        do_debug_rd(32'hc0a0);
        do_debug_rd(32'hc0a4);
    end
endtask

task do_debug_rd;
    input [31:0] addr;
    begin
    @(posedge debug_clk);
    debug_addr  <= addr;
    debug_rd    <= 1;
    @(posedge debug_clk);
    debug_addr  <= 32'h0;
    debug_rd    <= 0;
    @(posedge debug_clk);
    @(posedge debug_clk);
end endtask


reg [31:0]  debug_dout_latch;
task do_debug_rd_save;
    input [31:0] addr;
    output [31:0] ret;
    begin
        do_debug_rd(addr);
        @(posedge debug_clk);
        @(posedge debug_clk);
        ret = debug_dout_latch;
    end
endtask

reg [31:0]  debug_addr_q;
reg         debug_rd_q;
always @(posedge debug_clk) begin
    debug_addr_q    <= debug_addr;
    debug_rd_q      <= debug_rd;

    if (debug_rd_q) begin
        debug_dout_latch    <= debug_dout;
    end

    if (debug_rd_q) begin
        $display("[%t] debug_rd @ 0x%x: 0x%x", $time, debug_addr_q, debug_dout);
        //$display("also, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x", user_debug_dout_p1[31:0], user_debug_dout[31:0], user_ctl_dout[31:0], hmc_init_debug_dout[31:0], hmc_phy_debug_dout[31:0], rx_debug_dout[31:0], tx_debug_dout[31:0]);
    end

    if (debug_wr) begin
        $display("[%t] debug_wr @ 0x%x: 0x%x", $time, debug_addr, debug_din);
    end
end

task do_debug_wr;
    input [31:0] addr;
    input [31:0] data;
    begin

    @(posedge debug_clk);
    debug_addr  <= addr;
    debug_din   <= data;
    debug_wr    <= 1;
    @(posedge debug_clk);
    debug_addr  <= 32'h0;
    debug_din   <= 32'h0;
    debug_wr    <= 0;

    // we've done the write, yes, but we should let it "flow through" whatever it might have triggered.
    // (example: the rtc module's token injection can't handle back to back writes.)
    @(posedge debug_clk);
    @(posedge debug_clk);
    /*@(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);
    @(posedge debug_clk);*/
end endtask

task hmc_atomic_add8;
    input [31:0] base;
    input [31:0] addr;
    input [31:0] op1;
    input [31:0] op2;
    input [5:0] tag;
    begin
    $display("[%t] do hmc atomic add8: base: %x, addr: %x, op1: %x, op2: %x, tag: %x",
        $time, base, addr, op1, op2, tag);
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA0(base), op1);  // write bytes 0~3
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA1(base), 0);    // write bytes 4~7
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA2(base), op2);  // write bytes 8~11
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA3(base), 0);    // write bytes 12~16
    do_debug_wr(`REG_GUPS_HMC_TEST_ADDR(base), addr); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_SIZE(base), 1); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_TAG(base), tag); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_COMMAND(base), `HMC_CMD_AT8); // write cmd at the end
    #100;
    end
endtask

task hmc_atomic_add16;
    input [31:0] base;
    input [31:0] addr;
    input [63:0] op;
    input [5:0] tag;
    begin
    $display("[%t] do hmc atomic add16: base: %x, addr: %x, op: %x, tag: %x",
        $time, base, addr, op, tag);
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA0(base), op[0  +: 32]);  // write bytes 0~3
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA1(base), op[32 +: 32]);    // write bytes 4~7
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA2(base), 0);  // write bytes 8~11
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA3(base), 0);    // write bytes 12~16
    do_debug_wr(`REG_GUPS_HMC_TEST_ADDR(base), addr); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_SIZE(base), 1); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_TAG(base), tag); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_COMMAND(base), `HMC_CMD_AT16); // write cmd at the end
    #100;
    end
endtask

task hmc_bit_write;
    input [31:0] base;
    input [31:0] addr;
    input [63:0] data;
    input [63:0] mask;
    input [5:0] tag;
    begin
    $display("[%t] do hmc bit write: base: %x, addr: %x, data: %x, mask: %x, tag: %x",
        $time, base, addr, data, mask, tag);
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA0(base), data[0  +: 32]);  // write bytes 0~3
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA1(base), data[32 +: 32]);    // write bytes 4~7
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA2(base), mask[0  +: 32]);  // write bytes 8~11
    do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA3(base), mask[32 +: 32]);    // write bytes 12~16
    do_debug_wr(`REG_GUPS_HMC_TEST_ADDR(base), addr); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_SIZE(base), 1); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_TAG(base), tag); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_COMMAND(base), `HMC_CMD_BW); // write cmd at the end
    #100;
    end
endtask

// hmc_write 
task hmc_write;
    input [31:0] base;
    input [31:0] addr;
    input [1023:0] data;
    input [31:0] size;
    input [5:0] tag;
    
    integer i;
    begin

    for (i=0; i<size; i=i+1) begin
        do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA0(base), data[128*i + 0 +: 32]);  // write bytes 0~3
        do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA1(base), data[128*i +32 +: 32]);  // write bytes 4~7
        do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA2(base), data[128*i +64 +: 32]);  // write bytes 8~11
        do_debug_wr(`REG_GUPS_HMC_TEST_WR_DATA3(base), data[128*i +96 +: 32]);  // write bytes 12~16
        $display("[%t] HMC write: base: %x, addr: %x, data: %x, size: %x, tag: %x", $time, base, addr, data[128*i +: 128], size, tag);
    end

    do_debug_wr(`REG_GUPS_HMC_TEST_ADDR(base), addr); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_SIZE(base), size); // size
    do_debug_wr(`REG_GUPS_HMC_TEST_TAG(base), tag);   // tag
    do_debug_wr(`REG_GUPS_HMC_TEST_COMMAND(base), `HMC_CMD_WR); // write cmd at the end
    #100;
    end
endtask

task hmc_read;
    input [31:0] base;
    input [31:0] addr;
    input [31:0] size;
    input [5:0]  tag;
    begin
    $display("[%t] HMC read: base: %x, addr: %x, size: %x, tag: %x,",
        $time, base, addr, size, tag);
    do_debug_wr(`REG_GUPS_HMC_TEST_ADDR(base), addr); // write addr
    do_debug_wr(`REG_GUPS_HMC_TEST_SIZE(base), size); // size
    do_debug_wr(`REG_GUPS_HMC_TEST_TAG(base), tag);   // tag
    do_debug_wr(`REG_GUPS_HMC_TEST_COMMAND(base), `HMC_CMD_RD); // write cmd at the end
    #100;
    end
endtask

task hmc_read_data;
    input [31:0] base;
    input [31:0] offset;
    output reg [1023:0] read_data;
    input [31:0] size;
    output reg [5:0]   rd_tag;
    integer i;

    begin
    #10;
    
    for (i=0; i<size; i=i+1) begin
        do_debug_wr(`REG_GUPS_HMC_TEST_RD_DATA_BRAM_ADDR(base), offset+i);

        do_debug_rd_save(`REG_GUPS_HMC_TEST_RD_DATA0(base), read_data[128*i +  0 +: 32]);
        do_debug_rd_save(`REG_GUPS_HMC_TEST_RD_DATA1(base), read_data[128*i + 32 +: 32]);
        do_debug_rd_save(`REG_GUPS_HMC_TEST_RD_DATA2(base), read_data[128*i + 64 +: 32]);
        do_debug_rd_save(`REG_GUPS_HMC_TEST_RD_DATA3(base), read_data[128*i + 96 +: 32]);

        do_debug_rd_save(`REG_GUPS_HMC_TEST_RD_TAG(base), rd_tag);
    
        $display("[%t] HMC bram readback data: %x tag: %x", $time, read_data[128*i +: 128], rd_tag);
    end

    #100;
    end
endtask


localparam enable_lost_tag_recycle = 0;
localparam enable_lost_tag_stop = 1;
localparam enable_lost_tag_detect = 1;
localparam max_tag_life = 32'h400;
localparam enable_min_rd_latency_stop = 1;
localparam min_rd_latency_stop = 31'h60;
localparam max_rd_tags = 32'h40;
localparam enable_gups_rd = 1;
localparam enable_gups_wr = 1;

// in the software, we have this method that just sets up 1 module, which then
// gets called 5 times.  instead, we setup all 5 modules here. to setup the
// modules, we:
// 0) bring the user modules out of reset
// 1) load the tags
// 2) set the max tag life
// 3) set the min read latency
// 4) set the tag control (e.g. lost tag recycle, lost tag stop, etc)
// 5) set the iteration limit
// 6) set the burst size
// 7) configure the gups LFSRs
// 8) set the flag so we stop when we detect error packets
// 9) set the master enable for all user modules
// Note: this task does not validate its params - read the param docs!
// gups_setup uses the above local parameters
task gups_setup;
    input   [31:0]  n_modules;              // how many gups modules should we setup? (range: 1-5)
    input   [31:0]  size;                   // pkt size in flits (range: 1-8)

    gups_setup_w_params(n_modules, size, max_rd_tags, enable_gups_rd,  enable_gups_wr); 
    
endtask

// gups_setup_w_params allows varying modules, size, tags, read and write modes through inputs
task gups_setup_w_params;
    input   [31:0]  n_modules;              // how many gups modules should we setup? (range: 1-5)
    input   [31:0]  size;                   // pkt size in flits (range: 1-8)
    input   [31:0]  tags;                   // number of tags (range 1-64
    input           do_reads;
    input           do_writes;

    // addr mask values 
    reg     [31:0]  addr_mask;
    reg     [31:0]  addr_anti_mask;
    reg     [1:0]   link;

    integer i, j;

begin : GUPS_SETUP
    // the next three lines restrict us to our local quadrant
    addr_mask = 32'h7fffffc0 & ~((2'h3 << 2) << 7);  // knock out the top two vault bits
    link = 0;                                        // HMC link 
    addr_anti_mask = (link << 2) << 7;               // use our link number as the quadrant. (ie - talk to our own quadrant)

    // 0) bring the user modules out of reset
    // Note: the original simulation did not do this, but we pulled it from
    // the HMC software
    // We do _not_ look at n_modules here and selectively un-reset only the required modules.
    // This is safe since they won't actually do anything without the final "enable" command.
    gups_rst(0);

    // 6) set the burst size
    $display("[%t] set burst_size = %d, in user modules", $time, size);
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_BURST_SIZE(32'ha00000 | i << 16), size);
    end
    #100;

    // 7) configure the gups LFSRs
    $display("[%t] set lfsr in user modules", $time);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (1 << 16))), 32'hf93758ee);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (2 << 16))), 32'h5242630f);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (3 << 16))), 32'h1b14880f);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (4 << 16))), 32'hd613365d);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (5 << 16))), 32'h588203c6);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (1 << 16))), 32'hf93758ee);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (2 << 16))), 32'h5242630f);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (3 << 16))), 32'h1b14880f);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (4 << 16))), 32'hd613365d);
    do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_IV1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (5 << 16))), 32'h588203c6);
    #100;
    $display("[%t] set lfsr feed back pattern in user modules", $time);
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_FB0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), 32'h3);
        do_debug_wr(`REG_GUPS_DATA_GEN_LFSR_FB1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), 32'h0);
    end
    #100;

    // 4) set the tag control (e.g. lost tag recycle, lost tag stop, etc)
    $display("[%t] set tag_ctl in user modules", $time);
    // [0]: reset bit for tag manager, need to manually clear
    // [2]: enable lost tag recycling
    // [3]: stop gups if detect lost tags
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_TAG_CONTROL(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))), (enable_lost_tag_recycle << 3) | (enable_lost_tag_stop << 3) | (enable_lost_tag_detect << 4));
    end
    #100;

    // 2) set the max tag life
    $display("[%t] set max tag life", $time);
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_TAG_MAX_LIFE(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))), max_tag_life);
    end

    // 3) set the min read latency
    $display("[%t] set min rd latency stop", $time);
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_TAG_MIN_LATENCY_STOP(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))), (enable_min_rd_latency_stop << 31) | min_rd_latency_stop);
    end

    // 1) load the tags
    $display("[%t] loading rd tags", $time);
    for (i=1; i<=n_modules; i=i+1) begin
        for (j=0; j<tags; j=j+1) begin
            do_debug_wr(`REG_GUPS_TAG_WRITE(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))), j);
        end
    end
    #100;
    
    // 5) TODO: set the iteration limit

    // Set the address mask as done in the software for fixed_addr_en=0
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_DATA_GEN_MASK0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), addr_mask);
        do_debug_wr(`REG_GUPS_DATA_GEN_MASK1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), 0);
        do_debug_wr(`REG_GUPS_DATA_GEN_ANTI_MASK0(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), addr_anti_mask);
        do_debug_wr(`REG_GUPS_DATA_GEN_ANTI_MASK1(`REG_GUPS_ADDR_GEN_BASE_ADDR(32'ha00000 | (i << 16))), 0);
    end
    
    // 8) set the flag so we stop when we detect error packets
    // Note: the original simulation did not do this, but we pulled it from
    // the HMC software
    //$display("[%t] Setting the stop on error flag", $time);
    //do_debug_wr(32'hc0a0, 32'h1);
    
    // 9) set the master enable for all user modules
    $display("[%t] enabling user modules", $time);
    for (i=1; i<=n_modules; i=i+1) begin
        do_debug_wr(`REG_GUPS_CONTROL(32'ha00000 | i << 16), 32'h01 | (do_reads << 1) | (do_writes<< 2));
    end

end
endtask

// setup all gups modules with the default values. hopefully this corresponds roughly to the same defaults we
//   use when running real hardware and software.
// this is the function that used to be called just plain "gups_setup"
task gups_setup_defaults;
    begin
        gups_setup(5 /*#ports*/, 1 /*size*/);
    end
endtask
        

// this just resets the gups modules by writing the user reset register
task gups_rst;
    input   rst_val;
    begin
        if (rst_val)    $display("[%t] placing the user modules into reset", $time);
        else            $display("[%t] bringing user modules out of reset", $time);
        do_debug_wr(32'h408, {27'h0,{5{rst_val}}});
        #1000;
    end
endtask

task gups_stop;
begin : GUPS_STOP
    integer i;
    $display("disabling user modules", $time);
    for (i=1; i<5; i=i+1) begin
        do_debug_wr(`REG_GUPS_CONTROL(32'ha00000 | i << 16), 32'h00 | (enable_gups_rd << 1) | (enable_gups_wr << 2));
    end
    #5000; // let the last module keep running awhile to flush out all the reads from the other modules.
    do_debug_wr(`REG_GUPS_CONTROL(32'ha00000 | 5 << 16), 32'h00 | (enable_gups_rd << 1) | (enable_gups_wr << 2));
end
endtask

task gups_stats;
begin : GUPS_STATS
    integer i;
    #200;
    $display("[%t] GUPS stats", $time);
    $display("[%t] read/write", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_N_READ0(32'ha00000 | i << 16));
        do_debug_rd(`REG_GUPS_N_WRITE0(32'ha00000 | i << 16));
    end
    #200;
    $display("[%t] min rd latency", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_TAG_MIN_LATENCY(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))));
    end
    #200;
    $display("[%t] max rd latency", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_TAG_MAX_LATENCY(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))));
    end
    #200;
    $display("[%t] n lost tags", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_TAG_N_LOST(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))));
    end
    #200;
    $display("[%t] first lost tag", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_TAG_LOST(`REG_GUPS_RD_TAG_BASE_ADDR(32'ha00000 | (i << 16))));
    end
    #200;
    $display("[%t] magic", $time);
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd(`REG_GUPS_MAGIC(32'ha00000 | i << 16));
    end
end
endtask

task gups_speed;
    input   integer RUNTIME;
    input   [15:0]  mode;
    input   integer tokens;
    input   integer modules;
    input   integer tags;
    input   integer size;
    output  real    total_gups;
begin : GUPS_SPEED
    integer i;
    reg [31:0] start_count [1:5], end_count[1:5];

    // Start the runtime and read the start values simultaneously so the time taken to read
    // the registers does not corrupt the runtime
    fork     
        // Run for the specified runtime
        #RUNTIME;

        // Get starting read counts
        for (i=1; i<=5; i=i+1) begin
            do_debug_rd_save(`REG_GUPS_N_READ0(32'ha00000 | i << 16), start_count[i]);
        end
    join

    // Get ending read counts, these reads start exactly RUNTIME after the start_count reads
    for (i=1; i<=5; i=i+1) begin
        do_debug_rd_save(`REG_GUPS_N_READ0(32'ha00000 | i << 16), end_count[i]);
    end

    // Calculate and print the results
    total_gups = 0.0;
    for (i=1; i<=5; i=i+1) begin
        total_gups = total_gups + $itor(end_count[i]) - $itor(start_count[i]); 
    end

    // Total_gups time is corrected for the 12.5MHz tx_clk rate used in the simulation
    // to make it match the 250MHz clock rate used in HW testing on the EX800 and also
    // multiplied by 4 to match the 4 links on the EX800.
    total_gups = total_gups / $itor(RUNTIME) * 250.0 / 12.5 * 4.0;

    $display("[%t] GUPS Speed  MODE=%s, TOKENS=%0d, MODULES=%0d, TAGS=%0d, SIZE=%0d GUPS=%06f", $time,mode,tokens,modules,tags,size,total_gups);

end
endtask

