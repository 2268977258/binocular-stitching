/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.www.cnblogs.com/crazybingo
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		I2C_MT9M001_Gray_Config.v
Author				:		CrazyBingo
Date				:		2012-05-11
Version				:		1.0
Description			:		I2C Configure Data of MT9M001.
Modification History	:
Date			By			Version			Change Description
===========================================================================
12/05/11		CrazyBingo	1.0				Original
12/05/13		CrazyBingo	1.1				Modification
12/06/01		CrazyBingo	1.4				Modification
12/06/05		CrazyBingo	1.5				Modification
13/04/08		CrazyBingo	1.6				Modification
17/08/12		CrazyBingo	2.0				Modification for MT9M001 V1.0
--------------------------------------------------------------------------*/

`timescale 1ns/1ns
module	I2C_MT9M001_Gray_Config
(
	input		[7:0]	LUT_INDEX,
	output	reg	[23:0]	LUT_DATA,
	output		[7:0]	LUT_SIZE
);

//---------------------------------------------
//  LUT size
assign  LUT_SIZE = 8'd12;

//---------------------------------------------
//  Config Data LUT
always@(*)
begin
    case(LUT_INDEX)
        0   :   LUT_DATA = {24'h0D_0001};	//Reset
        1   :   LUT_DATA = {24'h0D_0000};
        2   :   LUT_DATA = {24'h09_0419};	//Shutter Width, 	Default 0x0419(1049)
        3   :   LUT_DATA = {24'h0C_0000};	//Shutter Delay,	Default 0x0000
        4   :   LUT_DATA = {24'h01_00A4};	//Row Start, 		Default 0x000C,	12+(1024-720)/2=164
        5   :   LUT_DATA = {24'h02_0014};	//Column Start, 	Default 0x0014
        6   :   LUT_DATA = {24'h03_02CF};	//Row Width, 		Default 0x03FF,	0x02CF = 720  - 1
        7   :   LUT_DATA = {24'h04_04FF};	//Column Width, 	Default	0x04FF,	0x3FFF = 1280 - 1
        8   :   LUT_DATA = {24'h20_D104};	//Read Option1,		Defalut 0x1104,	bit[15:14] is for Row/col mirror
		
        9   :   LUT_DATA = {8'h09, 16'd960};//Shutter Width, 	Default 0x0419 = 1049
        10  :   LUT_DATA = {24'h0C_0082};	//Shutter Delay,	Default 0x0000
		
		11	:	LUT_DATA = {24'h35_0020};	//Global Gain,		Default 0x0008;	0x08-0x20:1-4;0x51-0x60:4.25-8;0x61-0x67:9-15
        default :   LUT_DATA = {24'h0D0000};
    endcase
end



endmodule


