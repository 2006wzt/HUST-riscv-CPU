module counter_32(clk, out,halt,RST);
	input clk,halt,RST;                    
	output reg [31:0] out;             
    initial out=0;
	always @(posedge clk)  begin
	    if(RST) out<=0;
        else if(out<32'hffffffff) begin
            if(~halt)
                out<=out+1'b1;
        end
        else begin
            out<=0;
        end
	end                           
endmodule