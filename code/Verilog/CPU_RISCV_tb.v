`timescale 1ns / 1ps
module CPU_RISCV_tb();
    reg CLK,RST,Go;
    wire [7:0] SEG,AN;
    wire halt,e_signal;
    wire [31:0]PC_Data,IR_Data,in_PC,LED_num,R1Data,R2Data,ALUData,rd_in,Imm_value,Imm_shift_value;
    wire [4:0]R1Addr,R2Addr,RD;
    initial begin
        CLK=0;
        RST=0;
        Go=0;
    end
    
    always #1 CLK=~CLK;
    CPU_RISCV CPU(.CLK(CLK),.Go(Go),.RST(RST),.SEG(SEG),.AN(AN),.halt(halt),
    .PC_Data(PC_Data),.IR_Data(IR_Data),.in_PC(in_PC),.LED_num(LED_num),
    .R1Data(R1Data),.R2Data(R2Data),.ALUData(ALUData),
    .R1Addr(R1Addr),.R2Addr(R2Addr),.RD(RD),.rd_in(rd_in),.Imm_value(Imm_value),.Imm_shift_value(Imm_shift_value),.e_signal(e_signal));
endmodule
    