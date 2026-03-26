// =============================================================
// LABU - Labubu Adaptive Behavioral Unit
// Phase 2 Testbench
// =============================================================
// A sequential program of opcodes sent against a clock.
// Each opcode changes Labubu's internal state (mood/energy).
// Output shows: time, opcode, behavior name, input A, state, error.
// =============================================================

module testbench();
    reg  clk, rst;
    reg  [7:0]  A;
    reg  [3:0]  opcode;
    wire [7:0]  C;
    wire        error;

    // Instantiate the breadboard (Device Under Test)
    breadboard dut(clk, rst, A, opcode, C, error);

    // Clock generator: 10-unit period
    initial begin clk = 0; forever #5 clk = ~clk; end

    // Task: load one opcode + operand, wait for rising edge, display result
    task run_op;
        input [3:0]  op;
        input [7:0]  val;
        input [127:0] label;
        begin
            opcode = op;
            A      = val;
            @(posedge clk); #1;
            $display("  %5t | %s | OP=%b (%h) | A=%3d (0x%02h) | STATE=%3d (0x%02h) | ERR=%b",
                     $time, label, op, op, val, val, C, C, error);
        end
    endtask

    initial begin
        $display("==============================================================================");
        $display("   LABU - Labubu Adaptive Behavioral Unit              Phase 2 Output");
        $display("==============================================================================");
        $display("   Time  |     Behavior      | Opcode   | Input A      | State        | ERR");
        $display("------------------------------------------------------------------------------");

        // Initialize
        rst = 1; A = 8'd0; opcode = 4'b0000;
        @(posedge clk); #1;
        $display("  %5t | [RESET PULSE]      | rst=1    | A=%3d        | STATE=%3d    | ERR=%b",
                 $time, A, C, error);
        rst = 0;

        // 0000 STARE: hold state (state stays 0)
        run_op(4'b0000, 8'd0,   "0000 STARE    NO-OP ");

        // 0001 SLEEP: wipe to zero (already 0, confirms RESET channel)
        run_op(4'b0001, 8'd0,   "0001 SLEEP    RESET ");

        // 0010 SNACK: ADD 75 -> state = 0 + 75 = 75
        run_op(4'b0010, 8'd75,  "0010 SNACK    ADD   ");

        // 0010 SNACK: ADD 30 -> state = 75 + 30 = 105
        run_op(4'b0010, 8'd30,  "0010 SNACK    ADD   ");

        // 0011 DRAIN: SUB 25 -> state = 105 - 25 = 80
        run_op(4'b0011, 8'd25,  "0011 DRAIN    SUB   ");

        // 0100 FART: DIV 8 -> state = 80 / 8 = 10
        run_op(4'b0100, 8'd8,   "0100 FART     DIV   ");

        // 0101 POOP: MOD 3 -> state = 10 % 3 = 1
        run_op(4'b0101, 8'd3,   "0101 POOP     MOD   ");

        // 0010 SNACK: ADD 49 -> state = 1 + 49 = 50  (set up for multiply)
        run_op(4'b0010, 8'd49,  "0010 SNACK    ADD   ");

        // 0110 SUGAR RUSH: MUL 3 -> state = 50 * 3 = 150
        run_op(4'b0110, 8'd3,   "0110 SUGARUSH MUL   ");

        // 0111 ZOOMIES: SHL -> state = 150 << 1 = 44 (wraps 8-bit: 300 & 0xFF = 44)
        run_op(4'b0111, 8'd0,   "0111 ZOOMIES  SHL   ");

        // 1000 NAP: SHR -> state = 44 >> 1 = 22
        run_op(4'b1000, 8'd0,   "1000 NAP      SHR   ");

        // 1001 GIGGLE: XOR 0xFF -> state = 22 ^ 255 = 233
        run_op(4'b1001, 8'hFF,  "1001 GIGGLE   XOR   ");

        // 1010 PARTY: OR 0x0F -> state = 233 | 15 = 239
        run_op(4'b1010, 8'h0F,  "1010 PARTY    OR    ");

        // 1011 GRUMPY: AND 0xF0 -> state = 239 & 240 = 224
        run_op(4'b1011, 8'hF0,  "1011 GRUMPY   AND   ");

        // 1100 GHOST: NOT -> state = ~224 = 31
        run_op(4'b1100, 8'd0,   "1100 GHOST    NOT   ");

        // 1101 DANCE: SWAP nibbles -> state = {31[3:0], 31[7:4]} = {1111,0001} = 0xF1 = 241
        run_op(4'b1101, 8'd0,   "1101 DANCE    SWAP  ");

        // 1110 MAX OUT: force to 255
        run_op(4'b1110, 8'd0,   "1110 MAXOUT   CONST ");

        // 1111 MIN OUT: force to 1
        run_op(4'b1111, 8'd0,   "1111 MINOUT   CONST ");

        $display("------------------------------------------------------------------------------");
        $display("  ERROR HANDLING TESTS");
        $display("------------------------------------------------------------------------------");

        // Error Test 1: FART divide-by-zero -> ERR=1, state = x
        run_op(4'b0100, 8'd0,   "0100 FART/0   ERR   ");

        // Error Test 2: POOP mod-by-zero -> ERR=1
        run_op(4'b0101, 8'd0,   "0101 POOP/0   ERR   ");

        // Error Test 3: SNACK overflow -> 1 + 255 = overflow
        run_op(4'b0001, 8'd0,   "0001 SLEEP    RESET "); // reset first
        run_op(4'b0010, 8'd255, "0010 SNACK+FF ADD   "); // load 255
        // Add again to push past 255
        run_op(4'b0010, 8'd10,  "0010 SNACK 265 ADD  "); // 255+10 -> overflow ERR=1

        $display("==============================================================================");
        $display("  [INFO] All 16 opcodes exercised. Sequential clock-driven program complete.");
        $display("  [STRUCTURAL]  : Dec4x16, Mux16x8, EightBitAddSub, FourBitAddSub,");
        $display("                  FullAdder, FourBitXOR, FourBitOR, FourBitAND, DFF");
        $display("  [BEHAVIORAL]  : FourBitDiv (GasDiv), FourBitMod (PoopMod),");
        $display("                  EightBitMul (SugarRush) - structural equiv. too large");
        $display("  [FEEDBACK]    : cur[7:0] wire from ACC1 (DFF[7:0]) to all math units");
        $display("  [ERROR CODES] : overflow on ADD/SUB, divide-by-zero on DIV/MOD");
        $display("==============================================================================");

        #10 $finish;
    end
endmodule
