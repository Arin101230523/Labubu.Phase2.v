module breadboard(clk, rst, A, opcode, C, error, status);
    input clk, rst;
    input [31:0] A;
    input [3:0] opcode;
    output [31:0] C;
    output error;
    output [3:0] status;

    // Change 4-bit opcode to 16-bit one-hot for the Mux
    wire [15:0] select;
    Dec4x16 brain_dec(opcode, select);

    // 16-bit Feedback Loop
    wire [31:0] acc_out;
    wire [15:0] cur = acc_out[15:0];
    wire [31:0] cur32 = {16'b0, cur};
    assign C = acc_out; // Zero extends rest
    
    // Add and Sub
    wire [31:0] sum_res, sub_res;
    wire add_carry, sub_carry, add_ov, sub_ov;
    ThirtyTwoBitAddSub snack_unit(cur32, A, 1'b0, sum_res, add_carry, add_ov);
    ThirtyTwoBitAddSub drain_unit(cur32, A, 1'b1, sub_res, sub_carry, sub_ov);

    // Div, Mod, Mul
    wire [31:0] div_res, mod_res, mul_res;
    wire div_err, mod_err, mul_ov;
    ThirtyTwoBitDiv fart_unit(cur32, A, div_res, div_err);
    ThirtyTwoBitMod poop_unit(cur32, A, mod_res, mod_err);
    ThirtyTwoBitMul sugar_unit(cur32, A, mul_res, mul_ov);

    // Bitwise Logic
    wire [31:0] xor_res, or_res, and_res, not_res;
    ThirtyTwoBitXOR giggle_unit(cur32, A, xor_res);
    ThirtyTwoBitOR party_unit(cur32, A, or_res);
    ThirtyTwoBitAND grumpy_unit(cur32, A, and_res);
    ThirtyTwoBitNOT ghost_unit(cur32, not_res);

    // Shift, Swap, Constants
    wire [31:0] shl_res, shr_res, swap_res, max_res, min_res;
    ThirtyTwoBitSHL  zoom_unit(cur32, shl_res);
    ThirtyTwoBitSHR  nap_unit(cur32, shr_res);
    ThirtyTwoBitSWAP dance_unit(acc_out, swap_res);
    ThirtyTwoBitMAX  maxout_unit(max_res);
    ThirtyTwoBitMIN  minout_unit(min_res);

    // Multiplexer Channels
    wire [511:0] channels;
    assign channels[31:0]   = acc_out;  // 0000: NOP
    assign channels[63:32]  = 32'h0;    // 0001: RESET
    assign channels[95:64]  = sum_res;  // 0010: ADD
    assign channels[127:96] = sub_res;  // 0011: SUB
    assign channels[159:128] = div_res; // 0100: DIV
    assign channels[191:160] = mod_res; // 0101: MOD
    assign channels[223:192] = mul_res; // 0110: MUL
    assign channels[255:224] = shl_res; // 0111: ZOOM (SHL)
    assign channels[287:256] = shr_res; // 1000: NAP  (SHR)
    assign channels[319:288] = xor_res; // 1001: XOR
    assign channels[351:320] = or_res;  // 1010: OR
    assign channels[383:352] = and_res; // 1011: AND
    assign channels[415:384] = not_res; // 1100: NOT
    assign channels[447:416] = swap_res;// 1101: DANCE (SWAP)
    assign channels[479:448] = max_res; // 1110: MAXOUT (MAX)
    assign channels[511:480] = min_res; // 1111: MINOUT (MIN)

    wire [31:0] next;
    Mux16x32 brain_mux(channels, select, next);

    // Main Register
    wire rst_not;
    wire [31:0] acc_in;
    OneBitNOT rst_inv(rst, rst_not);
    ThirtyTwoBitAND rst_and(next, {32{rst_not}}, acc_in);
    DFF acc1 [31:0] (clk, acc_in, acc_out);

    // Error Gates
    wire e0, e1, e2, e3, e4;
    wire sub_carry_not;
    OneBitNOT sub_inv(sub_carry, sub_carry_not);
    OneBitAND g0(select[2], add_carry, e0);
    OneBitAND g1(select[3], sub_carry_not, e1);
    OneBitAND g2(select[4], div_err, e2);
    OneBitAND g3(select[5], mod_err, e3);
    OneBitAND g4(select[6], mul_ov, e4);

    wire comb_err;
    ThirtyTwoFiveOR err_or(e0, e1, e2, e3, e4, comb_err);

    // Status slot wires
    wire [3:0] stat2, stat3, stat4, stat5, stat6;
    FourBitAND s2(4'd1, {4{e0}}, stat2);
    FourBitAND s3(4'd2, {4{e1}}, stat3);
    FourBitAND s4(4'd3, {4{e2}}, stat4);
    FourBitAND s5(4'd4, {4{e3}}, stat5);
    FourBitAND s6(4'd5, {4{e4}}, stat6);

    // Status Bus Channels
    wire [63:0] s_channels; // 16 channels of 4-bit status codes
    assign s_channels[3:0] = 4'd0;
    assign s_channels[7:4] = 4'd0;
    assign s_channels[11:8] = stat2;
    assign s_channels[15:12] = stat3;
    assign s_channels[19:16] = stat4;
    assign s_channels[23:20] = stat5;
    assign s_channels[27:24] = stat6;
    assign s_channels[63:28] = 36'd0;

    wire [3:0] comb_stat;
    Mux16x32 #(.k(4)) stat_mux(s_channels, select, comb_stat);

    // Register Status
    wire err_in;
    wire [3:0] stat_in;
    OneBitAND err_and(comb_err, rst_not, err_in);
    FourBitAND stat_and(comb_stat, {4{rst_not}}, stat_in);
    DFF err_reg (clk, err_in, error);
    DFF stat_reg [3:0] (clk, stat_in, status);

endmodule