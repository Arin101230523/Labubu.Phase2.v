//=================================================================
// EightBitMul (Behavioral Multiplier)
// Inputs:  inputA, inputB - 8-bit integers
// Output:  result         - 8-bit result (lower 8 bits of product)
// Behavioral: a structural 8x8 multiplier would be larger than
// the entire program. Per project spec, such operations are
// permitted to be behavioral with this comment as justification.
//=================================================================
module EightBitMul(inputA, inputB, result);
    input  [7:0] inputA;
    input  [7:0] inputB;
    output [7:0] result;
    reg    [7:0] result;

    always @(*) begin
        result = inputA * inputB;   // behavioral multiply
    end
endmodule
