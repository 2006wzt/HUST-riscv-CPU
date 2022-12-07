//������RISCV CPU
module CPU_RISCV(CLK,CLK_Sel,Display_Sel,Go,RST,SEG,AN,halt);

    //�������
    input CLK;//�������ϵ�ʱ��Դ100MHz
    input Go;//����ͣ�����ź�
    input RST;//��λ�ź�
    input [1:0] CLK_Sel,Display_Sel;//ʱ������ʾģʽ��ѡ��
    //CLK_Sel:00-1Hz,01-10Hz,10-50Hz,11-100Hz
    //Display_Sel:00-LedData,01-PCData,10-IRData,11-������
    output [7:0] SEG;//��������
    output [7:0] AN;//�����Ƭѡ
    output halt;//ͣ���ź�
//    output [31:0] PC_Data,IR_Data;
//    output [31:0] in_PC,LED_num,R1Data,R2Data,ALUData,rd_in,Imm_value,Imm_shift_value;
//    output [4:0] R1Addr,R2Addr,RD;
//    output e_signal;
    
    //��Ҫ��·
    wire [31:0] PC_in,PC_out,PC_add_4,IR;
    wire CLK_N,PC_en,CLK_1,CLK_2,CLK_3,CLK_4;
    wire [4:0] Funct,OpCode;//����Ӳ���߿������е��ź�
    wire MemtoReg,MemWrite,ALU_Src,RegWrite,ecall,S_Type,BEQ,BNE,jal,jalr,sltiu,sb,blt;//Ӳ���߿���������ź�
    wire [3:0] ALUOP;//�����ź�
    wire [4:0] rs1,rs2,rd,R1Adr,R2Adr;//�ź��н�������R1��R2��ַ��д���ַrd
    wire [31:0] RDin,R1,R2;//RegFile�����������
    wire [11:0] Imm_I,Imm_S,Imm_B;//I,S,B��ָ��������
    wire [19:0] Imm_J;//J��ָ��������
    wire [31:0] Imm_I_ex,Imm_S_ex,Imm_B_ex,Imm_J_ex,Imm;//��չ���������
    wire [1:0] Imm_Sel;//������ѡ���ź�
    wire B_signal,S_signal,J_signal,Jalr_signal;//ָ���ź�
    wire [31:0] X,Y;//����ALU������
    wire [31:0] Result1,Result2;//ALU������
    wire greater_equal,lesser,equal;//ALU����ź�
    wire Branch;//��ת�ź�
    wire [31:0] MEMout,MEMData;//���ݼĴ�������Ͷ�·ѡ�������
    wire RDin_Sel;//�õ�RDin��ѡ���ź�
    wire [31:0] Imm_shift,Branch_Adr,PC_Adr;//����������1λ�������֧��ת��ַ,��һ����·ѡ���������PC��ַ
    wire Ledout;//ͣ���źź�LedData����ź�
    wire [31:0] LedData,LED_Show;//���������ź�
    wire [31:0] sltiuData,Imm_I_value,MemData1,MemData2;//sltiu������չ���
    wire [3:0] MemSel,Sel1;
    wire [1:0] BitSel;
    wire [4:0] Sel2;
    wire [31:0] PeriodNum,BCD;
    
    //�߼�ʵ��
    assign PC_en=Go|(~halt);//����PCʹ���ź�
    assign PC_add_4=PC_out+4;//����PC+4
    //����Ӳ���߿������е��ź�
    assign Funct={IR[30],IR[25],IR[14:12]};
    assign OpCode=IR[6:2];
    //����Reg File�е��ź�
    assign rs1=IR[19:15];
    assign rs2=IR[24:20];
    assign rd=IR[11:7];
    //I,S,B,J��ָ��������
    assign Imm_I=IR[31:20];
    assign Imm_S={IR[31:25],IR[11:7]};
    assign Imm_B={IR[31],IR[7],IR[30:25],IR[11:8]};
    assign Imm_J={IR[31],IR[19:12],IR[20],IR[30:21]};
    //����ָ�������ź�
    assign B_signal=BEQ||BNE||blt;
    assign S_signal=S_Type;
    assign J_signal=jal;
    assign Jalr_signal=jalr;
    assign Imm_Sel={~S_signal&&(B_signal||J_signal),~B_signal&&(J_signal||S_signal)};
    //����ALU������
    assign X=R1;
    //��֧��ת�ź�
    assign Branch=(BEQ&&equal)||(BNE&&~equal)||(blt&&lesser);
    //����RDin�Ķ�·ѡ���ź�
    assign RDin_Sel=J_signal||Jalr_signal;
    //���ɷ�֧��ת��ַ
    assign Branch_Adr=PC_out+Imm_shift;
    //����ͣ���źź�LedData����ź�
    assign halt=ecall&&(~(R1==32'h00000022));
    assign Ledout=ecall&&(R1==32'h00000022);
    //sbָ���߼�����
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
    
    //ʵ����ģ��
    divider #(50000000) divider1(.clk(CLK),.clk_N(CLK_1));//����1Hz��ʱ���ź�
    divider #(5000000)  divider2(.clk(CLK),.clk_N(CLK_2));//����10Hz��ʱ���ź�
    divider #(1000000)  divider3(.clk(CLK),.clk_N(CLK_3));//����50Hz��ʱ���ź�
    divider #(500000)  divider4(.clk(CLK),.clk_N(CLK_4));//����100Hz��ʱ���ź�
    mux4 #(1) mux4_2(.out(CLK_N),.in0(CLK_1), .in1(CLK_2), .in2(CLK_3), .in3(CLK_4), .sel(CLK_Sel));//4·��·ѡ����
    
    counter_32 counter1(.clk(CLK_N), .out(PeriodNum),.halt(halt),.RST(RST));
    BinToBCD BinaryToBCD(.Bin(PeriodNum),.BCD(BCD));
    mux4 #(32) mux4_3(.out(LED_Show),.in0(LedData), .in1(PC_out), .in2(IR), .in3(BCD), .sel(Display_Sel));//4·��·ѡ����
    
    register #(32) PC(.CLK(CLK_N),.RST(RST),.EN(PC_en),.Din(PC_in),.Dout(PC_out));//PC�Ĵ���
    ROM IR_register(.Addr(PC_out[11:2]),.Dout(IR));//ָ��Ĵ���
    hard_wire_controller controller(.Funct(Funct),.OpCode(OpCode),.ALUOP(ALUOP),.MemtoReg(MemtoReg),.MemWrite(MemWrite),
        .ALU_Src(ALU_Src),.RegWrite(RegWrite),.ecall(ecall),.S_Type(S_Type),.BEQ(BEQ),.BNE(BNE),
        .jal(jal),.jalr(jalr),.sltiu(sltiu),.sb(sb),.blt(blt));//Ӳ���߿�����
    mux2 #(5) mux2_1(.out(R1Adr),.in0(rs1),.in1(5'b10001),.sel(ecall));//��·ѡ����1
    mux2 #(5) mux2_2(.out(R2Adr),.in0(rs2),.in1(5'b01010),.sel(ecall));//��·ѡ����2
    RegFile Regfile(.Din(RDin),.R1Adr(R1Adr),.R2Adr(R2Adr),.WAdr(rd),.WE(RegWrite),.CLK(CLK_N),.R1(R1),.R2(R2));//���ݼĴ���
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex1(.in(Imm_I),.out(Imm_I_ex));//����λ��չ��
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex2(.in(Imm_S),.out(Imm_S_ex));
    extender_sign #(.in_WIDTH(12),.out_WIDTH(32)) ex3(.in(Imm_B),.out(Imm_B_ex));
    extender_sign #(.in_WIDTH(20),.out_WIDTH(32)) ex4(.in(Imm_J),.out(Imm_J_ex));
    mux4 #(32) mux4_1(.out(Imm),.in0(Imm_I_value), .in1(Imm_S_ex), .in2(Imm_B_ex), .in3(Imm_J_ex), .sel(Imm_Sel));//4·��·ѡ����
    mux2 #(32) mux2_3(.out(Y),.in0(R2),.in1(Imm),.sel(ALU_Src));//��·ѡ����3
    ALU ALU(.X(X),.Y(Y),.ALUOP(ALUOP),.Result1(Result1),.Result2(Result2),.greater_equal(greater_equal),.lesser(lesser),.equal(equal));//������
    MEM Mem(.Addr(Result1[11:2]),.Din(MemData2),.CLK(CLK_N),.MemWrite(MemWrite),.sel(MemSel),.Dout(MEMout));//���ݴ洢��
    mux2 #(32) mux2_4(.out(MEMData),.in0(Result1),.in1(MEMout),.sel(MemtoReg));//��·ѡ����4
    mux2 #(32) mux2_5(.out(RDin),.in0(MEMData),.in1(PC_add_4),.sel(RDin_Sel));//��·ѡ����5
    log_shifter_left #(.data_WIDTH(32),.shift_WIDTH(5)) shifter(.in(Imm),.out(Imm_shift),.shiftAmount(5'b00001));//�߼�����
    mux2 #(32) mux2_6(.out(PC_Adr), .in0(PC_add_4),.in1(Branch_Adr),.sel(Branch||J_signal));//��·ѡ����6
    mux2 #(32) mux2_7(.out(PC_in), .in0(PC_Adr), .in1(Result1), .sel(Jalr_signal));//��·ѡ����7
    register #(32) LED(.CLK(CLK_N),.RST(RST),.EN(Ledout),.Din(R2),.Dout(LedData));//LedData�Ĵ���
    FPGADigit FPGADigit(.LedData(LED_Show),.CLK(CLK),.SEG(SEG),.AN(AN));//�������Ϣ����
    
    //CCAB���
    //sltiu
    extender_0 #(.in_WIDTH(12),.out_WIDTH(32)) ex5(.in(Imm_I),.out(sltiuData));
    mux2 #(32) mux2_8(.out(Imm_I_value), .in0(Imm_I_ex), .in1(sltiuData), .sel(sltiu));//��·ѡ����8
    //sb
    decoder2_4 decoder2(.in(BitSel),.out(Sel1));
    mux2 #(4) mux2_9(.out(MemSel), .in0(4'b1111), .in1(Sel1), .sel(sb));//��·ѡ����9
    extender_0 #(.in_WIDTH(2),.out_WIDTH(5)) ex6(.in(BitSel),.out(Sel2));
    log_shifter_left #(.data_WIDTH(32),.shift_WIDTH(5)) shifter2(.in(R2),.out(MemData1),.shiftAmount(Sel2*8));//�߼�����
    mux2 #(32) mux2_10(.out(MemData2), .in0(R2), .in1(MemData1), .sel(sb));//��·ѡ����10

    
endmodule