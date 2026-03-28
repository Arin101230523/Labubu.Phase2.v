// Behaviorial justification: We would need 32 sequential subtractions stages that would make gates larger than rest of program
module ThirtyTwoBitDiv(inputA, inputB, result, err);
    input  [31:0] inputA; // Dividend
    input  [31:0] inputB; // Divisor
    output [31:0] result;
    output        err;
    reg    [31:0] result;
    reg           err;

    always @(*) begin
        // Divide by zero check
        if (inputB == 32'd0) begin
            err    = 1;
            result = 32'd0;
        end else begin
            err    = 0;
            result = inputA / inputB;
        end
    end
endmodule