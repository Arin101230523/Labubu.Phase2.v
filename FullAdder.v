//=============================================
//
// Full Adder
//
//=============================================
module FullAdder(A,B,C,carry,sum);
	input A;
	wire A;
	input B;
	wire B;
	input C;
	wire C;
	output carry;
	output sum;
	reg carry;
	reg sum;
//---------------------------------------------
	always @(*) 
	  begin
 		sum= A^B^C;
 		carry=((A^B)&C)|(A&B);  
	  end
//---------------------------------------------
	
endmodule