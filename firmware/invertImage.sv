`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2017 09:08:50 PM
// Design Name: 
// Module Name: invertImage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "reg_list.vh"
`include "hmc_def.vh"


module invertImage # (
)(
        input  wire startFunction,
        input  wire [127:0]         values[31:0],
        output  reg [127:0]         invertedValues[31:0],
        output reg done
        
    );
    
    reg[15:0] num1[31:0]; 
    reg[15:0] num2[31:0];
    reg[15:0] num3[31:0]; 
    reg[15:0] num4[31:0];
    reg[15:0] num5[31:0]; 
    reg[15:0] num6[31:0];
    reg[15:0] num7[31:0]; 
    reg[15:0] num8[31:0];
          
  
   integer i,j;

always @(startFunction) begin
    
    if(startFunction == 1)
    begin
        for(i=0;i<32;i=i+1)
            begin
        
             num1[i] <= 255 - values[i][127:112];   
             num2[i] <= 255 - values[i][111:96];
             
             num3[i] <= 255 - values[i][95:80];   
             num4[i] <= 255 - values[i][79:64];

             num5[i] <= 255 - values[i][63:48];   
             num6[i] <= 255 - values[i][47:32];
             
             num7[i] <= 255 - values[i][31:16];   
             num8[i] <= 255 - values[i][15:0];
   
            end
   
        for(j=0;j<32;j=j+1)
         begin
           invertedValues[j] <= {num1[j],num2[j],  num3[j],num4[j],  num5[j],num6[j],  num7[j],num8[j]};
   
          end
        
        done <= 1;  
     end
     else
        begin
            done <= 0;
        end
   
end
  
    
endmodule
