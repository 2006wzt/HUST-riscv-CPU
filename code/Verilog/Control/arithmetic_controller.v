//运算控制器
module arithmetic_controller(Funct7,Funct3,OpCode,ALUOP);
    input[7:0] Funct7;
    input[2:0] Funct3;
    input[4:0] OpCode;
    output reg[3:0] ALUOP;
    always@(Funct7,Funct3,OpCode)begin
        if(Funct7==7'b0000000 && Funct3==3'b000 && OpCode==5'b01100) ALUOP=4'b0101;//add
        else if(Funct7==7'b0100000 && Funct3==3'b000 && OpCode==5'b01100) ALUOP=4'b0110;//sub
        else if(Funct7==7'b0000000 && Funct3==3'b111 && OpCode==5'b01100) ALUOP=4'b0111;//and
        else if(Funct7==7'b0000000 && Funct3==3'b110 && OpCode==5'b01100) ALUOP=4'b1000;//or
        else if(Funct7==7'b0000000 && Funct3==3'b010 && OpCode==5'b01100) ALUOP=4'b1011;//slt
        else if(Funct7==7'b0000000 && Funct3==3'b011 && OpCode==5'b01100) ALUOP=4'b1100;//sltu
        else if(Funct3==3'b000 && OpCode==5'b00100) ALUOP=4'b0101;//addi
        else if(Funct3==3'b111 && OpCode==5'b00100) ALUOP=4'b0111;//andi
        else if(Funct3==3'b110 && OpCode==5'b00100) ALUOP=4'b1000;//ori
        else if(Funct3==3'b100 && OpCode==5'b00100) ALUOP=4'b1001;//xori
        else if(Funct3==3'b010 && OpCode==5'b00100) ALUOP=4'b1011;//slti
        else if(Funct7==7'b0000000 && Funct3==3'b001 && OpCode==5'b00100) ALUOP=4'b0000;//slli
        else if(Funct7==7'b0000000 && Funct3==3'b101 && OpCode==5'b00100) ALUOP=4'b0010;//srli
        else if(Funct7==7'b0100000 && Funct3==3'b101 && OpCode==5'b00100) ALUOP=4'b0001;//srai
        else if(Funct3==3'b010 && OpCode==5'b00000) ALUOP=4'b0101;//lw
        else if(Funct3==3'b010 && OpCode==5'b01000) ALUOP=4'b0101;//sw
        else if(OpCode==5'b11001) ALUOP=4'b0101;//jalr
        else if(Funct7==7'b0000000 && Funct3==3'b101 && OpCode==5'b01100) ALUOP=4'b0010;//srl
        else if(Funct3==3'b011 && OpCode==5'b00100) ALUOP=4'b1100;//sltiu
        else if(Funct3==3'b000 && OpCode==5'b01000) ALUOP=4'b0101;//sb
        else if(Funct3==3'b100 && OpCode==5'b11000) ALUOP=4'b1011;//blt
        else ALUOP=4'b0101;//默认加法
    end
endmodule