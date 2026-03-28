// Behaviorial Justification: Would require 1024 gate product array and a large adder tree that would be larger than rest of program
module ThirtyTwoBitMul(inputA, inputB, result, mul_ov);
    input  [31:0] inputA;
    input  [31:0] inputB;
    output [31:0] result;
    output        mul_ov;
    reg    [63:0] full;

    always @(*) begin
        full = inputA * inputB; // 64-bit product captures overflow
    end

    assign result = full[31:0];
    assign mul_ov = |full[63:32]; // 1 if any upper 32 bits are non zero
endmodule