module BRIEF_Descriptor(
    input              i_clk,

    input              i_dvp_vs,
    input              i_dvp_hs,
    input    [7:0]     i_dvp_data,

    input              i_fast_vs,
    input              i_fast_hs,
    input    [7:0]     i_fast_data,


    output             o_orb_descriptor_start,
    output             o_orb_descriptor_end,
    output             o_orb_descriptor_valid,
    output  [287:0]    o_orb_descriptor_value
    );

localparam Pra_Image_Width=8;
localparam  Pra_Position_Offset = 15;   //关键点位置偏移量

logic VS_Start;
logic VS_End;

logic [15:0] Counter_VS;
logic [15:0] Counter_HS;

//启动同步计数�?
DVP_Counter u_DVP_Counter (
    .i_clk                   ( i_clk             ),
    .i_dvp_vs                ( i_dvp_vs          ),
    .i_dvp_hs                ( i_dvp_hs          ),

    .o_vs_start              ( VS_Start          ),
    .o_vs_end                ( VS_End            ),
    .o_hs_start              (                   ),
    .o_hs_end                (                   ),
    .o_counter_vs            ( Counter_VS        ),
    .o_counter_hs            ( Counter_HS        )
);

//定义原始图像输入和滑动窗口输�?
interface_image #(.Pra_Width(Pra_Image_Width)) Interface_Image_Original_In();
interface_windows #(.Pra_Width(Pra_Image_Width)) Interface_Image_Window_31_31();

//链接同步计数�?
assign Interface_Image_Original_In.image_vs=i_dvp_vs;
assign Interface_Image_Original_In.image_hs=i_dvp_hs;
assign Interface_Image_Original_In.image_data=i_dvp_data;


//启动滑动窗口
BRIEF_WINDOW31_31_1 #(
    .Pra_Value_Width ( Pra_Image_Width ))
u_DIP_Shift_Window_31_31_Image (
    .i_clk              ( i_clk       ),
    .i_image            ( Interface_Image_Original_In   ),
    .o_window           ( Interface_Image_Window_31_31   )
);

logic [255:0] FAST_ORB_Descriptor;

//用brief算法处理滑动窗口中的数据
ORB_BRIEF u_ORB_BRIEF (
    .i_clk              ( i_clk       ),
    .i_window           ( Interface_Image_Window_31_31   ),
    .o_brief            ( FAST_ORB_Descriptor   )
);

logic FAST_Keypoint_Valid;
logic Is_FAST_Keypoint;
assign Is_FAST_Keypoint=i_fast_data!=0 ? 1 : 0;


//延时
Shift_9_Line_6_Pixel  u_Shift_9_Line_6_Pixel (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_fast_hs      ),
    .i_data                  ( Is_FAST_Keypoint    ),

    .o_data                  ( FAST_Keypoint_Valid    )
);

logic             ORB_Descriptor_Start;
logic             ORB_Descriptor_End;
logic             ORB_Descriptor_Valid;
logic  [287:0]    ORB_Descriptor_Value;


logic signed [15:0] Position_X;
logic signed [15:0] Position_Y;

assign Position_Y=Counter_VS-Pra_Position_Offset;
assign Position_X=Counter_HS-Pra_Position_Offset;

//通过状�?�机控制信号输出关键点位置与描述信息
logic [7:0] State_Index=0;
always_ff @(posedge i_clk)
begin
    case(State_Index)
    0:
    begin
        if(VS_Start)
        begin
            ORB_Descriptor_Start    <=1;
            ORB_Descriptor_End      <=0;
            ORB_Descriptor_Valid    <=0;
            ORB_Descriptor_Value    <=0;
            State_Index<=State_Index+1;
        end
        else
        begin
            ORB_Descriptor_Start    <=0;
            ORB_Descriptor_End      <=0;
            ORB_Descriptor_Valid    <=0;
            ORB_Descriptor_Value    <=0;
            State_Index<=0;
        end
    end
    1:
    begin
        if(VS_End)
        begin
            ORB_Descriptor_Start    <=0;
            ORB_Descriptor_End      <=1;
            ORB_Descriptor_Valid    <=1;
            ORB_Descriptor_Value    <=0;//assign the last value to 0
            State_Index<=0;
        end
        else if(Counter_VS>Pra_Position_Offset && Counter_HS>Pra_Position_Offset)//Mask of the frame 
        begin
            ORB_Descriptor_Start    <=0;
            ORB_Descriptor_End      <=0;
            ORB_Descriptor_Valid    <=FAST_Keypoint_Valid;
            ORB_Descriptor_Value    <={FAST_ORB_Descriptor,Position_Y,Position_X};
            State_Index<=State_Index;
        end
        else
        begin
            ORB_Descriptor_Start    <=0;
            ORB_Descriptor_End      <=0;
            ORB_Descriptor_Valid    <=0;
            ORB_Descriptor_Value    <=0;
            State_Index<=State_Index;
        end
    end
    
    default:
    begin
        ORB_Descriptor_Start    <=0;
        ORB_Descriptor_End      <=0;
        ORB_Descriptor_Valid    <=0;
        ORB_Descriptor_Value    <=0;
        State_Index<=0;
    end
    endcase
end


assign o_orb_descriptor_start=ORB_Descriptor_Start;
assign o_orb_descriptor_end=ORB_Descriptor_End;
assign o_orb_descriptor_valid=ORB_Descriptor_Valid;
assign o_orb_descriptor_value=ORB_Descriptor_Value;



endmodule
