module FourBitAddSub(inputA,inputB,mode,carry,sum,overflow);
	parameter k=4;
    input [k-1:0] inputA;
	input [k-1:0] inputB;
    input mode;
	output carry;
    output [k-1:0] sum;
    output overflow;
 

    wire [k-1:0] xorInterface;
	wire [k-1:0] carryInterface;
	
	assign xorInterface={(k){mode}}^inputB;
	
	FullAdder FA00(inputA[0],xorInterface[0],mode,carryInterface[0],sum[0]);
	FullAdder FA01(inputA[1],xorInterface[1],carryInterface[0],carryInterface[1],sum[1]);
	FullAdder FA02(inputA[2],xorInterface[2],carryInterface[1],carryInterface[2],sum[2]);
	FullAdder FA03(inputA[3],xorInterface[3],carryInterface[2],carryInterface[3],sum[3]);
 
 	
	assign carry=carryInterface[k-1];
	assign overflow=(carryInterface[k-1])^(carryInterface[k-2]);
 	
 
endmodule