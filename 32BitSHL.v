module ThirtyTwoBitSHL(input [31:0] A, output [31:0] Y);
    assign Y = {A[30:0], 1'b0};
endmodule