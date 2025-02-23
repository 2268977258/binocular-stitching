/************************************************************************************
 Company:           
 Author:            han
 Author Email:      sciencefuture@163.com
 Create Date:       2023-05-18
 Module Name:       
 HDL Type:        Verilog HDL
 Description: 

 Additional Comments: 

************************************************************************************/

module FAST_Top(
    input              i_clk,

    input              i_dvp_vs,
    input              i_dvp_hs,
    input    [7:0]     i_dvp_data,

    output             o_fast_vs,
    output             o_fast_hs,
    output    [7:0]    o_fast_data,

    output             o_fast_position_done,
    output             o_fast_position_en,
    output    [15:0]   o_fast_position_x,
    output    [15:0]   o_fast_position_y
    );


parameter Pra_Value_Width=8;                         //***********将Image_Width改为Value_Width
parameter Pra_FAST_Window_Size=7;


parameter Pra_Weight_Width=16;
parameter Pra_NMS_Window_Size=7;


parameter Pra_Threshold_Value=10;//compare threshold, 
parameter Pra_Threshold_Number=9;// it's recommaned 12, but for a corner 90 degerr, it can miss this corner how many pixels means it's a FAST corner


/*************************************************************************
                Step 1 : shift window
**************************************************************************/

Interface_Image #(.Pra_Width(Pra_Value_Width)) Interface_Image_In();
Interface_Window #(.Pra_Width(Pra_Value_Width)) Interface_Window_Image_In();

assign Interface_Image_In.image_vs=i_dvp_vs;
assign Interface_Image_In.image_hs=i_dvp_hs;
assign Interface_Image_In.image_data=i_dvp_data;

DIP_Shift_Window #(
    .Pra_Value_Width ( Pra_Value_Width ),
    .Pra_Window_Size ( Pra_FAST_Window_Size ))
u_DIP_Shift_Window_FAST (
    .i_clk              ( i_clk       ),
    .i_image            ( Interface_Image_In   ),
    .o_window           ( Interface_Window_Image_In   )
);

/*************************************************************************
                Step 2 : get keypoint information
**************************************************************************/
Interface_Image #(.Pra_Width(Pra_Value_Width)) Interface_Image_Compare_Neighbors();

//judge the keypoint by comparing the neighbors, and continuous pixels, many keypoints can be next to each other.
FAST_Compare_Neighbors #(
    .Pra_Threshold_Value  ( Pra_Threshold_Value   ),
    .Pra_Threshold_Number ( Pra_Threshold_Number ))
 u_FAST_Compare_Neighbors (
    .i_clk              ( i_clk       ),
    .i_window           ( Interface_Window_Image_In   ),
    .o_image            ( Interface_Image_Compare_Neighbors   )
);


// assign o_fast_vs=Interface_Image_Compare_Neighbors.image_vs;
// assign o_fast_hs=Interface_Image_Compare_Neighbors.image_hs;
// assign o_fast_data=Interface_Image_Compare_Neighbors.image_data;

/*************************************************************************
                Step 3 : Calculate keypoint weight 
**************************************************************************/

Interface_Image #(.Pra_Width(Pra_Weight_Width)) Interface_Image_Compare_Weight();

//remove the weak keypoint by add the abs difference.
FAST_Weight u_FAST_Weight (
    .i_clk              ( i_clk       ),
    .i_window           ( Interface_Window_Image_In   ),
    .o_image            ( Interface_Image_Compare_Weight   )
);


Interface_Image #(.Pra_Width(Pra_Weight_Width)) Interface_Image_FAST_Information();

assign Interface_Image_FAST_Information.image_vs=Interface_Image_Compare_Neighbors.image_vs;
assign Interface_Image_FAST_Information.image_hs=Interface_Image_Compare_Neighbors.image_hs;
assign Interface_Image_FAST_Information.image_en=Interface_Image_Compare_Neighbors.image_en;
assign Interface_Image_FAST_Information.image_data={Interface_Image_Compare_Neighbors.image_data[1:0],Interface_Image_Compare_Weight.image_data[13:0]};



/*************************************************************************
                Step 4 : NMS 
**************************************************************************/

Interface_Window #(.Pra_Width(Pra_Weight_Width)) Interface_Window_NMS();

DIP_Shift_Window #(
    .Pra_Value_Width ( Pra_Weight_Width ),
    .Pra_Window_Size ( Pra_NMS_Window_Size ))
u_DIP_Shift_Window_NMS (
    .i_clk              ( i_clk       ),
    .i_image            ( Interface_Image_FAST_Information   ),
    .o_window           ( Interface_Window_NMS   )
);


Interface_Image #(.Pra_Width(Pra_Value_Width)) Interface_Image_FAST_NMS();


FAST_NMS_Window_7_7 u_FAST_NMS_Window_7_7 (
    .i_clk              ( i_clk       ),
    .i_window           ( Interface_Window_NMS   ),
    .o_image            ( Interface_Image_FAST_NMS   )
);


/*************************************************************************
                output
**************************************************************************/

assign o_fast_vs=Interface_Image_FAST_NMS.image_vs;
assign o_fast_hs=Interface_Image_FAST_NMS.image_hs;
assign o_fast_data=Interface_Image_FAST_NMS.image_data;


endmodule
