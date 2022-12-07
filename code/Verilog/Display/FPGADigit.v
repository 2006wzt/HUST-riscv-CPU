//将LedData转成数码管信号，SEG为数码管显示，AN为数码管片选信号
module FPGADigit(LedData,CLK,SEG,AN);
    input CLK;//开发板的时钟源
    input [31:0] LedData;//LedData显示的数据
    output [7:0] SEG;//7段译码信号
    output [7:0] AN;// 数码管片选信号
    
    wire CLK_N;//高频时钟信号
    wire [3:0] Led;//数码管显示数据
    wire [2:0] count;//计数器计数
   
    //实例化模块
    divider #(5000) div(.clk(CLK),.clk_N(CLK_N));//获得一个高频信号CLK_N
    counter cot(.clk(CLK_N),.out(count));//高频计数器
    decoder3_8 decoder(.num(count),.sel(AN));//获得数码管片选信号
    display_sel sel(.num(count), .dig(LedData), .code(Led));
    pattern SEG7_0(.code(Led),.patt(SEG));
endmodule