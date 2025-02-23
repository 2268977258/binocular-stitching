/************************************************************************************
 Company:             
 Author:             han
 Author Email:       sciencefuture@163.com
 Create Date:        2023-05-15
 Module Name:        
 HDL Type:        Verilog HDL
 Description: 
    
    2023-05-15
    1: support 8bit and 16bit
    2: FIFO use First-World Fall-Through FWFT
    3: support 31 window define
    
 Additional Comments: 

************************************************************************************/

module DIP_Shift_Window (
    input                           i_clk,

    Interface_Image.I_Image         i_image,
    Interface_Window.O_Window       o_window
    );




parameter Pra_Value_Width=8;
parameter Pra_Window_Size=5;

/*************************************************************************
                HS VS Rising and Falling edge
**************************************************************************/
logic               Image_VS_Rising;
logic               Image_VS_Falling;
logic               Image_HS_Rising;
logic               Image_HS_Falling;
logic [15:0]        Counter_Image_VS;
logic [15:0]        Counter_Image_HS;

DIP_DVP_Counter u_DIP_DVP_Counter (
    .i_clk                   ( i_clk                 ),
    .i_dvp_vs                ( i_image.image_vs      ),
    .i_dvp_hs                ( i_image.image_hs      ),

    .o_vs_start              ( Image_VS_Rising       ),
    .o_vs_end                ( Image_VS_Falling      ),
    .o_hs_start              ( Image_HS_Rising       ),
    .o_hs_end                ( Image_HS_Falling      ),

    .o_counter_vs            ( Counter_Image_VS      ),
    .o_counter_hs            ( Counter_Image_HS      )
);


/*************************************************************************
                Line buffer for shift data
**************************************************************************/

logic [Pra_Window_Size-2:0]            FIFO_Full;
logic [Pra_Window_Size-2:0]            FIFO_Empty;
logic [9:0]                           FIFO_Read_Count[Pra_Window_Size-2:0];
logic [10:0]                           FIFO_Write_Count[Pra_Window_Size-2:0];
logic [Pra_Window_Size-2:0]            FIFO_Write_En;
logic [Pra_Value_Width-1:0]            FIFO_Write_Data[Pra_Window_Size-2:0];
logic [Pra_Window_Size-2:0]            FIFO_Read_En;
logic [Pra_Value_Width-1:0]            FIFO_Read_Data[Pra_Window_Size-2:0];

logic [Pra_Window_Size-1:0]            Flag_Line_Ready;


assign FIFO_Write_En[0]=i_image.image_hs;
assign FIFO_Write_Data[0]=i_image.image_data;
assign Flag_Line_Ready[0]=1;

logic FIFO_Reset;
assign FIFO_Reset=Image_VS_Falling;

generate//start from 0
genvar i;
for (i = 0; i<Pra_Window_Size-1; i++) begin : FIFO_Block
    
        FIFO_8_2048_FWFT u_FIFO_8_2048_FWFT_Line_Buffer (
        .a_rst_i(FIFO_Reset),            // input wire rst
        .wr_clk_i(i_clk),                // input wire wr_clk
        .rd_clk_i(i_clk),                // input wire rd_clk

        .wr_en_i(FIFO_Write_En[i]),                  // input wire wr_en
        .wdata(FIFO_Write_Data[i]),                      // input wire [7 : 0] din
        .rd_en_i(FIFO_Read_En[i]),                  // input wire rd_en
        .rdata(FIFO_Read_Data[i]),                    // output wire [7 : 0] dout

        .full_o(FIFO_Full[i]),                    // output wire full
        .empty_o(FIFO_Empty[i]),                  // output wire empty
        .rd_datacount_o(FIFO_Read_Count[i]),  // output wire [10 : 0] rd_data_count
        .wr_datacount_o(FIFO_Write_Count[i])  // output wire [10 : 0] wr_data_count
        );
    

assign FIFO_Read_En[i]=Flag_Line_Ready[i+1]&i_image.image_hs;

end
endgenerate



generate//start from 1
genvar j;
//2022-05-24
for (j = 1; j<=Pra_Window_Size-1; j++) begin : Always_Blaock    

always @(posedge i_clk)
begin
    if(Image_VS_Rising)
    begin
        Flag_Line_Ready[j]<=0;
    end
    else if(Image_HS_Falling==1'b1 && FIFO_Read_Count[j-1]>0)
    begin
        Flag_Line_Ready[j]<=1;
    end
    else
    begin
        Flag_Line_Ready[j]<=Flag_Line_Ready[j];
    end
end

//---------------------------------
//if(Pra_Window_Size==2) begin
//    //do nothing
//end
//else 
if(j<Pra_Window_Size-1)
begin
    assign FIFO_Write_En[j]=FIFO_Read_En[j-1];
    assign FIFO_Write_Data[j]=FIFO_Read_En[j-1]==1'b1 ? FIFO_Read_Data[j-1] : 0;
end
//---------------------------------

end
endgenerate

/*************************************************************************
                assign the window value
**************************************************************************/

logic [Pra_Value_Width-1:0]        Window_Data_0X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_1X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_2X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_3X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_4X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_5X[Pra_Window_Size-1:0];
logic [Pra_Value_Width-1:0]        Window_Data_6X[Pra_Window_Size-1:0];


generate//start from 0
genvar k;
for (k = 0; k<Pra_Window_Size-1; k++) begin : Window_Block
    always_ff @(posedge i_clk)
    begin
        Window_Data_0X[k+1]<=Window_Data_0X[k];
        Window_Data_1X[k+1]<=Window_Data_1X[k];
        Window_Data_2X[k+1]<=Window_Data_2X[k];
        Window_Data_3X[k+1]<=Window_Data_3X[k];
        Window_Data_4X[k+1]<=Window_Data_4X[k];
        Window_Data_5X[k+1]<=Window_Data_5X[k];
        Window_Data_6X[k+1]<=Window_Data_6X[k];
    end
end

endgenerate


generate 
    if(Pra_Window_Size==2) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=i_image.image_data;
    end
    else if(Pra_Window_Size==3) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=FIFO_Read_En[Pra_Window_Size-3]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-3] : 0;
        assign Window_Data_2X[0]=i_image.image_data;
    end
    else if(Pra_Window_Size==4) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=FIFO_Read_En[Pra_Window_Size-3]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-3] : 0;
        assign Window_Data_2X[0]=FIFO_Read_En[Pra_Window_Size-4]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-4] : 0;
        assign Window_Data_3X[0]=i_image.image_data;
    end
    else if(Pra_Window_Size==5) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=FIFO_Read_En[Pra_Window_Size-3]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-3] : 0;
        assign Window_Data_2X[0]=FIFO_Read_En[Pra_Window_Size-4]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-4] : 0;
        assign Window_Data_3X[0]=FIFO_Read_En[Pra_Window_Size-5]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-5] : 0;
        assign Window_Data_4X[0]=i_image.image_data;
    end
    else if(Pra_Window_Size==6) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=FIFO_Read_En[Pra_Window_Size-3]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-3] : 0;
        assign Window_Data_2X[0]=FIFO_Read_En[Pra_Window_Size-4]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-4] : 0;
        assign Window_Data_3X[0]=FIFO_Read_En[Pra_Window_Size-5]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-5] : 0;
        assign Window_Data_4X[0]=FIFO_Read_En[Pra_Window_Size-6]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-6] : 0;
        assign Window_Data_5X[0]=i_image.image_data;
    end
    else if(Pra_Window_Size==7) begin
        assign Window_Data_0X[0]=FIFO_Read_En[Pra_Window_Size-2]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-2] : 0;
        assign Window_Data_1X[0]=FIFO_Read_En[Pra_Window_Size-3]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-3] : 0;
        assign Window_Data_2X[0]=FIFO_Read_En[Pra_Window_Size-4]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-4] : 0;
        assign Window_Data_3X[0]=FIFO_Read_En[Pra_Window_Size-5]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-5] : 0;
        assign Window_Data_4X[0]=FIFO_Read_En[Pra_Window_Size-6]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-6] : 0;
        assign Window_Data_5X[0]=FIFO_Read_En[Pra_Window_Size-7]==1'b1 ? FIFO_Read_Data[Pra_Window_Size-7] : 0;
        assign Window_Data_6X[0]=i_image.image_data;
    end
endgenerate


/*************************************************************************
                output window value set the invalid window value to 0
**************************************************************************/

logic Flag_Pixel_Ready;

always @(posedge i_clk)
begin
    if(Image_VS_Rising)
    begin
        Flag_Pixel_Ready<=0;
    end
    else if(Counter_Image_HS>=Pra_Window_Size-2)
    begin
        Flag_Pixel_Ready<=1;
    end
    else
    begin
        Flag_Pixel_Ready<=0;
    end
end


assign o_window.image_vs=i_image.image_vs;
assign o_window.image_hs=i_image.image_hs;
assign o_window.image_en=i_image.image_hs&Flag_Line_Ready[Pra_Window_Size-1]&Flag_Pixel_Ready;



        assign o_window.window_00=Window_Data_0X[Pra_Window_Size-1];
        assign o_window.window_01=Window_Data_0X[Pra_Window_Size-2];
        assign o_window.window_02=Window_Data_0X[Pra_Window_Size-3];
        assign o_window.window_03=Window_Data_0X[Pra_Window_Size-4];
        assign o_window.window_04=Window_Data_0X[Pra_Window_Size-5];
        assign o_window.window_05=Window_Data_0X[Pra_Window_Size-6];
        assign o_window.window_06=Window_Data_0X[Pra_Window_Size-7];

        assign o_window.window_10=Window_Data_1X[Pra_Window_Size-1];
        assign o_window.window_11=Window_Data_1X[Pra_Window_Size-2];
        assign o_window.window_12=Window_Data_1X[Pra_Window_Size-3];
        assign o_window.window_13=Window_Data_1X[Pra_Window_Size-4];
        assign o_window.window_14=Window_Data_1X[Pra_Window_Size-5];
        assign o_window.window_15=Window_Data_1X[Pra_Window_Size-6];
        assign o_window.window_16=Window_Data_1X[Pra_Window_Size-7];

        assign o_window.window_20=Window_Data_2X[Pra_Window_Size-1];
        assign o_window.window_21=Window_Data_2X[Pra_Window_Size-2];
        assign o_window.window_22=Window_Data_2X[Pra_Window_Size-3];
        assign o_window.window_23=Window_Data_2X[Pra_Window_Size-4];
        assign o_window.window_24=Window_Data_2X[Pra_Window_Size-5];
        assign o_window.window_25=Window_Data_2X[Pra_Window_Size-6];
        assign o_window.window_26=Window_Data_2X[Pra_Window_Size-7];

        assign o_window.window_30=Window_Data_3X[Pra_Window_Size-1];
        assign o_window.window_31=Window_Data_3X[Pra_Window_Size-2];
        assign o_window.window_32=Window_Data_3X[Pra_Window_Size-3];
        assign o_window.window_33=Window_Data_3X[Pra_Window_Size-4];
        assign o_window.window_34=Window_Data_3X[Pra_Window_Size-5];
        assign o_window.window_35=Window_Data_3X[Pra_Window_Size-6];
        assign o_window.window_36=Window_Data_3X[Pra_Window_Size-7];

        assign o_window.window_40=Window_Data_4X[Pra_Window_Size-1];
        assign o_window.window_41=Window_Data_4X[Pra_Window_Size-2];
        assign o_window.window_42=Window_Data_4X[Pra_Window_Size-3];
        assign o_window.window_43=Window_Data_4X[Pra_Window_Size-4];
        assign o_window.window_44=Window_Data_4X[Pra_Window_Size-5];
        assign o_window.window_45=Window_Data_4X[Pra_Window_Size-6];
        assign o_window.window_46=Window_Data_4X[Pra_Window_Size-7];

        assign o_window.window_50=Window_Data_5X[Pra_Window_Size-1];
        assign o_window.window_51=Window_Data_5X[Pra_Window_Size-2];
        assign o_window.window_52=Window_Data_5X[Pra_Window_Size-3];
        assign o_window.window_53=Window_Data_5X[Pra_Window_Size-4];
        assign o_window.window_54=Window_Data_5X[Pra_Window_Size-5];
        assign o_window.window_55=Window_Data_5X[Pra_Window_Size-6];
        assign o_window.window_56=Window_Data_5X[Pra_Window_Size-7];

        assign o_window.window_60=Window_Data_6X[Pra_Window_Size-1];
        assign o_window.window_61=Window_Data_6X[Pra_Window_Size-2];
        assign o_window.window_62=Window_Data_6X[Pra_Window_Size-3];
        assign o_window.window_63=Window_Data_6X[Pra_Window_Size-4];
        assign o_window.window_64=Window_Data_6X[Pra_Window_Size-5];
        assign o_window.window_65=Window_Data_6X[Pra_Window_Size-6];
        assign o_window.window_66=Window_Data_6X[Pra_Window_Size-7];





endmodule
