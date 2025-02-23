/************************************************************************************
 Company:             
 Author:             han
 Author Email:       sciencefuture@163.com
 Create Date:        2023-05-18
 Module Name:        
 HDL Type:        Verilog HDL
 Description: 

 Additional Comments: 

************************************************************************************/

module FAST_Compare_Neighbors(
    input                           i_clk,

    Interface_Window.I_Window       i_window,

    Interface_Image.O_Image         o_image
    );


parameter Pra_Threshold_Value=3;//compare threshold, 
parameter Pra_Threshold_Number=9;//how many pixels means it's a FAST corner

/*************************************************************************
                compare pixels
**************************************************************************/

logic [15:0] Target_Value;
assign Target_Value={8'd0,i_window.window_33};



logic [15:0] Result_Black;
logic [15:0] Result_White;

assign Result_White[0]     =Target_Value>({8'd0,i_window.window_03}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[1]     =Target_Value>({8'd0,i_window.window_04}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[2]     =Target_Value>({8'd0,i_window.window_15}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[3]     =Target_Value>({8'd0,i_window.window_26}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[4]     =Target_Value>({8'd0,i_window.window_36}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[5]     =Target_Value>({8'd0,i_window.window_46}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[6]     =Target_Value>({8'd0,i_window.window_55}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[7]     =Target_Value>({8'd0,i_window.window_64}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[8]     =Target_Value>({8'd0,i_window.window_63}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[9]     =Target_Value>({8'd0,i_window.window_62}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[10]    =Target_Value>({8'd0,i_window.window_51}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[11]    =Target_Value>({8'd0,i_window.window_40}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[12]    =Target_Value>({8'd0,i_window.window_30}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[13]    =Target_Value>({8'd0,i_window.window_20}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[14]    =Target_Value>({8'd0,i_window.window_11}+Pra_Threshold_Value) ? 1'b1 : 1'b0;
assign Result_White[15]    =Target_Value>({8'd0,i_window.window_02}+Pra_Threshold_Value) ? 1'b1 : 1'b0;

assign Result_Black[0]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_03}) ? 1'b1 : 1'b0;
assign Result_Black[1]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_04}) ? 1'b1 : 1'b0;
assign Result_Black[2]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_15}) ? 1'b1 : 1'b0;
assign Result_Black[3]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_26}) ? 1'b1 : 1'b0;
assign Result_Black[4]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_36}) ? 1'b1 : 1'b0;
assign Result_Black[5]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_46}) ? 1'b1 : 1'b0;
assign Result_Black[6]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_55}) ? 1'b1 : 1'b0;
assign Result_Black[7]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_64}) ? 1'b1 : 1'b0;
assign Result_Black[8]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_63}) ? 1'b1 : 1'b0;
assign Result_Black[9]     =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_62}) ? 1'b1 : 1'b0;
assign Result_Black[10]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_51}) ? 1'b1 : 1'b0;
assign Result_Black[11]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_40}) ? 1'b1 : 1'b0;
assign Result_Black[12]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_30}) ? 1'b1 : 1'b0;
assign Result_Black[13]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_20}) ? 1'b1 : 1'b0;
assign Result_Black[14]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_11}) ? 1'b1 : 1'b0;
assign Result_Black[15]    =Target_Value+Pra_Threshold_Value<({8'd0,i_window.window_02}) ? 1'b1 : 1'b0;



/*************************************************************************
                calculate compare result by bit
**************************************************************************/
logic [7:0] Counter_White=0;
logic [7:0] Counter_Black=0;

always @(posedge i_clk)
begin
    begin
        Counter_White<= Result_White[0]+
                        Result_White[1]+
                        Result_White[2]+
                        Result_White[3]+
                        Result_White[4]+
                        Result_White[5]+
                        Result_White[6]+
                        Result_White[7]+
                        Result_White[8]+
                        Result_White[9]+
                        Result_White[10]+
                        Result_White[11]+
                        Result_White[12]+
                        Result_White[13]+
                        Result_White[14]+
                        Result_White[15];
        Counter_Black<= Result_Black[0]+
                        Result_Black[1]+
                        Result_Black[2]+
                        Result_Black[3]+
                        Result_Black[4]+
                        Result_Black[5]+
                        Result_Black[6]+
                        Result_Black[7]+
                        Result_Black[8]+
                        Result_Black[9]+
                        Result_Black[10]+
                        Result_Black[11]+
                        Result_Black[12]+
                        Result_Black[13]+
                        Result_Black[14]+
                        Result_Black[15];
    end
end

logic White_Valid;
logic Black_Valid;
Count_Continuous_Bit  u_Count_Continuous_Bit_White (
    .i_clk                   ( i_clk     ),
    .i_value                 ( Result_White   ),

    .o_valid                 ( White_Valid   )
);

Count_Continuous_Bit  u_Count_Continuous_Bit_Black (
    .i_clk                   ( i_clk     ),
    .i_value                 ( Result_Black   ),

    .o_valid                 ( Black_Valid   )
);

/*************************************************************************
                judgement for the FAST corner
**************************************************************************/
logic [7:0] Result;
always @(posedge i_clk)
begin
    if(Counter_White>=Pra_Threshold_Number && Counter_White<8'd16 && White_Valid==1'b1)
    begin
        Result<=1;
    end
    else if(Counter_Black>=Pra_Threshold_Number && Counter_Black<8'd16 && Black_Valid==1'b1)
    begin
        Result<=2;
    end
    else
    begin
        Result<=0;
    end
end

/*************************************************************************
                2 clocks delay
**************************************************************************/

logic [1:0]        Image_VS;
logic [1:0]        Image_HS;
logic [1:0]        Image_En;
always @(posedge i_clk)
begin
    begin
        Image_VS[0]<=i_window.image_vs;
        Image_HS[0]<=i_window.image_hs;
        Image_En[0]<=i_window.image_en;
        Image_VS[1]<=Image_VS[0];
        Image_HS[1]<=Image_HS[0];
        Image_En[1]<=Image_En[0];
    end
end

assign o_image.image_vs=Image_VS[1];
assign o_image.image_hs=Image_HS[1];
assign o_image.image_en=Image_En[1];
assign o_image.image_data=Result;

endmodule
