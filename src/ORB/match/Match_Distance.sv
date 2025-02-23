
//本模块计算两图描述符的汉明距离

module Match_Distance (
    input              i_clk,

	input	    	   i_value_ready,
	input	[255:0]	   i_value_0,   //图一的描述符输入
	input	[255:0]	   i_value_1,   //图二的描述符输入

    output             o_ready,
    output  [15:0]     o_value
    );

logic               ORB_Ready;
logic               ORB_Ready_Ack;

logic Value_Ready=0;


//指示描述符各位数据是否相等的判断数组，1为不相等，0为相等
logic [255:0] Value_Temp=0;

always @(posedge i_clk)
begin
	if(i_value_ready)
    begin
        Value_Temp<=i_value_0^i_value_1;    //用异或检查描述符同位上的数据是否相等
        Value_Ready<=1;
    end
	else
    begin
        Value_Temp<=0;
        Value_Ready<=0;
    end
end


//汉明距离计数器
Count_256  u_Coun_256 (
    .i_clk                   ( i_clk     ),
    .i_ready                 ( Value_Ready   ),
    .i_value                 ( Value_Temp   ),

    .o_ready                 ( o_ready   ),
    .o_value                 ( o_value   )
);



endmodule