// Behaviorial Justification: We would need again a 32 stage subtraction gate architecture larger than the rest of program.
module ThirtyTwoBitMod(inputA, inputB, result, err);
    input  [31:0] inputA; // Dividend
    input  [31:0] inputB; // Divisor
    output [31:0] result;
    output        err;
    reg    [31:0] result;
    reg           err;

    always @(*) begin
        // mod 0 check
        if (inputB == 32'd0) begin
            err    = 1;
            result = 32'd0;
        end else begin
            err    = 0;
            result = inputA % inputB;
        end
    end
endmodule