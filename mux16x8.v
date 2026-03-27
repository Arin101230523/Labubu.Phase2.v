//=================================================================
//
// STRUCTURAL MULTIPLEXER
//
// StructMux
//
// Combinational Logic of GATES
// Parallels Course Material
//
//=================================================================

//=================================================================
module Mux16x8(channels, select, b);

parameter k = 8;

input  [15:0] select;
input  [16*k-1:0] channels;
output [k-1:0] b;

assign b =
    ({k{select[15]}} & channels[16*15 +: k]) |
    ({k{select[14]}} & channels[16*14 +: k]) |
    ({k{select[13]}} & channels[16*13 +: k]) |
    ({k{select[12]}} & channels[16*12 +: k]) |
    ({k{select[11]}} & channels[16*11 +: k]) |
    ({k{select[10]}} & channels[16*10 +: k]) |
    ({k{select[ 9]}} & channels[16* 9 +: k]) |
    ({k{select[ 8]}} & channels[16* 8 +: k]) |
    ({k{select[ 7]}} & channels[16* 7 +: k]) |
    ({k{select[ 6]}} & channels[16* 6 +: k]) |
    ({k{select[ 5]}} & channels[16* 5 +: k]) |
    ({k{select[ 4]}} & channels[16* 4 +: k]) |
    ({k{select[ 3]}} & channels[16* 3 +: k]) |
    ({k{select[ 2]}} & channels[16* 2 +: k]) |
    ({k{select[ 1]}} & channels[16* 1 +: k]) |
    ({k{select[ 0]}} & channels[16* 0 +: k]);

endmodule
