`timescale 1ns / 1ps

`ifdef SIMULATION
    `define HMC_N_PORTS 5
`else
`ifndef HMC_N_PORTS
    `define HMC_N_PORTS 10
`endif
`endif

`include "reg_list.vh"
`include "hmc_def.vh"

module user_wrapper #(
        parameter SIZE_WIDTH = 4,
        parameter ADDR_WIDTH = 34,
        parameter DATA_WIDTH = 128,
        parameter N_PORTS = `HMC_N_PORTS
        ) (
        input                       tx_clk,
        input                       rx_clk,
        input                       hmc_rst,
        input                       hmc_trained,

        (* mark_debug = "true" *) output                      cmd_valid_p0,
        (* mark_debug = "true" *) input                       cmd_ready_p0,
        (* mark_debug = "true" *) output [3:0]                cmd_p0,
        (* mark_debug = "true" *) output [ADDR_WIDTH-1:0]     addr_p0,
        (* mark_debug = "true" *) output [SIZE_WIDTH-1:0]     size_p0,
        (* mark_debug = "true" *) output [5:0]                tag_p0,
        output [DATA_WIDTH-1:0]     wr_data_p0,
        (* mark_debug = "true" *) output                      wr_data_valid_p0,
        (* mark_debug = "true" *) input                       wr_data_ready_p0,

        input [DATA_WIDTH-1:0]      rd_data_p0,
        (* mark_debug = "true" *) input [5:0]                 rd_data_tag_p0,
        (* mark_debug = "true" *) input                       rd_data_valid_p0,
        (* mark_debug = "true" *) input [6:0]                 errstat_p0,
        (* mark_debug = "true" *) input                       dinv_p0,
        (* mark_debug = "true" *)output                      cmd_valid_p1,
        (* mark_debug = "true" *)input                       cmd_ready_p1,
        output [3:0]                cmd_p1,
        output [ADDR_WIDTH-1:0]     addr_p1,
        output [SIZE_WIDTH-1:0]     size_p1,
        output [5:0]                tag_p1,
        output [DATA_WIDTH-1:0]     wr_data_p1,
        output                      wr_data_valid_p1,
        input                       wr_data_ready_p1,

        input [DATA_WIDTH-1:0]      rd_data_p1,
        input [5:0]                 rd_data_tag_p1,
        input                       rd_data_valid_p1,
        input [6:0]                 errstat_p1,
        input                       dinv_p1,
        (* mark_debug = "true" *) output                      cmd_valid_p2,
        (* mark_debug = "true" *) input                       cmd_ready_p2,
        output [3:0]                cmd_p2,
        output [ADDR_WIDTH-1:0]     addr_p2,
        output [SIZE_WIDTH-1:0]     size_p2,
        output [5:0]                tag_p2,
        output [DATA_WIDTH-1:0]     wr_data_p2,
        output                      wr_data_valid_p2,
        input                       wr_data_ready_p2,

        input [DATA_WIDTH-1:0]      rd_data_p2,
        input [5:0]                 rd_data_tag_p2,
        input                       rd_data_valid_p2,
        input [6:0]                 errstat_p2,
        input                       dinv_p2,
        (* mark_debug = "true" *) output                      cmd_valid_p3,
        (* mark_debug = "true" *) input                       cmd_ready_p3,
        output [3:0]                cmd_p3,
        output [ADDR_WIDTH-1:0]     addr_p3,
        output [SIZE_WIDTH-1:0]     size_p3,
        output [5:0]                tag_p3,
        output [DATA_WIDTH-1:0]     wr_data_p3,
        output                      wr_data_valid_p3,
        input                       wr_data_ready_p3,

        input [DATA_WIDTH-1:0]      rd_data_p3,
        input [5:0]                 rd_data_tag_p3,
        input                       rd_data_valid_p3,
        input [6:0]                 errstat_p3,
        input                       dinv_p3,
        (* mark_debug = "true" *) output                      cmd_valid_p4,
        (* mark_debug = "true" *) input                       cmd_ready_p4,
        (* mark_debug = "true" *) output [3:0]                cmd_p4,
        (* mark_debug = "true" *) output [ADDR_WIDTH-1:0]     addr_p4,
        (* mark_debug = "true" *) output [SIZE_WIDTH-1:0]     size_p4,
        (* mark_debug = "true" *) output [5:0]                tag_p4,
        output [DATA_WIDTH-1:0]     wr_data_p4,
        (* mark_debug = "true" *) output                      wr_data_valid_p4,
        (* mark_debug = "true" *) input                       wr_data_ready_p4,

        input [DATA_WIDTH-1:0]      rd_data_p4,
        (* mark_debug = "true" *) input [5:0]                 rd_data_tag_p4,
        (* mark_debug = "true" *) input                       rd_data_valid_p4,
        (* mark_debug = "true" *) input [6:0]                 errstat_p4,
        (* mark_debug = "true" *) input                       dinv_p4,
        (* mark_debug = "true" *) output                      cmd_valid_p5,
        (* mark_debug = "true" *) input                       cmd_ready_p5,
        output [3:0]                cmd_p5,
        output [ADDR_WIDTH-1:0]     addr_p5,
        output [SIZE_WIDTH-1:0]     size_p5,
        output [5:0]                tag_p5,
        output [DATA_WIDTH-1:0]     wr_data_p5,
        output                      wr_data_valid_p5,
        input                       wr_data_ready_p5,

        input [DATA_WIDTH-1:0]      rd_data_p5,
        input [5:0]                 rd_data_tag_p5,
        input                       rd_data_valid_p5,
        input [6:0]                 errstat_p5,
        input                       dinv_p5,
        (* mark_debug = "true" *) output                      cmd_valid_p6,
        (* mark_debug = "true" *) input                       cmd_ready_p6,
        output [3:0]                cmd_p6,
        output [ADDR_WIDTH-1:0]     addr_p6,
        output [SIZE_WIDTH-1:0]     size_p6,
        output [5:0]                tag_p6,
        output [DATA_WIDTH-1:0]     wr_data_p6,
        output                      wr_data_valid_p6,
        input                       wr_data_ready_p6,

        input [DATA_WIDTH-1:0]      rd_data_p6,
        input [5:0]                 rd_data_tag_p6,
        input                       rd_data_valid_p6,
        input [6:0]                 errstat_p6,
        input                       dinv_p6,
        (* mark_debug = "true" *) output                      cmd_valid_p7,
        (* mark_debug = "true" *) input                       cmd_ready_p7,
        output [3:0]                cmd_p7,
        output [ADDR_WIDTH-1:0]     addr_p7,
        output [SIZE_WIDTH-1:0]     size_p7,
        output [5:0]                tag_p7,
        output [DATA_WIDTH-1:0]     wr_data_p7,
        output                      wr_data_valid_p7,
        input                       wr_data_ready_p7,

        input [DATA_WIDTH-1:0]      rd_data_p7,
        input [5:0]                 rd_data_tag_p7,
        input                       rd_data_valid_p7,
        input [6:0]                 errstat_p7,
        input                       dinv_p7,
        output                      cmd_valid_p8,
        input                       cmd_ready_p8,
        output [3:0]                cmd_p8,
        output [ADDR_WIDTH-1:0]     addr_p8,
        output [SIZE_WIDTH-1:0]     size_p8,
        output [5:0]                tag_p8,
        output [DATA_WIDTH-1:0]     wr_data_p8,
        output                      wr_data_valid_p8,
        input                       wr_data_ready_p8,

        input [DATA_WIDTH-1:0]      rd_data_p8,
        input [5:0]                 rd_data_tag_p8,
        input                       rd_data_valid_p8,
        input [6:0]                 errstat_p8,
        input                       dinv_p8,
        output                      cmd_valid_p9,
        input                       cmd_ready_p9,
        output [3:0]                cmd_p9,
        output [ADDR_WIDTH-1:0]     addr_p9,
        output [SIZE_WIDTH-1:0]     size_p9,
        output [5:0]                tag_p9,
        output [DATA_WIDTH-1:0]     wr_data_p9,
        output                      wr_data_valid_p9,
        input                       wr_data_ready_p9,

        input [DATA_WIDTH-1:0]      rd_data_p9,
        input [5:0]                 rd_data_tag_p9,
        input                       rd_data_valid_p9,
        input [6:0]                 errstat_p9,
        input                       dinv_p9,

        input               PicoClk,
        input               PicoRst,
        input  [31:0]       PicoAddr,
        input  [31:0]       PicoDataIn,
        output [31:0]       PicoDataOut,
        input               PicoRd,
        input               PicoWr
    );
    wire rst = hmc_rst;
    
    reg[31:0] PicoDataOut_this;
    assign PicoDataOut = PicoDataOut_this;
    
    reg[31:0] hmc_address;
    reg[31:0] vector_size; // In 8*16 byte
    reg enable;
    
    reg[31:0] counter_ticks;    // Stores the clock cycles (4MHz PicoClk) needed to finish the vector addition
    
    always @(posedge PicoClk) begin
            if (PicoRst) begin
                PicoDataOut_this <= 0;
                hmc_address <= 32'h0;
                enable <= 0;
                vector_size <= 0;
                counter_ticks <= 0;
                
            
            end else begin
                /* First argument of Pico_write is the address on the PicoBus,
                second argument is the operation performed when a write operation to that address is detected */
                `PICO_WRITE(32'h10000, hmc_address <= PicoDataIn;)
                `PICO_WRITE(32'h10008, counter_ticks <= PicoDataIn;)
                `PICO_WRITE(32'h10018, vector_size <= PicoDataIn;)
                `PICO_WRITE(32'h10004, enable <= PicoDataIn[0];)
                else if((enable==1) && (finished==1)) begin
                    enable <= 0;
                end
            end
            
            /* Most of the registers can be read for debugging purposes.
            Necessary is only counter_ticks (to measure the time needed) */    
            `PICO_READ(32'h10000, PicoDataOut_this   <= hmc_address;)
            else `PICO_READ(32'h10004, PicoDataOut_this[0] <= enable;)
            else `PICO_READ(32'h10008, PicoDataOut_this <= counter_ticks;)
            else `PICO_READ(32'h10018, PicoDataOut_this <= vector_size;)
            else `PICO_READ(32'h10020, PicoDataOut_this <= finished;)
            
            else `PICO_READ(32'h10034, PicoDataOut_this <= errstat_m0;)
            else `PICO_READ(32'h1003C, PicoDataOut_this <= errstat_m1;)
            else `PICO_READ(32'h10040, PicoDataOut_this <= errstat_m2;)
            else `PICO_READ(32'h10044, PicoDataOut_this <= errstat_m3;)
            else `PICO_READ(32'h10048, PicoDataOut_this <= errstat_m4;)
            else `PICO_READ(32'h1004C, PicoDataOut_this <= errstat_m5;)
            else `PICO_READ(32'h10050, PicoDataOut_this <= errstat_m6;)
            else `PICO_READ(32'h10054, PicoDataOut_this <= errstat_m7;)
            else `PICO_READ(32'h10058, PicoDataOut_this <= rd_add0;)
            else `PICO_READ(32'h1005C, PicoDataOut_this <= rd_add1;)
            else `PICO_READ(32'h10060, PicoDataOut_this <= rd_add2;)
            else `PICO_READ(32'h10064, PicoDataOut_this <= rd_add3;)
            else `PICO_READ(32'h10068, PicoDataOut_this <= rd_add4;)
            else `PICO_READ(32'h1006C, PicoDataOut_this <= rd_add5;)
            else `PICO_READ(32'h10070, PicoDataOut_this <= rd_add6;)
            else `PICO_READ(32'h10074, PicoDataOut_this <= rd_add7;)
            else `PICO_READ(32'h10078, PicoDataOut_this <= wr_add0;)
            else `PICO_READ(32'h1007C, PicoDataOut_this <= wr_add1;)
            else `PICO_READ(32'h10080, PicoDataOut_this <= wr_add2;)
            else `PICO_READ(32'h10084, PicoDataOut_this <= wr_add3;)
            else `PICO_READ(32'h10088, PicoDataOut_this <= wr_add4;)
            else `PICO_READ(32'h1008C, PicoDataOut_this <= wr_add5;)
            else `PICO_READ(32'h10090, PicoDataOut_this <= wr_add6;)
            else `PICO_READ(32'h10094, PicoDataOut_this <= wr_add7;)
            else `PICO_READ(32'h10098, PicoDataOut_this <= work_size0;)
            else `PICO_READ(32'h1009C, PicoDataOut_this <= work_size1;)
            else `PICO_READ(32'h100A0, PicoDataOut_this <= work_size2;)
            else `PICO_READ(32'h100A4, PicoDataOut_this <= work_size3;)
            else `PICO_READ(32'h100A8, PicoDataOut_this <= work_size4;)
            else `PICO_READ(32'h100AC, PicoDataOut_this <= work_size5;)
            else `PICO_READ(32'h100B0, PicoDataOut_this <= work_size6;)
            else `PICO_READ(32'h100B4, PicoDataOut_this <= work_size7;)
            else `PICO_READ(32'h100B8, PicoDataOut_this <= hmc_address0;)
            else `PICO_READ(32'h100BC, PicoDataOut_this <= hmc_address1;)
            else `PICO_READ(32'h100C0, PicoDataOut_this <= hmc_address2;)
            else `PICO_READ(32'h100C4, PicoDataOut_this <= hmc_address3;)
            else `PICO_READ(32'h100C8, PicoDataOut_this <= hmc_address4;)
            else `PICO_READ(32'h100CC, PicoDataOut_this <= hmc_address5;)
            else `PICO_READ(32'h100D0, PicoDataOut_this <= hmc_address6;)
            else `PICO_READ(32'h100D4, PicoDataOut_this <= hmc_address7;)
            else PicoDataOut_this <= 0; // PicoBus is shared, thus it must be set to zero if not in use
            
            /* If hardware is working count the clock cycles to measure the time needed */
            if(enable) begin
                counter_ticks <= counter_ticks + 1;
            end
            
    end

   
    wire [6:0] errstat_m0;
    wire [6:0] errstat_m1;
    wire [6:0] errstat_m2;
    wire [6:0] errstat_m3;
    wire [6:0] errstat_m4;
    wire [6:0] errstat_m5;
    wire [6:0] errstat_m6;
    wire [6:0] errstat_m7;
    wire [6:0] errstat_count_m0;
    wire [6:0] errstat_count_m1;
    wire [6:0] errstat_count_m2;
    wire [6:0] errstat_count_m3;
    wire [6:0] errstat_count_m4;
    wire [6:0] errstat_count_m5;
    wire [6:0] errstat_count_m6;
    wire [6:0] errstat_count_m7;
    wire [6:0] dinv_count_m0;
    wire [6:0] dinv_count_m1;
    wire [6:0] dinv_count_m2;
    wire [6:0] dinv_count_m3;
    wire [6:0] dinv_count_m4;
    wire [6:0] dinv_count_m5;
    wire [6:0] dinv_count_m6;
    wire [6:0] dinv_count_m7;
  
    wire [31:0] work_size0;
    wire [31:0] work_size1;
    wire [31:0] work_size2;
    wire [31:0] work_size3;
    wire [31:0] work_size4;
    wire [31:0] work_size5;
    wire [31:0] work_size6;
    wire [31:0] work_size7;
    wire [31:0] hmc_address0;
    wire [31:0] hmc_address1;
    wire [31:0] hmc_address2; 
    wire [31:0] hmc_address3; 
    wire [31:0] hmc_address4; 
    wire [31:0] hmc_address5; 
    wire [31:0] hmc_address6;
    wire [31:0] hmc_address7;   
    (* mark_debug = "true" *) wire finished0;
    (* mark_debug = "true" *) wire finished1;
    (* mark_debug = "true" *) wire finished2;
    (* mark_debug = "true" *) wire finished3;
    (* mark_debug = "true" *) wire finished4;
    (* mark_debug = "true" *) wire finished5;
    (* mark_debug = "true" *) wire finished6;
    (* mark_debug = "true" *) wire finished7;
    
    (* mark_debug = "true" *) wire finished;
    
    //modification
    wire [31:0] rd_add0;
    wire [31:0] rd_add1;
    wire [31:0] rd_add2;
    wire [31:0] rd_add3;
    wire [31:0] rd_add4;
    wire [31:0] rd_add5;
    wire [31:0] rd_add6;
    wire [31:0] rd_add7;
    
    wire [31:0] wr_add0;
    wire [31:0] wr_add1;
    wire [31:0] wr_add2;
    wire [31:0] wr_add3;
    wire [31:0] wr_add4;
    wire [31:0] wr_add5;
    wire [31:0] wr_add6;
    wire [31:0] wr_add7;
    
    //modifucation ends
          
    
    /* Split the address space of the vector and assign it to the 8 modules */
    assign work_size0 = vector_size/8;
    assign work_size1 = vector_size/8;
    assign work_size2 = vector_size/8;
    assign work_size3 = vector_size/8;
    assign work_size4 = vector_size/8;
    assign work_size5 = vector_size/8;
    assign work_size6 = vector_size/8;
    assign work_size7 = vector_size - 7*(vector_size/8);
    assign hmc_address0 = hmc_address;
    assign hmc_address1 = hmc_address0 + work_size0*16;
    assign hmc_address2 = hmc_address1 + work_size1*16;
    assign hmc_address3 = hmc_address2 + work_size2*16;
    assign hmc_address4 = hmc_address3 + work_size3*16;
    assign hmc_address5 = hmc_address4 + work_size4*16;
    assign hmc_address6 = hmc_address5 + work_size5*16;
    assign hmc_address7 = hmc_address6 + work_size6*16;
    assign finished = finished0 && finished1 && finished2 && finished3 && finished4 && finished5 && finished6 && finished7;
    
    /* Instantiate 8 vector addition modules. Every module uses one user port of the HMC Controller
    and is responsible for a portion of the vector address space. */
    gups_top UserModule_0 (
        .tx_clk(tx_clk),
        .rx_clk(rx_clk),
        .rst(rst),
        .hmc_trained(hmc_trained),

        .PicoClk(PicoClk),
        .PicoRst(PicoRst),
        .PicoRd(PicoRd),
        .PicoWr(PicoWr),
        .PicoAddr(PicoAddr),
        .PicoDataIn(PicoDataIn),



        .addr(addr_p0),
        .size(size_p0),
        .tag(tag_p0),
        .cmd_valid(cmd_valid_p0),
        .cmd_ready(cmd_ready_p0),
        .cmd(cmd_p0),
        .wr_data(wr_data_p0),
        .wr_data_valid(wr_data_valid_p0),
        .wr_data_ready(wr_data_ready_p0),

        .rd_data(rd_data_p0),
        .rd_data_tag(rd_data_tag_p0),
        .rd_data_valid(rd_data_valid_p0),
        .errstat(errstat_p0),
        .dinv(dinv_p0),
        .errstat_count(errstat_count_m0),
        .dinv_count(dinv_count_m0),
        .errstat_out(errstat_m0),
        
        .vector_size(vector_size),
        .work_size(work_size0),
        .hmc_address(hmc_address0),
        .enable(enable),
        .finished(finished0),
        .rd_addr(rd_add0),
        .wr_addr(wr_add0)
        
    );
    
    gups_top UserModule_1 (
        .tx_clk(tx_clk),
        .rx_clk(rx_clk),
        .rst(rst),
        .hmc_trained(hmc_trained),

        .PicoClk(PicoClk),
        .PicoRst(PicoRst),
        .PicoRd(PicoRd),
        .PicoWr(PicoWr),
        .PicoAddr(PicoAddr),
        .PicoDataIn(PicoDataIn),



        .addr(addr_p1),
        .size(size_p1),
        .tag(tag_p1),
        .cmd_valid(cmd_valid_p1),
        .cmd_ready(cmd_ready_p1),
        .cmd(cmd_p1),
        .wr_data(wr_data_p1),
        .wr_data_valid(wr_data_valid_p1),
        .wr_data_ready(wr_data_ready_p1),

        .rd_data(rd_data_p1),
        .rd_data_tag(rd_data_tag_p1),
        .rd_data_valid(rd_data_valid_p1),
        .errstat(errstat_p1),
        .dinv(dinv_p1),
        .errstat_count(errstat_count_m1),
        .dinv_count(dinv_count_m1),
        .errstat_out(errstat_m1),
        
        .vector_size(vector_size),
        .work_size(work_size1),
        .hmc_address(hmc_address1),
        .enable(enable),
        .finished(finished1),
        .rd_addr(rd_add1),
        .wr_addr(wr_add1)        
        
    );
    
    gups_top UserModule_3 (
            .tx_clk(tx_clk),
            .rx_clk(rx_clk),
            .rst(rst),
            .hmc_trained(hmc_trained),
    
            .PicoClk(PicoClk),
            .PicoRst(PicoRst),
            .PicoRd(PicoRd),
            .PicoWr(PicoWr),
            .PicoAddr(PicoAddr),
            .PicoDataIn(PicoDataIn),
    
    
            .addr(addr_p3),
            .size(size_p3),
            .tag(tag_p3),
            .cmd_valid(cmd_valid_p3),
            .cmd_ready(cmd_ready_p3),
            .cmd(cmd_p3),
            .wr_data(wr_data_p3),
            .wr_data_valid(wr_data_valid_p3),
            .wr_data_ready(wr_data_ready_p3),
    
            .rd_data(rd_data_p3),
            .rd_data_tag(rd_data_tag_p3),
            .rd_data_valid(rd_data_valid_p3),
            .errstat(errstat_p3),
            .dinv(dinv_p3),
            .errstat_count(errstat_count_m3),
            .dinv_count(dinv_count_m3),
            .errstat_out(errstat_m3),
            
            .vector_size(vector_size),
            .work_size(work_size3),
            .hmc_address(hmc_address3),
            .enable(enable),
            .finished(finished3),
            .rd_addr(rd_add3),
            .wr_addr(wr_add3)
            
        );
        
        gups_top UserModule_2 (
            .tx_clk(tx_clk),
            .rx_clk(rx_clk),
            .rst(rst),
            .hmc_trained(hmc_trained),
    
            .PicoClk(PicoClk),
            .PicoRst(PicoRst),
            .PicoRd(PicoRd),
            .PicoWr(PicoWr),
            .PicoAddr(PicoAddr),
            .PicoDataIn(PicoDataIn),
    
    
            .addr(addr_p2),
            .size(size_p2),
            .tag(tag_p2),
            .cmd_valid(cmd_valid_p2),
            .cmd_ready(cmd_ready_p2),
            .cmd(cmd_p2),
            .wr_data(wr_data_p2),
            .wr_data_valid(wr_data_valid_p2),
            .wr_data_ready(wr_data_ready_p2),
    
            .rd_data(rd_data_p2),
            .rd_data_tag(rd_data_tag_p2),
            .rd_data_valid(rd_data_valid_p2),
            .errstat(errstat_p2),
            .dinv(dinv_p2),
            .errstat_count(errstat_count_m2),
            .dinv_count(dinv_count_m2),
            .errstat_out(errstat_m2),
            
            .vector_size(vector_size),
            .work_size(work_size2),
            .hmc_address(hmc_address2),
            .enable(enable),
            .finished(finished2),
            .rd_addr(rd_add2),
            .wr_addr(wr_add2)
            
        );

    gups_top UserModule_4 (
            .tx_clk(tx_clk),
            .rx_clk(rx_clk),
            .rst(rst),
            .hmc_trained(hmc_trained),
    
            .PicoClk(PicoClk),
            .PicoRst(PicoRst),
            .PicoRd(PicoRd),
            .PicoWr(PicoWr),
            .PicoAddr(PicoAddr),
            .PicoDataIn(PicoDataIn),
    
    
            .addr(addr_p4),
            .size(size_p4),
            .tag(tag_p4),
            .cmd_valid(cmd_valid_p4),
            .cmd_ready(cmd_ready_p4),
            .cmd(cmd_p4),
            .wr_data(wr_data_p4),
            .wr_data_valid(wr_data_valid_p4),
            .wr_data_ready(wr_data_ready_p4),
    
            .rd_data(rd_data_p4),
            .rd_data_tag(rd_data_tag_p4),
            .rd_data_valid(rd_data_valid_p4),
            .errstat(errstat_p4),
            .dinv(dinv_p4),
            .errstat_count(errstat_count_m4),
            .dinv_count(dinv_count_m4),
            .errstat_out(errstat_m4),
            
            .vector_size(vector_size),
            .work_size(work_size4),
            .hmc_address(hmc_address4),
            .enable(enable),
            .finished(finished4),
            .rd_addr(rd_add4),
            .wr_addr(wr_add4)
            
        );

    gups_top UserModule_5 (
            .tx_clk(tx_clk),
            .rx_clk(rx_clk),
            .rst(rst),
            .hmc_trained(hmc_trained),
    
            .PicoClk(PicoClk),
            .PicoRst(PicoRst),
            .PicoRd(PicoRd),
            .PicoWr(PicoWr),
            .PicoAddr(PicoAddr),
            .PicoDataIn(PicoDataIn),
    
    
            .addr(addr_p5),
            .size(size_p5),
            .tag(tag_p5),
            .cmd_valid(cmd_valid_p5),
            .cmd_ready(cmd_ready_p5),
            .cmd(cmd_p5),
            .wr_data(wr_data_p5),
            .wr_data_valid(wr_data_valid_p5),
            .wr_data_ready(wr_data_ready_p5),
    
            .rd_data(rd_data_p5),
            .rd_data_tag(rd_data_tag_p5),
            .rd_data_valid(rd_data_valid_p5),
            .errstat(errstat_p5),
            .dinv(dinv_p5),
            .errstat_count(errstat_count_m5),
            .dinv_count(dinv_count_m5),
            .errstat_out(errstat_m5),
            
            .vector_size(vector_size),
            .work_size(work_size5),
            .hmc_address(hmc_address5),
            .enable(enable),
            .finished(finished5),
            .rd_addr(rd_add5),
            .wr_addr(wr_add5)
            
        );  
        
    gups_top UserModule_6 (
                .tx_clk(tx_clk),
                .rx_clk(rx_clk),
                .rst(rst),
                .hmc_trained(hmc_trained),
        
                .PicoClk(PicoClk),
                .PicoRst(PicoRst),
                .PicoRd(PicoRd),
                .PicoWr(PicoWr),
                .PicoAddr(PicoAddr),
                .PicoDataIn(PicoDataIn),
        
        
                .addr(addr_p6),
                .size(size_p6),
                .tag(tag_p6),
                .cmd_valid(cmd_valid_p6),
                .cmd_ready(cmd_ready_p6),
                .cmd(cmd_p6),
                .wr_data(wr_data_p6),
                .wr_data_valid(wr_data_valid_p6),
                .wr_data_ready(wr_data_ready_p6),
        
                .rd_data(rd_data_p6),
                .rd_data_tag(rd_data_tag_p6),
                .rd_data_valid(rd_data_valid_p6),
                .errstat(errstat_p6),
                .dinv(dinv_p6),
                .errstat_count(errstat_count_m6),
                .dinv_count(dinv_count_m6),
                .errstat_out(errstat_m6),
                
                .vector_size(vector_size),
                .work_size(work_size6),
                .hmc_address(hmc_address6),
                .enable(enable),
                .finished(finished6),
                .rd_addr(rd_add6),
                .wr_addr(wr_add6)
                
            );  
            
    gups_top UserModule_7 (
                    .tx_clk(tx_clk),
                    .rx_clk(rx_clk),
                    .rst(rst),
                    .hmc_trained(hmc_trained),
            
                    .PicoClk(PicoClk),
                    .PicoRst(PicoRst),
                    .PicoRd(PicoRd),
                    .PicoWr(PicoWr),
                    .PicoAddr(PicoAddr),
                    .PicoDataIn(PicoDataIn),
            
            
                    .addr(addr_p7),
                    .size(size_p7),
                    .tag(tag_p7),
                    .cmd_valid(cmd_valid_p7),
                    .cmd_ready(cmd_ready_p7),
                    .cmd(cmd_p7),
                    .wr_data(wr_data_p7),
                    .wr_data_valid(wr_data_valid_p7),
                    .wr_data_ready(wr_data_ready_p7),
            
                    .rd_data(rd_data_p7),
                    .rd_data_tag(rd_data_tag_p7),
                    .rd_data_valid(rd_data_valid_p7),
                    .errstat(errstat_p7),
                    .dinv(dinv_p7),
                    .errstat_count(errstat_count_m7),
                    .dinv_count(dinv_count_m7),
                    .errstat_out(errstat_m7),
                    
                    .vector_size(vector_size),
                    .work_size(work_size7),
                    .hmc_address(hmc_address7),
                    .enable(enable),
                    .finished(finished7),
                    .rd_addr(rd_add7),
                    .wr_addr(wr_add7)
                    
                );        
    

endmodule
