module BinToBCD(Bin,BCD);//二进制转3个BCD码
    integer i;
    //输入输出
    input [31:0] Bin;//输入的二进制数
    output[31:0] BCD;//输出的十进制BCD码
    reg[3:0] Thousands,Hundreds,Tens,Ones;//输出的3个BCD码
    assign BCD={Thousands,Hundreds,Tens,Ones};
    always@(Bin) begin
        Thousands=4'd0;
        Hundreds=4'd0;
        Tens=4'd0;
        Ones=4'd0;
        for(i=31;i>=0;i=i-1)
        begin
            if(Thousands>=5)
                Thousands=Thousands+3;
            if(Hundreds>=5)
                Hundreds=Hundreds+3;
            if(Tens>=5)
                Tens=Tens+3;
            if(Ones>=5)
                Ones=Ones+3;
            Thousands=Thousands<<1;
            Thousands[0]=Hundreds[3];
            Hundreds=Hundreds<<1;
            Hundreds[0]=Tens[3];
            Tens=Tens<<1;
            Tens[0]=Ones[3];
            Ones=Ones<<1;
            Ones[0]=Bin[i];
        end
    end
endmodule