module ALU(X,Y,ALUOP,Result1,Result2,greater_equal,lesser,equal);
    input [31:0] X,Y;
    input [3:0] ALUOP;
    output reg [31:0] Result1,Result2;
    output reg greater_equal,lesser;
    output equal;
    assign equal=(X==Y);
    always@(X,Y,ALUOP) begin
        case(ALUOP)
            4'b0000:begin
                Result1=X<<Y[4:0];
                Result2=0;
            end
            4'b0001:begin
                Result1=$signed(X)>>>Y[4:0];
                Result2=0;
            end
            4'b0010:begin
                Result1=X>>Y[4:0];
                Result2=0;
            end
            4'b0011:{Result2,Result1}=X*Y;
            4'b0100:begin
                Result1=X/Y;
                Result2=X%Y;
            end
            4'b0101:begin
                Result1=X+Y;
            end
            4'b0110:begin
                Result1=X-Y;
            end
            4'b0111:Result1=X&Y;
            4'b1000:Result1=X|Y;
            4'b1001:Result1=X^Y;
            4'b1010:Result1=~(X|Y);
            4'b1011:begin
                Result1=($signed(X)<$signed(Y))?1:0;
                lesser=Result1==1?1:0;
                greater_equal=~lesser;
            end
            4'b1100:begin
                Result1=(X<Y)?1:0;
                lesser=Result1==1?1:0;
                greater_equal=~lesser;
            end
        endcase
    end
endmodule