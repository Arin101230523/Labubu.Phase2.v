module ThirtyTwoBitAND(inputA, inputB, outputC);
    input  [31:0] inputA;
    input  [31:0] inputB;
    output [31:0] outputC;

    assign outputC = inputA & inputB;
endmodule