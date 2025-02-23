

//这个模块将一个Pra_Width位的数据延时Pra_Delay个周期


module Common_Delay # (
    parameter Pra_Width=1,
    parameter Pra_Delay=4)
    (
    input                       i_clk,
    
    input   [Pra_Width-1 : 0]   i_signal,
    output  [Pra_Width-1 : 0]   o_signal
    );


logic [Pra_Delay*Pra_Width-1:0] Stage_Reg=0;

always @(posedge i_clk)
begin
    Stage_Reg<={Stage_Reg[Pra_Delay*Pra_Width-Pra_Width-1:0],i_signal};
end

assign o_signal=Stage_Reg[Pra_Delay*Pra_Width-1 : Pra_Delay*Pra_Width-Pra_Width];

endmodule
