/*
* File Name     : hmc_soft_trainer.v
*
* Description   : This module lets our software inject data directly into our
*                 PHY during the bringup sequence.  It also lets us snoop on
*                 the outgoing RX data (out of the PHY) during the bringup
*                 sequence, which we then use to adjust our sync_shifter.
*
* TODO          : I think we need to align all the debug bus stuff to 4B
*
* Copyright     : 2015, Micron, Inc.
*/
module hmc_soft_trainer (
    // TX bus
    input                           tx_clk,
    input       [639:0]             tx_data_i,
    output  reg [639:0]             tx_data_o,

    // RX bus
    input                           rx_clk,
    input       [639:0]             rx_data_i,
    
    // async reset
    input                           rst,

	// Debug Bus
	input                           debug_clk,
	input       [31:0]              debug_addr,
	input       [31:0]              debug_din,
	output      [31:0]              debug_dout,
	input                           debug_rd,
	input                           debug_wr
);

    /////////////
    // TX BRAM //
    /////////////

    // we inject data into the PHY TX side using this BRAM
    wire        [31:0]              flit_debug_dout;
    wire        [639:0]             hmc_tx_data_bram;
    flit_bram flit_bram (
        .tx_clk                     (tx_clk),
        .tx_rst                     (rst),
        .dout                       (hmc_tx_data_bram),
        .rx_clk                     (rx_clk),
        .rx_rst                     (rst),
        .din                        (rx_data_i),
        .debug_clk                  (debug_clk),
        .debug_addr                 (debug_addr),
        .debug_rd                   (debug_rd),
        .debug_wr                   (debug_wr),
        .debug_din                  (debug_din),
        .debug_dout                 (flit_debug_dout)
    );

    ////////////
    // TX MUX //
    ////////////

    // this is the mux for the TX side
    // we either write data from the flit_bram into the PHY or else we just
    // let our tx_data_i pass right on through
    reg                             controller_en           = 0;
    reg                             controller_en_1         = 0;
    reg                             controller_en_2         = 0;
    reg         [31:0]              enable_debug_dout       = 0;

    always @(posedge tx_clk) begin
        if(controller_en_2)
            tx_data_o               <= tx_data_i;
        else
            tx_data_o               <= hmc_tx_data_bram;
        controller_en_1             <= controller_en;
        controller_en_2             <= controller_en_1;
    end

    ////////////////////
    // RX FLIT LOGGER //
    ////////////////////

    // listen to the data that comes back on the RX side
    wire        [31:0]              old_rx_debug_dout;
    old_flit_logger #(
        .BASE_ADDR                  (24'h8e),
        .NAME                       ("RX")
    ) old_rx_flit_logger (
        .clk                        (rx_clk),
        .rst                        (rst),
        .din                        (rx_data_i),

        .debug_clk                  (debug_clk),
        .debug_addr                 (debug_addr),
        .debug_rd                   (debug_rd),
        .debug_wr                   (debug_wr),
        .debug_din                  (debug_din),
        .debug_dout                 (old_rx_debug_dout)
	);

    ///////////////
    // DEBUG BUS //
    ///////////////
    
    // control our TX data mux selectro
    always @(posedge debug_clk) begin
        if(debug_wr & (debug_addr == 32'h8500)) begin
            controller_en           <= debug_din[0];
        end
        if(debug_rd & (debug_addr == 32'h8500)) begin
            enable_debug_dout       <= {31'h0, controller_en};
        end else
            enable_debug_dout       <= 32'h0;
    end

    // form our find debug bus
    assign  debug_dout              =   flit_debug_dout     |
                                        enable_debug_dout   |
                                        old_rx_debug_dout   ;

endmodule
