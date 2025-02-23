////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   bram_primitive.v
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

module bram_primitive #(
	parameter FAMILY = "TITANIUM",	
	
	//Trion and Titanium parameters 
	parameter WRITE_WIDTH	 = 16, 			// write width
	parameter WCLK_POLARITY  = 1'b1, 		//wclk polarity,  0:falling edge, 1:rising edge
	parameter WCLKE_POLARITY = 1'b1, 		//wclke polarity, 0:active low, 1:active high
	parameter WE_POLARITY	 = 1'b1, 		//we polarity,    0:active low, 1:active high
	parameter WRITE_MODE  	 = "READ_FIRST",//write mode,  	  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
											//				  "READ_UNKNOWN": Read and writes are unsynchronized, therefore, the results of the address can conflict.
	parameter READ_WIDTH	 = 16,   		// read width
	parameter RCLK_POLARITY  = 1'b1, 		// rclk polarity, 0:falling edge, 1:rising edge
	parameter RE_POLARITY    = 1'b1, 		// re polarity,	  0:active low  , 1:active high
	parameter OUTPUT_REG     = 1'b0, 		// Output register enable, 1:add pipe-line read register

	//Titanium extra paramters 
	parameter RST_POLARITY 	    = 1'b1,    	// rst polarity
	parameter RESET_RAM 	    = "ASYNC", 	// reset mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG 	    = "ASYNC", 	// reset mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter WADDREN_POLARITY  = 1'b1,    	// waddren polarity
	parameter RADDREN_POLARITY  = 1'b1,   	// raddren polarity

	//Titanium Option for byte enable in WEN width = 2 when it is Mode 512x16 or  512x20
	parameter WEN_WIDTH			= 1,
	
	parameter ini_index	 		= 0
						
)   
(
	//Trion and Titanium ports
	WCLK, // Write clock input
	WCLKE, // Write clock-enable input
	WE,    // Write-enable input
	WADDR, // Write address input
	WDATA, // Write data input
	
	RCLK, 	// Read clock input
	RE, 		// Read-enable input
	RADDR, // Read address input
	RDATA, // Read data output

	//Titanium extra ports
    RST, 	  // reset	
	WADDREN,  // write address enable
	RADDREN  // read address enable
						
 );
function integer address_map;
input integer index;//Input data width parameter 
input integer type_; //Mapped data width, Mapped Address Width for Ram 5K(Trion), Mapped Address Width for Ram 10K(Titanium), WEN width for Ram 5K(Trion),  WEN width for Ram 10K(Titanium)
case (index)
0	: address_map=	(type_==0)?	1	:(type_==1)?	12	:(type_==2)?	13	:1;
1	: address_map=	(type_==0)?	1	:(type_==1)?	12	:(type_==2)?	13	:1;
2	: address_map=	(type_==0)?	2	:(type_==1)?	11	:(type_==2)?	12	:1;
3	: address_map=	(type_==0)?	4	:(type_==1)?	10	:(type_==2)?	11	:1;
4	: address_map=	(type_==0)?	4	:(type_==1)?	10	:(type_==2)?	11	:1;
5	: address_map=	(type_==0)?	5	:(type_==1)?	10	:(type_==2)?	11	:1;
6	: address_map=	(type_==0)?	8	:(type_==1)?	9	:(type_==2)?	10	:1;
7	: address_map=	(type_==0)?	8	:(type_==1)?	9	:(type_==2)?	10	:1;
8	: address_map=	(type_==0)?	8	:(type_==1)?	9	:(type_==2)?	10	:1;
9	: address_map=	(type_==0)?	10	:(type_==1)?	9	:(type_==2)?	10	:1;
10	: address_map=	(type_==0)?	10	:(type_==1)?	9	:(type_==2)?	10	:1;
11	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
12	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
13	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
14	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
15	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
16	: address_map=	(type_==0)?	16	:(type_==1)?	8	:(type_==2)?	9	:1;
17	: address_map=	(type_==0)?	20	:(type_==1)?	8	:(type_==2)?	9	:1;
18	: address_map=	(type_==0)?	20	:(type_==1)?	8	:(type_==2)?	9	:1;
19	: address_map=	(type_==0)?	20	:(type_==1)?	8	:(type_==2)?	9	:1;
20	: address_map=	(type_==0)?	20	:(type_==1)?	8	:(type_==2)?	9	:1;
   endcase
endfunction  

localparam  WRITE_DATA_WIDTH		= 	address_map(WRITE_WIDTH,0);
localparam  WRITE_ADDRESS_WIDTH     = 	address_map(WRITE_WIDTH,(FAMILY=="TRION")?1:2);

localparam  READ_DATA_WIDTH			= 	address_map(READ_WIDTH,0);
localparam  READ_ADDRESS_WIDTH     	= 	address_map(READ_WIDTH,(FAMILY=="TRION")?1:2);


//Trion and Titanium ports
input WCLK;  // Write clock input
input WCLKE; // Write clock-enable input
input [WEN_WIDTH-1:0] WE; 	 // Write-enable input
input [WRITE_ADDRESS_WIDTH-1:0] WADDR; // Write address input
input [WRITE_DATA_WIDTH-1:0] WDATA; // Write data input
	
input RCLK;  // Read clock input
input RE; 	 // Read-enable input
input [READ_ADDRESS_WIDTH-1:0] RADDR; // Read address input
output[READ_DATA_WIDTH-1:0]RDATA; // Read data output

//Titanium extra ports
input RST; 	  // reset	
input WADDREN;  // write address enable
input RADDREN;  // read address enable


`include "bram_ini.vh"
parameter filePath = "bram_ini.vh";
integer fd;
 
    generate 
       initial begin  
	   fd = $fopen(filePath, "r");  
            $fclose(fd);  
	   end 
    
    
		if (FAMILY=="TRION")
		begin
			EFX_RAM_5K # (
				.WRITE_WIDTH	(WRITE_WIDTH), 
				.WCLK_POLARITY  (WCLK_POLARITY), 
				.WCLKE_POLARITY (WCLKE_POLARITY), 
				.WE_POLARITY	(WE_POLARITY), 
				.WRITE_MODE  	(WRITE_MODE), 
															
				.READ_WIDTH	    (READ_WIDTH),
				.RCLK_POLARITY  (RCLK_POLARITY),
				.RE_POLARITY    (RE_POLARITY),
				.OUTPUT_REG     (OUTPUT_REG),
				
			
				.INIT_0  (bram_ini_table(ini_index,16'h0 )), 
				.INIT_1  (bram_ini_table(ini_index,16'h1 )),
				.INIT_2  (bram_ini_table(ini_index,16'h2 )),
				.INIT_3  (bram_ini_table(ini_index,16'h3 )),
				.INIT_4  (bram_ini_table(ini_index,16'h4 )),
				.INIT_5  (bram_ini_table(ini_index,16'h5 )),
				.INIT_6  (bram_ini_table(ini_index,16'h6 )),
				.INIT_7  (bram_ini_table(ini_index,16'h7 )),
				.INIT_8  (bram_ini_table(ini_index,16'h8 )),
				.INIT_9  (bram_ini_table(ini_index,16'h9 )),
				.INIT_A  (bram_ini_table(ini_index,16'hA )),
				.INIT_B  (bram_ini_table(ini_index,16'hB )),
				.INIT_C  (bram_ini_table(ini_index,16'hC )),
				.INIT_D  (bram_ini_table(ini_index,16'hD )),
				.INIT_E  (bram_ini_table(ini_index,16'hE )),
				.INIT_F  (bram_ini_table(ini_index,16'hF )),
				.INIT_10 (bram_ini_table(ini_index,16'h10)),
				.INIT_11 (bram_ini_table(ini_index,16'h11)),
				.INIT_12 (bram_ini_table(ini_index,16'h12)),
				.INIT_13 (bram_ini_table(ini_index,16'h13))
			) 
			 ram5k (
				.WCLK(WCLK), // Write clock input
				.WE(WE[0]), // Write-enable input
				.WCLKE(WCLKE), // Write clock-enable input
				.WADDR(WADDR), // Write address input
				.WDATA(WDATA), // Write data input

				.RCLK(RCLK), 	// Read clock input
				.RE(RE), 		// Read-enable input
				.RADDR(RADDR), // Read address input
				.RDATA(RDATA)  // Read data output
			);
		end 
		else 
		begin 
		
			wire [1:0]w_wen_ram10;
			assign w_wen_ram10[0] = WE[0];
			
			if (WEN_WIDTH>1)
				assign w_wen_ram10[1] = WE[1];
			else if (WRITE_DATA_WIDTH >= 16 )
				assign w_wen_ram10[1] = WE[0];
			else 	
				assign w_wen_ram10[1] = 1'b0;
			
			EFX_RAM10 # (
			
				.WRITE_WIDTH	(WRITE_WIDTH), 
				.WCLK_POLARITY  (WCLK_POLARITY), 
				.WCLKE_POLARITY (WCLKE_POLARITY), 
				.WE_POLARITY	({2{WE_POLARITY}}), 
				.WRITE_MODE  	(WRITE_MODE), 
															
				.READ_WIDTH	    (READ_WIDTH),
				.RCLK_POLARITY  (RCLK_POLARITY),
				.RE_POLARITY    (RE_POLARITY),
				.OUTPUT_REG     (OUTPUT_REG),
			
				//Titanium extra paramters 
				.RST_POLARITY 	(RST_POLARITY),    // rst polarity
				.RESET_RAM 	    (RESET_RAM), // reset mode on ram
				.RESET_OUTREG 	(RESET_OUTREG), // reset mode on output register
				.WADDREN_POLARITY  (WADDREN_POLARITY),    // waddren polarity
				.RADDREN_POLARITY  (RADDREN_POLARITY),     // raddren polarity
				
				
				.INIT_0  (bram_ini_table(ini_index, 16'h0 )), 
				.INIT_1  (bram_ini_table(ini_index, 16'h1 )),
				.INIT_2  (bram_ini_table(ini_index, 16'h2 )),
				.INIT_3  (bram_ini_table(ini_index, 16'h3 )),
				.INIT_4  (bram_ini_table(ini_index, 16'h4 )),
				.INIT_5  (bram_ini_table(ini_index, 16'h5 )),
				.INIT_6  (bram_ini_table(ini_index, 16'h6 )),
				.INIT_7  (bram_ini_table(ini_index, 16'h7 )),
				.INIT_8  (bram_ini_table(ini_index, 16'h8 )),
				.INIT_9  (bram_ini_table(ini_index, 16'h9 )),
				.INIT_A  (bram_ini_table(ini_index, 16'hA )),
				.INIT_B  (bram_ini_table(ini_index, 16'hB )),
				.INIT_C  (bram_ini_table(ini_index, 16'hC )),
				.INIT_D  (bram_ini_table(ini_index, 16'hD )),
				.INIT_E  (bram_ini_table(ini_index, 16'hE )),
				.INIT_F  (bram_ini_table(ini_index, 16'hF )),
				.INIT_10 (bram_ini_table(ini_index, 16'h10)),
				.INIT_11 (bram_ini_table(ini_index, 16'h11)),
				.INIT_12 (bram_ini_table(ini_index, 16'h12)),
				.INIT_13 (bram_ini_table(ini_index, 16'h13)),
				.INIT_14 (bram_ini_table(ini_index, 16'h14)),
				.INIT_15 (bram_ini_table(ini_index, 16'h15)),
				.INIT_16 (bram_ini_table(ini_index, 16'h16)),
				.INIT_17 (bram_ini_table(ini_index, 16'h17)),
				.INIT_18 (bram_ini_table(ini_index, 16'h18)),
				.INIT_19 (bram_ini_table(ini_index, 16'h19)),
				.INIT_1A (bram_ini_table(ini_index, 16'h1A)),
				.INIT_1B (bram_ini_table(ini_index, 16'h1B)),
				.INIT_1C (bram_ini_table(ini_index, 16'h1C)),
				.INIT_1D (bram_ini_table(ini_index, 16'h1D)),
				.INIT_1E (bram_ini_table(ini_index, 16'h1E)),
				.INIT_1F (bram_ini_table(ini_index, 16'h1F)),
				.INIT_20 (bram_ini_table(ini_index, 16'h20)),
				.INIT_21 (bram_ini_table(ini_index, 16'h21)),
				.INIT_22 (bram_ini_table(ini_index, 16'h22)),
				.INIT_23 (bram_ini_table(ini_index, 16'h23)),
				.INIT_24 (bram_ini_table(ini_index, 16'h24)),
				.INIT_25 (bram_ini_table(ini_index, 16'h25)),
				.INIT_26 (bram_ini_table(ini_index, 16'h26)),
				.INIT_27 (bram_ini_table(ini_index, 16'h27))
		
			)
			ram10k(
			
				.WCLK(WCLK), // Write clock input
				.WE(w_wen_ram10), // Write-enable input
				.WCLKE(WCLKE), // Write clock-enable input
				.WADDR(WADDR), // Write address input
				.WDATA(WDATA), // Write data input
							
				.RCLK(RCLK), 	// Read clock input
				.RE(RE), 		// Read-enable input
				.RADDR(RADDR), // Read address input
				.RDATA(RDATA), // Read data output
			
                //Titanium extra ports 
				.RST (RST), 		// reset
				.WADDREN (WADDREN), // write address enable
				.RADDREN (RADDREN)  // read address enable

			);
		end
	endgenerate 
      
endmodule