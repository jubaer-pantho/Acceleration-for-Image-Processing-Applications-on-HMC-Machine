`include "hmc_def.vh"

module hmc_crc_1 (
	input  [31:0] c,
	output [31:0] n
);

assign n[0]  = c[0]  ^ c[4]  ^ c[6]  ^ c[7]  ^ c[9]  ^ c[11] ^ c[12] ^ c[15] ^ c[16] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[27] ^ c[30];
assign n[1]  = c[0]  ^ c[1]  ^ c[4]  ^ c[5]  ^ c[6]  ^ c[8]  ^ c[9]  ^ c[10] ^ c[11] ^ c[13] ^ c[15] ^ c[17] ^ c[18] ^ c[21] ^ c[22] ^ c[23] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
assign n[2]  = c[1]  ^ c[2]  ^ c[4]  ^ c[5]  ^ c[10] ^ c[14] ^ c[15] ^ c[20] ^ c[23] ^ c[24] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
assign n[3]  = c[0]  ^ c[2]  ^ c[3]  ^ c[5]  ^ c[6]  ^ c[11] ^ c[15] ^ c[16] ^ c[21] ^ c[24] ^ c[25] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
assign n[4]  = c[0]  ^ c[1]  ^ c[3]  ^ c[9]  ^ c[11] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[20] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
assign n[5]  = c[0]  ^ c[1]  ^ c[2]  ^ c[4]  ^ c[10] ^ c[12] ^ c[16] ^ c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
assign n[6]  = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[5]  ^ c[6]  ^ c[7]  ^ c[9]  ^ c[12] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[18] ^ c[21] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
assign n[7]  = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[5]  ^ c[8]  ^ c[9]  ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[17] ^ c[20] ^ c[27] ^ c[29] ^ c[31];
assign n[8]  = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[6]  ^ c[9]  ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[16] ^ c[18] ^ c[21] ^ c[28] ^ c[30];
assign n[9]  = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[5]  ^ c[7]  ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[16] ^ c[17] ^ c[19] ^ c[22] ^ c[29] ^ c[31];
assign n[10] = c[1]  ^ c[2]  ^ c[3]  ^ c[5]  ^ c[7]  ^ c[8]  ^ c[9]  ^ c[13] ^ c[14] ^ c[17] ^ c[19] ^ c[22] ^ c[23] ^ c[27];
assign n[11] = c[2]  ^ c[3]  ^ c[7]  ^ c[8]  ^ c[10] ^ c[11] ^ c[12] ^ c[14] ^ c[16] ^ c[19] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
assign n[12] = c[0]  ^ c[3]  ^ c[4]  ^ c[8]  ^ c[9]  ^ c[11] ^ c[12] ^ c[13] ^ c[15] ^ c[17] ^ c[20] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
assign n[13] = c[1]  ^ c[4]  ^ c[5]  ^ c[9]  ^ c[10] ^ c[12] ^ c[13] ^ c[14] ^ c[16] ^ c[18] ^ c[21] ^ c[24] ^ c[25] ^ c[26] ^ c[29] ^ c[30];
assign n[14] = c[0]  ^ c[2]  ^ c[5]  ^ c[6]  ^ c[10] ^ c[11] ^ c[13] ^ c[14] ^ c[15] ^ c[17] ^ c[19] ^ c[22] ^ c[25] ^ c[26] ^ c[27] ^ c[30] ^ c[31];
assign n[15] = c[0]  ^ c[1]  ^ c[3]  ^ c[4]  ^ c[9]  ^ c[14] ^ c[19] ^ c[22] ^ c[23] ^ c[26] ^ c[28] ^ c[30] ^ c[31];
assign n[16] = c[0]  ^ c[1]  ^ c[2]  ^ c[5]  ^ c[6]  ^ c[7]  ^ c[9]  ^ c[10] ^ c[11] ^ c[12] ^ c[16] ^ c[18] ^ c[19] ^ c[22] ^ c[23] ^ c[24] ^ c[29] ^ c[30] ^ c[31];
assign n[17] = c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[8]  ^ c[9]  ^ c[10] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[18] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[27] ^ c[31];
assign n[18] = c[2]  ^ c[3]  ^ c[4]  ^ c[5]  ^ c[9]  ^ c[10] ^ c[11] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[19] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[28];
assign n[19] = c[0]  ^ c[3]  ^ c[5]  ^ c[7]  ^ c[9]  ^ c[10] ^ c[16] ^ c[17] ^ c[22] ^ c[24] ^ c[25] ^ c[26] ^ c[29] ^ c[30];
assign n[20] = c[0]  ^ c[1]  ^ c[7]  ^ c[8]  ^ c[9]  ^ c[10] ^ c[12] ^ c[15] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[25] ^ c[26] ^ c[31];
assign n[21] = c[0]  ^ c[1]  ^ c[2]  ^ c[8]  ^ c[9]  ^ c[10] ^ c[11] ^ c[13] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[27];
assign n[22] = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[9]  ^ c[10] ^ c[11] ^ c[12] ^ c[14] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
assign n[23] = c[0]  ^ c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
assign n[24] = c[1]  ^ c[2]  ^ c[3]  ^ c[4]  ^ c[5]  ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[16] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[30];
assign n[25] = c[2]  ^ c[3]  ^ c[4]  ^ c[5]  ^ c[6]  ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[17] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
assign n[26] = c[3]  ^ c[5]  ^ c[9]  ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
assign n[27] = c[4]  ^ c[6]  ^ c[10] ^ c[12] ^ c[13] ^ c[14] ^ c[15] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
assign n[28] = c[0]  ^ c[4]  ^ c[5]  ^ c[6]  ^ c[9]  ^ c[12] ^ c[13] ^ c[14] ^ c[18] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
assign n[29] = c[1]  ^ c[4]  ^ c[5]  ^ c[9]  ^ c[10] ^ c[11] ^ c[12] ^ c[13] ^ c[14] ^ c[16] ^ c[18] ^ c[21] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
assign n[30] = c[2]  ^ c[4]  ^ c[5]  ^ c[7]  ^ c[9]  ^ c[10] ^ c[13] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ c[25] ^ c[28];
assign n[31] = c[3]  ^ c[5]  ^ c[6]  ^ c[8]  ^ c[10] ^ c[11] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[26] ^ c[29];

endmodule


module hmc_crc_0 (
	input  [127:0] data,
	output [31:0] c
);

`define CRC_REVERSE_BITS 1
`ifdef CRC_REVERSE_BITS
wire [127:0] a = data;
wire [127:0] d = {
	a[0],   a[1],   a[2],   a[3],   a[4],   a[5],   a[6],   a[7],
	a[8],   a[9],   a[10],  a[11],  a[12],  a[13],  a[14],  a[15],
	a[16],  a[17],  a[18],  a[19],  a[20],  a[21],  a[22],  a[23],
	a[24],  a[25],  a[26],  a[27],  a[28],  a[29],  a[30],  a[31],
	a[32],  a[33],  a[34],  a[35],  a[36],  a[37],  a[38],  a[39],
	a[40],  a[41],  a[42],  a[43],  a[44],  a[45],  a[46],  a[47],
	a[48],  a[49],  a[50],  a[51],  a[52],  a[53],  a[54],  a[55],
	a[56],  a[57],  a[58],  a[59],  a[60],  a[61],  a[62],  a[63],
	a[64],  a[65],  a[66],  a[67],  a[68],  a[69],  a[70],  a[71],
	a[72],  a[73],  a[74],  a[75],  a[76],  a[77],  a[78],  a[79],
	a[80],  a[81],  a[82],  a[83],  a[84],  a[85],  a[86],  a[87],
	a[88],  a[89],  a[90],  a[91],  a[92],  a[93],  a[94],  a[95],
	a[96],  a[97],  a[98],  a[99],  a[100], a[101], a[102], a[103],
	a[104], a[105], a[106], a[107], a[108], a[109], a[110], a[111],
	a[112], a[113], a[114], a[115], a[116], a[117], a[118], a[119],
	a[120], a[121], a[122], a[123], a[124], a[125], a[126], a[127]
};
`else
wire [127:0] d = data;
`endif

assign c[0]  = d[126] ^ d[123] ^ d[118] ^ d[116] ^ d[115] ^ d[114] ^ d[112] ^ d[111] ^ d[108] ^ d[107] ^ d[105] ^ d[103] ^ d[102] ^ d[100] ^ d[96]  ^ d[94]  ^
               d[92]  ^ d[88]  ^ d[87]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[79]  ^ d[77]  ^ d[75]  ^ d[74]  ^ d[71]  ^ d[70]  ^ d[68]  ^ d[67]  ^ d[64]  ^ d[63]  ^
               d[62]  ^ d[57]  ^ d[54]  ^ d[52]  ^ d[51]  ^ d[50]  ^ d[48]  ^ d[47]  ^ d[46]  ^ d[44]  ^ d[36]  ^ d[35]  ^ d[34]  ^ d[28]  ^ d[26]  ^ d[25]  ^
               d[24]  ^ d[23]  ^ d[22]  ^ d[20]  ^ d[17]  ^ d[13]  ^ d[12]  ^ d[9]   ^ d[7]   ^ d[6]   ^ d[3]   ^ d[2]   ^ d[0];
assign c[1]  = d[127] ^ d[126] ^ d[124] ^ d[123] ^ d[119] ^ d[118] ^ d[117] ^ d[114] ^ d[113] ^ d[111] ^ d[109] ^ d[107] ^ d[106] ^ d[105] ^ d[104] ^ d[102] ^
               d[101] ^ d[100] ^ d[97]  ^ d[96]  ^ d[95]  ^ d[94]  ^ d[93]  ^ d[92]  ^ d[89]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[82]  ^ d[81]  ^
               d[80]  ^ d[79]  ^ d[78]  ^ d[77]  ^ d[76]  ^ d[74]  ^ d[72]  ^ d[70]  ^ d[69]  ^ d[67]  ^ d[65]  ^ d[62]  ^ d[58]  ^ d[57]  ^ d[55]  ^ d[54]  ^
               d[53]  ^ d[50]  ^ d[49]  ^ d[46]  ^ d[45]  ^ d[44]  ^ d[37]  ^ d[34]  ^ d[29]  ^ d[28]  ^ d[27]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[18]  ^ d[17]  ^
               d[14]  ^ d[12]  ^ d[10]  ^ d[9]   ^ d[8]   ^ d[6]   ^ d[4]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[2]  = d[127] ^ d[126] ^ d[125] ^ d[124] ^ d[123] ^ d[120] ^ d[119] ^ d[116] ^ d[111] ^ d[110] ^ d[106] ^ d[101] ^ d[100] ^ d[98]  ^ d[97]  ^ d[95]  ^
               d[93]  ^ d[92]  ^ d[90]  ^ d[86]  ^ d[84]  ^ d[82]  ^ d[80]  ^ d[78]  ^ d[74]  ^ d[73]  ^ d[67]  ^ d[66]  ^ d[64]  ^ d[62]  ^ d[59]  ^ d[58]  ^
               d[57]  ^ d[56]  ^ d[55]  ^ d[52]  ^ d[48]  ^ d[45]  ^ d[44]  ^ d[38]  ^ d[36]  ^ d[34]  ^ d[30]  ^ d[29]  ^ d[26]  ^ d[25]  ^ d[24]  ^ d[21]  ^
               d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[15]  ^ d[12]  ^ d[11]  ^ d[10]  ^ d[6]   ^ d[5]   ^ d[1]   ^ d[0];
assign c[3]  = d[127] ^ d[126] ^ d[125] ^ d[124] ^ d[121] ^ d[120] ^ d[117] ^ d[112] ^ d[111] ^ d[107] ^ d[102] ^ d[101] ^ d[99]  ^ d[98]  ^ d[96]  ^ d[94]  ^
               d[93]  ^ d[91]  ^ d[87]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[79]  ^ d[75]  ^ d[74]  ^ d[68]  ^ d[67]  ^ d[65]  ^ d[63]  ^ d[60]  ^ d[59]  ^ d[58]  ^
               d[57]  ^ d[56]  ^ d[53]  ^ d[49]  ^ d[46]  ^ d[45]  ^ d[39]  ^ d[37]  ^ d[35]  ^ d[31]  ^ d[30]  ^ d[27]  ^ d[26]  ^ d[25]  ^ d[22]  ^ d[21]  ^
               d[20]  ^ d[19]  ^ d[18]  ^ d[16]  ^ d[13]  ^ d[12]  ^ d[11]  ^ d[7]   ^ d[6]   ^ d[2]   ^ d[1];
assign c[4]  = d[127] ^ d[125] ^ d[123] ^ d[122] ^ d[121] ^ d[116] ^ d[115] ^ d[114] ^ d[113] ^ d[111] ^ d[107] ^ d[105] ^ d[99]  ^ d[97]  ^ d[96]  ^ d[95]  ^
               d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[82]  ^ d[81]  ^ d[80]  ^ d[79]  ^ d[77]  ^ d[76]  ^ d[74]  ^ d[71]  ^ d[70]  ^ d[69]  ^ d[67]  ^
               d[66]  ^ d[63]  ^ d[62]  ^ d[61]  ^ d[60]  ^ d[59]  ^ d[58]  ^ d[52]  ^ d[51]  ^ d[48]  ^ d[44]  ^ d[40]  ^ d[38]  ^ d[35]  ^ d[34]  ^ d[32]  ^
               d[31]  ^ d[27]  ^ d[25]  ^ d[24]  ^ d[21]  ^ d[19]  ^ d[14]  ^ d[9]   ^ d[8]   ^ d[6]   ^ d[0];
assign c[5]  = d[126] ^ d[124] ^ d[123] ^ d[122] ^ d[117] ^ d[116] ^ d[115] ^ d[114] ^ d[112] ^ d[108] ^ d[106] ^ d[100] ^ d[98]  ^ d[97]  ^ d[96]  ^ d[88]  ^
               d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[82]  ^ d[81]  ^ d[80]  ^ d[78]  ^ d[77]  ^ d[75]  ^ d[72]  ^ d[71]  ^ d[70]  ^ d[68]  ^ d[67]  ^
               d[64]  ^ d[63]  ^ d[62]  ^ d[61]  ^ d[60]  ^ d[59]  ^ d[53]  ^ d[52]  ^ d[49]  ^ d[45]  ^ d[41]  ^ d[39]  ^ d[36]  ^ d[35]  ^ d[33]  ^ d[32]  ^
               d[28]  ^ d[26]  ^ d[25]  ^ d[22]  ^ d[20]  ^ d[15]  ^ d[10]  ^ d[9]   ^ d[7]   ^ d[1];
assign c[6]  = d[127] ^ d[126] ^ d[125] ^ d[124] ^ d[117] ^ d[114] ^ d[113] ^ d[112] ^ d[111] ^ d[109] ^ d[108] ^ d[105] ^ d[103] ^ d[102] ^ d[101] ^ d[100] ^
               d[99]  ^ d[98]  ^ d[97]  ^ d[96]  ^ d[94]  ^ d[92]  ^ d[89]  ^ d[86]  ^ d[84]  ^ d[82]  ^ d[78]  ^ d[77]  ^ d[76]  ^ d[75]  ^ d[74]  ^ d[73]  ^
               d[72]  ^ d[70]  ^ d[69]  ^ d[67]  ^ d[65]  ^ d[61]  ^ d[60]  ^ d[57]  ^ d[53]  ^ d[52]  ^ d[51]  ^ d[48]  ^ d[47]  ^ d[44]  ^ d[42]  ^ d[40]  ^
               d[37]  ^ d[35]  ^ d[33]  ^ d[29]  ^ d[28]  ^ d[27]  ^ d[25]  ^ d[24]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[17]  ^ d[16]  ^ d[13]  ^ d[12]  ^ d[11]  ^
               d[10]  ^ d[9]   ^ d[8]   ^ d[7]   ^ d[6]   ^ d[3]   ^ d[0];
assign c[7]  = d[127] ^ d[125] ^ d[123] ^ d[116] ^ d[113] ^ d[111] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[106] ^ d[105] ^ d[104] ^ d[101] ^ d[99]  ^ d[98]  ^
               d[97]  ^ d[96]  ^ d[95]  ^ d[94]  ^ d[93]  ^ d[92]  ^ d[90]  ^ d[88]  ^ d[81]  ^ d[78]  ^ d[76]  ^ d[73]  ^ d[67]  ^ d[66]  ^ d[64]  ^ d[63]  ^
               d[61]  ^ d[58]  ^ d[57]  ^ d[53]  ^ d[51]  ^ d[50]  ^ d[49]  ^ d[47]  ^ d[46]  ^ d[45]  ^ d[44]  ^ d[43]  ^ d[41]  ^ d[38]  ^ d[35]  ^ d[30]  ^
               d[29]  ^ d[24]  ^ d[21]  ^ d[20]  ^ d[18]  ^ d[14]  ^ d[11]  ^ d[10]  ^ d[8]   ^ d[6]   ^ d[4]   ^ d[3]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[8]  = d[126] ^ d[124] ^ d[117] ^ d[114] ^ d[112] ^ d[111] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[106] ^ d[105] ^ d[102] ^ d[100] ^ d[99]  ^ d[98]  ^
               d[97]  ^ d[96]  ^ d[95]  ^ d[94]  ^ d[93]  ^ d[91]  ^ d[89]  ^ d[82]  ^ d[79]  ^ d[77]  ^ d[74]  ^ d[68]  ^ d[67]  ^ d[65]  ^ d[64]  ^ d[62]  ^
               d[59]  ^ d[58]  ^ d[54]  ^ d[52]  ^ d[51]  ^ d[50]  ^ d[48]  ^ d[47]  ^ d[46]  ^ d[45]  ^ d[44]  ^ d[42]  ^ d[39]  ^ d[36]  ^ d[31]  ^ d[30]  ^
               d[25]  ^ d[22]  ^ d[21]  ^ d[19]  ^ d[15]  ^ d[12]  ^ d[11]  ^ d[9]   ^ d[7]   ^ d[5]   ^ d[4]   ^ d[3]   ^ d[2]   ^ d[1];
assign c[9]  = d[127] ^ d[125] ^ d[118] ^ d[115] ^ d[113] ^ d[112] ^ d[111] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[106] ^ d[103] ^ d[101] ^ d[100] ^ d[99]  ^
               d[98]  ^ d[97]  ^ d[96]  ^ d[95]  ^ d[94]  ^ d[92]  ^ d[90]  ^ d[83]  ^ d[80]  ^ d[78]  ^ d[75]  ^ d[69]  ^ d[68]  ^ d[66]  ^ d[65]  ^ d[63]  ^
               d[60]  ^ d[59]  ^ d[55]  ^ d[53]  ^ d[52]  ^ d[51]  ^ d[49]  ^ d[48]  ^ d[47]  ^ d[46]  ^ d[45]  ^ d[43]  ^ d[40]  ^ d[37]  ^ d[32]  ^ d[31]  ^
               d[26]  ^ d[23]  ^ d[22]  ^ d[20]  ^ d[16]  ^ d[13]  ^ d[12]  ^ d[10]  ^ d[8]   ^ d[6]   ^ d[5]   ^ d[4]   ^ d[3]   ^ d[2];
assign c[10] = d[123] ^ d[119] ^ d[118] ^ d[115] ^ d[113] ^ d[110] ^ d[109] ^ d[105] ^ d[104] ^ d[103] ^ d[101] ^ d[99]  ^ d[98]  ^ d[97]  ^ d[95]  ^ d[94]  ^
               d[93]  ^ d[92]  ^ d[91]  ^ d[88]  ^ d[87]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[77]  ^ d[76]  ^ d[75]  ^ d[74]  ^ d[71]  ^ d[69]  ^ d[68]  ^ d[66]  ^
               d[63]  ^ d[62]  ^ d[61]  ^ d[60]  ^ d[57]  ^ d[56]  ^ d[53]  ^ d[51]  ^ d[49]  ^ d[41]  ^ d[38]  ^ d[36]  ^ d[35]  ^ d[34]  ^ d[33]  ^ d[32]  ^
               d[28]  ^ d[27]  ^ d[26]  ^ d[25]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[14]  ^ d[12]  ^ d[11]  ^ d[5]   ^ d[4]   ^ d[2]   ^ d[0];
assign c[11] = d[126] ^ d[124] ^ d[123] ^ d[120] ^ d[119] ^ d[118] ^ d[115] ^ d[112] ^ d[110] ^ d[108] ^ d[107] ^ d[106] ^ d[104] ^ d[103] ^ d[99]  ^ d[98]  ^
               d[95]  ^ d[93]  ^ d[89]  ^ d[87]  ^ d[86]  ^ d[84]  ^ d[83]  ^ d[81]  ^ d[79]  ^ d[78]  ^ d[76]  ^ d[74]  ^ d[72]  ^ d[71]  ^ d[69]  ^ d[68]  ^
               d[61]  ^ d[58]  ^ d[51]  ^ d[48]  ^ d[47]  ^ d[46]  ^ d[44]  ^ d[42]  ^ d[39]  ^ d[37]  ^ d[33]  ^ d[29]  ^ d[27]  ^ d[25]  ^ d[24]  ^ d[21]  ^
               d[20]  ^ d[17]  ^ d[15]  ^ d[9]   ^ d[7]   ^ d[5]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[12] = d[127] ^ d[125] ^ d[124] ^ d[121] ^ d[120] ^ d[119] ^ d[116] ^ d[113] ^ d[111] ^ d[109] ^ d[108] ^ d[107] ^ d[105] ^ d[104] ^ d[100] ^ d[99]  ^
               d[96]  ^ d[94]  ^ d[90]  ^ d[88]  ^ d[87]  ^ d[85]  ^ d[84]  ^ d[82]  ^ d[80]  ^ d[79]  ^ d[77]  ^ d[75]  ^ d[73]  ^ d[72]  ^ d[70]  ^ d[69]  ^
               d[62]  ^ d[59]  ^ d[52]  ^ d[49]  ^ d[48]  ^ d[47]  ^ d[45]  ^ d[43]  ^ d[40]  ^ d[38]  ^ d[34]  ^ d[30]  ^ d[28]  ^ d[26]  ^ d[25]  ^ d[22]  ^
               d[21]  ^ d[18]  ^ d[16]  ^ d[10]  ^ d[8]   ^ d[6]   ^ d[3]   ^ d[2]   ^ d[1];
assign c[13] = d[126] ^ d[125] ^ d[122] ^ d[121] ^ d[120] ^ d[117] ^ d[114] ^ d[112] ^ d[110] ^ d[109] ^ d[108] ^ d[106] ^ d[105] ^ d[101] ^ d[100] ^ d[97]  ^
               d[95]  ^ d[91]  ^ d[89]  ^ d[88]  ^ d[86]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[80]  ^ d[78]  ^ d[76]  ^ d[74]  ^ d[73]  ^ d[71]  ^ d[70]  ^ d[63]  ^
               d[60]  ^ d[53]  ^ d[50]  ^ d[49]  ^ d[48]  ^ d[46]  ^ d[44]  ^ d[41]  ^ d[39]  ^ d[35]  ^ d[31]  ^ d[29]  ^ d[27]  ^ d[26]  ^ d[23]  ^ d[22]  ^
               d[19]  ^ d[17]  ^ d[11]  ^ d[9]   ^ d[7]   ^ d[4]   ^ d[3]   ^ d[2];
assign c[14] = d[127] ^ d[126] ^ d[123] ^ d[122] ^ d[121] ^ d[118] ^ d[115] ^ d[113] ^ d[111] ^ d[110] ^ d[109] ^ d[107] ^ d[106] ^ d[102] ^ d[101] ^ d[98]  ^
               d[96]  ^ d[92]  ^ d[90]  ^ d[89]  ^ d[87]  ^ d[86]  ^ d[84]  ^ d[82]  ^ d[81]  ^ d[79]  ^ d[77]  ^ d[75]  ^ d[74]  ^ d[72]  ^ d[71]  ^ d[64]  ^
               d[61]  ^ d[54]  ^ d[51]  ^ d[50]  ^ d[49]  ^ d[47]  ^ d[45]  ^ d[42]  ^ d[40]  ^ d[36]  ^ d[32]  ^ d[30]  ^ d[28]  ^ d[27]  ^ d[24]  ^ d[23]  ^
               d[20]  ^ d[18]  ^ d[12]  ^ d[10]  ^ d[8]   ^ d[5]   ^ d[4]   ^ d[3];
assign c[15] = d[127] ^ d[126] ^ d[124] ^ d[122] ^ d[119] ^ d[118] ^ d[115] ^ d[110] ^ d[105] ^ d[100] ^ d[99]  ^ d[97]  ^ d[96]  ^ d[94]  ^ d[93]  ^ d[92]  ^
               d[91]  ^ d[90]  ^ d[82]  ^ d[81]  ^ d[80]  ^ d[79]  ^ d[78]  ^ d[77]  ^ d[76]  ^ d[74]  ^ d[73]  ^ d[72]  ^ d[71]  ^ d[70]  ^ d[68]  ^ d[67]  ^
               d[65]  ^ d[64]  ^ d[63]  ^ d[57]  ^ d[55]  ^ d[54]  ^ d[47]  ^ d[44]  ^ d[43]  ^ d[41]  ^ d[37]  ^ d[36]  ^ d[35]  ^ d[34]  ^ d[33]  ^ d[31]  ^
               d[29]  ^ d[26]  ^ d[23]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[19]  ^ d[17]  ^ d[12]  ^ d[11]  ^ d[7]   ^ d[5]   ^ d[4]   ^ d[3]   ^ d[2]   ^ d[0];
assign c[16] = d[127] ^ d[126] ^ d[125] ^ d[120] ^ d[119] ^ d[118] ^ d[115] ^ d[114] ^ d[112] ^ d[108] ^ d[107] ^ d[106] ^ d[105] ^ d[103] ^ d[102] ^ d[101] ^
               d[98]  ^ d[97]  ^ d[96]  ^ d[95]  ^ d[93]  ^ d[91]  ^ d[88]  ^ d[87]  ^ d[85]  ^ d[82]  ^ d[80]  ^ d[78]  ^ d[73]  ^ d[72]  ^ d[70]  ^ d[69]  ^
               d[67]  ^ d[66]  ^ d[65]  ^ d[63]  ^ d[62]  ^ d[58]  ^ d[57]  ^ d[56]  ^ d[55]  ^ d[54]  ^ d[52]  ^ d[51]  ^ d[50]  ^ d[47]  ^ d[46]  ^ d[45]  ^
               d[42]  ^ d[38]  ^ d[37]  ^ d[32]  ^ d[30]  ^ d[28]  ^ d[27]  ^ d[26]  ^ d[25]  ^ d[21]  ^ d[18]  ^ d[17]  ^ d[9]   ^ d[8]   ^ d[7]   ^ d[5]   ^
               d[4]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[17] = d[127] ^ d[123] ^ d[121] ^ d[120] ^ d[119] ^ d[118] ^ d[114] ^ d[113] ^ d[112] ^ d[111] ^ d[109] ^ d[106] ^ d[105] ^ d[104] ^ d[100] ^ d[99]  ^
               d[98]  ^ d[97]  ^ d[89]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[77]  ^ d[75]  ^ d[73]  ^ d[66]  ^ d[62]  ^ d[59]  ^ d[58]  ^ d[56]  ^ d[55]  ^ d[54]  ^
               d[53]  ^ d[50]  ^ d[44]  ^ d[43]  ^ d[39]  ^ d[38]  ^ d[36]  ^ d[35]  ^ d[34]  ^ d[33]  ^ d[31]  ^ d[29]  ^ d[27]  ^ d[25]  ^ d[24]  ^ d[23]  ^
               d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[13]  ^ d[12]  ^ d[10]  ^ d[8]   ^ d[7]   ^ d[5]   ^ d[1]   ^ d[0];
assign c[18] = d[124] ^ d[122] ^ d[121] ^ d[120] ^ d[119] ^ d[115] ^ d[114] ^ d[113] ^ d[112] ^ d[110] ^ d[107] ^ d[106] ^ d[105] ^ d[101] ^ d[100] ^ d[99]  ^
               d[98]  ^ d[90]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[78]  ^ d[76]  ^ d[74]  ^ d[67]  ^ d[63]  ^ d[60]  ^ d[59]  ^ d[57]  ^ d[56]  ^ d[55]  ^ d[54]  ^
               d[51]  ^ d[45]  ^ d[44]  ^ d[40]  ^ d[39]  ^ d[37]  ^ d[36]  ^ d[35]  ^ d[34]  ^ d[32]  ^ d[30]  ^ d[28]  ^ d[26]  ^ d[25]  ^ d[24]  ^ d[21]  ^
               d[20]  ^ d[19]  ^ d[18]  ^ d[14]  ^ d[13]  ^ d[11]  ^ d[9]   ^ d[8]   ^ d[6]   ^ d[2]   ^ d[1];
assign c[19] = d[126] ^ d[125] ^ d[122] ^ d[121] ^ d[120] ^ d[118] ^ d[113] ^ d[112] ^ d[106] ^ d[105] ^ d[103] ^ d[101] ^ d[99]  ^ d[96]  ^ d[94]  ^ d[92]  ^
               d[91]  ^ d[89]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[74]  ^ d[71]  ^ d[70]  ^ d[67]  ^ d[63]  ^ d[62]  ^ d[61]  ^ d[60]  ^ d[58]  ^ d[56]  ^ d[55]  ^
               d[54]  ^ d[51]  ^ d[50]  ^ d[48]  ^ d[47]  ^ d[45]  ^ d[44]  ^ d[41]  ^ d[40]  ^ d[38]  ^ d[37]  ^ d[34]  ^ d[33]  ^ d[31]  ^ d[29]  ^ d[28]  ^
               d[27]  ^ d[24]  ^ d[23]  ^ d[21]  ^ d[19]  ^ d[17]  ^ d[15]  ^ d[14]  ^ d[13]  ^ d[10]  ^ d[6]   ^ d[0];
assign c[20] = d[127] ^ d[122] ^ d[121] ^ d[119] ^ d[118] ^ d[116] ^ d[115] ^ d[113] ^ d[112] ^ d[111] ^ d[108] ^ d[106] ^ d[105] ^ d[104] ^ d[103] ^ d[97]  ^
               d[96]  ^ d[95]  ^ d[94]  ^ d[93]  ^ d[90]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[82]  ^ d[81]  ^ d[79]  ^ d[77]  ^ d[74]  ^
               d[72]  ^ d[70]  ^ d[67]  ^ d[61]  ^ d[59]  ^ d[56]  ^ d[55]  ^ d[54]  ^ d[50]  ^ d[49]  ^ d[47]  ^ d[45]  ^ d[44]  ^ d[42]  ^ d[41]  ^ d[39]  ^
               d[38]  ^ d[36]  ^ d[32]  ^ d[30]  ^ d[29]  ^ d[26]  ^ d[23]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[15]  ^ d[14]  ^ d[13]  ^ d[12]  ^ d[11]  ^ d[9]   ^
               d[6]   ^ d[3]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[21] = d[123] ^ d[122] ^ d[120] ^ d[119] ^ d[117] ^ d[116] ^ d[114] ^ d[113] ^ d[112] ^ d[109] ^ d[107] ^ d[106] ^ d[105] ^ d[104] ^ d[98]  ^ d[97]  ^
               d[96]  ^ d[95]  ^ d[94]  ^ d[91]  ^ d[89]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[82]  ^ d[80]  ^ d[78]  ^ d[75]  ^ d[73]  ^
               d[71]  ^ d[68]  ^ d[62]  ^ d[60]  ^ d[57]  ^ d[56]  ^ d[55]  ^ d[51]  ^ d[50]  ^ d[48]  ^ d[46]  ^ d[45]  ^ d[43]  ^ d[42]  ^ d[40]  ^ d[39]  ^
               d[37]  ^ d[33]  ^ d[31]  ^ d[30]  ^ d[27]  ^ d[24]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[15]  ^ d[14]  ^ d[13]  ^ d[12]  ^ d[10]  ^ d[7]   ^
               d[4]   ^ d[3]   ^ d[2]   ^ d[1];
assign c[22] = d[124] ^ d[123] ^ d[121] ^ d[120] ^ d[118] ^ d[117] ^ d[115] ^ d[114] ^ d[113] ^ d[110] ^ d[108] ^ d[107] ^ d[106] ^ d[105] ^ d[99]  ^ d[98]  ^
               d[97]  ^ d[96]  ^ d[95]  ^ d[92]  ^ d[90]  ^ d[89]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[83]  ^ d[81]  ^ d[79]  ^ d[76]  ^ d[74]  ^
               d[72]  ^ d[69]  ^ d[63]  ^ d[61]  ^ d[58]  ^ d[57]  ^ d[56]  ^ d[52]  ^ d[51]  ^ d[49]  ^ d[47]  ^ d[46]  ^ d[44]  ^ d[43]  ^ d[41]  ^ d[40]  ^
               d[38]  ^ d[34]  ^ d[32]  ^ d[31]  ^ d[28]  ^ d[25]  ^ d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[15]  ^ d[14]  ^ d[13]  ^ d[11]  ^ d[8]   ^
               d[5]   ^ d[4]   ^ d[3]   ^ d[2];
assign c[23] = d[125] ^ d[124] ^ d[122] ^ d[121] ^ d[119] ^ d[118] ^ d[116] ^ d[115] ^ d[114] ^ d[111] ^ d[109] ^ d[108] ^ d[107] ^ d[106] ^ d[100] ^ d[99]  ^
               d[98]  ^ d[97]  ^ d[96]  ^ d[93]  ^ d[91]  ^ d[90]  ^ d[89]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[84]  ^ d[82]  ^ d[80]  ^ d[77]  ^ d[75]  ^
               d[73]  ^ d[70]  ^ d[64]  ^ d[62]  ^ d[59]  ^ d[58]  ^ d[57]  ^ d[53]  ^ d[52]  ^ d[50]  ^ d[48]  ^ d[47]  ^ d[45]  ^ d[44]  ^ d[42]  ^ d[41]  ^
               d[39]  ^ d[35]  ^ d[33]  ^ d[32]  ^ d[29]  ^ d[26]  ^ d[21]  ^ d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[15]  ^ d[14]  ^ d[12]  ^ d[9]   ^
               d[6]   ^ d[5]   ^ d[4]   ^ d[3];
assign c[24] = d[126] ^ d[125] ^ d[123] ^ d[122] ^ d[120] ^ d[119] ^ d[117] ^ d[116] ^ d[115] ^ d[112] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[101] ^ d[100] ^
               d[99]  ^ d[98]  ^ d[97]  ^ d[94]  ^ d[92]  ^ d[91]  ^ d[90]  ^ d[89]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[78]  ^ d[76]  ^
               d[74]  ^ d[71]  ^ d[65]  ^ d[63]  ^ d[60]  ^ d[59]  ^ d[58]  ^ d[54]  ^ d[53]  ^ d[51]  ^ d[49]  ^ d[48]  ^ d[46]  ^ d[45]  ^ d[43]  ^ d[42]  ^
               d[40]  ^ d[36]  ^ d[34]  ^ d[33]  ^ d[30]  ^ d[27]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[15]  ^ d[13]  ^ d[10]  ^
               d[7]   ^ d[6]   ^ d[5]   ^ d[4];
assign c[25] = d[127] ^ d[126] ^ d[124] ^ d[123] ^ d[121] ^ d[120] ^ d[118] ^ d[117] ^ d[116] ^ d[113] ^ d[111] ^ d[110] ^ d[109] ^ d[108] ^ d[102] ^ d[101] ^
               d[100] ^ d[99]  ^ d[98]  ^ d[95]  ^ d[93]  ^ d[92]  ^ d[91]  ^ d[90]  ^ d[89]  ^ d[88]  ^ d[87]  ^ d[86]  ^ d[84]  ^ d[82]  ^ d[79]  ^ d[77]  ^
               d[75]  ^ d[72]  ^ d[66]  ^ d[64]  ^ d[61]  ^ d[60]  ^ d[59]  ^ d[55]  ^ d[54]  ^ d[52]  ^ d[50]  ^ d[49]  ^ d[47]  ^ d[46]  ^ d[44]  ^ d[43]  ^
               d[41]  ^ d[37]  ^ d[35]  ^ d[34]  ^ d[31]  ^ d[28]  ^ d[23]  ^ d[22]  ^ d[21]  ^ d[20]  ^ d[19]  ^ d[18]  ^ d[17]  ^ d[16]  ^ d[14]  ^ d[11]  ^
               d[8]   ^ d[7]   ^ d[6]   ^ d[5];
assign c[26] = d[127] ^ d[126] ^ d[125] ^ d[124] ^ d[123] ^ d[122] ^ d[121] ^ d[119] ^ d[117] ^ d[116] ^ d[115] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[105] ^
               d[101] ^ d[99]  ^ d[93]  ^ d[91]  ^ d[90]  ^ d[89]  ^ d[81]  ^ d[80]  ^ d[79]  ^ d[78]  ^ d[77]  ^ d[76]  ^ d[75]  ^ d[74]  ^ d[73]  ^ d[71]  ^
               d[70]  ^ d[68]  ^ d[65]  ^ d[64]  ^ d[63]  ^ d[61]  ^ d[60]  ^ d[57]  ^ d[56]  ^ d[55]  ^ d[54]  ^ d[53]  ^ d[52]  ^ d[46]  ^ d[45]  ^ d[42]  ^
               d[38]  ^ d[34]  ^ d[32]  ^ d[29]  ^ d[28]  ^ d[26]  ^ d[25]  ^ d[21]  ^ d[19]  ^ d[18]  ^ d[15]  ^ d[13]  ^ d[8]   ^ d[3]   ^ d[2]   ^ d[0];
assign c[27] = d[127] ^ d[126] ^ d[125] ^ d[124] ^ d[123] ^ d[122] ^ d[120] ^ d[118] ^ d[117] ^ d[116] ^ d[111] ^ d[110] ^ d[109] ^ d[108] ^ d[106] ^ d[102] ^
               d[100] ^ d[94]  ^ d[92]  ^ d[91]  ^ d[90]  ^ d[82]  ^ d[81]  ^ d[80]  ^ d[79]  ^ d[78]  ^ d[77]  ^ d[76]  ^ d[75]  ^ d[74]  ^ d[72]  ^ d[71]  ^
               d[69]  ^ d[66]  ^ d[65]  ^ d[64]  ^ d[62]  ^ d[61]  ^ d[58]  ^ d[57]  ^ d[56]  ^ d[55]  ^ d[54]  ^ d[53]  ^ d[47]  ^ d[46]  ^ d[43]  ^ d[39]  ^
               d[35]  ^ d[33]  ^ d[30]  ^ d[29]  ^ d[27]  ^ d[26]  ^ d[22]  ^ d[20]  ^ d[19]  ^ d[16]  ^ d[14]  ^ d[9]   ^ d[4]   ^ d[3]   ^ d[1];
assign c[28] = d[127] ^ d[125] ^ d[124] ^ d[121] ^ d[119] ^ d[117] ^ d[116] ^ d[115] ^ d[114] ^ d[110] ^ d[109] ^ d[108] ^ d[105] ^ d[102] ^ d[101] ^ d[100] ^
               d[96]  ^ d[95]  ^ d[94]  ^ d[93]  ^ d[91]  ^ d[88]  ^ d[87]  ^ d[85]  ^ d[82]  ^ d[80]  ^ d[78]  ^ d[76]  ^ d[74]  ^ d[73]  ^ d[72]  ^ d[71]  ^
               d[68]  ^ d[66]  ^ d[65]  ^ d[64]  ^ d[59]  ^ d[58]  ^ d[56]  ^ d[55]  ^ d[52]  ^ d[51]  ^ d[50]  ^ d[46]  ^ d[40]  ^ d[35]  ^ d[31]  ^ d[30]  ^
               d[27]  ^ d[26]  ^ d[25]  ^ d[24]  ^ d[22]  ^ d[21]  ^ d[15]  ^ d[13]  ^ d[12]  ^ d[10]  ^ d[9]   ^ d[7]   ^ d[6]   ^ d[5]   ^ d[4]   ^ d[3]   ^
               d[0];
assign c[29] = d[125] ^ d[123] ^ d[122] ^ d[120] ^ d[117] ^ d[114] ^ d[112] ^ d[110] ^ d[109] ^ d[108] ^ d[107] ^ d[106] ^ d[105] ^ d[101] ^ d[100] ^ d[97]  ^
               d[95]  ^ d[89]  ^ d[87]  ^ d[86]  ^ d[85]  ^ d[73]  ^ d[72]  ^ d[71]  ^ d[70]  ^ d[69]  ^ d[68]  ^ d[66]  ^ d[65]  ^ d[64]  ^ d[63]  ^ d[62]  ^
               d[60]  ^ d[59]  ^ d[56]  ^ d[54]  ^ d[53]  ^ d[50]  ^ d[48]  ^ d[46]  ^ d[44]  ^ d[41]  ^ d[35]  ^ d[34]  ^ d[32]  ^ d[31]  ^ d[27]  ^ d[24]  ^
               d[20]  ^ d[17]  ^ d[16]  ^ d[14]  ^ d[12]  ^ d[11]  ^ d[10]  ^ d[9]   ^ d[8]   ^ d[5]   ^ d[4]   ^ d[3]   ^ d[2]   ^ d[1]   ^ d[0];
assign c[30] = d[124] ^ d[121] ^ d[116] ^ d[114] ^ d[113] ^ d[112] ^ d[110] ^ d[109] ^ d[106] ^ d[105] ^ d[103] ^ d[101] ^ d[100] ^ d[98]  ^ d[94]  ^ d[92]  ^
               d[90]  ^ d[86]  ^ d[85]  ^ d[83]  ^ d[81]  ^ d[79]  ^ d[77]  ^ d[75]  ^ d[73]  ^ d[72]  ^ d[69]  ^ d[68]  ^ d[66]  ^ d[65]  ^ d[62]  ^ d[61]  ^
               d[60]  ^ d[55]  ^ d[52]  ^ d[50]  ^ d[49]  ^ d[48]  ^ d[46]  ^ d[45]  ^ d[44]  ^ d[42]  ^ d[34]  ^ d[33]  ^ d[32]  ^ d[26]  ^ d[24]  ^ d[23]  ^
               d[22]  ^ d[21]  ^ d[20]  ^ d[18]  ^ d[15]  ^ d[11]  ^ d[10]  ^ d[7]   ^ d[5]   ^ d[4]   ^ d[1]   ^ d[0];
assign c[31] = d[125] ^ d[122] ^ d[117] ^ d[115] ^ d[114] ^ d[113] ^ d[111] ^ d[110] ^ d[107] ^ d[106] ^ d[104] ^ d[102] ^ d[101] ^ d[99]  ^ d[95]  ^ d[93]  ^
               d[91]  ^ d[87]  ^ d[86]  ^ d[84]  ^ d[82]  ^ d[80]  ^ d[78]  ^ d[76]  ^ d[74]  ^ d[73]  ^ d[70]  ^ d[69]  ^ d[67]  ^ d[66]  ^ d[63]  ^ d[62]  ^
               d[61]  ^ d[56]  ^ d[53]  ^ d[51]  ^ d[50]  ^ d[49]  ^ d[47]  ^ d[46]  ^ d[45]  ^ d[43]  ^ d[35]  ^ d[34]  ^ d[33]  ^ d[27]  ^ d[25]  ^ d[24]  ^
               d[23]  ^ d[22]  ^ d[21]  ^ d[19]  ^ d[16]  ^ d[12]  ^ d[11]  ^ d[8]   ^ d[6]   ^ d[5]   ^ d[2]   ^ d[1];

endmodule


module hmc_crc (
	input [127:0] data,
	input [31:0] crc_i,
	output [31:0] crc_o
);

wire [31:0] data_c;
hmc_crc_0 hmc_crc_0 (
	.data(data),
	.c(data_c)
);

wire [31:0] crc_c;
hmc_crc_1 hmc_crc_1 (
	.c(crc_i),
	.n(crc_c)
);

assign crc_o = data_c ^ crc_c;

endmodule


module hmc_find_pkts_pipe (
	input              clk,
	input      [639:0] data_i,
	input      [3:0]   len_i,
	input      [4:0]   pres_i,
	input      [4:0]   sof_i,
	input      [4:0]   eof_i,
	input      [4:0]   err_i,
	output reg [639:0] data_o = 640'h0,
	output reg [3:0]   len_o = 4'h0,
	output reg [4:0]   pres_o = 5'h0,
	output reg [4:0]   sof_o = 5'h0,
	output reg [4:0]   eof_o = 5'h0,
	output reg [4:0]   err_o = 5'h0
);

always @(*) begin
	// We're going to shift all signals each stage so the
	// pipeline processes every FLIT
	data_o <= {data_i[127:0], data_i[639:128]};

	// If last FLIT wasn't enabled or if it was an EOF,
	// then check to see if this is an SOF
	if(len_i == 4'h0) begin

		// If this isn't a NULL FLIT, then mark as SOF
		// and save DLN / LEN
		if(data_i[5:0] != 6'h0) begin

			// If length is 1, then go ahead and flag EOF as well
			if(data_i[`CMD_LEN_FIELD] == 1) begin
				len_o <= 4'h0;
				eof_o <= {1'b1, eof_i[4:1]};
				// Otherwise save len and set EOF to 0
			end else begin
				len_o <= data_i[`CMD_LEN_FIELD];
				eof_o <= {1'b0, eof_i[4:1]};
			end

			// Mark SOF and Present
			pres_o <= {1'b1, pres_i[4:1]};
			sof_o  <= {1'b1, sof_i[4:1]};

			// If LEN != DLN, then flag an error (corresponding to SOF bit)
			if(data_i[`CMD_LEN_FIELD] != data_i[`CMD_DLN_FIELD] || data_i[`CMD_LEN_FIELD] > 9) begin
				err_o <= {1'b1, err_i[4:1]};
                    $display("[%t] %m : flagging rx error (bad pkt format)", $time);
			end else
				err_o <= {1'b0, err_i[4:1]};

		// NULL FLIT
		end else begin
			len_o  <= 4'h0;
			pres_o <= {1'b0, pres_i[4:1]};
			sof_o  <= {1'b0, sof_i[4:1]};
			eof_o  <= {1'b0, eof_i[4:1]};
			err_o  <= {1'b0, err_i[4:1]};
		end

	// otherwise if there's a len_i, then decrement until EOF
	end else begin

		// If we haven't reached the EOF yet
		if(len_i != 4'h2) begin
			len_o  <= len_i - 1;
			pres_o <= {1'b1, pres_i[4:1]};
			sof_o  <= {1'b0, sof_i[4:1]};
			eof_o  <= {1'b0, eof_i[4:1]};
			err_o  <= {1'b0, err_i[4:1]};

		// otherwise flag EOF
		end else begin
			len_o  <= 4'h0;
			pres_o <= {1'b1, pres_i[4:1]};
			sof_o  <= {1'b0, sof_i[4:1]};
			eof_o  <= {1'b1, eof_i[4:1]};
			err_o  <= {1'b0, err_i[4:1]};
		end
	end
end

endmodule


module hmc_find_pkts (
	input              rx_clk,
	input      [639:0] rx_data_i,
	output reg [639:0] rx_data_o,
	output reg [4:0]   rx_present_o,
	output reg [4:0]   rx_sof_o,
	output reg [4:0]   rx_eof_o,
	output reg [4:0]   rx_err_o
);

parameter PIPE_DEPTH = 6;
wire [639:0] data_pipe [PIPE_DEPTH-1:0];
wire [3:0] len_pipe    [PIPE_DEPTH-1:0];
wire [4:0] pres_pipe   [PIPE_DEPTH-1:0];
wire [4:0] sof_pipe    [PIPE_DEPTH-1:0];
wire [4:0] eof_pipe    [PIPE_DEPTH-1:0];
wire [4:0] err_pipe    [PIPE_DEPTH-1:0];

// Register length from last clock cycle to pass to next
reg [3:0] last_len = 0;

// Initial values for the pipeline
assign data_pipe[0] = rx_data_i;
assign len_pipe[0]  = last_len;
assign pres_pipe[0] = 5'h0;
assign sof_pipe[0]  = 5'h0;
assign eof_pipe[0]  = 5'h0;
assign err_pipe[0]  = 5'h0;

// Pipeline processes 5 FLITs completely combinatorially
// (rx_clk is not used)
genvar i;
generate for(i = 0; i < (PIPE_DEPTH-1); i = i + 1) begin : hmc_find_pkts_pipe
	hmc_find_pkts_pipe hmc_find_pkts_pipe (
		.clk(rx_clk),
		.data_i(data_pipe[i]),
		.len_i(len_pipe[i]),
		.pres_i(pres_pipe[i]),
		.sof_i(sof_pipe[i]),
		.eof_i(eof_pipe[i]),
		.err_i(err_pipe[i]),
		.data_o(data_pipe[i+1]),
		.len_o(len_pipe[i+1]),
		.pres_o(pres_pipe[i+1]),
		.sof_o(sof_pipe[i+1]),
		.eof_o(eof_pipe[i+1]),
		.err_o(err_pipe[i+1])
	);
end endgenerate

// Register output of pipeline and save last_len
always @(posedge rx_clk) begin
	last_len     <= len_pipe[5];
	rx_data_o    <= data_pipe[5];
	rx_present_o <= pres_pipe[5];
	rx_sof_o     <= sof_pipe[5];
	rx_eof_o     <= eof_pipe[5];
	rx_err_o     <= err_pipe[5];
end

endmodule

/*
 * We have already detected where our packets start and end.
 * Now we just need to use our SOF flags to find our header and see if our LNG
 * field matches the DLN field
 */
module detect_lng_dln_mismatch (
	input              clk,
	input      [639:0] data_i,
	input      [4:0]   pres_i,
	input      [4:0]   sof_i,
	input      [4:0]   eof_i,
	input      [4:0]   err_i,
	output reg [639:0] data_o   = 640'h0,
	output reg [4:0]   pres_o   = 5'h0,
	output reg [4:0]   sof_o    = 5'h0,
	output reg [4:0]   eof_o    = 5'h0,
	output reg [4:0]   err_o    = 5'h0
);
    `include "hmc_func.h.v"
    integer             i;

    always @ (posedge clk) begin
        data_o              <= data_i;
        pres_o              <= pres_i;
        sof_o               <= sof_i;
        eof_o               <= eof_i;
        for (i=0; i<5; i=i+1) begin
            if (sof_i[i]) begin
                if ((GetLNG(data_i>>(i*128)) != GetDLN(data_i>>(i*128))) || (GetLNG(data_i>>(i*128)) > 9)) begin
                    err_o[i]<=  1'b1;
                    $display("[%t] %m : flagging rx error (bad pkt format)", $time);
                end else begin
                    err_o[i]<=  err_i[i];
                end
            end else begin
                err_o[i]    <=  err_i[i];
            end
        end
    end
endmodule

/*
 * this just combines the hmc_find_pkts module with the DLN detection
 */
module hmc_find_pkts_w_lng (
	input              rx_clk,
	input      [639:0] rx_data_i,
	output     [639:0] rx_data_o,
	output     [4:0]   rx_present_o,
	output     [4:0]   rx_sof_o,
	output     [4:0]   rx_eof_o,
	output     [4:0]   rx_err_o
);

    wire    [639:0]     data;
    wire    [4:0]       pkt_map;
    wire    [4:0]       sof_map;
    wire    [4:0]       eof_map;
    wire    [4:0]       err_map = 5'h0;

    find_pkts find_pkts (
        .clk            (rx_clk),
        .rst            (),

        .din            (rx_data_i),
        .dout           (data),
        .pkt_map        (pkt_map),
        .sof_map        (sof_map),
        .eof_map        (eof_map),
        .len            ()
    );

    detect_lng_dln_mismatch lng_mismatch (
        .clk            (rx_clk),
        .data_i         (data),
        .pres_i         (pkt_map),
        .sof_i          (sof_map),
        .eof_i          (eof_map),
        .err_i          (err_map),
        .data_o         (rx_data_o),
        .pres_o         (rx_present_o),
        .sof_o          (rx_sof_o),
        .eof_o          (rx_eof_o),
        .err_o          (rx_err_o)
    );

endmodule

/*
 * Pipeline stage for calculating CRC.
 * This module should calculate the CRC based on the previous crc (crc_i),
 * if it's enabled (en_i), if it's start of frame (sof_i), or if it's end
 * of frame (eof_i). Based on this data we calculate the CRC and then
 * output en_o if we aren't at the end of frame.
 */
module hmc_crc_pipe #(
	parameter  CARRY = 0,
	parameter  PIPE = 0
) (
	input              clk,
	input      [639:0] data_i,
	input      [31:0]  crc_i,
	input      [5:0]   en_i,
	input      [4:0]   pres_i,
	input      [4:0]   sof_i,
	input      [4:0]   eof_i,
	input      [4:0]   err_i,
	output reg [639:0] data_o = 640'h0,
	output reg [31:0]  crc_o = 32'h0,
	output reg [5:0]   en_o = 5'h0,
	output reg [4:0]   pres_o = 5'h0,
	output reg [4:0]   sof_o = 5'h0,
	output reg [4:0]   eof_o = 5'h0,
	output reg [4:0]   err_o = 5'h0
);

// Data input to CRC, set CRC field to 0 if we're processing an EOF FLIT
wire [127:0] data_c = eof_i[0] ? {32'h0, data_i[95:0]} : data_i[127:0];

// If we're processing an SOF FLIT, set CRC input to 0
wire [31:0] crc_c = sof_i[0] ? 32'h0 : crc_i;

// CRC32
wire [31:0] crc;
hmc_crc hmc_crc_0 (
	.data(data_c),
	.crc_i(crc_c),
	.crc_o(crc)
);

// If we're the first stage of the pipeline, make use of carry input
wire en = CARRY ? en_i[5] : en_i[4];

// This is the inner block of an always done this way so we can adjust
// the pipeline stages that are registered
// Note: ignore the error checking in this module, because we do that
// elsewhere now
`define DOCRC \
	data_o <= {data_i[127:0], data_i[639:128]}; \
	crc_o  <= crc; \
	err_o  <= {err_i[0], err_i[4:1]}; \
	en_o   <= {1'b0, en_i[0] | en | sof_i[0], en_i[4:1]}; \
	pres_o <= {pres_i[0], pres_i[4:1]}; \
	sof_o  <= {sof_i[0], sof_i[4:1]}; \
	eof_o  <= {eof_i[0], eof_i[4:1]}

     // one of these always blocks will be empty. the alternative would be generate-if
     always @(posedge clk) begin
          if(PIPE != 0) begin
               `DOCRC;
          end
     end
     always @(*) begin
          if (PIPE == 0) begin
               `DOCRC;
          end
     end

endmodule


/*
 * Carry Pipeline stage for calculating CRC
 * This module just adds a delay stage and carries the last CRC back in
 * pipeline to properly continue CRC propagation back through the chain.
 */
module hmc_crc_carry (
	input              clk,
	input      [639:0] data_i,
	input      [31:0]  crc_i,
	input      [5:0]   en_i,
	input      [4:0]   pres_i,
	input      [4:0]   sof_i,
	input      [4:0]   eof_i,
	input      [4:0]   err_i,
	output reg [639:0] data_o = 640'h0,
	output reg [31:0]  crc_o = 32'h0,
	output reg [5:0]   en_o = 5'h0,
	output reg [4:0]   pres_o = 5'h0,
	output reg [4:0]   sof_o = 5'h0,
	output reg [4:0]   eof_o = 5'h0,
	output reg [4:0]   err_o = 5'h0
);

reg [31:0] crc_save = 0;
reg en_save = 0;

always @(posedge clk) begin
	crc_save <= crc_i[31:0];
	en_save  <= en_i[4];
	data_o   <= data_i;
	crc_o    <= en_save ? crc_save : 32'h0;
	en_o     <= {en_save, en_i[4:0]};
	sof_o    <= sof_i;
	eof_o    <= eof_i;
	pres_o   <= pres_i;
	err_o    <= err_i;
end

endmodule

/*
 * this module checks if the CRC embedded in the incoming data matches the
 * input CRC. Note that we only need to do this if we are enabled. we will be
 * enabled if the crc has been fully computed for a packet.
 */
module hmc_crc_check #(
	parameter  PIPE = 0
)
(
	input              clk,
	input      [639:0] data_i,
	input      [31:0]  crc_i,
	input      [4:0]   err_i,
    input              en_i,
	output reg [4:0]   err_o = 5'h0
);

// this is our CRC checking
// like the other stuff, we want to make sure this can be done either in
// a registered fashion or in combinational logic
`define DOCRC_CHECK \
	if(en_i) begin \
		if(crc_i != data_i[640-1:640-32]) begin \
			err_o <= {1'b1, err_i[4:1]}; $display("[%t] %m : flagging rx error (bad crc. 0x%x should be 0x%x)", $time, data_i[640-1:640-32], crc_i); \
		end else begin \
			err_o <= {err_i[0], err_i[4:1]}; $display("[%t] %m : computed CRC matches expected (expected 0x%x, computed 0x%x)", $time, data_i[640-1:640-32], crc_i); \
		end \
    end else \
		err_o <= {err_i[0], err_i[4:1]}
     
    // one of these always blocks will be empty. the alternative would be generate-if
    always @(posedge clk) begin
        if(PIPE != 0) begin
            `DOCRC_CHECK;
        end
    end
    always @(*) begin
        if (PIPE == 0) begin
            `DOCRC_CHECK;
        end
    end
endmodule

// this just carries the err signals forward 1 cycle w/o shifting them
module hmc_err_carry (
    input               clk,
    input       [4:0]   err_i,
    output  reg [4:0]   err_o   = 5'h0
);
    always @ (posedge clk) begin
        err_o           <= err_i;
    end
endmodule

module hmc_crc_seq_chk (
	// Clock
	input      rx_clk,

	// RX Input Stream
	input      [639:0] rx_data_i,
	input      [4:0]   rx_present_i,
	input      [4:0]   rx_sof_i,
	input      [4:0]   rx_eof_i,
	input      [4:0]   rx_err_i,

	// RX Output Stream
	output reg [639:0] rx_data_o = 0,
	output reg [4:0]   rx_present_o = 0,
	output reg [4:0]   rx_sof_o = 0,
	output reg [4:0]   rx_eof_o = 0,
	output reg [4:0]   rx_err_o = 0
);

parameter PIPE_DEPTH = 18;
parameter PIPE_MOD   = 1; // should set this to 2 or 3

wire [639:0] data_pipe [PIPE_DEPTH-1:0];
wire [31:0]  crc_pipe  [PIPE_DEPTH-1:0];
wire [5:0]   en_pipe   [PIPE_DEPTH-1:0];
wire [4:0]   pres_pipe [PIPE_DEPTH-1:0];
wire [4:0]   sof_pipe  [PIPE_DEPTH-1:0];
wire [4:0]   eof_pipe  [PIPE_DEPTH-1:0];
wire [4:0]   err_pipe  [PIPE_DEPTH:0];

assign data_pipe[0] = rx_data_i;
assign crc_pipe[0]  = 32'h0;
assign en_pipe[0]   = 6'h0;
assign pres_pipe[0] = rx_present_i;
assign sof_pipe[0]  = rx_sof_i;
assign eof_pipe[0]  = rx_eof_i;
assign err_pipe[0]  = rx_err_i;

/*
 * We must be able to handle calculating the CRC for packets up to 9 FLITs long. Because our parallel bus contains
 * 5 FLITs in each clock cycle, we must be able to carry CRC calculation between 3 clock cycles worth of FLITs
 * to be able to handle calculating CRCs for all possible sizes of FLITs. Below demonstrates calculating the CRC
 * for a 9 FLIT long packet (with it's first FLIT being FLIT #3 on the parallel bus) and with a packet immediately
 * following it:
 * 
 * +  - Calculating CRC on data
 * *  - CRC was calculated on data and passed along to rest of CRC chain
 * x  - CRC checked with EOF packet -- err_o contains result of check
 * [] - Parallel bus where we're operating on the 9 FLIT long packet
 * N: - Pipeline stage
 *
 *      (Input Third)    (Input Second)   (Input First)
 * 0:   4  3  2  1  0    4  3  2  1  0   [4  3  2  1  0 ]  # NULL FLIT
 * 1:   0  4  3  2  1    0  4  3  2  1   [0  4  3  2  1 ]  # NULL FLIT
 * 2:   1  0  4  3  2    1  0  4  3  2   [1  0  4  3  2+]  # FLIT #1 (SOF)
 *
 * 3:   2  1  0  4  3    2  1  0  4  3   [2* 1  0  4  3+]  # FLIT #2
 * 4:   3  2  1  0  4    3  2  1  0  4   [3* 2* 1  0  4+]  # FLIT #3
 * 5:   4  3  2  1  0    4  3  2  1  0   [4* 3* 2* 1  0 ]  # Carry CRC forward in pipeline
 ******************* <--- *********** <--- *************
 * 6:   4  3  2  1  0   [4  3  2  1  0+]  4* 3* 2* 1  0    # FLIT #4
 * 7:   0  4  3  2  1   [0* 4  3  2  1+]  0  4* 3* 2* 1    # FLIT #5
 * 8:   1  0  4  3  2   [1* 0* 4  3  2+]  1  0  4* 3* 2*   # FLIT #6
 *
 * 9:   2  1  0  4  3   [2* 1* 0* 4  3+]  2* 1  0  4* 3*   # FLIT #7
 * 10:  3  2  1  0  4   [3* 2* 1* 0* 4+]  3* 2* 1  0  4*   # FLIT #8
 * 11:  4  3  2  1  0   [4* 3* 2* 1* 0*]  4* 3* 2* 1  0    # Carry CRC forward in pipeline
 ******************* <--- *********** <--- **************
 * 12: [4  3  2  1  0x]  4* 3* 2* 1* 0*   4* 3* 2* 1  0    # FLIT #9 (EOF)
 * 13: [0x 4  3  2  1+]  0* 4* 3* 2* 1*   0  4* 3* 2* 1    # FLIT #1 (SOF)
 * 14: [1* 0x 4  3  2+]  1* 0* 4* 3* 2*   1  0  4* 3* 2*   # FLIT #2
 *
 * 15: [2* 1* 0x 4  3+]  2* 1* 0* 4* 3*   2* 1  0  4* 3*   # FLIT #3
 * 16: [3* 2* 1* 0x 4+]  3* 2* 1* 0* 4*   3* 2* 1  0  4*   # FLIT #4
 * 17: [4* 3* 2* 1* 0x]  4* 3* 2* 1* 0*   4* 3* 2* 1  0    # End of pipeline -- CRC is fully checked and output to user
 *      (Output Third)   (Output Second)  (Output First) 
 *
 * 
 */

genvar j;
generate for(j = 0; j <= 17; j = j + 1) begin : hmc_crc_pipe_0
	if((j == 5) || (j == 11)) begin
		// Register pipeline but carry calculated CRC back in the pipeline so the next FLITs can
		// use the CRC calculated in the time slot before it.
		hmc_crc_carry hmc_crc_carry (
			.clk(rx_clk),
			.data_i(data_pipe[j]),
			.crc_i(crc_pipe[j]),
			.en_i(en_pipe[j]),
			.pres_i(pres_pipe[j]),
			.sof_i(sof_pipe[j]),
			.eof_i(eof_pipe[j]),
			.data_o(data_pipe[j+1]),
			.crc_o(crc_pipe[j+1]),
			.en_o(en_pipe[j+1]),
			.pres_o(pres_pipe[j+1]),
			.sof_o(sof_pipe[j+1]),
			.eof_o(eof_pipe[j+1])
		);
	end else if (j<17) begin
		// Calculate and check CRC on FLIT 0, then barrel shift right so we check the next FLIT on
		// the next clock cycle. All signals are shifted and pipelined through.
		hmc_crc_pipe #((j == 0) | (j == 6), (j % PIPE_MOD) == (PIPE_MOD-1)) hmc_crc_pipe (
			.clk(rx_clk),
			.data_i(data_pipe[j]),
			.crc_i(crc_pipe[j]),
			.en_i(en_pipe[j]),
			.pres_i(pres_pipe[j]),
			.sof_i(sof_pipe[j]),
			.eof_i(eof_pipe[j]),
			.data_o(data_pipe[j+1]),
			.crc_o(crc_pipe[j+1]),
			.en_o(en_pipe[j+1]),
			.pres_o(pres_pipe[j+1]),
			.sof_o(sof_pipe[j+1]),
			.eof_o(eof_pipe[j+1])
		);
    end
    
    // do the CRC checking separately from the CRC generation
    if ((j==0) || (j==6) || (j==12)) begin
        // for these timesteps, we don't want to shift the err signals at all
        // we just want to carry them through space
        hmc_err_carry hmc_err_carry (
            .clk(rx_clk),
            .err_i(err_pipe[j]),
            .err_o(err_pipe[j+1])
        );
    end else begin
        // we want our crc checking to follow the crc creation by exactly 1 cycle
        // Note: our error pipelining is off by 1 cycle, since we want to play
        // nicely with the existing hmc_crc_carry, so we just make up for it
        // later (at the output assignment)
        // Note: this module is going to be checking the crc_i against the CRC
        // in the FLIT that was just shifted into bits [639:512]
		hmc_crc_check #((j % PIPE_MOD) == (PIPE_MOD-1)) hmc_crc_check (
			.clk(rx_clk),
			.data_i(data_pipe[j]),
			.crc_i(crc_pipe[j]),
			.en_i((eof_pipe[j][4]&en_pipe[j][4])),
			.err_i(err_pipe[j]),
			.err_o(err_pipe[j+1])
        );
	end
end endgenerate

always @(posedge rx_clk) begin
	rx_data_o    <= data_pipe[17];
	rx_present_o <= pres_pipe[17];
	rx_sof_o     <= sof_pipe[17];
	rx_eof_o     <= eof_pipe[17];
end
always @(*) begin
	rx_err_o     <= err_pipe[18];
end

endmodule


module hmc_crc_seq_add (
    // Clock
    input  tx_clk,

    // TX Input Stream
    input  [639:0] tx_data_i,
    input  [4:0] tx_present_i,
    input  [4:0] tx_sof_i,
    input  [4:0] tx_eof_i,

    // TX Output Stream
    output reg [639:0] tx_data_o = 0,
    output reg   [4:0] present_o = 0,
    output reg   [4:0] sof_o = 0,
    output reg   [4:0] eof_o = 0
);

wire [31:0] crc [4:0];

hmc_crc hmc_crc_0 (
	.data({32'h0, tx_data_i[95:0]}),
	.crc_i(tx_data_i[127:96]),
	.crc_o(crc[0])
);

hmc_crc hmc_crc_1 (
	.data({32'h0, tx_data_i[223:128]}),
	.crc_i(tx_data_i[255:224]),
	.crc_o(crc[1])
);

hmc_crc hmc_crc_2 (
	.data({32'h0, tx_data_i[351:256]}),
	.crc_i(tx_data_i[383:352]),
	.crc_o(crc[2])
);

hmc_crc hmc_crc_3 (
	.data({32'h0, tx_data_i[479:384]}),
	.crc_i(tx_data_i[511:480]),
	.crc_o(crc[3])
);

hmc_crc hmc_crc_4 (
	.data({32'h0, tx_data_i[607:512]}),
	.crc_i(tx_data_i[639:608]),
	.crc_o(crc[4])
);

always @(posedge tx_clk) begin
	tx_data_o[127:0]   <= {tx_eof_i[0] ? crc[0] : tx_data_i[127:96],  tx_data_i[95:0]};
	tx_data_o[255:128] <= {tx_eof_i[1] ? crc[1] : tx_data_i[255:224], tx_data_i[223:128]};
	tx_data_o[383:256] <= {tx_eof_i[2] ? crc[2] : tx_data_i[383:352], tx_data_i[351:256]};
	tx_data_o[511:384] <= {tx_eof_i[3] ? crc[3] : tx_data_i[511:480], tx_data_i[479:384]};
	tx_data_o[639:512] <= {tx_eof_i[4] ? crc[4] : tx_data_i[639:608], tx_data_i[607:512]};

     // pass the accessory bits straight on through
     present_o <= tx_present_i;
     sof_o     <= tx_sof_i;
     eof_o     <= tx_eof_i;
end

endmodule
