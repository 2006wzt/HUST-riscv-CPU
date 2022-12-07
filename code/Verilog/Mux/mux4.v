//4Â·Ñ¡ÔñÆ÷
module mux4(out, in0, in1, in2, in3, sel);
	parameter WIDTH = 32;
	output reg [WIDTH-1:0] out;
    input [WIDTH-1:0] in0, in1,in2,in3;
	input[1:0] sel;
    always @ (in0,in1,in2,in3,sel) begin
		case(sel)
			2'b00: out=in0;
			2'b01: out=in1;
			2'b10: out=in2;
			2'b11: out=in3;
		endcase
	end
endmodule