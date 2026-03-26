module FourBitMod(inputA,inputB,result,err);
parameter k=4;

input [k-1:0]inputA;
input [k-1:0]inputB;
wire [k-1:0] inputA;
wire [k-1:0] inputB;

output [k-1:0]result;
output err;
reg [k-1:0] result;
reg err;

//This module is behavioral, which means I can use if statements and built-in math operations.

always@(*)
begin
 
   assign err=0;

   if (inputB==0)
      begin
	     assign err=1;
      end
 
   result=inputA%inputB;//behavioral modulus
   
 end

endmodule

/*
//============================================
module testbench();

reg [3:0] a,b;
wire [3:0] c;
wire d;

FourBitMod fbm(a,b,c,d);

initial begin

a=4'b1111;
b=4'b1010;
#10;
$display("%b|%b|%b|%b",a,b,c,d);

a=4'b1111;
b=4'b0000;
#10;
$display("%b|%b|%b|%b",a,b,c,d);



$finish;

end


endmodule
 */