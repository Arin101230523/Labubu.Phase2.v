module breadboard(clk, rst, A, opcode, C, error, status);
    input clk, rst;
    input [31:0] A;
    input [ 3:0] opcode;
    output [31:0] C;
    output error;
    output [ 3:0] status;

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
    wire [31:0] xor_res, or_res, and_res;
    ThirtyTwoBitXOR giggle_unit(cur32, A, xor_res);
    ThirtyTwoBitOR party_unit(cur32, A, or_res);
    ThirtyTwoBitAND grumpy_unit(cur32, A, and_res);

    // Multiplexer Channels
    wire [511:0] channels;
    assign channels[31:0] = acc_out; // 0000: NOP
    assign channels[63:32] = 32'h0; // 0001: RESET
    assign channels[95:64] = sum_res; // 0010: ADD
    assign channels[127:96] = sub_res; // 0011: SUB
    assign channels[159:128] = div_res; // 0100: DIV
    assign channels[191:160] = mod_res; // 0101: MOD
    assign channels[223:192] = mul_res; // 0110: MUL
    assign channels[255:224] = {cur32[30:0], 1'b0}; // 0111: Shift Left (SHL)
    assign channels[287:256] = {1'b0, cur32[31:1]}; // 1000: Shift Right (SHR)
    assign channels[319:288] = xor_res; // 1001: XOR
    assign channels[351:320] = or_res; // 1010: OR
    assign channels[383:352] = and_res; // 1011: AND
    assign channels[415:384] = ~cur32; // 1100: NOT
    assign channels[447:416] = {acc_out[15:0], acc_out[31:16]}; // 1101: SWAP
    assign channels[479:448] = 32'hFFFFFFFF; // 1110: MAX
    assign channels[511:480] = 32'h00000001; // 1111: MIN

    wire [31:0] next;
    Mux16x32 brain_mux(channels, select, next);

    // Main Register
    wire [31:0] acc_in = rst ? 32'b0 : next;
    DFF acc1 [31:0] (clk, acc_in, acc_out);

    // Error Gates
    wire e0 = select[2] & add_carry; 
    wire e1 = select[3] & ~sub_carry; 
    wire e2 = select[4] & div_err;   
    wire e3 = select[5] & mod_err;   
    wire e4 = select[6] & mul_ov;    

    wire comb_err = e0 | e1 | e2 | e3 | e4;
    wire [3:0] comb_stat = e0 ? 4'd1 : e1 ? 4'd2 : e2 ? 4'd3 : e3 ? 4'd4 : e4 ? 4'd5 : 4'd0;

    // Register Status
    DFF err_reg (clk, (rst ? 1'b0 : comb_err), error);
    DFF stat_reg [3:0] (clk, (rst ? 4'b0 : comb_stat), status);

endmodule