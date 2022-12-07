module pattern(code, patt);//7¶ÎÒëÂëÆ÷
	input [3: 0] code;       
	output reg [7:0] patt;      
    always@(code) begin
        case (code[3:0])
	        4'b0000:patt=8'b11000000;
            4'b0001:patt=8'b11111001;
            4'b0010:patt=8'b10100100;
            4'b0011:patt=8'b10110000;
            4'b0100:patt=8'b10011001;
            4'b0101:patt=8'b10010010;
            4'b0110:patt=8'b10000010;
            4'b0111:patt=8'b11111000;
            4'b1000:patt=8'b10000000;
            4'b1001:patt=8'b10011000;
            4'b1010:patt=8'b10001000;
            4'b1011:patt=8'b10000011;
            4'b1100:patt=8'b11000110;
            4'b1101:patt=8'b10100001;
            4'b1110:patt=8'b10000110;
            4'b1111:patt=8'b10001110;
        endcase
	end                       
endmodule