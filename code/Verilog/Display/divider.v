module divider (clk, clk_N);
    input           clk;
    output reg      clk_N;
    parameter      N = 50_000_000;
    reg [31:0]      counter;
        initial begin;
            counter <= 32'h0;
            clk_N <= 1'b0;
        end
    always @(posedge clk)  begin
        if(counter==N) begin
            clk_N <= ~clk_N;
            counter <= 32'h0;
        end
        else
            counter <= counter + 1;
    end
endmodule