
`timescale 1ns/1ps

`include "reg_list.vh"
`include "hmc_def.vh"


module gups_top # (
    parameter TAG_WIDTH = 6,
    parameter SIZE_WIDTH = 4,
    parameter ADDR_WIDTH = 34,
    parameter DATA_WIDTH = 128,
    parameter INSTANCE_NUM = 1,
    parameter NAME = ""
) (
    input  wire                     tx_clk,
    input  wire                     rx_clk,

    input  wire                     rst,

    input  wire                     hmc_trained,
    
    output reg                     cmd_valid,
    input  wire                     cmd_ready,
    output reg [3:0]               cmd,
    output reg [ADDR_WIDTH-1:0]    addr,
    output reg [SIZE_WIDTH-1:0]    size,
    output reg [TAG_WIDTH-1:0]     tag,
    output reg [DATA_WIDTH-1:0]    wr_data,
    output reg                     wr_data_valid,
    input  wire                     wr_data_ready,

    input  wire [DATA_WIDTH-1:0]    rd_data,
    input  wire [TAG_WIDTH-1:0]     rd_data_tag,
    input  wire                     rd_data_valid,
    input  wire [6:0]               errstat,
    input  wire                     dinv,
    output reg [6:0]                errstat_count,
    output reg [6:0]                dinv_count,
    output reg [6:0]                errstat_out,                



    // Pico Bus
    input  wire                     PicoClk,
    input  wire                     PicoRst,
    input  wire                     PicoRd,
    input  wire                     PicoWr,
    input  wire [31:0]              PicoAddr,
    input  wire [31:0]              PicoDataIn,
    output wire [31:0]              PicoDataOut,
    
    input  wire [31:0]              vector_size,
    input  wire [31:0]              work_size,
    input  wire [31:0]              hmc_address,
    input  wire                     enable,        
    output reg                      finished
       
);  
       
   
    reg[33:0] current_addr;
    reg startFunction; //added
    wire functionDone; //added
    
    
    reg[127:0] data_this;
    reg[5:0] counter_rd=0;
    reg[5:0] counter_wr=0;
    reg readFinished =0;
    reg writeFinished =0;
    
    //new addition
    reg writeStart=0;
    reg[33:0] write_addr=0;
    //reg[1:0] write_requests=0;
    
    reg[3:0] cmd_this;
    reg[33:0] addr_this;
    reg[3:0] size_this;
    reg[5:0] tag_this;
    reg wr_en_data;
    reg wr_en_cmd;
    wire data_full;
    wire cmd_full;
    wire data_empty;
    wire cmd_empty;
    reg[127:0] values[31:0];
    reg[127:0] invertedValues[31:0]; //added
    
    reg[31:0] valid_signal;
    
    reg [6:0] readCounter = 0;
    
    //user logic change
   invertImage invertValues (
       .startFunction(startFunction),
       .values(values),
       .invertedValues(invertedValues),
       .done(functionDone)
    );
    
    
    
    /* Instantiate the memory interface containing the fifos */
    cmd_data_interface hmc_interface (
        .tx_clk(tx_clk),
        .application_clk(rx_clk),
        .rst(rst),
        
        .cmd_ready(cmd_ready),
        .write_data_ready(wr_data_ready),
        .data_in(data_this),
        .cmd_in(cmd_this),
        .address_in(addr_this),
        .size_in(size_this),
        .tag_in(tag_this),
        .wr_en_data(wr_en_data),
        .wr_en_cmd(wr_en_cmd),
        
        .cmd_valid(cmd_valid),
        .write_data_valid(wr_data_valid),
        .data_out(wr_data),
        .cmd_out(cmd),
        .address_out(addr),
        .size_out(size),
        .tag_out(tag),
        .data_full(data_full),
        .cmd_full(cmd_full),
        .data_empty(data_empty),
        .cmd_empty(cmd_empty)
    );
    
    
    reg enable_this;
    
 always @(posedge rx_clk) begin
    if(rst) begin
        cmd_this <= 0;
        addr_this <= 0;
        tag_this <= 0;
        size_this <= 0;
        data_this <= 0;
        wr_en_data <= 0;
        wr_en_cmd <= 0;
        enable_this <= 0;    
        current_addr <= 0;
        finished <= 0;
        startFunction <= 0;
        
        counter_rd <=0;
        counter_wr<=0;
        readFinished <=0;
        
        writeFinished <=0;
        writeStart <=0;
        readCounter <= 0;
        write_addr <=0;
    
    end
//else_id2    
    else begin
    
        
        if(rd_data_valid) begin
            values[rd_data_tag] <= rd_data;
            valid_signal[rd_data_tag] <= 1;
            
            readCounter <= readCounter +1;
            if(readCounter == 31) begin
                startFunction <= 1;
            end
        end
    
//if_id1    
        if((enable_this == 0) && (enable == 1)) begin
            enable_this <= 1;
            startFunction <= 0;
            wr_en_data <= 0;
            wr_en_cmd <= 0;
            counter_rd <=0;
            counter_wr <=0;
            readCounter<=0;
            writeStart <=0;
            current_addr <= hmc_address;
            write_addr <= hmc_address + 16*vector_size;            
        end
        else if(enable_this ==1) begin
            if(!cmd_full && !readFinished && counter_rd<32) begin
                cmd_this <= `HMC_CMD_RD;
                addr_this <= current_addr;
                size_this <= 1;
                wr_en_cmd <= 1;
                wr_en_data <= 0;
                tag_this <= counter_rd; 
                current_addr <= current_addr +16;
             
                counter_rd <= counter_rd+1;   // only 32 tags are being used           
                
                if(current_addr >= (hmc_address + 16*work_size)) begin       //16 ->32
                    readFinished <=1;
                    current_addr <= current_addr+16;
                    
                end
                
                 
            end
            else if(writeStart && !cmd_full && !data_full && readCounter >=(counter_rd-1) && !writeFinished && (functionDone)) begin
    
                if(counter_wr !=  32) begin
                    data_this <= invertedValues[counter_wr];
                    cmd_this <= `HMC_CMD_WR;
                    wr_en_data <= 1;
                    size_this <= 1;
                    wr_en_cmd <= 1;
                    addr_this <= write_addr;
                    write_addr <= write_addr +16;
                end
            
                if(counter_wr <32 && counter_wr<counter_rd) begin                            
                    counter_wr <= counter_wr+1;                       
                end
                else begin
                    writeStart <=0;
                    counter_wr <= 0;
                    counter_rd <= 0;
                    readCounter <=0;
                    startFunction <= 0;
                    //write_addr <= write_addr -16;
                    
                    if(readFinished ==1) begin
                          writeFinished <=1;
                          writeStart <=0;
                          wr_en_data <= 0;
                          wr_en_cmd <= 0;  
                    end
                    
                end
                
                if(write_addr >= (hmc_address + 16*vector_size + 16 *work_size)) begin //made change 16->32
                    finished <=1;
                    writeFinished <=1;
                    writeStart <=0;
                    wr_en_data <= 0;
                    wr_en_cmd <= 0; 
                
                end
                
                
                
                            
            end
        
            else begin
                wr_en_data <= 0;
                wr_en_cmd <= 0;  
            end
            
            
            if(counter_rd==32 || readFinished) begin
                writeStart <=1;
            end
        end
//if_id1        
        


//if_id3            
        if((current_addr >= (hmc_address + 16*work_size))  && (writeFinished ==1)) begin
             if(enable == 0) begin
                 enable_this <= 0;
                 finished <= 0;
             end
             else begin
                 finished <= 1;
             end            
        end
//if_id3ends
/*        
        if (enable == 0) begin
            enable_this <=0;
            wr_en_data <= 0;
            wr_en_cmd <= 0;
            counter_rd <=0;
            counter_wr <=0;
            current_addr <= 0;
            startFunction <= 0;   
            readCounter<=0;
            
            cmd_this <= 0;
            addr_this <= 0;
            tag_this <= 0;
            size_this <= 0;
            data_this <= 0;
        end
*/        
        
            
//else_id2       
    end
    
 end

    
endmodule

    
