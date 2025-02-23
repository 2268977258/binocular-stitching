
//本模块是16位的汉明距离计数器

module Count_16 (
    input            i_clk,

    input            i_ready,
    input  [15:0]    i_value,
    output           o_ready,
    output  [7:0]    o_value
    );


logic Ready=0;
logic [7:0] Sum_Result=0;


assign o_ready=Ready;

//直接将输入的判断数组各位相加
always @(posedge i_clk)
begin
    Ready<=i_ready;
    Sum_Result<=    i_value[0]+i_value[1]+i_value[2]+i_value[3]+i_value[4]+i_value[5]+i_value[6]+i_value[7]+
                    i_value[8]+i_value[9]+i_value[10]+i_value[11]+i_value[12]+i_value[13]+i_value[14]+i_value[15];
end

assign o_value=Sum_Result;

endmodule
