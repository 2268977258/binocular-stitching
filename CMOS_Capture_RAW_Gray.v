/*-------------------------------------------------------------------------
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2011-201x CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Eamil Address 		: 		crazyfpga@vip.qq.com
Filename			:		CMOS_Capture_RAW_Gray.v
Date				:		2013-04-10
Version				:		1.0
Description			:		Capture cmos data from cmos senser of RAW or Gray Format
Modification History	:
Date			By			Version		Change Description
===========================================================================
13/04/10		CrazyBingo	1.0			Original
13/04/14		CrazyBingo	1.1			Complete
13/05/26		CrazyBingo	1.2			Modification
13/11/08		CrazyBingo	2.0			Modification	
14/03/16		CrazyBingo	2.0			Modification
--------------------------------------------------------------------------*/
`timescale 1ns/1ns
module CMOS_Capture_RAW_Gray
#(
	parameter			CMOS_FRAME_WAITCNT	=	4'd10,		//Wait n fps for steady(OmniVision need 10 Frame)
	parameter			CMOS_PCLK_FREQ		=	24_000000,					
					SIMU_EN 			= 0
)
(
	//global clock
	input				clk_cmos,			//24MHz CMOS Driver clock input
	input				rst_n,				//global reset

	//CMOS Sensor Interface
	input				cmos_pclk,			//24MHz CMOS Pixel clock input
	output				cmos_xclk,			//24MHz drive clock
	input				cmos_vsync,			//H : Data Valid; L : Frame Sync(Set it by register)
	input				cmos_href,			//H : Data vaild, L : Line Sync
	input		[7:0]	cmos_data,			//8 bits cmos data input
	
	//CMOS SYNC Data output
	output				cmos_frame_vsync,	//cmos frame data vsync valid signal
	output				cmos_frame_href,	//cmos frame data href vaild  signal
	output		[7:0]	cmos_frame_data,	//cmos frame RAW output	
	
	//user interface
	output	reg	[7:0]	cmos_fps_rate,		//cmos frame output rate
	output				cmos_vsync_end,
	output 				cmos_vsync_start,
	output	reg	[11:0]	pixel_cnt,
	output	reg	[11:0]	line_cnt
);
assign	cmos_xclk = clk_cmos;	//24MHz CMOS XCLK output

//-----------------------------------------------------
//Sensor HS & VS Vaild Capture
/**************************************************					       
         _________________________________
VS______|                                 |________
	            _______	 	     _______
HS_____________|       |__...___|       |____________
**************************************************/
//-------------------------------------------------------------
//sync the frame vsync and href signal and generate frame begin & end signal
reg	[1:0]	cmos_vsync_r, cmos_href_r;
reg	[7:0]	cmos_data_r0, cmos_data_r1;
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		begin
		cmos_vsync_r <= 0;
		cmos_href_r <= 0;
		{cmos_data_r1, cmos_data_r0} <= 0;
		end
	else
		begin
		cmos_vsync_r <= {cmos_vsync_r[0], cmos_vsync};
		cmos_href_r <= {cmos_href_r[0], cmos_href};
		{cmos_data_r1, cmos_data_r0} <= {cmos_data_r0, cmos_data};
		end
end
assign	cmos_vsync_start 	= 	(~cmos_vsync_r[1] & cmos_vsync_r[0]) ? 1'b1 : 1'b0;	
assign	cmos_vsync_end 		= 	(cmos_vsync_r[1] & ~cmos_vsync_r[0]) ? 1'b1 : 1'b0;	
wire	cmos_href_begin		=	(cmos_vsync_r[0] & ~cmos_href_r[1] & cmos_href_r[0]) ? 1'b1 : 1'b0;	

//----------------------------------------------------------------------------------
//reg	[11:0]	pixel_cnt;	
//reg	[11:0]	line_cnt;	
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		pixel_cnt <= 0;
	else if(cmos_vsync_r[0] & cmos_href_r[0])
		pixel_cnt <= pixel_cnt + 1'b1;
	else
		pixel_cnt <= 0;
end

always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		line_cnt <= 0;
	else if(cmos_vsync_r[0] == 1'b1)
		begin
		if(cmos_href_begin == 1'b1)
			line_cnt <= line_cnt  + 1'b1;
		else
			line_cnt <= line_cnt;
		end
	else
		line_cnt <= 0;
end


//----------------------------------------------------------------------------------
//Wait for Sensor output Data valid 10 Frame of OmniVision
reg	[3:0]	cmos_fps_cnt;
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		cmos_fps_cnt <= 0;
	else	//Wait until cmos init complete
		begin
		if(cmos_fps_cnt < CMOS_FRAME_WAITCNT)	
			cmos_fps_cnt <= cmos_vsync_end ? cmos_fps_cnt + 1'b1 : cmos_fps_cnt;
		else
			cmos_fps_cnt <= CMOS_FRAME_WAITCNT;
		end
end

//----------------------------------------------------------------------------------
//Come ture frame synchronization to ignore error frame or has not capture when vsync begin
reg		frame_sync_flag;
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		frame_sync_flag <= SIMU_EN;
	else if(cmos_fps_cnt == CMOS_FRAME_WAITCNT && cmos_vsync_end == 1)
		frame_sync_flag <= 1;
	else
		frame_sync_flag <= frame_sync_flag;
end


assign	cmos_frame_vsync = frame_sync_flag ? cmos_vsync_r[1]  : 1'b0;//DFF 2 clocks
assign	cmos_frame_href  = frame_sync_flag ? cmos_href_r[1] & cmos_vsync_r[1] & (line_cnt >= 3 && line_cnt <= 722): 1'b0;	//DFF 2 clocks
assign	cmos_frame_data	 = frame_sync_flag & cmos_frame_href ? cmos_data_r1 : 8'd0;	//DFF 2 clocks

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//Delay 2s for cmos fps counter
localparam	DELAY_TOP = 2 * CMOS_PCLK_FREQ;	//2s delay
reg	[27:0]	delay_cnt;
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		delay_cnt <= 0;
	else if(delay_cnt < DELAY_TOP - 1'b1)
		delay_cnt <= delay_cnt + 1'b1;
	else
		delay_cnt <= 0;
end
wire	delay_2s = (delay_cnt == DELAY_TOP - 1'b1) ? 1'b1 : 1'b0;

//-------------------------------------
//cmos image output rate counter
reg	[8:0]	cmos_fps_cnt2;
always@(posedge cmos_pclk or negedge rst_n)
begin
	if(!rst_n)
		begin
		cmos_fps_cnt2 <= 0;
		cmos_fps_rate <= 0;
		end
	else if(delay_2s == 1'b0)	//time is not reached
		begin
		cmos_fps_cnt2 <= cmos_vsync_end ? cmos_fps_cnt2 + 1'b1 : cmos_fps_cnt2;
		cmos_fps_rate <= cmos_fps_rate;
		end
	else	//time up
		begin
		cmos_fps_cnt2 <= 0;
		cmos_fps_rate <= cmos_fps_cnt2[8:1];	//divide by 2
		end
end



endmodule
