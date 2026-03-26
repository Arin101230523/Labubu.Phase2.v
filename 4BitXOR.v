//=================================================================
//
// FourBitOR
//
// Inputs
// inputA, a 4-bit integer
// inputB, a 4-bit integer
//
// Output
// outputC, a 4-bit integer
//
//==================================================================

module FourBitXOR(inputA,inputB,outputC);
parameter k=4;
input  [k-1:0] inputA;
input  [k-1:0] inputB;
output [k-1:0] outputC;
wire   [k-1:0] inputA;
wire   [k-1:0] inputB;
reg    [k-1:0] outputC;

reg    [k-1:0] result;

always@(*)
begin
	result=inputA^inputB;
	outputC=result;
end
 
endmodule

/*
//============================================
module testbench();

reg [3:0] a,b;
wire [3:0] c;

FourBitXOR fbx(a,b,c);

initial begin
a=4'b1111;
b=4'b1010;
#10;
$display("%b|%b|%b",a,b,c);
$finish;

end


endmodule
 */