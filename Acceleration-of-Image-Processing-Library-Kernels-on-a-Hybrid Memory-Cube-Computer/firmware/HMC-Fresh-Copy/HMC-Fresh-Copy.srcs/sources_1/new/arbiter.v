// Copyright 2013 Pico Computing, Inc.

`timescale 1ns / 1ps

module arbiter #(parameter name = "", parameter verbose = 0) (
    input               clk,
    input               rst,


    input      [639:0]  data_p0,
    input        [4:0]  present_map_p0,
    input        [4:0]  sof_map_p0,
    input        [4:0]  eof_map_p0,
    input    [5*4-1:0]  len_p0,
    input    [5*4-1:0]  len_eof_p0,
    input               pkt_carry_p0,
    output reg          load_p0,

    input      [639:0]  data_p1,
    input        [4:0]  present_map_p1,
    input        [4:0]  sof_map_p1,
    input        [4:0]  eof_map_p1,
    input    [5*4-1:0]  len_p1,
    input    [5*4-1:0]  len_eof_p1,
    input               pkt_carry_p1,
    output reg          load_p1,

    input      [639:0]  data_p2,
    input        [4:0]  present_map_p2,
    input        [4:0]  sof_map_p2,
    input        [4:0]  eof_map_p2,
    input    [5*4-1:0]  len_p2,
    input    [5*4-1:0]  len_eof_p2,
    input               pkt_carry_p2,
    output reg          load_p2,

    input      [639:0]  data_p3,
    input        [4:0]  present_map_p3,
    input        [4:0]  sof_map_p3,
    input        [4:0]  eof_map_p3,
    input    [5*4-1:0]  len_p3,
    input    [5*4-1:0]  len_eof_p3,
    input               pkt_carry_p3,
    output reg          load_p3,

    input      [639:0]  data_p4,
    input        [4:0]  present_map_p4,
    input        [4:0]  sof_map_p4,
    input        [4:0]  eof_map_p4,
    input    [5*4-1:0]  len_p4,
    input    [5*4-1:0]  len_eof_p4,
    input               pkt_carry_p4,
    output reg          load_p4,


    output reg [639:0]  dout,
    output reg [5*4-1:0]len,
    output reg [5*4-1:0]len_eof,
    output reg   [4:0]  present_map,
    output reg   [4:0]  sof_map,
    output reg   [4:0]  eof_map,
    output reg          pkt_carry

    );
    
    localparam PORT_0 = 5'd1;
    localparam PORT_1 = 5'd2;
    localparam PORT_2 = 5'd4;
    localparam PORT_3 = 5'd8;
    localparam PORT_4 = 5'd16;
    
    reg [4:0] shifter, shifter_q, shifter_q1;
    reg toggle;

    reg [4:0] port_selector;
    

    

    always @(posedge clk) begin
        if (rst) begin
            shifter       <= 5'b00001;
            shifter_q     <= 5'b10000;
            shifter_q1    <= 5'b01000;
            port_selector <= 5'b00100;
            toggle <= 1'b0;
            load_p0    <= 2'b0;
            load_p1    <= 2'b0;
            load_p2    <= 2'b0;
            load_p3    <= 2'b0;
            load_p4    <= 2'b0;
//          dout    <= 640'h0;   // reset not necessary, data is qualified with present_map
            present_map <= 0;
            sof_map <= 0;
            eof_map <= 0;
            len     <= 20'h0;
            len_eof <= 20'h0;
            pkt_carry <= 1'b0;
        end else begin
            toggle <= ~toggle;
            if (toggle) // shifting every two cycles
                shifter <= {shifter[3:0], shifter[4]};
            shifter_q <= shifter;
            shifter_q1 <= shifter_q;
            port_selector <= shifter_q1; // wait for data is latched in selected port
            
            load_p0 <=  toggle & shifter[0];
            load_p1 <=  toggle & shifter[1];
            load_p2 <=  toggle & shifter[2];
            load_p3 <=  toggle & shifter[3];
            load_p4 <=  toggle & shifter[4];
            
            /* synthesis translate_off */
            if (toggle) begin
                if (((present_map == 5'b11111) && ~eof_map[4]) ||
                    ((present_map == 5'b01111) && ~eof_map[3]) ||
                    ((present_map == 5'b00111) && ~eof_map[2]) ||
                    ((present_map == 5'b00011) && ~eof_map[1]) ||
                    ((present_map == 5'b00001) && ~eof_map[0])) begin
                    $display("ARBITOR ERROR [%t] eof not set in the last present flit", $time);
                end
            end else begin
                if (present_map[0] && ~sof_map[0]) begin
                    $display("ARBITOR ERROR [%t] sof not set in the first flit", $time);
                end
            end
            /* synthesis translate_on */
            
            case (port_selector)  // synthesis parallel_case
                PORT_0 : begin //tx_port 0
                    /* synthesis translate_off */
                    if ((|present_map_p0) && verbose)
                        $display("[%t] arbiter loads data from port 0: data: 0x%x, present_map: %b, sof_map: %b, eof_map: %b, len: 0x%x, toggle %b",
                            $time, data_p0, present_map_p0, sof_map_p0, eof_map_p0, len_p0, toggle);
                    /* synthesis translate_on */

                    dout        <= data_p0;
                    present_map <= present_map_p0;
                    sof_map     <= sof_map_p0;
                    eof_map     <= eof_map_p0;
                    len         <= len_p0;
                    len_eof     <= len_eof_p0;
                    pkt_carry   <= pkt_carry_p0;
                end
                PORT_1 : begin //tx_port 1
                    /* synthesis translate_off */
                    if ((|present_map_p1) && verbose)
                        $display("[%t] arbiter loads data from port 1: data: 0x%x, present_map: %b, sof_map: %b, eof_map: %b, len: 0x%x, toggle %b",
                            $time, data_p1, present_map_p1, sof_map_p1, eof_map_p1, len_p1, toggle);
                    /* synthesis translate_on */

                    dout        <= data_p1;
                    present_map <= present_map_p1;
                    sof_map     <= sof_map_p1;
                    eof_map     <= eof_map_p1;
                    len         <= len_p1;
                    len_eof     <= len_eof_p1;
                    pkt_carry   <= pkt_carry_p1;
                end
                PORT_2 : begin //tx_port 2
                    /* synthesis translate_off */
                    if ((|present_map_p2) && verbose)
                        $display("[%t] arbiter loads data from port 2: data: 0x%x, present_map: %b, sof_map: %b, eof_map: %b, len: 0x%x, toggle %b",
                            $time, data_p2, present_map_p2, sof_map_p2, eof_map_p2, len_p2, toggle);
                    /* synthesis translate_on */

                    dout        <= data_p2;
                    present_map <= present_map_p2;
                    sof_map     <= sof_map_p2;
                    eof_map     <= eof_map_p2;
                    len         <= len_p2;
                    len_eof     <= len_eof_p2;
                    pkt_carry   <= pkt_carry_p2;
                end
                PORT_3 : begin //tx_port 3
                    /* synthesis translate_off */
                    if ((|present_map_p3) && verbose)
                        $display("[%t] arbiter loads data from port 3: data: 0x%x, present_map: %b, sof_map: %b, eof_map: %b, len: 0x%x, toggle %b",
                            $time, data_p3, present_map_p3, sof_map_p3, eof_map_p3, len_p3, toggle);
                    /* synthesis translate_on */

                    dout        <= data_p3;
                    present_map <= present_map_p3;
                    sof_map     <= sof_map_p3;
                    eof_map     <= eof_map_p3;
                    len         <= len_p3;
                    len_eof     <= len_eof_p3;
                    pkt_carry   <= pkt_carry_p3;
                end
                PORT_4 : begin //tx_port 4
                    /* synthesis translate_off */
                    if ((|present_map_p4) && verbose)
                        $display("[%t] arbiter loads data from port 4: data: 0x%x, present_map: %b, sof_map: %b, eof_map: %b, len: 0x%x, toggle %b",
                            $time, data_p4, present_map_p4, sof_map_p4, eof_map_p4, len_p4, toggle);
                    /* synthesis translate_on */

                    dout        <= data_p4;
                    present_map <= present_map_p4;
                    sof_map     <= sof_map_p4;
                    eof_map     <= eof_map_p4;
                    len         <= len_p4;
                    len_eof     <= len_eof_p4;
                    pkt_carry   <= pkt_carry_p4;
                end
            endcase
        end
    end
endmodule
