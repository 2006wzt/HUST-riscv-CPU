//2Â·Ñ¡ÔñÆ÷
module mux2(out, in0, in1, sel) ;
	parameter WIDTH = 32;
	output [WIDTH-1:0] out;
    input [WIDTH-1:0] in0, in1;
	input sel;
	assign out = sel == 0?in0:in1 ;
endmodule