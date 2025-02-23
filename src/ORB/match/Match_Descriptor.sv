module Match_Descriptor (
    input              i_clk,

    input              i_orb_0_ready,       //buffer存完一张图的所有特征点
    output             o_orb_0_ready_ack,   //match发出握手可以接受
    input    [15:0]    i_orb_0_valid_length,    //buffer内的特征点数量

    output             o_orb_0_brief_en,//match发给buffer的读使能
    output   [15:0]    o_orb_0_brief_address,//match发给buffer的读地址
    input    [255:0]   i_orb_0_brief_data,  //读出的数据

    output             o_orb_0_location_en,//类似的，坐标
    output   [15:0]    o_orb_0_location_address,
    input    [31:0]    i_orb_0_location_data,   

    input              i_orb_1_ready,       
    output             o_orb_1_ready_ack,   
    input    [15:0]    i_orb_1_valid_length,    

    output             o_orb_1_brief_en,
    output   [15:0]    o_orb_1_brief_address,
    input    [255:0]   i_orb_1_brief_data, 

    output             o_orb_1_location_en,
    output   [15:0]    o_orb_1_location_address,
    input    [31:0]    i_orb_1_location_data,   

    output             o_match_start,       //
    output             o_match_end,
    output             o_match_location_en,
    output   [31:0]    o_match_location_0,
    output   [31:0]    o_match_location_1
    );



wire [2:0] diff_Y;

assign diff_Y = o_match_location_1[31:16] - o_match_location_0[31:16];



logic               ORB_Ready=0;
logic               ORB_Ready_Ack=0;
logic [15:0]        ORB_Left_Valid_Length=0;
logic [15:0]        ORB_Right_Valid_Length=0;

//握手
assign o_orb_0_ready_ack=ORB_Ready_Ack;     
assign o_orb_1_ready_ack=ORB_Ready_Ack;



/********************************************************************************************************
    当图一与图二都可以接收时，用内部变量接收描述符有效长度，并为匹配算法使能ORB_Ready赋高电平，否则各变量不变
********************************************************************************************************/
always @(posedge i_clk)
begin
    if(i_orb_0_ready&i_orb_1_ready)//两张buffer都准备好
    begin
        ORB_Ready<=1;
        ORB_Ready_Ack<=1;
        ORB_Left_Valid_Length<=i_orb_0_valid_length;//左图特征点数量
        ORB_Right_Valid_Length<=i_orb_1_valid_length;//右图特征点数量
    end
    else
    begin
        ORB_Ready<=0;
        ORB_Ready_Ack<=0;
        ORB_Left_Valid_Length<=ORB_Left_Valid_Length;
        ORB_Right_Valid_Length<=ORB_Right_Valid_Length;
    end
end


//定义并声明了一个枚举类型用于构建状态机
typedef enum {
    Pra_Match_Idle,
    Pra_Match_Ready,
    Pra_Match_Left_Increase,
    Pra_Match_Right_Increase,
    Pra_Match_Right_Done,
    Pra_Match_All_Done
} Pra_State;        

Pra_State State_Match=Pra_Match_Idle;



logic [31:0] Counter_Match_Left=0;  //左图坐标
logic [31:0] Counter_Match_Right=0; //右图坐标


//读使能的控制信号状态机
always @(posedge i_clk)
begin
    if(ORB_Ready)//两张buffer都准备好，重置
    begin
        State_Match<=Pra_Match_Ready;
        Counter_Match_Left<=32'd0;
        Counter_Match_Right<=32'd0;
    end
    else
    begin
        case(State_Match)
        Pra_Match_Idle://同上，状态机内的重置
                begin
                    if(ORB_Ready)
                    begin
                        State_Match<=Pra_Match_Ready;
                        Counter_Match_Left<=32'd0;
                        Counter_Match_Right<=32'd0;
                    end
                    else
                    begin
                        State_Match<=Pra_Match_Idle;
                        Counter_Match_Left<=32'd0;
                        Counter_Match_Right<=32'd0;
                    end
                end
        Pra_Match_Ready://过渡态
                begin
                    State_Match<=Pra_Match_Left_Increase;       //计算左图坐标
                    Counter_Match_Left<=32'd0;
                    Counter_Match_Right<=32'd0;
                end
        Pra_Match_Left_Increase://计数左图的第i个特征点，每个左图的点，与右图每个特征点匹配
                begin
                    if(Counter_Match_Left>=ORB_Left_Valid_Length-32'd1)//左图匹配完，说明整张图匹配结束
                    begin
                        State_Match<=Pra_Match_All_Done;        //
                        Counter_Match_Left<=32'd0;
                        Counter_Match_Right<=32'd0;
                    end
                    else
                    begin
                        State_Match<=Pra_Match_Right_Increase;  
                        Counter_Match_Left<=Counter_Match_Left+32'd1;
                        Counter_Match_Right<=32'd0;
                    end
                end 
        Pra_Match_Right_Increase://遍历右图所有特征点
                begin
                    if(Counter_Match_Right>=ORB_Right_Valid_Length-32'd1)
                    begin
                        State_Match<=Pra_Match_Right_Done;      
                        Counter_Match_Right<=32'd0;
                    end
                    else
                    begin
                        State_Match<=Pra_Match_Right_Increase;  
                        Counter_Match_Right<=Counter_Match_Right+32'd1;
                    end
                    Counter_Match_Left<=Counter_Match_Left;
                end
        Pra_Match_Right_Done://右图遍历结束，算左图下一个特征点
                begin
                    State_Match<=Pra_Match_Left_Increase;       //横坐标完成态无条件返回纵坐标递增态
                    Counter_Match_Left<=Counter_Match_Left;
                end
        Pra_Match_All_Done://匹配完
                begin
                    State_Match<=Pra_Match_Idle;                //完成态
                    Counter_Match_Left<=32'd0;
                    Counter_Match_Right<=32'd0;
                end
                default:
                begin
                    State_Match<=Pra_Match_Idle;
                    Counter_Match_Left<=32'd0;
                    Counter_Match_Right<=32'd0;
                end
        endcase
    end
end


logic               ORB_Left_Read_En;
logic [15:0]        ORB_Left_Read_Address=0;
logic               ORB_Right_Read_En;
logic [15:0]        ORB_Right_Read_Address=0;

//根据状态机的读需求，分配输出的RAM读控制信号
assign ORB_Left_Read_En=State_Match==Pra_Match_Left_Increase ? 1 : 0;
assign ORB_Right_Read_En=State_Match==Pra_Match_Right_Increase ? 1 : 0;

assign o_orb_0_brief_en=ORB_Left_Read_En;
assign o_orb_1_brief_en=ORB_Right_Read_En;

assign o_orb_0_brief_address=ORB_Left_Read_Address;
assign o_orb_1_brief_address=ORB_Right_Read_Address;

//根据读使能信号，获得读地址
always @(posedge i_clk)
begin
    if(State_Match==Pra_Match_Idle)
    begin
        ORB_Left_Read_Address<=0;
    end
    else if(ORB_Left_Read_En)
    begin
        ORB_Left_Read_Address<=ORB_Left_Read_Address+1;     //描述符纵坐标索引增加时，地址纵坐标也加一
    end
    else if(ORB_Right_Read_En)
    begin
        ORB_Right_Read_Address<=ORB_Right_Read_Address+1;   //描述符横坐标索引增加时，地址横坐标也加一
    end
    else if(State_Match==Pra_Match_Right_Done)
    begin
        ORB_Left_Read_Address<=ORB_Left_Read_Address;
        ORB_Right_Read_Address<=0;      //地址横坐标索引超过最大值时，地址横坐标清零
    end
    else
    begin
        ORB_Left_Read_Address<=ORB_Left_Read_Address;
        ORB_Right_Read_Address<=ORB_Right_Read_Address;
    end
end


//由于是对于每个左图的特征点，遍历每个右图的特征点，因此基本的匹配单位是右图读使能
logic   ORB_BRIEF_Valid=0;

always @(posedge i_clk)
begin
    if(ORB_Right_Read_En)
    begin
        ORB_BRIEF_Valid<=1;
    end
    else
    begin
        ORB_BRIEF_Valid<=0;
    end
end


/*****************
    计算汉明距离
*****************/
logic           Match_BRIEF_Valid;
logic [15:0]    Match_BRIEF_Distance;

Match_Distance  u_Match_Distance (
    .i_clk                   ( i_clk           ),
    .i_value_ready           ( ORB_BRIEF_Valid   ),
    .i_value_0               ( i_orb_0_brief_data       ),
    .i_value_1               ( i_orb_1_brief_data       ),

    .o_ready                 ( Match_BRIEF_Valid      ),
    .o_value                 ( Match_BRIEF_Distance      )
);



//延迟三个周期
logic [15:0]    Match_BRIEF_Location_Temp_0=0;
logic [15:0]    Match_BRIEF_Location_Temp_1=0;
logic [15:0]    Match_BRIEF_Location_Temp_2=0;
logic [15:0]    Match_BRIEF_Location=0;
always @(posedge i_clk)
begin
    Match_BRIEF_Location_Temp_0<=ORB_Right_Read_Address;
    Match_BRIEF_Location_Temp_1<=Match_BRIEF_Location_Temp_0;
    Match_BRIEF_Location_Temp_2<=Match_BRIEF_Location_Temp_1;
    Match_BRIEF_Location<=Match_BRIEF_Location_Temp_2;
end



logic Get_Min_Max_Start_Temp,Get_Min_Max_End_Temp;
logic Get_Min_Max_Start,Get_Min_Max_End;

//地址纵坐标索引增加时，开始寻找这一行描述符的最小汉明距离
assign Get_Min_Max_Start_Temp=ORB_Left_Read_En;
//地址横坐标索引超过最大值时，结束寻找最小汉明距离
assign Get_Min_Max_End_Temp=State_Match==Pra_Match_Right_Done ? 1 : 0;



//将一个Pra_Width位的数据延时Pra_Delay个周期
Common_Delay #(.Pra_Width ( 1 ),.Pra_Delay ( 4 ))u_Common_Delay_Start (
    .i_clk                   ( i_clk      ),
    .i_signal                ( Get_Min_Max_Start_Temp   ),
    .o_signal                ( Get_Min_Max_Start   ));
Common_Delay #(.Pra_Width ( 1 ),.Pra_Delay ( 4 ))u_Common_Delay_End (
    .i_clk                   ( i_clk      ),
    .i_signal                ( Get_Min_Max_End_Temp   ),
    .o_signal                ( Get_Min_Max_End   ));



//寻找最小汉明距离
logic           Match_BRIEF_Min_Max_Ready;
logic [15:0]    Match_BRIEF_Min_Distance;
logic [15:0]    Match_BRIEF_Max_Distance;
logic [15:0]    Match_BRIEF_Min_Location;
logic [15:0]    Match_BRIEF_Max_Location;

Get_Min #(.Pra_Data_Width ( 16 ))u_Get_Min (
    .i_clk                   ( i_clk        ),

    .i_start                 ( Get_Min_Max_Start      ),
    .i_end                   ( Get_Min_Max_End        ),

    .i_en                    ( Match_BRIEF_Valid     ),
    .i_data                  ( Match_BRIEF_Distance     ),
    .i_location              ( Match_BRIEF_Location       ),

    .o_ready                 ( Match_BRIEF_Min_Max_Ready          ),
    .o_min_data              ( Match_BRIEF_Min_Distance       ),        //最小值
    .o_min_location          ( Match_BRIEF_Min_Location   )             //最小值地址
);



//纵坐标索引增加时，将纵坐标索引的数值同步到本地变量
logic [15:0]    Match_BRIEF_Reference_Location_Temp=0;

always @(posedge i_clk)
begin
    if(Get_Min_Max_Start_Temp)
    begin
        Match_BRIEF_Reference_Location_Temp<=ORB_Left_Read_Address;
    end
    else
    begin
        Match_BRIEF_Reference_Location_Temp<=Match_BRIEF_Reference_Location_Temp;
    end
end



//设置一个延时四个时钟周期的的延时链
logic [15:0]    Match_BRIEF_Reference_Location_Delay_0=0;
logic [15:0]    Match_BRIEF_Reference_Location_Delay_1=0;
logic [15:0]    Match_BRIEF_Reference_Location_Delay_2=0;
logic [15:0]    Match_BRIEF_Reference_Location_Delay_3=0;

always @(posedge i_clk)
begin
    Match_BRIEF_Reference_Location_Delay_0<=Match_BRIEF_Reference_Location_Temp;
    Match_BRIEF_Reference_Location_Delay_1<=Match_BRIEF_Reference_Location_Delay_0;
    Match_BRIEF_Reference_Location_Delay_2<=Match_BRIEF_Reference_Location_Delay_1;
    Match_BRIEF_Reference_Location_Delay_3<=Match_BRIEF_Reference_Location_Delay_2;
end



//得到汉明距离最小的描述符后，将其地址的横纵坐标记录到本地变量
logic           Match_BRIEF_Location_Read_En=0;
logic [15:0]    Match_BRIEF_Location_Read_Address_Left=0;
logic [15:0]    Match_BRIEF_Location_Read_Address_Right=0;

always @(posedge i_clk)
begin
    if(Match_BRIEF_Min_Max_Ready)
    begin
        Match_BRIEF_Location_Read_En<=1;
        Match_BRIEF_Location_Read_Address_Left<=Match_BRIEF_Reference_Location_Delay_3;//这个地址有滞后，需要处理
        Match_BRIEF_Location_Read_Address_Right<=Match_BRIEF_Min_Location;
    end
    else
    begin
        Match_BRIEF_Location_Read_En<=0;
        Match_BRIEF_Location_Read_Address_Left<=0;
        Match_BRIEF_Location_Read_Address_Right<=0;
    end
end



//配置输出数据
logic       Match_BRIEF_Best_Match_Location_Ready=0;
logic       Match_Start=0;

assign o_orb_0_location_en=Match_BRIEF_Location_Read_En;
assign o_orb_1_location_en=Match_BRIEF_Location_Read_En;
assign o_orb_0_location_address=Match_BRIEF_Location_Read_Address_Left;
assign o_orb_1_location_address=Match_BRIEF_Location_Read_Address_Right;

always @(posedge i_clk)
begin
    Match_BRIEF_Best_Match_Location_Ready<=Match_BRIEF_Location_Read_En;
end

assign o_match_location_en= diff_Y < 3'b111 ? Match_BRIEF_Best_Match_Location_Ready : 0;
assign o_match_location_0=i_orb_0_location_data;
assign o_match_location_1=i_orb_1_location_data;

assign o_match_start=Match_Start;
always @(posedge i_clk)
begin
    if(State_Match==Pra_Match_Ready)
    begin
        Match_Start<=1;
    end
    else
    begin
        Match_Start<=0;
    end
end
//配置输出数据



//最后设置一个状态机，验证匹配是否完成
localparam int Pra_IDLE                 = 0;
localparam int Pra_Match_State_Done     = 1;
localparam int Pra_Match_Valid_Done     = 2;
localparam int Pra_Match_Finish         = 3;

logic[3:0] State_I=Pra_IDLE;

logic Match_End=0;
assign o_match_end=Match_End;

always @(posedge i_clk)
begin
    if(State_I==Pra_IDLE)
    begin
        if(State_Match==Pra_Match_All_Done)
        begin
            State_I<=Pra_Match_State_Done;
            Match_End<=0;
        end
        else
        begin
            State_I<=Pra_IDLE;
            Match_End<=0;
        end
    end
    else if(State_I==Pra_Match_State_Done)
    begin
        if(Match_BRIEF_Best_Match_Location_Ready)
        begin
            State_I<=Pra_Match_Valid_Done;
            Match_End<=0;
        end
        else
        begin
            State_I<=Pra_Match_State_Done;
            Match_End<=0;
        end
    end
    else if(State_I==Pra_Match_Valid_Done)
    begin
        State_I<=Pra_Match_Finish;
        Match_End<=1;
    end
    else
    begin
        State_I<=Pra_IDLE;
        Match_End<=0;
    end
end

endmodule
