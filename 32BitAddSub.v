module ThirtyTwoBitAddSub(inputA, inputB, mode, sum, carry, overflow);
    input  [31:0] inputA, inputB;
    input  mode; // 0 addition, 1 subtraction
    output [31:0] sum;
    output carry, overflow;

    //Carry wires between 4 bit blocks
    wire c0, c1, c2, c3, c4, c5, c6;
    wire ov0;

    FourBitAddSub N0(inputA[3:0], inputB[3:0], mode, c0, sum[3:0], ov0);

    // Two's complement subtraction
    wire [27:0] Binv;
    assign Binv[ 3: 0] = {4{mode}} ^ inputB[ 7: 4];
    assign Binv[ 7: 4] = {4{mode}} ^ inputB[11: 8];
    assign Binv[11: 8] = {4{mode}} ^ inputB[15:12];
    assign Binv[15:12] = {4{mode}} ^ inputB[19:16];
    assign Binv[19:16] = {4{mode}} ^ inputB[23:20];
    assign Binv[23:20] = {4{mode}} ^ inputB[27:24];
    assign Binv[27:24] = {4{mode}} ^ inputB[31:28];

    //Internal carry wires
    wire [3:0] ch1, ch2, ch3, ch4, ch5, ch6, ch7;

    // Block 1
    FullAdder N1FA0(inputA[ 4], Binv[ 0],  c0,    ch1[0], sum[ 4]);
    FullAdder N1FA1(inputA[ 5], Binv[ 1], ch1[0], ch1[1], sum[ 5]);
    FullAdder N1FA2(inputA[ 6], Binv[ 2], ch1[1], ch1[2], sum[ 6]);
    FullAdder N1FA3(inputA[ 7], Binv[ 3], ch1[2], ch1[3], sum[ 7]);
    assign c1 = ch1[3];

    // Block 2
    FullAdder N2FA0(inputA[ 8], Binv[ 4],  c1,    ch2[0], sum[ 8]);
    FullAdder N2FA1(inputA[ 9], Binv[ 5], ch2[0], ch2[1], sum[ 9]);
    FullAdder N2FA2(inputA[10], Binv[ 6], ch2[1], ch2[2], sum[10]);
    FullAdder N2FA3(inputA[11], Binv[ 7], ch2[2], ch2[3], sum[11]);
    assign c2 = ch2[3];

    //Block 3
    FullAdder N3FA0(inputA[12], Binv[ 8],  c2,    ch3[0], sum[12]);
    FullAdder N3FA1(inputA[13], Binv[ 9], ch3[0], ch3[1], sum[13]);
    FullAdder N3FA2(inputA[14], Binv[10], ch3[1], ch3[2], sum[14]);
    FullAdder N3FA3(inputA[15], Binv[11], ch3[2], ch3[3], sum[15]);
    assign c3 = ch3[3];

    // Block 4
    FullAdder N4FA0(inputA[16], Binv[12],  c3,    ch4[0], sum[16]);
    FullAdder N4FA1(inputA[17], Binv[13], ch4[0], ch4[1], sum[17]);
    FullAdder N4FA2(inputA[18], Binv[14], ch4[1], ch4[2], sum[18]);
    FullAdder N4FA3(inputA[19], Binv[15], ch4[2], ch4[3], sum[19]);
    assign c4 = ch4[3];

    // Block 5
    FullAdder N5FA0(inputA[20], Binv[16],  c4,    ch5[0], sum[20]);
    FullAdder N5FA1(inputA[21], Binv[17], ch5[0], ch5[1], sum[21]);
    FullAdder N5FA2(inputA[22], Binv[18], ch5[1], ch5[2], sum[22]);
    FullAdder N5FA3(inputA[23], Binv[19], ch5[2], ch5[3], sum[23]);
    assign c5 = ch5[3];

    // Block 6
    FullAdder N6FA0(inputA[24], Binv[20],  c5,    ch6[0], sum[24]);
    FullAdder N6FA1(inputA[25], Binv[21], ch6[0], ch6[1], sum[25]);
    FullAdder N6FA2(inputA[26], Binv[22], ch6[1], ch6[2], sum[26]);
    FullAdder N6FA3(inputA[27], Binv[23], ch6[2], ch6[3], sum[27]);
    assign c6 = ch6[3];

    // Block 7
    FullAdder N7FA0(inputA[28], Binv[24],  c6,    ch7[0], sum[28]);
    FullAdder N7FA1(inputA[29], Binv[25], ch7[0], ch7[1], sum[29]);
    FullAdder N7FA2(inputA[30], Binv[26], ch7[1], ch7[2], sum[30]);
    FullAdder N7FA3(inputA[31], Binv[27], ch7[2], ch7[3], sum[31]);

    assign carry    = ch7[3];
    assign overflow = ch7[3] ^ ch7[2];
endmodule