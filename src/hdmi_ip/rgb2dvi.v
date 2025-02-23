`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    11:23:23 02/27/2022 
// Module Name:    rgb2dvi 
//////////////////////////////////////////////////////////////////////////////////

module rgb2dvi #(
	parameter 	ENABLE_OSERDES 	= 1		
)(
	//	Pixel Clock (1X). 
	input 			PixelClk,
	input 			aRst,
	input 			aRst_n, 
	
	input 	[3:0] 	bitflip_i,		//	LVDS Lane Flip. [3]TXC, [2:0]TXD
	input 			oe_i, 		//	Output Enable. 
	
	//	Video Timing Generator (With Data Valid Control)
	input 			vid_pVSync,		//	VSync. High Valid. 
	input 			vid_pHSync,		//	HSync. High Valid. 
	input 			vid_pVDE, 		//	DataValid (Timing). Must be WIDTH + 2. (de & ~dvalid) will send VLG. 
	input 	[23:0] 	vid_pData,		//	RGB Data. [7:0]B(0), [15:8]G(1), [23:16]R(2). 
	
	//	HDMI Serializer (5X). 
	input 	 		SerialClk, 
	output 			TMDS_Clk_p,
	output 			TMDS_Clk_n,
	output 	[2:0] 	TMDS_Data_p,
	output 	[2:0] 	TMDS_Data_n,
	
	output 	[9:0] 	txc_o, 
	output 	[9:0] 	txd0_o, 
	output 	[9:0] 	txd1_o, 
	output 	[9:0] 	txd2_o
);
	
	wire 			w_rst = aRst || (~aRst_n); 
	
	wire 	[3:0] 	w_ctl = 4'b0000; 
	
	//////////////////////////////////////////////////////////////////////////////////
	//	TMDS Encoder
	//////////////////////////////////////////////////////////////////////////////////
	
	wire 	[9:0] 	w_tmds_0_enc, w_tmds_1_enc, w_tmds_2_enc; 
	
	tmds_channel enc_0 (
		.clk_pixel			(PixelClk),
		.video_data			(vid_pData[ 7: 0]),
		.data_island_data		(0),
		.control_data		({vid_pVSync, vid_pHSync}),
		.mode				({3'b0, vid_pVDE}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_0_enc)
	);
	tmds_channel enc_1 (
		.clk_pixel			(PixelClk),
		.video_data			(vid_pData[15: 8]),
		.data_island_data		(0),
		.control_data		(w_ctl[1:0]),
		.mode				({3'b0, vid_pVDE}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_1_enc)
	);
	tmds_channel enc_2 (
		.clk_pixel			(PixelClk),
		.video_data			(vid_pData[23:16]),
		.data_island_data		(0),
		.control_data		(w_ctl[3:2]),
		.mode				({3'b0, vid_pVDE}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(w_tmds_2_enc)
	);
	
	
	//////////////////////////////////////////////////////////////////////////////////
	//	Serializer
	//////////////////////////////////////////////////////////////////////////////////
	
	assign txc_o = 10'b1111100000;
	assign txd0_o = w_tmds_0_enc;
	assign txd1_o = w_tmds_1_enc;
	assign txd2_o = w_tmds_2_enc; 
	
	
	
endmodule
