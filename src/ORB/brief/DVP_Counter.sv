module DVP_Counter(     //定义垂直同步计数器
    input                   i_clk,
  
    input                   i_dvp_vs,
    input                   i_dvp_hs,

    output                  o_vs_start,
    output                  o_vs_end,
    output                  o_hs_start,
    output                  o_hs_end,

    output[15:0]            o_counter_vs,
    output[15:0]            o_counter_hs
    );

logic VS;
logic HS;
logic VS_Start;
logic VS_End;
logic HS_Start;
logic HS_End;

logic [15:0] Counter_VS=0;      
logic [15:0] Counter_HS=0;

assign o_vs_start=VS_Start;     //为输出赋值
assign o_vs_end=VS_End;         //同上
assign o_hs_start=HS_Start;     //同上
assign o_hs_end=HS_End;         //同上

assign o_counter_vs=Counter_VS; //同上
assign o_counter_hs=Counter_HS; //同上

assign VS_Start=i_dvp_vs & (~VS);   //检测垂直同步上升沿
assign VS_End=VS & (~i_dvp_vs);     //检测垂直同步下降沿
assign HS_Start=i_dvp_hs & (~HS);   //水平同步
assign HS_End=HS & (~i_dvp_hs);     //同上

always @(posedge i_clk)
begin
    VS<=i_dvp_vs;
    HS<=i_dvp_hs;
end


always @(posedge i_clk)
begin
    if(VS_End)
    begin
        Counter_VS<=16'd0;
    end
    else if(HS_End)
    begin
        Counter_VS<=Counter_VS+16'd1;   //垂直同步计数
    end
    else
    begin
        Counter_VS<=Counter_VS;
    end
end

always @(posedge i_clk)
begin
    if(i_dvp_vs&i_dvp_hs)
    begin
        Counter_HS<=Counter_HS+16'd1;   //水平同步计数
    end
    else
    begin
        Counter_HS<=16'd0;
    end
end


endmodule