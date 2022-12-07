//��LedDataת��������źţ�SEGΪ�������ʾ��ANΪ�����Ƭѡ�ź�
module FPGADigit(LedData,CLK,SEG,AN);
    input CLK;//�������ʱ��Դ
    input [31:0] LedData;//LedData��ʾ������
    output [7:0] SEG;//7�������ź�
    output [7:0] AN;// �����Ƭѡ�ź�
    
    wire CLK_N;//��Ƶʱ���ź�
    wire [3:0] Led;//�������ʾ����
    wire [2:0] count;//����������
   
    //ʵ����ģ��
    divider #(5000) div(.clk(CLK),.clk_N(CLK_N));//���һ����Ƶ�ź�CLK_N
    counter cot(.clk(CLK_N),.out(count));//��Ƶ������
    decoder3_8 decoder(.num(count),.sel(AN));//��������Ƭѡ�ź�
    display_sel sel(.num(count), .dig(LedData), .code(Led));
    pattern SEG7_0(.code(Led),.patt(SEG));
endmodule