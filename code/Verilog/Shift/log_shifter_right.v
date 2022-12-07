//Âß¼­ÓÒÒÆ
module log_shifter_right(in,out,shiftAmount);
    parameter data_WIDTH=32;
    parameter shift_WIDTH=5;
    input[data_WIDTH-1:0] in;
    input[shift_WIDTH-1:0] shiftAmount;
    output[data_WIDTH-1:0] out;
    assign out=in>>shiftAmount;
endmodule