//=================================================================
//
// STRUCTURAL MULTIPLEXER
//
// StructMux
//
// Combinational Logic of GATES
// Parallels Course Material
//
//=================================================================

//=================================================================
module Mux16x8(channels, select, b);
parameter k=8;
input [15:0][k-1:0] channels;
input      [15:0] select;
output      [k-1:0] b;


	assign b = ({k{select[15]}} & channels[15]) | 
               ({k{select[14]}} & channels[14]) |
			   ({k{select[13]}} & channels[13]) |
			   ({k{select[12]}} & channels[12]) |
			   ({k{select[11]}} & channels[11]) |
			   ({k{select[10]}} & channels[10]) |
			   ({k{select[ 9]}} & channels[ 9]) | 
			   ({k{select[ 8]}} & channels[ 8]) |
			   ({k{select[ 7]}} & channels[ 7]) |
			   ({k{select[ 6]}} & channels[ 6]) |
			   ({k{select[ 5]}} & channels[ 5]) | 
			   ({k{select[ 4]}} & channels[ 4]) | 
			   ({k{select[ 3]}} & channels[ 3]) | 
			   ({k{select[ 2]}} & channels[ 2]) | 
               ({k{select[ 1]}} & channels[ 1]) | 
               ({k{select[ 0]}} & channels[ 0]) ;

endmodule