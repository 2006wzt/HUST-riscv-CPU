//硬布线控制器
module hard_wire_controller(Funct,OpCode,ALUOP,MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt);
    input[4:0] Funct;
    input[4:0] OpCode;
    output MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt;
    output [3:0]ALUOP;
    //根据Funct构造Funct7和Funct3
    wire [6:0] Funct7;
    wire [2:0] Funct3;
    assign Funct3=Funct[2:0];
    assign Funct7={1'b0,Funct[4],4'b0000,Funct[3]};
    //实例化控制器
    arithmetic_controller controller1(.Funct7(Funct7),.Funct3(Funct3),.OpCode(OpCode),.ALUOP(ALUOP));
    control_signal_controller controller2(.Funct7(Funct7),.Funct3(Funct3),.OpCode(OpCode),.MemtoReg(MemtoReg),.MemWrite(MemWrite),
        .ALU_Src(ALU_Src),.RegWrite(RegWrite),.ecall(ecall),.S_Type(S_Type),.BEQ(BEQ),.BNE(BNE),
        .jal(jal),.jalr(jalr),.sltiu(sltiu),.sb(sb),.blt(blt));
endmodule