module ThirtyTwoBitSHR(input [31:0] A, output [31:0] Y);
    assign Y = {1'b0, A[31:1]};
endmodule