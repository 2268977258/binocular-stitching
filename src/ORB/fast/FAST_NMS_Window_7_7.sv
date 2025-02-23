/************************************************************************************
 Company:             
 Author:             han
 Author Email:       sciencefuture@163.com
 Create Date:        2022-07-20
 Module Name:        
 HDL Type:        Verilog HDL
 Description: 
    only support 7*7 window
 Additional Comments: 

************************************************************************************/

module FAST_NMS_Window_7_7(
    input                           i_clk,

    Interface_Window.I_Window       i_window,

    Interface_Image.O_Image         o_image
    );


/*************************************************************************
                
**************************************************************************/


logic [15:0] Target_Value;
assign Target_Value=i_window.window_33;

logic [48:0] Result;

/*************************************************************************
        if the value is a keypoint, keep the value, 
        otherwire set the vlaue to 0 ,make sure the result is 1 when compare
**************************************************************************/

logic [13:0]        Window_Data_Temp[48:0];

assign Window_Data_Temp[0]      =i_window.window_00[15:14]!=0 ? i_window.window_00[13:0] : 0;
assign Window_Data_Temp[1]      =i_window.window_01[15:14]!=0 ? i_window.window_01[13:0] : 0;
assign Window_Data_Temp[2]      =i_window.window_02[15:14]!=0 ? i_window.window_02[13:0] : 0;
assign Window_Data_Temp[3]      =i_window.window_03[15:14]!=0 ? i_window.window_03[13:0] : 0;
assign Window_Data_Temp[4]      =i_window.window_04[15:14]!=0 ? i_window.window_04[13:0] : 0;
assign Window_Data_Temp[5]      =i_window.window_05[15:14]!=0 ? i_window.window_05[13:0] : 0;
assign Window_Data_Temp[6]      =i_window.window_06[15:14]!=0 ? i_window.window_06[13:0] : 0;
assign Window_Data_Temp[7]      =i_window.window_10[15:14]!=0 ? i_window.window_10[13:0] : 0;
assign Window_Data_Temp[8]      =i_window.window_11[15:14]!=0 ? i_window.window_11[13:0] : 0;
assign Window_Data_Temp[9]      =i_window.window_12[15:14]!=0 ? i_window.window_12[13:0] : 0;
assign Window_Data_Temp[10]     =i_window.window_13[15:14]!=0 ? i_window.window_13[13:0] : 0;
assign Window_Data_Temp[11]     =i_window.window_14[15:14]!=0 ? i_window.window_14[13:0] : 0;
assign Window_Data_Temp[12]     =i_window.window_15[15:14]!=0 ? i_window.window_15[13:0] : 0;
assign Window_Data_Temp[13]     =i_window.window_16[15:14]!=0 ? i_window.window_16[13:0] : 0;
assign Window_Data_Temp[14]     =i_window.window_20[15:14]!=0 ? i_window.window_20[13:0] : 0;
assign Window_Data_Temp[15]     =i_window.window_21[15:14]!=0 ? i_window.window_21[13:0] : 0;
assign Window_Data_Temp[16]     =i_window.window_22[15:14]!=0 ? i_window.window_22[13:0] : 0;
assign Window_Data_Temp[17]     =i_window.window_23[15:14]!=0 ? i_window.window_23[13:0] : 0;
assign Window_Data_Temp[18]     =i_window.window_24[15:14]!=0 ? i_window.window_24[13:0] : 0;
assign Window_Data_Temp[19]     =i_window.window_25[15:14]!=0 ? i_window.window_25[13:0] : 0;
assign Window_Data_Temp[20]     =i_window.window_26[15:14]!=0 ? i_window.window_26[13:0] : 0;
assign Window_Data_Temp[21]     =i_window.window_30[15:14]!=0 ? i_window.window_30[13:0] : 0;
assign Window_Data_Temp[22]     =i_window.window_31[15:14]!=0 ? i_window.window_31[13:0] : 0;
assign Window_Data_Temp[23]     =i_window.window_32[15:14]!=0 ? i_window.window_32[13:0] : 0;
assign Window_Data_Temp[24]     =i_window.window_33[15:14]!=0 ? i_window.window_33[13:0] : 0;
assign Window_Data_Temp[25]     =i_window.window_34[15:14]!=0 ? i_window.window_34[13:0] : 0;
assign Window_Data_Temp[26]     =i_window.window_35[15:14]!=0 ? i_window.window_35[13:0] : 0;
assign Window_Data_Temp[27]     =i_window.window_36[15:14]!=0 ? i_window.window_36[13:0] : 0;
assign Window_Data_Temp[28]     =i_window.window_40[15:14]!=0 ? i_window.window_40[13:0] : 0;
assign Window_Data_Temp[29]     =i_window.window_41[15:14]!=0 ? i_window.window_41[13:0] : 0;
assign Window_Data_Temp[30]     =i_window.window_42[15:14]!=0 ? i_window.window_42[13:0] : 0;
assign Window_Data_Temp[31]     =i_window.window_43[15:14]!=0 ? i_window.window_43[13:0] : 0;
assign Window_Data_Temp[32]     =i_window.window_44[15:14]!=0 ? i_window.window_44[13:0] : 0;
assign Window_Data_Temp[33]     =i_window.window_45[15:14]!=0 ? i_window.window_45[13:0] : 0;
assign Window_Data_Temp[34]     =i_window.window_46[15:14]!=0 ? i_window.window_46[13:0] : 0;
assign Window_Data_Temp[35]     =i_window.window_50[15:14]!=0 ? i_window.window_50[13:0] : 0;
assign Window_Data_Temp[36]     =i_window.window_51[15:14]!=0 ? i_window.window_51[13:0] : 0;
assign Window_Data_Temp[37]     =i_window.window_52[15:14]!=0 ? i_window.window_52[13:0] : 0;
assign Window_Data_Temp[38]     =i_window.window_53[15:14]!=0 ? i_window.window_53[13:0] : 0;
assign Window_Data_Temp[39]     =i_window.window_54[15:14]!=0 ? i_window.window_54[13:0] : 0;
assign Window_Data_Temp[40]     =i_window.window_55[15:14]!=0 ? i_window.window_55[13:0] : 0;
assign Window_Data_Temp[41]     =i_window.window_56[15:14]!=0 ? i_window.window_56[13:0] : 0;
assign Window_Data_Temp[42]     =i_window.window_60[15:14]!=0 ? i_window.window_60[13:0] : 0;
assign Window_Data_Temp[43]     =i_window.window_61[15:14]!=0 ? i_window.window_61[13:0] : 0;
assign Window_Data_Temp[44]     =i_window.window_62[15:14]!=0 ? i_window.window_62[13:0] : 0;
assign Window_Data_Temp[45]     =i_window.window_63[15:14]!=0 ? i_window.window_63[13:0] : 0;
assign Window_Data_Temp[46]     =i_window.window_64[15:14]!=0 ? i_window.window_64[13:0] : 0;
assign Window_Data_Temp[47]     =i_window.window_65[15:14]!=0 ? i_window.window_65[13:0] : 0;
assign Window_Data_Temp[48]     =i_window.window_66[15:14]!=0 ? i_window.window_66[13:0] : 0;



/*************************************************************************
        only compare the valid keypoint, otherwise set the value to 0
**************************************************************************/

//compare to find the max one 
assign Result[0]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[0] ) ? 1'b1 : 1'b0;
assign Result[1]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[1] ) ? 1'b1 : 1'b0;
assign Result[2]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[2] ) ? 1'b1 : 1'b0;
assign Result[3]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[3] ) ? 1'b1 : 1'b0;
assign Result[4]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[4] ) ? 1'b1 : 1'b0;
assign Result[5]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[5] ) ? 1'b1 : 1'b0;
assign Result[6]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[6] ) ? 1'b1 : 1'b0;
assign Result[7]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[7] ) ? 1'b1 : 1'b0;
assign Result[8]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[8] ) ? 1'b1 : 1'b0;
assign Result[9]     =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[9] ) ? 1'b1 : 1'b0;
assign Result[10]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[10]) ? 1'b1 : 1'b0;
assign Result[11]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[11]) ? 1'b1 : 1'b0;
assign Result[12]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[12]) ? 1'b1 : 1'b0;
assign Result[13]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[13]) ? 1'b1 : 1'b0;
assign Result[14]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[14]) ? 1'b1 : 1'b0;
assign Result[15]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[15]) ? 1'b1 : 1'b0;
assign Result[16]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[16]) ? 1'b1 : 1'b0;
assign Result[17]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[17]) ? 1'b1 : 1'b0;
assign Result[18]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[18]) ? 1'b1 : 1'b0;
assign Result[19]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[19]) ? 1'b1 : 1'b0;
assign Result[20]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[20]) ? 1'b1 : 1'b0;
assign Result[21]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[21]) ? 1'b1 : 1'b0;
assign Result[22]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[22]) ? 1'b1 : 1'b0;
assign Result[23]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[23]) ? 1'b1 : 1'b0;
assign Result[24]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[24]) ? 1'b1 : 1'b0;
assign Result[25]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[25]) ? 1'b1 : 1'b0;
assign Result[26]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[26]) ? 1'b1 : 1'b0;
assign Result[27]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[27]) ? 1'b1 : 1'b0;
assign Result[28]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[28]) ? 1'b1 : 1'b0;
assign Result[29]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[29]) ? 1'b1 : 1'b0;
assign Result[30]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[30]) ? 1'b1 : 1'b0;
assign Result[31]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[31]) ? 1'b1 : 1'b0;
assign Result[32]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[32]) ? 1'b1 : 1'b0;
assign Result[33]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[33]) ? 1'b1 : 1'b0;
assign Result[34]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[34]) ? 1'b1 : 1'b0;
assign Result[35]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[35]) ? 1'b1 : 1'b0;
assign Result[36]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[36]) ? 1'b1 : 1'b0;
assign Result[37]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[37]) ? 1'b1 : 1'b0;
assign Result[38]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[38]) ? 1'b1 : 1'b0;
assign Result[39]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[39]) ? 1'b1 : 1'b0;
assign Result[40]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[40]) ? 1'b1 : 1'b0;
assign Result[41]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[41]) ? 1'b1 : 1'b0;
assign Result[42]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[42]) ? 1'b1 : 1'b0;
assign Result[43]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[43]) ? 1'b1 : 1'b0;
assign Result[44]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[44]) ? 1'b1 : 1'b0;
assign Result[45]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[45]) ? 1'b1 : 1'b0;
assign Result[46]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[46]) ? 1'b1 : 1'b0;
assign Result[47]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[47]) ? 1'b1 : 1'b0;
assign Result[48]    =(Target_Value[15:14]!=0) && (Target_Value[13:0]>=Window_Data_Temp[48]) ? 1'b1 : 1'b0;




parameter Pra_All_1=49'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1;

logic [7:0] NMS_Result=0;
always_ff @(posedge i_clk)
begin
    if(Result==Pra_All_1)
    begin
        NMS_Result<={6'd0,Target_Value[15:14]};//Marker the pixel
    end
    else
    begin
        NMS_Result<=0;
    end
end

/*************************************************************************
                1 clock delay
**************************************************************************/

logic         Image_VS=0;
logic         Image_HS=0;
logic         Image_En=0;
always_ff @(posedge i_clk)
begin
    Image_VS<=i_window.image_vs;
    Image_HS<=i_window.image_hs;
    Image_En<=i_window.image_en;
end

assign o_image.image_vs=Image_VS;
assign o_image.image_hs=Image_HS;
assign o_image.image_en=Image_En;
assign o_image.image_data=NMS_Result;


endmodule
