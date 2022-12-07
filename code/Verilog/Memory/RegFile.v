//¶ÁÐ´¼Ä´æÆ÷
module RegFile(Din,R1Adr,R2Adr,WAdr,WE,CLK,R1,R2);
    input [31:0] Din;
    input [4:0] WAdr,R1Adr,R2Adr;
    input WE,CLK;
    output[31:0]R1,R2;
    reg [31:0] RAM[31:0];//´æ´¢¼Ä´æÆ÷
    integer i;
    initial begin
        for(i=0;i<=31;i=i+1) begin
            RAM[i]=0;
        end
    end
    assign R1 = RAM[R1Adr];
    assign R2 = RAM[R2Adr];
    always@(posedge CLK) begin
        if (WE && WAdr!=0) RAM[WAdr] <= Din;//½øÐÐÊý¾ÝÐ´Èë
    end
endmodule