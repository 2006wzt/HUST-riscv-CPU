module decoder3_8(num, sel);//3-8译码器，生成数码管片选信号
	input [2: 0] num;       
	output reg [7:0] sel;
    always@(num) begin
        case (num[2:0])
		3'b000:sel=~8'b00000001;
		3'b001:sel=~8'b00000010;
		3'b010:sel=~8'b00000100;
		3'b011:sel=~8'b00001000;
		3'b100:sel=~8'b00010000;
		3'b101:sel=~8'b00100000;
		3'b110:sel=~8'b01000000;
		3'b111:sel=~8'b10000000;
        endcase
	end                    
endmodule