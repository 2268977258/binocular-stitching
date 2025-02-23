/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )  
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2012-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Email Address 		: 		crazyfpga@qq.com
Filename			:		integer_divider.v
Date				:		2022-02-08
Description			:		Integer divider.
Modification History	:
Date			By			Version			Change Description
=========================================================================
22/02/08		CrazyBingo	1.0				Original
-------------------------------------------------------------------------
|                                     Oooo								|
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/  

`timescale 1ns/1ns
module	integer_divider
#(
	parameter		DEVIDE_CNT = 16'd651	//9600bps * 16
)
(
	//global clock
	input			clk,
	input			rst_n,
	
	//user interface
	output			divide_clken
);

//------------------------------------------------------
//RTL1: Precise fractional frequency for uart bps clock 
reg	[31:0]	cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 0;
	else
		cnt <= (cnt < DEVIDE_CNT - 1'b1) ? cnt + 1'b1 : 16'd0;		
end

assign divide_clken = (cnt == DEVIDE_CNT - 1'b1) ? 1'b1 : 1'b0;


endmodule
