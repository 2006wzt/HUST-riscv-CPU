module display_sel(num, dig, code);
    input   [2: 0]    num;
    input   [31:0]    dig;
    output reg [3:0]  code;
    always @* begin
        case(num)
            3'd0: code = dig[3:0];
            3'd1: code = dig[7:4];
            3'd2: code = dig[11:8];
            3'd3: code = dig[15:12];
            3'd4: code = dig[19:16];
            3'd5: code = dig[23:20];
            3'd6: code = dig[27:24];
            3'd7: code = dig[31:28];
            default: code = 4'h0;
        endcase
    end
endmodule
