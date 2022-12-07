module MEM(Addr,Din,CLK,MemWrite,sel,Dout);
    input[9:0] Addr;
    input[31:0] Din;
    input CLK,MemWrite;
    input [3:0] sel;
    output[31:0] Dout;
    reg [31:0] RAM[2**20-1:0];//存储寄存器
    always@(posedge CLK) begin
        if (MemWrite) begin
            if (sel==4'b1111) RAM[Addr] <= Din;//进行数据写入
            else if (sel==4'b0001) RAM[Addr][7:0]<=Din[7:0];
            else if (sel==4'b0010) RAM[Addr][15:8]<=Din[15:8];
            else if (sel==4'b0100) RAM[Addr][23:16]<=Din[23:16];
            else if (sel==4'b1000) RAM[Addr][31:24]<=Din[31:24];
        end
    end
    assign Dout=RAM[Addr];
endmodule