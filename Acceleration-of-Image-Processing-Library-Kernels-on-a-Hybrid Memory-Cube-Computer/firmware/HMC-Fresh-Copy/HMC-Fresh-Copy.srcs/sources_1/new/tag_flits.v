// tag_flits.v


module tag_flits #(
    parameter N_FLITS = 5
) (
    input  wire                     clk,

    input  wire [N_FLITS*128-1:0]   din,
    input  wire [N_FLITS-1:0]       present_map_i,
    input  wire [N_FLITS-1:0]       sof_map_i,
    input  wire [N_FLITS-1:0]       eof_map_i,


    output wire [N_FLITS*128-1:0]   dout,
    output wire [N_FLITS-1:0]       present_map_o,
    output wire [N_FLITS-1:0]       sof_map_o,
    output wire [N_FLITS-1:0]       eof_map_o,
    output wire [N_FLITS*9-1:0]     tag_map_o
);

    localparam L=8;

    reg [N_FLITS*128-1:0] dq [L:0];
    reg [N_FLITS-1:0] pmap [L:0];
    reg [N_FLITS-1:0] smap [L:0];
    reg [N_FLITS-1:0] emap [L:0];
    reg [N_FLITS*9-1:0] tmap [L:0];
    reg [N_FLITS-1:0] tvalid [L:0];

    `define TAG(x,y) tmap[(x)][9*(y)+:9]
    `define TAG_FIELD(x) 128*(x)+15+:9
    integer i, j;
    always @ (posedge clk) begin
        // register data
        dq[0]       <= din;
        pmap[0]     <= present_map_i;
        smap[0]     <= sof_map_i;
        emap[0]     <= eof_map_i;
        tvalid[0]   <= sof_map_i & present_map_i;
        for (j=0; j<N_FLITS; j=j+1) begin
            `TAG(0,j) <= din[`TAG_FIELD(j)];
        end
        
        for (i=1; L>=i; i=i+1) begin
            dq[i]       <= dq[i-1];
            pmap[i]     <= pmap[i-1];
            smap[i]     <= smap[i-1];
            emap[i]     <= emap[i-1];

            tvalid[i][0] <= tvalid[i-1][0] | (tvalid[i][N_FLITS-1] & pmap[i-1][0]);
            `TAG(i,0) <= tvalid[i-1][0] ? `TAG(i-1,0) : `TAG(i,N_FLITS-1);
            for (j=1; j<N_FLITS; j=j+1) begin
                tvalid[i][j] <= tvalid[i-1][j] | (tvalid[i-1][j-1] & pmap[i-1][j]);
                `TAG(i,j) <= tvalid[i-1][j] ? `TAG(i-1,j) : `TAG(i-1,j-1);
            end
        end
    end

    assign dout = dq[L];
    assign present_map_o = pmap[L];
    assign sof_map_o = smap[L];
    assign eof_map_o = emap[L];
    assign tag_map_o = tmap[L];


    initial begin 
        for (i=0; i<L; i=i+1) begin
            dq[i] <= 0;
            pmap[i] <= 0;
            smap[i] <= 0;
            emap[i] <= 0;
            tmap[i] <= 0;
            tvalid[i] <= 0;
        end
    end

    /*
    integer fid;
    initial begin
        fid = $fopen("tag_flits.txt", "w+");
    end
    reg [4:0] tv [L:0][L:0];
    always @ (*) begin
        for (i=0; i<=L; i=i+1) begin
            tv[i][0]=tvalid[i];
        end
    end
    always @ (posedge clk) begin
        for (i=0; i<=L; i=i+1) begin
            for (j=1; j<=L; j=j+1) begin
                tv[i][j]<=tv[i][j-1];
            end
        end
        if (|present_map_o) begin
            $fwrite(fid, "tag:\t");
            for (i=0; i<5; i=i+1) begin
                $fwrite(fid, "  %02x", tag_map_o[i*9 +: 9]);
            end
            $fwrite(fid, "\npkt:\t");
            for (i=0; i<5; i=i+1) begin
                $fwrite(fid, "  %2s", present_map_o[i] ? (sof_map_o[i] ? (eof_map_o[i] ? "se" : "s") : (eof_map_o[i] ? "e" : "p")) : " ");
            end
            for (j=0; j<=L; j=j+1) begin
                $fwrite(fid, "\ntv%1d:\t", j);
                for (i=0; i<5; i=i+1) begin
                    $fwrite(fid, "  %2s", tv[j][L-j][i] ? "t" : " ");
                end
            end
            $fwrite(fid, "\n");
            $fflush;
        end
    end
    */
endmodule
