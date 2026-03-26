// =============================================================
// EightBitAddSub - 8-bit Structural Ripple-Carry Adder/Subtractor
// =============================================================
// Chains two FourBitAddSub units (low nibble + high nibble).
// mode=0: Addition  (sum = inputA + inputB)
// mode=1: Subtraction (sum = inputA - inputB via 2's complement)
//
// For the high nibble, the carry-in must be mid_c (carry out of
// low nibble), NOT mode. FourBitAddSub uses mode as both the XOR
// control and the initial carry-in, so the high nibble is built
// from four explicit FullAdder instantiations to correctly
// separate the carry-in from the XOR invert control.
//
// overflow flag: carry out of bit 7 (unsigned carry-out).
//   For addition:    overflow = 1 means result > 255.
//   For subtraction: overflow = 1 means result < 0 (borrow).
// =============================================================
module EightBitAddSub(inputA, inputB, mode, sum, carry, overflow);
    input  [7:0] inputA, inputB;
    input  mode;
    output [7:0] sum;
    output carry, overflow;

    wire mid_c;    // carry out of low nibble -> carry in of high nibble
    wire ov_low;   // overflow of low nibble (discarded)

    // Low nibble: mode is both XOR control and initial carry-in (correct for 2's complement)
    FourBitAddSub low(inputA[3:0], inputB[3:0], mode, mid_c, sum[3:0], ov_low);

    // High nibble: XOR inputB[7:4] with mode for inversion, carry-in = mid_c (NOT mode)
    wire [3:0] xor_hi;
    assign xor_hi = {4{mode}} ^ inputB[7:4];

    wire [3:0] c_hi; // internal carry chain for high nibble
    FullAdder FA4(inputA[4], xor_hi[0], mid_c,  c_hi[0], sum[4]);
    FullAdder FA5(inputA[5], xor_hi[1], c_hi[0], c_hi[1], sum[5]);
    FullAdder FA6(inputA[6], xor_hi[2], c_hi[1], c_hi[2], sum[6]);
    FullAdder FA7(inputA[7], xor_hi[3], c_hi[2], c_hi[3], sum[7]);

    // Unsigned overflow = carry out of the MSB
    assign carry    = c_hi[3];
    assign overflow = c_hi[3];   // 1 = result overflowed 8 bits (unsigned)
endmodule
