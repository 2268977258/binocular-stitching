

//这个模块用于寻找最小汉明距离


module Get_Min #(parameter Pra_Data_Width=16)(
    input                           i_clk,

    input                           i_start,
    input                           i_end,

    input                           i_en,
    input  [Pra_Data_Width-1:0]     i_data,
    input  [15:0]                   i_location,

    output                          o_ready,
    output  [Pra_Data_Width-1:0]    o_min_data,
    output  [15:0]                  o_min_location
    );

logic                           Result_Ready;
logic [Pra_Data_Width-1:0]      Min_Data;

logic [15:0]                    Min_Location;

assign o_ready=Result_Ready;
assign o_min_data=Min_Data;
assign o_min_location=Min_Location;

always @(posedge i_clk)
begin
    Result_Ready<=i_end;
end


localparam Pra_Init_Min_Value = 0-1;
localparam Pra_Init_Max_Value = 0;

always @(posedge i_clk)
begin
    if(i_start)
    begin
        Min_Data<=Pra_Init_Min_Value;
        Min_Location<=0;
    end
    else if(i_en)
    begin
        if(i_data<Min_Data)
        begin
            Min_Data<=i_data;
            Min_Location<=i_location;
        end
        else
        begin
            Min_Data<=Min_Data;
            Min_Location<=Min_Location;
        end
    end
    else
    begin
        Min_Data<=Min_Data;
        Min_Location<=Min_Location;
    end
end



endmodule
