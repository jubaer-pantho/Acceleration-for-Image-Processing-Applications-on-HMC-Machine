
module hmc_request_header (
    input    [2:0]      cub,    /* not used yet */
    input    [8:0]      tag,
    input               wr,
    input               posted,
    input               mode,
    input               bwr,
    input               atomic,
    input               add8, // high: dual 8-byte add; low: single 16-byte add
    input   [33:0]      addr,
    input    [3:0]      size,

    output  [63:0]      dout
);
    // request commands
    // commands varible in size
    localparam WR       = 3'b001;
    localparam P_WR     = 3'b011;
    localparam RD       = 3'b110;
    // static commands
    localparam MD_WR    = 6'b010000;
    localparam BWR      = 6'b010001;
    localparam ADD8     = 6'b010010;
    localparam ADD16    = 6'b010011;
    localparam P_BWR    = 6'b100001;
    localparam P_ADD8   = 6'b100010;
    localparam P_ADD16  = 6'b100011;
    localparam MD_RD    = 6'b101000;

    wire [3:0] size_minus_one   = size - 1;
    wire [3:0] size_plus_one    = size + 1;

    assign dout[63:61]  = 3'h0;             /* CUB */
    assign dout[60:58]  = 3'h0;             /* res */
    assign dout[57:24]  = addr[33:0];       /* ADRS */
    assign dout[23:15]  = tag;              /* TAG */
    assign dout[14:11]  = wr ? (mode | bwr | atomic) ? 4'h2 : size_plus_one[3:0]
                             : 4'h1;        /* DLN */
    assign dout[10:7]   = wr ? (mode | bwr | atomic) ? 4'h2 : size_plus_one[3:0]
                             : 4'h1;        /* LNG */
    assign dout[6]      = 1'b0;             /* res */
    assign dout[5:0]    = wr ? posted ? bwr     ? P_BWR
                                      : atomic  ? add8 ? P_ADD8 : P_ADD16
                                                : {P_WR, size_minus_one[2:0]}
                          /*!posted*/ : mode    ? MD_WR
                                      : bwr     ? BWR
                                      : atomic  ? add8 ? ADD8 : ADD16
                                                : {WR, size_minus_one[2:0]}
                     /*!wr*/ : mode ? MD_RD 
                          /*!mode*/ : {RD, size_minus_one[2:0]};    /* CMD */

endmodule
