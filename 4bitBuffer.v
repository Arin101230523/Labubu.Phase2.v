//=================================================================
//
// FourBitBuffer
//
// Inputs
// inputA, a 4-bit integer
//
// Output
// outputC, a 4-bit integer
//
//==================================================================

module FourBitBuffer(inputA,outputC);
parameter k=4;
input  [k-1:0] inputA;
output [k-1:0] outputC;
wire   [k-1:0] inputA;
reg    [k-1:0] outputC;
reg    [k-1:0] result;

always@(*)
begin
	result= (inputA);
	outputC=result;
end
 
endmodule
