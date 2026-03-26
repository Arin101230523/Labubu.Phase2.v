// =============================================================
// LABU - Labubu Adaptive Behavioral Unit
// Breadboard (Top-Level Structural Module)
// =============================================================
// Inputs:
//   clk    - system clock
//   rst    - active-high synchronous reset
//   A      - 8-bit operand (food amount, poke strength, etc.)
//   opcode - 4-bit command selector
// Outputs:
//   C      - 8-bit current Labubu mood/energy (ACC1 output)
//   error  - 1-bit registered error flag (synchronized to clock)
// Interfaces:
//   cur    - feedback wire: ACC1 output -> all math/logic units
//   next   - mux output -> ACC1 input (next state)
//   channels - 16-lane 8-bit internal bus to mux
// =============================================================

module breadboard(clk, rst, A, opcode, C, error);
    input  clk, rst;
    input  [7:0] A;
    input  [3:0] opcode;
    output [7:0] C;
    output error;

    // --- Interface Wires ---
    wire [7:0] cur;               // feedback: ACC1 output -> all units
    wire [7:0] next;              // mux output -> ACC1 input
    wire [127:0] channels;
    wire [15:0] select;           // one-hot decoder output

    // --- Carry / error wires ---
    wire add_carry, sub_carry;    // carry-out of adder/subtractor
    wire add_ov,    sub_ov;       // overflow aliases
    wire div_err,   mod_err;
    wire comb_error;              // combinational error (pre-register)

    // --- Result wires ---
    wire [7:0] sum_res, sub_res, div_res, mod_res;
    wire [7:0] mul_res, xor_res, or_res, and_res;

    // ==========================================================
    // COMPONENTS ON THE BREADBOARD
    // ==========================================================

    // Decision Maker: Dec4x16 decodes 4-bit opcode -> 16-bit one-hot
    Dec4x16 brain_dec(opcode, select);

    // SnackAdd: 8-bit structural ripple-carry adder (SNACK, mode=0)
    EightBitAddSub snack_unit(cur, A, 1'b0, sum_res, add_carry, add_ov);

    // CrySub: 8-bit structural subtractor (DRAIN, mode=1)
    // 2's complement: carry_out=1 = valid result, carry_out=0 = borrow/underflow
    EightBitAddSub cry_unit(cur, A, 1'b1, sub_res, sub_carry, sub_ov);

    // GasDiv: behavioral long division (structural divider exceeds project scope)
    FourBitDiv #(.k(8)) gas_unit(cur, A, div_res, div_err);

    // PoopMod: behavioral modulus (structural modulus exceeds project scope)
    FourBitMod #(.k(8)) poop_unit(cur, A, mod_res, mod_err);

    // LogicUnit: structural bitwise operations (one gate per bit, no procedural code)
    FourBitXOR #(.k(8)) giggle_unit(cur, A, xor_res);   // GIGGLE XOR
    FourBitOR  #(.k(8)) party_unit (cur, A, or_res);    // PARTY  OR
    FourBitAND #(.k(8)) grumpy_unit(cur, A, and_res);   // GRUMPY AND

    // SugarRush: behavioral multiplier (structural 8x8 multiplier exceeds project scope)
    EightBitMul sugar_unit(cur, A, mul_res);

    // ==========================================================
    // CHANNEL MAP: 16 behaviors -> 16 Mux lanes
    // ==========================================================
    assign channels[ 0*8 +: 8] = cur;
assign channels[ 1*8 +: 8] = 8'b00000000;
assign channels[ 2*8 +: 8] = sum_res;
assign channels[ 3*8 +: 8] = sub_res;
assign channels[ 4*8 +: 8] = div_res;
assign channels[ 5*8 +: 8] = mod_res;
assign channels[ 6*8 +: 8] = mul_res;
assign channels[ 7*8 +: 8] = cur << 1;
assign channels[ 8*8 +: 8] = cur >> 1;
assign channels[ 9*8 +: 8] = xor_res;
assign channels[10*8 +: 8] = or_res;
assign channels[11*8 +: 8] = and_res;
assign channels[12*8 +: 8] = ~cur;
assign channels[13*8 +: 8] = {cur[3:0], cur[7:4]};
assign channels[14*8 +: 8] = 8'b11111111;
assign channels[15*8 +: 8] = 8'b00000001;        // 1111 MINOUT   CONST 1

    // LabuMux: 16x8 structural mux selects the active channel
    Mux16x8 brain_mux(channels, select, next);

    // ACC1: 8-bit accumulator - 8x DFF (feedback register)
    // rst synchronously clears mood/energy to 0
    wire [7:0] acc_in;
assign acc_in = rst ? 8'b0 : next;
DFF acc1 [7:0] (clk, acc_in, cur);

    // ==========================================================
    // ERROR LOGIC (combinational, then registered)
    //   ADD overflow  : carry_out=1 means result exceeded 255
    //   SUB underflow : carry_out=0 means borrow occurred (result < 0)
    //   DIV/MOD by 0  : divide or modulus by zero
    // Error is gated to active opcode to prevent false flags from
    // inactive units, then registered to synchronize with C output.
    // ==========================================================
    assign comb_error = (select[2]  &  add_carry)  |   // SNACK overflow
                        (select[3]  & ~sub_carry)  |   // DRAIN underflow
                        (select[4]  &  div_err)    |   // FART divide-by-zero
                        (select[5]  &  mod_err);       // POOP mod-by-zero

    // Register error output to synchronize with ACC1 output
    DFF err_reg(clk, (rst ? 1'b0 : comb_error), error);

    assign C = cur;

endmodule
