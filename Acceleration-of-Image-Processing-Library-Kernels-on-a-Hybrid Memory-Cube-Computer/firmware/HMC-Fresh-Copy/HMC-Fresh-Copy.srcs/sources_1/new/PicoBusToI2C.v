/*
* File Name     : PicoBusToI2C.v
*
* Creation Date : 07-18-2013
*
* Author        : Corey Olson
*
* Last Modified : Fri 19 Jul 2013 03:45:18 PM CDT
*
* Description   : This uses a bit-banging approach for reading and writing the
*                 I2C bus.  We simply expose the controls for the SCL and SDA
*                 lines to the PicoBus
*
*                 --------------
*                 PicoBus Writes
*                 --------------
*                 bit       data            description
*                 ---       ----            ----------------
*                 1         sda_padoen_n    active-low signal, when written to
*                                           1 SDA will be pulled high by the 
*                                           external pullup on the SDA line
*                 0         scl_padoen_n    active-low signal, when written to
*                                           1 SCL will be pulled high by the 
*                                           external pullup on the SCL line
*                 --------------
*                 PicoBus Reads
*                 --------------
*                 bit       data            description
*                 ---       ----            ----------------
*                 1         sda             current value on the SDA line
*                 0         scl             current value on the SCL line
*
* Copyright     : 2013, Pico Computing, Inc.
*/
module PicoBusToI2C #(
    parameter PICOBUS_ADDR  = 0
)
(
    // sda and scl lines
    input               scl_pad_i,      // SCL-line input
    output              scl_pad_o,      // SCL-line output (always 1'b0)
    output              scl_padoen_o,   // SCL-line output enable

    input               sda_pad_i,      // SDA-line input
    output              sda_pad_o,      // SDA-line output (always 1'b0)
    output              sda_padoen_o,   // SDA-line output enable

    // These are the standard PicoBus signals that we'll use to communicate with the rest of the system.
    input               PicoClk,
    input               PicoRst,
    input  [31:0]       PicoAddr,
    input  [31:0]       PicoDataIn,
    input               PicoRd,
    input               PicoWr,
    output reg [31:0]   PicoDataOut
);

    // I2C enable signals
    reg                 scl_padoen_n=1; // SCL-line output enable (active-low, set via PicoBus)
    reg                 sda_padoen_n=1; // SDA-line output enable (active-low, set via PicoBus)

    ///////////////////////////////////////////////////////
    // control the SDA and SCL lines
    ///////////////////////////////////////////////////////
    
    // SCL
    assign scl_pad_o = 1'b0;
    assign scl_padoen_o = ~scl_padoen_n;
    
    // SDA
    assign sda_pad_o = 1'b0;
    assign sda_padoen_o = ~sda_padoen_n;

    ///////////////////////////////////////////////////
    // Write the SDA and SCL outputs via the PicoBus //
    ///////////////////////////////////////////////////
    always @ (posedge PicoClk) begin
        if (PicoRst) begin
            sda_padoen_n    <= 1;
            scl_padoen_n    <= 1;
        end 
        // want to be sure that when we do NOT introduce a confusing inversion
        // when writing these signals via the PicoBus
        // -e.g. when we write PicoDataIn = 32'h1, we let SCL be pulled high
        // -e.g. when we write PicoDataIn = 32'h0, we drive SCL low
        else if (PicoWr && PicoAddr == PICOBUS_ADDR) begin
            sda_padoen_n    <= PicoDataIn[1];
            scl_padoen_n    <= PicoDataIn[0];
        end
    end

    /////////////////////////////////////////////////
    // Read the SDA and SCL inputs via the PicoBus //
    /////////////////////////////////////////////////
    always @ (posedge PicoClk) begin
        if (PicoRst) begin
            PicoDataOut     <= 0;
        end else if (PicoRd && PicoAddr == PICOBUS_ADDR) begin
            PicoDataOut     <= {sda_pad_i,
                                scl_pad_i};
        end else begin
            PicoDataOut     <= 0;
        end
    end

    ///////////
    // DEBUG //
    ///////////

    reg [8:0]   i2c_data;
    reg [31:0]  txCnt=0;

    // detect some data patterns and print them out
    // Note: this has not been verified to actually work, but it's just
    // a debugging print statement
    always @ (posedge scl_pad_i) begin
        i2c_data    <= {i2c_data, sda_pad_i};
        if (txCnt == 8) begin
            $display("I2C transmission = 0x%h, ack = %h", i2c_data[7:0], sda_pad_i);
            txCnt   <= 0;
        end else begin
            txCnt   <= txCnt + 1;
        end
    end

endmodule
