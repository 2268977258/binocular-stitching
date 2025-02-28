/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2013-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Email Address 		: 		crazyfpga@vip.qq.com
Filename			:		lcd_para.v
Date				:		2012-02-18
Description			:		LCD/VGA driver parameter.
Modification History	:
Date			By			Version			Change Description
=========================================================================
12/02/18		CrazyBingo	1.0				Original
12/03/19		CrazyBingo	1.1				Modification
12/03/21		CrazyBingo	1.2				Modification
12/05/13		CrazyBingo	1.3				Modification
13/11/07		CrazyBingo	2.1				Modification
17/04/02		CrazyBingo	3.0				Modify for 720P & 1080P & 800*480
-------------------------------------------------------------------------
|                                     Oooo								|
+------------------------------oooO--(   )-----------------------------+
                              (   )   ) /
                               \ (   (_/
                                \_)
----------------------------------------------------------------------*/

`timescale 1ns/1ps

//-----------------------------------------------------------------------
//Define the color parameter RGB--8|8|8
//define colors RGB--8|8|8
`define RED		24'hFF0000   /*11111111,00000000,00000000	*/
`define GREEN	24'h00FF00   /*00000000,11111111,00000000	*/
`define BLUE  	24'h0000FF   /*00000000,00000000,11111111	*/
`define WHITE 	24'hFFFFFF   /*11111111,11111111,11111111	*/
`define BLACK 	24'h000000   /*00000000,00000000,00000000	*/
`define YELLOW	24'hFFFF00   /*11111111,11111111,00000000	*/
`define CYAN  	24'hFF00FF   /*11111111,00000000,11111111	*/
`define ROYAL 	24'h00FFFF   /*00000000,11111111,11111111	*/ 

//---------------------------------
`define	SYNC_POLARITY 1'b0

//------------------------------------
//vga parameter define
//`define VGA_854_480_60FPS_30MHz
//`define	VGA_640_480_60FPS_25MHz
//`define	VGA_800_600_60FPS_40MHz
//`define	VGA_1280_720_60FPS_74_25MHz
`define	VGA_1920_1080_60FPS_148_5MHz
//`define   VGA_1024_600_60FPS_50MHz
//`define	DSI_1024_600_60FPS_50MHz

//---------------------------------
//	854 * 480
`ifdef	VGA_854_480_60FPS_30MHz
`define	H_FRONT	10'd50
`define	H_SYNC 	10'd16  
`define	H_BACK 	10'd40  
`define	H_DISP	10'd854 
`define	H_TOTAL	10'd960 	
 				
`define	V_FRONT	10'd30  
`define	V_SYNC 	10'd3  
`define	V_BACK 	10'd12 
`define	V_DISP 	10'd480   
`define	V_TOTAL	10'd525
`endif


//---------------------------------
//	640 * 480
`ifdef	VGA_640_480_60FPS_25MHz
`define	H_FRONT	12'd16
`define	H_SYNC 	12'd96  
`define	H_BACK 	12'd48  
`define	H_DISP	12'd640 
`define	H_TOTAL	12'd800 	
 				
`define	V_FRONT	12'd10  
`define	V_SYNC 	12'd2   
`define	V_BACK 	12'd33 
`define	V_DISP 	12'd480   
`define	V_TOTAL	12'd525
`endif

//---------------------------------
//	800 * 600
`ifdef VGA_800_600_60FPS_40MHz 
`define	H_FRONT	12'd40
`define	H_SYNC 	12'd128  
`define	H_BACK 	12'd88  
`define	H_DISP 	12'd800
`define	H_TOTAL	12'd1056 
				
`define	V_FRONT	12'd1 
`define	V_SYNC 	12'd4   
`define	V_BACK 	12'd23  
`define	V_DISP 	12'd600  
`define	V_TOTAL	12'd628
`endif


//---------------------------------
//	1024*600 DSI (Dual Output)
`ifdef	DSI_1024_600_60FPS_50MHz
`define	H_FRONT	151
`define	H_SYNC 	1
`define	H_BACK 	1
`define	H_DISP	512
`define	H_TOTAL	1330
 				
`define	V_FRONT	12'd32
`define	V_SYNC 	12'd5   
`define	V_BACK 	12'd8 
`define	V_DISP 	12'd600   
`define	V_TOTAL	12'd645
`endif


//---------------------------------
//	1280 * 720
`ifdef	VGA_1280_720_60FPS_74_25MHz
`define	H_FRONT	12'd110
`define	H_SYNC 	12'd40
`define	H_BACK 	12'd220
`define	H_DISP	12'd1280
`define	H_DISP_REQ	12'd1280
`define	H_TOTAL	12'd1650
 				
`define	V_FRONT	12'd5
`define	V_SYNC 	12'd5   
`define	V_BACK 	12'd20 
`define	V_DISP 	12'd720   
`define	V_DISP_REQ 	12'd720  
`define	V_TOTAL	12'd750
`endif


//---------------------------------
//	1920 * 1080
`ifdef	VGA_1920_1080_60FPS_148_5MHz
`define	H_FRONT	12'd88
`define	H_SYNC 	12'd44
`define	H_BACK 	12'd148
`define	H_DISP	12'd1920
`define	H_TOTAL	12'd2200
 					
`define	V_FRONT	12'd4
`define	V_SYNC 	12'd5   
`define	V_BACK 	12'd36
//`define	V_FRONT	12'd3
//`define	V_SYNC 	12'd2
//`define	V_BACK 	12'd3
`define	V_DISP 	12'd1080 
`define	V_TOTAL	12'd1125
//`define	V_TOTAL	12'd1088
`endif


//---------------------------------
//	1024 * 600
`ifdef	VGA_1024_600_60FPS_50MHz
`define	H_FRONT	11'd160
`define	H_SYNC 	11'd40
`define	H_BACK 	11'd120
`define	H_DISP	11'd1024
`define	H_TOTAL	11'd1344
 					
`define	V_FRONT	11'd12 
`define	V_SYNC 	11'd3   
`define	V_BACK 	11'd20 
`define	V_DISP 	11'd600   
`define	V_TOTAL	11'd635
`endif


`ifdef	VGA_800_480_30FPS_16MHz
`define	H_FRONT	11'd80
`define	H_SYNC 	11'd32
`define	H_BACK 	11'd48
`define	H_DISP	11'd800
`define	H_TOTAL	11'd960
 					
`define	V_FRONT	11'd12 
`define	V_SYNC 	11'd3   
`define	V_BACK 	11'd5
`define	V_DISP 	11'd480
`define	V_TOTAL	11'd500
`endif


