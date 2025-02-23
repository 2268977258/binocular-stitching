//////////////////////////////////////////////////////////////////////////////
//
//  Xilinx, Inc. 2008                 www.xilinx.com
//
//////////////////////////////////////////////////////////////////////////////
//  File name :       encode.v
//  Description :     TMDS encoder  
//  Author :          Bob Feng
//////////////////////////////////////////////////////////////////////////////  


`timescale 1 ps / 1ps
module hdmi_tx_ip
(
	input           pixelclk,       // system clock
	input           pixelclk5x,     // system clock x5
	input           rstin,          // reset
	input[7:0]      blue_din,       // Blue data in
	input[7:0]      green_din,      // Green data in
	input[7:0]      red_din,        // Red data in
	input           hsync,          // hsync data
	input           vsync,          // vsync data
	input           de,             // data enable
//	output [2:0]	dataout_h,
//	output [2:0]	dataout_l,
//	output			clk_h,
//	output			clk_l,
	output [2:0]    data_p_h,
	output [2:0]    data_p_l,
	output 		    clk_p_h ,
	output 		    clk_p_l ,
	output [2:0]    data_n_h,
	output [2:0]    data_n_l,
	output 		    clk_n_h ,
	output 		    clk_n_l ,
	
	output 	[9:0] 	txc_o, 
	output 	[9:0] 	txd0_o, 
	output 	[9:0] 	txd1_o, 
	output 	[9:0] 	txd2_o
);

wire    [9:0]   red ;
wire    [9:0]   green ;
wire    [9:0]   blue ;

	
	wire 	[3:0] 	w_ctl = 4'b0000; 
	
	tmds_channel enc_0 (
		.clk_pixel			(pixelclk),
		.video_data			(blue_din),
		.data_island_data		(0),
		.control_data		({vsync, hsync}),
		.mode				({3'b0, de}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(blue)
	);
	tmds_channel enc_1 (
		.clk_pixel			(pixelclk),
		.video_data			(green_din),
		.data_island_data		(0),
		.control_data		(w_ctl[1:0]),
		.mode				({3'b0, de}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(green)
	);
	tmds_channel enc_2 (
		.clk_pixel			(pixelclk),
		.video_data			(red_din),
		.data_island_data		(0),
		.control_data		(w_ctl[3:2]),
		.mode				({3'b0, de}),  // Mode select (0 = control, 1 = video, 2 = video guard, 3 = island, 4 = island guard)
		.tmds				(red)
	);

	//encode encb (
	//.clkin      (pixelclk),
	//.rstin      (rstin),
	//.din        (blue_din),
	//.c0         (hsync),
	//.c1         (vsync),
	//.de         (de),
	//.dout       (blue)) ;
	//
	//encode encr (
	//.clkin      (pixelclk),
	//.rstin      (rstin),
	//.din        (green_din),
	//.c0         (1'b0),
	//.c1         (1'b0),
	//.de         (de),
	//.dout       (green)) ;
	//
	//encode encg (
	//.clkin      (pixelclk),
	//.rstin      (rstin),
	//.din        (red_din),
	//.c0         (1'b0),
	//.c1         (1'b0),
	//.de         (de),
	//.dout       (red)) ;

serdes_4b_10to1 serdes_4b_10to1_m0(
	.clk         (pixelclk        ),// clock input
	.clkx5       (pixelclk5x      ),// 5x clock input
	.data_b      (blue            ),// input data for serialisation
	.data_g      (green           ),// input data for serialisation
	.data_r      (red             ),// input data for serialisation
	.data_c      (10'b1111100000  ),// input data for serialisation
	.dataout_h 	 (),//(dataout_h 	),
	.dataout_l 	 (),//(dataout_l 	),
	.clk_h 		 (),//(clk_h 		),
	.clk_l  	 (),//(clk_l  		)

	.data_p_h	(data_p_h),
	.data_p_l	(data_p_l),
	.clk_p_h 	(clk_p_h ),
	.clk_p_l 	(clk_p_l ),
	.data_n_h	(data_n_h),
	.data_n_l	(data_n_l),
	.clk_n_h 	(clk_n_h ),
	.clk_n_l 	(clk_n_l )
  ) ; 

	assign txc_o = 10'b1111100000;
	assign txd0_o = blue;
	assign txd1_o = green;
	assign txd2_o = red; 

endmodule
