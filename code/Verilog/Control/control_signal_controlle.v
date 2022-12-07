//控制信号生成器
module control_signal_controller(Funct7,Funct3,OpCode,MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt);
    input[7:0] Funct7;
    input[2:0] Funct3;
    input[4:0] OpCode;
    output reg MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt;
    always@(Funct7,Funct3,OpCode)begin
        if(Funct7==7'b0000000 && Funct3==3'b000 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//add
        else if(Funct7==7'b0100000 && Funct3==3'b000 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//sub
        else if(Funct7==7'b0000000 && Funct3==3'b111 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//and
        else if(Funct7==7'b0000000 && Funct3==3'b110 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//or
        else if(Funct7==7'b0000000 && Funct3==3'b010 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//slt
        else if(Funct7==7'b0000000 && Funct3==3'b011 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//sltu
        else if(Funct3==3'b000 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//addi
        else if(Funct3==3'b111 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//andi
        else if(Funct3==3'b110 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//ori
        else if(Funct3==3'b100 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//xori
        else if(Funct3==3'b010 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//slti
        else if(Funct7==7'b0000000 && Funct3==3'b001 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//slli
        else if(Funct7==7'b0000000 && Funct3==3'b101 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//srli
        else if(Funct7==7'b0100000 && Funct3==3'b101 && OpCode==5'b00100)
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000000;//srai
        else if(Funct3==3'b010 && OpCode==5'b00000)
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b1011000000000;//lw
        else if(Funct3==3'b010 && OpCode==5'b01000) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0110010000000;//sw
        else if(Funct3==3'b000 && OpCode==5'b11100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0000100000000;//ecall
        else if(Funct3==3'b000 && OpCode==5'b11000) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0000001000000;//beq
        else if(Funct3==3'b001 && OpCode==5'b11000) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0000000100000;//bne
        else if(OpCode==5'b11011) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000010000;//jal
        else if(OpCode==5'b11001) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000001000;//jalr
        else if(Funct7==7'b0000000 && Funct3==3'b101 && OpCode==5'b01100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0001000000000;//srl
        else if(Funct3==3'b011 && OpCode==5'b00100) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0011000000100;//sltiu
        else if(Funct3==3'b000 && OpCode==5'b01000) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0110010000010;//sb
        else if(Funct3==3'b100 && OpCode==5'b11000) 
            {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0000000000001;//blt
        else {MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt}=13'b0000000000000;
    end
endmodule
