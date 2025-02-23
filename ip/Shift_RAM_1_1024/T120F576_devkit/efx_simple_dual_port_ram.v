////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   tb_top.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /    
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// *******************************
// Revisions:
// 0.0 Initial rev
//
// *******************************

module efx_simple_dual_port_ram (
	//Trion and Titanium ports
	clk,		// clock input for one clock mode

	
	wclk, 		// Write clock input for two clock mode
	wclke,		// Write clock-enable input
    byteen,		// Byteen input 
    we, 		// Write-enable input
    waddr, 		// Write address input
    wdata,		// Write data input
  
	rclk, 		// Read clock input	for two clock mode
    re, 		// Read-enable input
    raddr, 		// Read address input
    rdata, 		// Read data output     
     
	//Titanium extra ports
	reset,		 // reset	
	waddren,	 // write address enable
	raddren		 // read address enable
);

//`include "bram_decompose.vh"

//Trion and Titanium parameters 
parameter CLK_POLARITY  = 1'b1; 		//clk polarity;  0:falling edge; 1:rising edge

parameter WCLK_POLARITY  = 1'b1; 		//wclk polarity;  0:falling edge; 1:rising edge
parameter WCLKE_POLARITY = 1'b1; 		//wclke polarity; 0:active low; 1:active high
parameter WE_POLARITY	 = 1'b1; 		//we polarity;    0:active low; 1:active high

parameter RCLK_POLARITY  = 1'b1; 		// rclk polarity; 0:falling edge; 1:rising edge
parameter RE_POLARITY    = 1'b1; 		// re polarity;	  0:active low  ; 1:active high
parameter OUTPUT_REG     = 1'b0; 		// Output register enable; 1:add pipe-line read register

parameter BYTEEN_POLARITY = 1'b1;		//byteen polarity;    0:active low; 1:active high   

//Port Enable  
parameter CLK_MODE			= 2;		//1: ONE CLK Mode; CLK pin will provide the clock source to the memory
										//2: TWO CLK Mode; wclk pin will provide the clock source for write operation ; rclk pin will provide the clock source for read operation
parameter WCLKE_ENABLE 		= 1'b1; 	//1: Enalbe the port for waddren pin  ; 0: dislable 

parameter WE_ENABLE 		= 1'b1;		//1: Enable the port for WE pin ; 0: disable 
parameter RE_ENABLE 		= 1'b1;		//1: Enable the port for RE pin ; 0: disable 
parameter BYTEEN_ENABLE 	= 1'b1;		//1: Enable the port for Byteen pins ; 0: disable 

//Titanium extra paramters 
parameter RST_POLARITY 	    = 1'b1;    	// rst polarity
parameter RESET_RAM 	    = "ASYNC"; 	// reset mode on ram;  "NONE": RST signals does not affect the RAM output.
										//					  "ASYNC": RAM output resets asynchronously to RCLK.
										//                     "SYNC": RAM output resets synchronously to RCLK. 
parameter RESET_OUTREG 	    = "ASYNC"; 	// reset mode on output register
										//					   "NONE": RST signals does not affect the RAM output register		
										//					  "ASYNC": RAM output register resets asynchronously to RCLK.
parameter WADDREN_POLARITY  = 1'b1;    	// waddren polarity
parameter RADDREN_POLARITY  = 1'b1;     // raddren polarity


//Port Enable  
parameter RESET_ENABLE 		= 1'b1;		//1: Enable the port for reset pin  ; 0: disable 
	
parameter WADDREN_ENABLE 	= 1'b1;		//1: Enable the port for waddren pin  ; 0: disable 
parameter RADDREN_ENABLE 	= 1;		//1: Enable the port for raddren pin  ; 0: disable 

parameter WRITE_MODE            = "READ_FIRST";

parameter DATA_WIDTH_A          = 16;
parameter DATA_WIDTH_B          = 16;
parameter ADDR_WIDTH_A          = 3;
parameter ADDR_WIDTH_B          = 3;
parameter BYTEEN_WIDTH          = 2;
parameter FAMILY                = "TITANIUM";

//Trion and Titanium ports
input clk;

input wclk;
input wclke;
input [BYTEEN_WIDTH-1:0] byteen;
input we;
input [ADDR_WIDTH_A-1:0] waddr;
input [DATA_WIDTH_A-1:0] wdata;

input rclk; 
input re;
input [ADDR_WIDTH_B-1:0] raddr;
output [DATA_WIDTH_B-1:0] rdata;

//Titanium extra ports
input reset;	
input waddren;
input raddren;

//localparam WRITE_MODE  	 = DECOMPOSE_WRITE_MODE;  // 				  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
											//				  "READ_UNKNOWN": Read and writes are unsynchronized, therefore, the results of the address can conflict.


wire w_wclk;
wire w_rclk;
wire w_wclke;
wire [BYTEEN_WIDTH-1:0] w_byteen;
wire w_we;
wire w_re;
wire w_reset;
wire w_waddren;
wire w_raddren;

assign w_wclk = (CLK_MODE==2) ? wclk : clk;
assign w_rclk = (CLK_MODE==2) ? rclk : clk;
assign w_wclke = (WCLKE_ENABLE==1) ? wclke : WCLKE_POLARITY;
assign w_byteen= (BYTEEN_ENABLE==1) ? byteen : {BYTEEN_WIDTH{BYTEEN_POLARITY}};
assign w_we   = (WE_ENABLE==1)  ? we : WE_POLARITY;
assign w_re   = (RE_ENABLE==1)  ? re : RE_POLARITY;

//Titanium extra ports
assign w_reset   = (RESET_ENABLE==1)  ? reset   : (RST_POLARITY==1'b1) ? 1'b0: 1'b1;
assign w_waddren = (WADDREN_ENABLE==1)? waddren : WADDREN_POLARITY;
assign w_raddren = (RADDREN_ENABLE==1)? raddren : RADDREN_POLARITY;


localparam WCLK_POLARITY_LC = (CLK_MODE==2) ? WCLK_POLARITY : CLK_POLARITY;
localparam RCLK_POLARITY_LC = (CLK_MODE==2) ? RCLK_POLARITY : CLK_POLARITY;



 	bram_wrapper_mwm #(
		//Trion and Titanium parameters 
		.WCLK_POLARITY(WCLK_POLARITY_LC), 	
		.WCLKE_POLARITY(WCLKE_POLARITY),
		.WE_POLARITY(WE_POLARITY), 		
		.WRITE_MODE(WRITE_MODE),		
				
		.RCLK_POLARITY(RCLK_POLARITY_LC), 	
		.RE_POLARITY(RE_POLARITY), 		
		.OUTPUT_REG(OUTPUT_REG),		
		
		.BYTEEN_POLARITY(BYTEEN_POLARITY),
		
		.DATA_WIDTH_A(DATA_WIDTH_A),
		.DATA_WIDTH_B(DATA_WIDTH_B),
		.ADDR_WIDTH_A(ADDR_WIDTH_A),
		.ADDR_WIDTH_B(ADDR_WIDTH_B),
		.BYTEEN_WIDTH(BYTEEN_WIDTH),
		.FAMILY(FAMILY),
		
		//Titanium extra paramters 
		.RST_POLARITY(RST_POLARITY),   	
		.RESET_RAM(RESET_RAM), 			
		.RESET_OUTREG(RESET_OUTREG), 	
		.WADDREN_POLARITY(WADDREN_POLARITY),
		.RADDREN_POLARITY(RADDREN_POLARITY)
		
	) brams (
		.wclk(w_wclk), 
		.wclke(w_wclke),
		.we(w_we), 
		.byteen(w_byteen),
        
        .waddr(waddr), 
		.wdata(wdata),
          
		.rclk(w_rclk), 
		.re(w_re), 
		.raddr(raddr), 
		.rdata(rdata),
		      
        
		//Titanium extra ports
		.reset(w_reset), 	// reset	
		.waddren(w_waddren), // write address enable
		.raddren(w_raddren)  // read address enable	
	);
 
 
endmodule