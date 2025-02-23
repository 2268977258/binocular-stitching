/************************************************************************************
 Company:             
 Author:             han
 Author Email:       sciencefuture@163.com
 Create Date:        2022-02-22
 Module Name:        
 HDL Type:        Verilog HDL
 Description: 

 Additional Comments: 

************************************************************************************/

module FAST_Weight(
    input                           i_clk,

    Interface_Window.I_Window       i_window,

    Interface_Image.O_Image         o_image
    );


/*************************************************************************
                
**************************************************************************/

logic [7:0] Difference[15:0];
logic [7:0] Difference_ABS[15:0];

logic [7:0] Target_Value;
assign Target_Value=i_window.window_33;


assign Difference[0 ]    =Target_Value-i_window.window_03;
assign Difference[1 ]    =Target_Value-i_window.window_04;
assign Difference[2 ]    =Target_Value-i_window.window_15;
assign Difference[3 ]    =Target_Value-i_window.window_26;
assign Difference[4 ]    =Target_Value-i_window.window_36;
assign Difference[5 ]    =Target_Value-i_window.window_46;
assign Difference[6 ]    =Target_Value-i_window.window_55;
assign Difference[7 ]    =Target_Value-i_window.window_64;
assign Difference[8 ]    =Target_Value-i_window.window_63;
assign Difference[9 ]    =Target_Value-i_window.window_62;
assign Difference[10]    =Target_Value-i_window.window_51;
assign Difference[11]    =Target_Value-i_window.window_40;
assign Difference[12]    =Target_Value-i_window.window_30;
assign Difference[13]    =Target_Value-i_window.window_20;
assign Difference[14]    =Target_Value-i_window.window_11;
assign Difference[15]    =Target_Value-i_window.window_02;

assign Difference_ABS[0 ]    =Difference[0 ][7]==1'b1 ? (~Difference[0 ])+1'b1 : Difference[0 ];
assign Difference_ABS[1 ]    =Difference[1 ][7]==1'b1 ? (~Difference[1 ])+1'b1 : Difference[1 ];
assign Difference_ABS[2 ]    =Difference[2 ][7]==1'b1 ? (~Difference[2 ])+1'b1 : Difference[2 ];
assign Difference_ABS[3 ]    =Difference[3 ][7]==1'b1 ? (~Difference[3 ])+1'b1 : Difference[3 ];
assign Difference_ABS[4 ]    =Difference[4 ][7]==1'b1 ? (~Difference[4 ])+1'b1 : Difference[4 ];
assign Difference_ABS[5 ]    =Difference[5 ][7]==1'b1 ? (~Difference[5 ])+1'b1 : Difference[5 ];
assign Difference_ABS[6 ]    =Difference[6 ][7]==1'b1 ? (~Difference[6 ])+1'b1 : Difference[6 ];
assign Difference_ABS[7 ]    =Difference[7 ][7]==1'b1 ? (~Difference[7 ])+1'b1 : Difference[7 ];
assign Difference_ABS[8 ]    =Difference[8 ][7]==1'b1 ? (~Difference[8 ])+1'b1 : Difference[8 ];
assign Difference_ABS[9 ]    =Difference[9 ][7]==1'b1 ? (~Difference[9 ])+1'b1 : Difference[9 ];
assign Difference_ABS[10]    =Difference[10][7]==1'b1 ? (~Difference[10])+1'b1 : Difference[10];
assign Difference_ABS[11]    =Difference[11][7]==1'b1 ? (~Difference[11])+1'b1 : Difference[11];
assign Difference_ABS[12]    =Difference[12][7]==1'b1 ? (~Difference[12])+1'b1 : Difference[12];
assign Difference_ABS[13]    =Difference[13][7]==1'b1 ? (~Difference[13])+1'b1 : Difference[13];
assign Difference_ABS[14]    =Difference[14][7]==1'b1 ? (~Difference[14])+1'b1 : Difference[14];
assign Difference_ABS[15]    =Difference[15][7]==1'b1 ? (~Difference[15])+1'b1 : Difference[15];


/*************************************************************************
                calculate compare result by bit
**************************************************************************/


logic [15:0] Difference_Sum_0=0;
logic [15:0] Difference_Sum_1=0;
logic [15:0] Difference_Sum_2=0;
logic [15:0] Difference_Sum_3=0;

always @(posedge i_clk)
begin
    begin
        Difference_Sum_0<=            
                            Difference_ABS[0]+
                            Difference_ABS[1]+
                            Difference_ABS[2]+
                            Difference_ABS[3];
    end
end
always @(posedge i_clk)
begin
    begin
        Difference_Sum_1<=            
                            Difference_ABS[4]+
                            Difference_ABS[5]+
                            Difference_ABS[6]+
                            Difference_ABS[7];
    end
end
always @(posedge i_clk)
begin
    begin
        Difference_Sum_2<=            
                            Difference_ABS[8]+
                            Difference_ABS[9]+
                            Difference_ABS[10]+
                            Difference_ABS[11];
    end
end
always @(posedge i_clk)
begin
    begin
        Difference_Sum_3<=            
                            Difference_ABS[12]+
                            Difference_ABS[13]+
                            Difference_ABS[14]+
                            Difference_ABS[15];
    end
end



/*************************************************************************
                judgement for the FAST corner
**************************************************************************/
logic [15:0] Result;
always @(posedge i_clk)
begin
    begin
        Result<=Difference_Sum_0+Difference_Sum_1+Difference_Sum_2+Difference_Sum_3;
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
