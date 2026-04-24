module ThirtyTwoBitSWAP(input [31:0] A, output [31:0] Y);
    assign Y = {A[15:0], A[31:16]};
endmodule