module Mux16x32(channels, select, b);
    parameter k = 32;

    input  [15:0]     select;
    input  [16*k-1:0] channels;
    output [k-1:0]    b;

    assign b =
        ({k{select[15]}} & channels[k*15 +: k]) |
        ({k{select[14]}} & channels[k*14 +: k]) |
        ({k{select[13]}} & channels[k*13 +: k]) |
        ({k{select[12]}} & channels[k*12 +: k]) |
        ({k{select[11]}} & channels[k*11 +: k]) |
        ({k{select[10]}} & channels[k*10 +: k]) |
        ({k{select[9]}} & channels[k*9 +: k]) |
        ({k{select[8]}} & channels[k*8 +: k]) |
        ({k{select[7]}} & channels[k*7 +: k]) |
        ({k{select[6]}} & channels[k*6 +: k]) |
        ({k{select[5]}} & channels[k*5 +: k]) |
        ({k{select[4]}} & channels[k*4 +: k]) |
        ({k{select[3]}} & channels[k*3 +: k]) |
        ({k{select[2]}} & channels[k*2 +: k]) |
        ({k{select[1]}} & channels[k*1 +: k]) |
        ({k{select[0]}} & channels[k*0 +: k]);
endmodule