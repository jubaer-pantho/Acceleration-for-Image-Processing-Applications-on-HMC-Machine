/*
* File Name     : flit_bram.v
*
* Description   : This is a memory that gets used during the PHY bringup
*                 sequence.
*
* Copyright     : 2015, Micron, Inc.
*/
module flit_bram #(
    parameter BASE_ADDR = 24'h86,
    parameter NAME = ""
) (
    input  tx_clk,
    input  tx_rst,
    output reg [639:0] dout = 0,
    input  rx_clk,
    input  rx_rst,
    input  [639:0] din,
    input  debug_clk,
    input  [31:0] debug_addr,
    input  debug_rd,
    input  debug_wr,
    input  [31:0] debug_din,
    output reg [31:0] debug_dout = 0
);

reg [639:0] bram_din = 0;
reg [8:0]   bram_len = 0;
//reg [639:0] bram [511:0];
reg [8:0] bram_rdaddr = 0, bram_wraddr = 0;
reg bram_en = 0;
reg [31:0] bram_count = 0;

reg [31:0]  clock_count = 0, flit_count = 0;
reg [31:0]  clock_count_cap = 0, flit_count_cap = 0;
reg cap_en = 0;
reg debug_dout_en = 0;
wire [639:0] bram_dout;

reg [31:0] clock_start = 0, clock_end = 0;

wire debug_en = (debug_addr[31:8] == BASE_ADDR);
always @(posedge debug_clk) begin
    if(debug_en & debug_wr) begin
        case(debug_addr[7:2])
        0:  bram_din[31:0]    <= debug_din;
        1:  bram_din[63:32]   <= debug_din;
        2:  bram_din[95:64]   <= debug_din;
        3:  bram_din[127:96]  <= debug_din;
        4:  bram_din[159:128] <= debug_din;
        5:  bram_din[191:160] <= debug_din;
        6:  bram_din[223:192] <= debug_din;
        7:  bram_din[255:224] <= debug_din;
        8:  bram_din[287:256] <= debug_din;
        9:  bram_din[319:288] <= debug_din;
        10: bram_din[351:320] <= debug_din;
        11: bram_din[383:352] <= debug_din;
        12: bram_din[415:384] <= debug_din;
        13: bram_din[447:416] <= debug_din;
        14: bram_din[479:448] <= debug_din;
        15: bram_din[511:480] <= debug_din;
        16: bram_din[543:512] <= debug_din;
        17: bram_din[575:544] <= debug_din;
        18: bram_din[607:576] <= debug_din;
        19: bram_din[639:608] <= debug_din;
        20: begin
            //bram[debug_din[8:0]] <= bram_din;
            bram_wraddr <= debug_din[8:0];
        end
        21: begin
            //bram_din <= bram[debug_din[8:0]];
            bram_rdaddr <= debug_din[8:0];
        end
        22: bram_len <= debug_din[8:0];
        23: bram_en <= debug_din[0];
        24: cap_en <= debug_din[0];
        27: bram_count <= debug_din;
        endcase
    end else if(debug_dout_en)
        bram_din <= bram_dout;
    
    if(debug_en & debug_rd) begin
        case(debug_addr[7:2])
        0:  debug_dout <= bram_din[31:0];
        1:  debug_dout <= bram_din[63:32];
        2:  debug_dout <= bram_din[95:64];
        3:  debug_dout <= bram_din[127:96];
        4:  debug_dout <= bram_din[159:128];
        5:  debug_dout <= bram_din[191:160];
        6:  debug_dout <= bram_din[223:192];
        7:  debug_dout <= bram_din[255:224];
        8:  debug_dout <= bram_din[287:256];
        9:  debug_dout <= bram_din[319:288];
        10: debug_dout <= bram_din[351:320];
        11: debug_dout <= bram_din[383:352];
        12: debug_dout <= bram_din[415:384];
        13: debug_dout <= bram_din[447:416];
        14: debug_dout <= bram_din[479:448];
        15: debug_dout <= bram_din[511:480];
        16: debug_dout <= bram_din[543:512];
        17: debug_dout <= bram_din[575:544];
        18: debug_dout <= bram_din[607:576];
        19: debug_dout <= bram_din[639:608];
        20: debug_dout <= bram_wraddr;
        21: debug_dout <= bram_rdaddr;
        22: debug_dout <= bram_len;
        23: debug_dout <= bram_en;
        25: debug_dout <= clock_count;
        26: debug_dout <= flit_count;
        27: debug_dout <= bram_count;
        28: debug_dout <= clock_start;
        29: debug_dout <= clock_end;
        default: debug_dout <= 0;
        endcase
    end else
        debug_dout <= 0;
    
    debug_dout_en <= debug_en & debug_wr & (debug_addr[7:2] == 21);
end

reg [31:0]  bram_sent = 0;
reg [8:0]   bram_idx = 0;
reg bram_en_0 = 0, bram_en_1 = 0;
reg bram_count_cmp = 0, bram_idx_cmp = 0;
reg dout_en = 0, dout_en_0 = 0;
wire [639:0] bram_doutb;
reg  [639:0] bram_doutb_0 = 0;
always @(posedge tx_clk) begin
    if(bram_en_1) begin
        if(bram_sent == bram_count)
            bram_count_cmp <= 1;
        //if(!bram_count_cmp) begin
            //dout <= bram[bram_idx];
            if(bram_idx_cmp) //bram_idx == bram_len)
                bram_idx <= 0;
            else
                bram_idx <= bram_idx + 1;
        //end //else
            //dout <= 0;
        bram_sent <= bram_sent + 1;
    end else begin
        //dout     <= 0;
        bram_idx <= 0;
        bram_sent <= 0;
        bram_count_cmp <= 0;
    end
    bram_en_0 <= bram_en;
    bram_en_1 <= bram_en_0;
    
    bram_idx_cmp <= bram_en_1 & ((bram_idx + 1) == bram_len);
    dout_en      <= bram_en_1 & !bram_count_cmp;
    dout_en_0    <= dout_en;
    bram_doutb_0 <= bram_doutb;
    dout         <= dout_en_0 ? bram_doutb_0 : 640'h0;
end

wire bram_wea = debug_en & debug_wr & (debug_addr[7:2] == 20);

// TODO: let's try to replace this w/ an inferred memory
blk_mem_gen_0 blk_mem_gen_0 (
    .clka(debug_clk),
    .addra(debug_din[9:0]),
    .dina(bram_din),
    .douta(bram_dout),
    .wea(bram_wea),
    .ena(1'b1),
    .clkb(tx_clk),
    .addrb(bram_idx),
    .dinb(640'h0),
    .doutb(bram_doutb),
    .web(1'b0),
    .enb(1'b1)
);


reg clock_start_set = 0;
reg [4:0] flit_valid = 0;
reg [2:0] valid_flits = 0;
reg cap_en_0 = 0, cap_en_1 = 0;
always @(posedge rx_clk) begin
    flit_valid[0] <= din[127:0]   != 128'h0;
    flit_valid[1] <= din[255:128] != 128'h0;
    flit_valid[2] <= din[383:256] != 128'h0;
    flit_valid[3] <= din[511:384] != 128'h0;
    flit_valid[4] <= din[639:512] != 128'h0;
    
    if(cap_en_0) begin
        if(~cap_en_1) begin
            clock_count <= 0;
            flit_count  <= 0;
            clock_start <= 0;
            clock_end   <= 0;
            clock_start_set <= 0;
        end else begin
            if(|valid_flits) begin
                if(!clock_start_set) begin
                    clock_start <= clock_count;
                    clock_start_set <= 1;
                end
                clock_end <= clock_count;
            end
            valid_flits <= flit_valid[0] + flit_valid[1] + flit_valid[2] + flit_valid[3] + flit_valid[4];
            flit_count  <= flit_count + valid_flits;
            clock_count <= clock_count + 1;
        end
    end
    
    cap_en_0 <= cap_en;
    cap_en_1 <= cap_en_0;
end

endmodule
