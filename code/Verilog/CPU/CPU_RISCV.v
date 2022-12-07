//单周期RISCV CPU
module CPU_RISCV(CLK,CLK_Sel,Display_Sel,Go,RST,SEG,AN,halt);

    //输入输出
    input CLK;//开发板上的时钟源100MHz
    input Go;//处理停机的信号
    input RST;//复位信号
    input [1:0] CLK_Sel,Display_Sel;//时钟与显示模式的选择
    //CLK_Sel:00-1Hz,01-10Hz,10-50Hz,11-100Hz
    //Display_Sel:00-LedData,01-PCData,10-IRData,11-周期数
    output [7:0] SEG;//数码管输出
    output [7:0] AN;//数码管片选
    output halt;//停机信号
//    output [31:0] PC_Data,IR_Data;
//    output [31:0] in_PC,LED_num,R1Data,R2Data,ALUData,rd_in,Imm_value,Imm_shift_value;
//    output [4:0] R1Addr,R2Addr,RD;
//    output e_signal;
    
    //必要线路
    wire [31:0] PC_in,PC_out,PC_add_4,IR;
    wire CLK_N,PC_en,CLK_1,CLK_2,CLK_3,CLK_4;
    wire [4:0] Funct,OpCode;//输入硬布线控制器中的信号
    wire MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt;//硬布线控制器输出信号
    wire [3:0] ALUOP;//运算信号
    wire [4:0] rs1,rs2,rd,R1Adr,R2Adr;//信号中解析出的R1，R2地址和写入地址rd
    wire [31:0] RDin,R1,R2;//RegFile输入输出数据
    wire [11:0] Imm_I,Imm_S,Imm_B;//I,S,B型指令立即数
    wire [19:0] Imm_J;//J型指令立即数
    wire [31:0] Imm_I_ex,Imm_S_ex,Imm_B_ex,Imm_J_ex,Imm;//扩展后的立即数
    wire [1:0] Imm_Sel;//立即数选择信号
    wire B_signal,S_signal,J_signal,Jalr_signal;//指令信号
    wire [31:0] X,Y;//输入ALU的数据
    wire [31:0] Result1,Result2;//ALU计算结果
    wire greater_equal,lesser,equal;//ALU输出信号
    wire Branch;//跳转信号
    wire [31:0] MEMout,MEMData;//数据寄存器输出和多路选择器输出
    wire RDin_Sel;//得到RDin的选择信号
    wire [31:0] Imm_shift,Branch_Adr,PC_Adr;//立即数左移1位结果，分支跳转地址,第一个多路选择器输出的PC地址
    wire Ledout;//停机信号和LedData输出信号
    wire [31:0] LedData,LED_Show;//数码管输出信号
    wire [31:0] sltiuData,Imm_I_value,MemData1,MemData2;//sltiu的零扩展结果
    wire [3:0] MemSel,Sel1;
    wire [1:0] BitSel;
    wire [4:0] Sel2;
    wire [31:0] PeriodNum,BCD;
    
    //逻辑实现
    assign PC_en=Go|(~halt);//生成PC使能信号
    assign PC_add_4=PC_out+4;//生成PC+4
    //输入硬布线控制器中的信号
    assign Funct={IR[30],IR[25],IR[14:12]};
    assign OpCode=IR[6:2];
    //输入Reg File中的信号
    assign rs1=IR[19:15];
    assign rs2=IR[24:20];
    assign rd=IR[11:7];
    //I,S,B,J型指令立即数
    assign Imm_I=IR[31:20];
    assign Imm_S={IR[31:25],IR[11:7]};
    assign Imm_B={IR[31],IR[7],IR[30:25],IR[11:8]};
    assign Imm_J={IR[31],IR[19:12],IR[20],IR[30:21]};
    //生成指令类型信号
    assign B_signal=BEQ||BNE||blt;
    assign S_signal=S_Type;
    assign J_signal=jal;
    assign Jalr_signal=jalr;
    assign Imm_Sel={~S_signal&&(B_signal||J_signal),~B_signal&&(J_signal||S_signal)};
    //输入ALU的数据
    assign X=R1;
    //分支跳转信号
    assign Branch=(BEQ&&equal)||(BNE&&~equal)||(blt&&lesser);
    //生成RDin的多路选择信号
    assign RDin_Sel=J_signal||Jalr_signal;
    //生成分支跳转地址
    assign Branch_Adr=PC_out+Imm_shift;
    //生成停机信号和LedData输出信号
    assign halt=ecall&&(~(R1==32'h00000022));
    assign Ledout=ecall&&(R1==32'h00000022);
    //sb指令逻辑运算
    assign BitSel=Result1[1:0];
    
//    assign PC_Data=PC_out;
//    assign IR_Data=IR;
//    assign in_PC=PC_in;
//    assign LED_num=LedData;
//    assign R1Data=R1;
//    assign R2Data=R2;
//    assign ALUData=Result1;
//    assign R1Addr=R1Adr;
//    assign R2Addr=R2Adr;
//    assign RD=rd;
//    assign rd_in=RDin;
//    assign Imm_value=Imm;
//    assign Imm_shift_value=PC_Adr;
//    assign e_signal=equal;
    
    //实例化模块
    divider #(50000000) divider1(.clk(CLK),.clk_N(CLK_1));//生成1Hz的时钟信号
    divider #(5000000)  divider2(.clk(CLK),.clk_N(CLK_2));//生成10Hz的时钟信号
    divider #(1000000)  divider3(.clk(CLK),.clk_N(CLK_3));//生成50Hz的时钟信号
    divider #(500000)  divider4(.clk(CLK),.clk_N(CLK_4));//生成100Hz的时钟信号
    mux4 #(1) mux4_2(.out(CLK_N),.in0(CLK_1), .in1(CLK_2), .in2(CLK_3), .in3(CLK_4), .sel(CLK_Sel));//4路多路选择器
    
    counter_32 counter1(.clk(CLK_N), .out(PeriodNum),.halt(halt),.RST(RST));
    BinToBCD BinaryToBCD(.Bin(PeriodNum),.BCD(BCD));
    mux4 #(32) mux4_3(.out(LED_Show),.in0(LedData), .in1(PC_out), .in2(IR), .in3(BCD), .sel(Display_Sel));//4路多路选择器
    
    register #(32) PC(.CLK(CLK_N),.RST(RST),.EN(PC_en),.Din(PC_in),.Dout(PC_out));//PC寄存器
    ROM IR_register(.Addr(PC_out[11:2]),.Dout(IR));//指令寄存器
    hard_wire_controller controller(.Funct(Funct),.OpCode(OpCode),.ALUOP(ALUOP),.MemtoReg(MemtoReg),.MemWrite(MemWrite),
        .ALU_Src(ALU_Src),.RegWrite(RegWrite),.ecall(ecall),.S_Type(S_Type),.BEQ(BEQ),.BNE(BNE),
        .jal(jal),.jalr(jalr),.sltiu(sltiu),.sb(sb),.blt(blt));//硬布线控制器
    mux2 #(5) mux2_1(.out(R1Adr),.in0(rs1),.in1(5'b10001),.sel(ecall));//二路选择器1
    mux2 #(5) mux2_2(.out(R2Adr),.in0(rs2),.in1(5'b01010),.sel(ecall));//二路选择器2
    RegFile Regfile(.Din(RDin),.R1Adr(R1Adr),.R2Adr(R2Adr),.WAdr(rd),.WE(RegWrite),.CLK(CLK_N),.R1(R1),.R2(R2));//数据寄存器
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex1(.in(Imm_I),.out(Imm_I_ex));//符号位扩展器
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex2(.in(Imm_S),.out(Imm_S_ex));
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex3(.in(Imm_B),.out(Imm_B_ex));
    extender_sign #(.in_WIDTH(20),.out_WIDTH(32)) ex4(.in(Imm_J),.out(Imm_J_ex));
    mux4 #(32) mux4_1(.out(Imm),.in0(Imm_I_value), .in1(Imm_S_ex), .in2(Imm_B_ex), .in3(Imm_J_ex), .sel(Imm_Sel));//4路多路选择器
    mux2 #(32) mux2_3(.out(Y),.in0(R2),.in1(Imm),.sel(ALU_Src));//二路选择器3
    ALU ALU(.X(X),.Y(Y),.ALUOP(ALUOP),.Result1(Result1),.Result2(Result2),.greater_equal(greater_equal),.lesser(lesser),.equal(equal));//运算器
    MEM Mem(.Addr(Result1[11:2]),.Din(MemData2),.CLK(CLK_N),.MemWrite(MemWrite),.sel(MemSel),.Dout(MEMout));//数据存储器
    mux2 #(32) mux2_4(.out(MEMData),.in0(Result1),.in1(MEMout),.sel(MemtoReg));//二路选择器4
    mux2 #(32) mux2_5(.out(RDin),.in0(MEMData),.in1(PC_add_4),.sel(RDin_Sel));//二路选择器5
    log_shifter_left #(.data_WIDTH(32),.shift_WIDTH(5)) shifter(.in(Imm),.out(Imm_shift),.shiftAmount(5'b00001));//逻辑左移
    mux2 #(32) mux2_6(.out(PC_Adr), .in0(PC_add_4),.in1(Branch_Adr),.sel(Branch||J_signal));//二路选择器6
    mux2 #(32) mux2_7(.out(PC_in), .in0(PC_Adr), .in1(Result1), .sel(Jalr_signal));//二路选择器7
    register #(32) LED(.CLK(CLK_N),.RST(RST),.EN(Ledout),.Din(R2),.Dout(LedData));//LedData寄存器
    FPGADigit FPGADigit(.LedData(LED_Show),.CLK(CLK),.SEG(SEG),.AN(AN));//数码管信息产生
    
    //CCAB添加
    //sltiu
    extender_0 #(.in_WIDTH(12),.out_WIDTH(32)) ex5(.in(Imm_I),.out(sltiuData));
    mux2 #(32) mux2_8(.out(Imm_I_value), .in0(Imm_I_ex), .in1(sltiuData), .sel(sltiu));//二路选择器8
    //sb
    decoder2_4 decoder2(.in(BitSel),.out(Sel1));
    mux2 #(4) mux2_9(.out(MemSel), .in0(4'b1111), .in1(Sel1), .sel(sb));//二路选择器9
    extender_0 #(.in_WIDTH(2),.out_WIDTH(5)) ex6(.in(BitSel),.out(Sel2));
    log_shifter_left #(.data_WIDTH(32),.shift_WIDTH(5)) shifter2(.in(R2),.out(MemData1),.shiftAmount(Sel2*8));//逻辑左移
    mux2 #(32) mux2_10(.out(MemData2), .in0(R2), .in1(MemData1), .sel(sb));//二路选择器10

    
endmodule