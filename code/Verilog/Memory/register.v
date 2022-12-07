module register(CLK, RST, EN, Din, Dout);
	parameter WIDTH = 32;
	input CLK,RST,EN;
	input [WIDTH-1:0] Din;
	output [WIDTH-1:0] Dout;
	reg [31:0] ram;
	initial ram=0;
	always @(posedge CLK) begin
        if (RST) ram <=0;
        else if (EN) ram <= Din;
        else ram=ram;
	end
	assign Dout=ram;
endmodule