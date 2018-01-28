`include "hmc_def.vh"

/*
Uses two FIFOs to send data and commands to the HMC controller
*/


module cmd_data_interface(
    input wire tx_clk,
    input wire application_clk,
    input wire rst,
    
    input wire cmd_ready,           // ready signal of the cmd channel of the HMC controller
    input wire write_data_ready,    // ready signal of the write_data channel of the HMC controller
    input wire [127:0] data_in,
    input wire [3:0] cmd_in,
    input wire [33:0] address_in,
    input wire [3:0] size_in,
    input wire [5:0] tag_in,
    input wire wr_en_data,          // write enable from the user logic to write into data fifo.
    input wire wr_en_cmd,           // write enable from the user logic to write into cmd fifo.
    
    output wire cmd_valid,          // valid signal to the cmd channel of the HMC controller
    output wire write_data_valid,   // valid signal to the write_data channel of the HMC controller 
    output wire [127:0] data_out,   // data channel to the HMC controller
    output wire [3:0] cmd_out,
    output wire [33:0] address_out,
    output wire [3:0] size_out,
    output wire [5:0] tag_out,
    output wire data_full,
    output wire cmd_full,
    output wire data_empty,
    output wire cmd_empty
    
    );
    
    wire rd_en_data;
    wire fifo_data_valid;
    reg fifo_data_enable;
    
    /* The write_data channel of the HMC controller accepts data even if no write request was issued.
    Therefore both the valid and the ready signal are set to 0 if no write request was issued.
    Then the data can be supplied to the fifo earlier than the write command. */ 
    assign rd_en_data = (fifo_data_enable && write_data_ready);
    assign write_data_valid = (fifo_data_enable && fifo_data_valid);
    
    fifo_generator_0 fifo_data (
      .wr_clk(application_clk),  // input wire wr_clk
      .rd_clk(tx_clk),  // input wire rd_clk
      .din(data_in),        // input wire [1023 : 0] din
      .wr_en(wr_en_data),    // input wire wr_en
      .rd_en(rd_en_data),    // input wire rd_en
      .dout(data_out),      // output wire [127 : 0] dout
      .full(data_full),      // output wire full
      .empty(data_empty),    // output wire empty
      .valid(fifo_data_valid)    // output wire valid
    );
    
    
    wire[47:0] din_cmd;
    wire[47:0] dout_cmd;
    assign din_cmd = {cmd_in,address_in,size_in,tag_in};
    assign tag_out = dout_cmd[5:0];
    assign size_out = dout_cmd[9:6];
    assign address_out = dout_cmd[43:10];
    assign cmd_out = dout_cmd[47:44];
    
    fifo_generator_1 fifo_cmd (
      .wr_clk(application_clk),  // input wire wr_clk
      .rd_clk(tx_clk),  // input wire rd_clk
      .din(din_cmd),        // input wire [47 : 0] din
      .wr_en(wr_en_cmd),    // input wire wr_en
      .rd_en(cmd_ready),    // input wire rd_en
      .dout(dout_cmd),      // output wire [47 : 0] dout
      .full(cmd_full),      // output wire full
      .empty(cmd_empty),    // output wire empty
      .valid(cmd_valid)    // output wire valid
    );
    
    reg[10:0] counter_wr_data;  // Stores the count of 16B blocks that have to be provided to the write_data channel.
            
    // Watch the command channel to enable data fifo only when write requests were issued
    always @(posedge tx_clk) begin
        if (rst) begin
            fifo_data_enable <= 0;
            counter_wr_data <= 0;
        end
        else begin
            if (counter_wr_data > 0) begin
                // If data is supplied to the HMC controller and no write request is issued in this clock cycle it could happen that this is the last outstanding 16B Block
                if(rd_en_data && write_data_valid && (!(cmd_valid && cmd_ready && (cmd_out==`HMC_CMD_WR)))) begin
                    // If only one 16B Block was outstanding the data fifo can be disabled for now
                    if(counter_wr_data == 1) begin
                        fifo_data_enable <= 0;
                    end
                end
                else begin
                    fifo_data_enable <= 1;
                end
            end
            
            // fifo_data read (16B provided to HMC controller), no write request issued
            if(rd_en_data && write_data_valid && (!(cmd_valid && cmd_ready && (cmd_out==`HMC_CMD_WR)))) begin 
                counter_wr_data <= counter_wr_data -1;
            end
            // write request issued, no fifo read
            else if((!(rd_en_data && write_data_valid)) && cmd_valid && cmd_ready && (cmd_out==`HMC_CMD_WR)) begin 
                counter_wr_data <= counter_wr_data + size_out;
            end
            // fifo_data read (16B provided to HMC controller) and write request issued
            else if(rd_en_data && write_data_valid && cmd_valid && cmd_ready && (cmd_out==`HMC_CMD_WR)) begin 
                counter_wr_data <= counter_wr_data + size_out - 1;
            end
        end  
    end
    
endmodule
