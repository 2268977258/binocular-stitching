`timescale 1ns/1ps

//`include "ddr3_controller.vh"


module example_top 
(
	////////////////////////////////////////////////////////////////
	//	External Clock & Reset
	//input 			nrst, 			//	Button K2
	input 			clk_24m,			//	24MHz Crystal
	input 			clk_25m,			//	25MHz Crystal 
	
	
	////////////////////////////////////////////////////////////////
	//	System Clock
	output 			sys_pll_rstn_o, 		
	
	input 			clk_sys,			//	Sys PLL 96MHz 
	input 			clk_pixel,			//	Sys PLL 74.25MHz
	input 			clk_pixel_2x,		//	Sys PLL 148.5MHz
	input 			clk_pixel_10x,		//	Sys PLL 742.5MHz
	
	input 			sys_pll_lock,		//	Sys PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	MIPI-DSI Clock & Reset
	output 			dsi_pll_rstn_o,
	
	input 			dsi_refclk_i,		//	48MHz Reference Clock (for DSI PLL)
	input 			dsi_byteclk_i,		//	DSI Byte Clock (1X)
	input 			dsi_serclk_i,		//	DSI Serial Clock (4X 45)
	input 			dsi_txcclk_i,		//	DSI Serial Clock (4X 135)
	
	input 			dsi_pll_lock,
	
	////////////////////////////////////////////////////////////////
	//	DDR Clock
	output 			ddr_pll_rstn_o, 
	
	input 			tdqss_clk,			
	input 			core_clk,			//	DDR PLL 200MHz
	input 			tac_clk,			
	input 			twd_clk,			
	
	input 			ddr_pll_lock,		//	DDR PLL Lock
	
	////////////////////////////////////////////////////////////////
	//	DDR PLL Phase Shift Interface
	output 	[2:0] 	shift,
	output 	[4:0] 	shift_sel,
	output 			shift_ena,
	
	
	
	////////////////////////////////////////////////////////////////
	//	LVDS Clock
	output 			lvds_pll_rstn_o, 
	
	input 			clk_lvds_1x, 
	input 			clk_lvds_7x, 
	input 			clk_27m, 			//	RGB 1X Clock (16MHz)
	input 			clk_54m, 			//	RGB 2X Clock (32MHz, for export control)
	
	input 			lvds_pll_lock, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	DDR Interface Ports
	output 	[15:0] 	addr,
	output 	[2:0] 	ba,
	output 			we,
	output 			reset,
	output 			ras,
	output 			cas,
	output 			odt,
	output 			cke,
	output 			cs,
	
	//	DQ I/O
	input 	[15:0] 	i_dq_hi,
	input 	[15:0] 	i_dq_lo,
	
	output 	[15:0] 	o_dq_hi,
	output 	[15:0] 	o_dq_lo,
	output 	[15:0] 	o_dq_oe,
	
	//	DM O
	output 	[1:0] 	o_dm_hi,
	output 	[1:0] 	o_dm_lo,
	
	//	DQS I/O
	input 	[1:0] 	i_dqs_hi,
	input 	[1:0] 	i_dqs_lo,
	
	input 	[1:0] 	i_dqs_n_hi,
	input 	[1:0] 	i_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_hi,
	output 	[1:0] 	o_dqs_lo,
	
	output 	[1:0] 	o_dqs_n_hi,
	output 	[1:0] 	o_dqs_n_lo,
	
	output 	[1:0] 	o_dqs_oe,
	output 	[1:0] 	o_dqs_n_oe,
	
	//	CK
	output 			clk_p_hi, 
	output 			clk_p_lo, 
	output 			clk_n_hi, 
	output 			clk_n_lo, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	MIPI-CSI Ctl / I2C
	output 			csi_ctl0_o,
	output 			csi_ctl0_oe,
	input 			csi_ctl0_i,
	
	output 			csi_ctl1_o,
	output 			csi_ctl1_oe,
	input 			csi_ctl1_i,
	
	output 			csi_scl_o,
	output 			csi_scl_oe,
	input 			csi_scl_i,
	
	output 			csi_sda_o,
	output 			csi_sda_oe,
	input 			csi_sda_i,
	
	//	MIPI-CSI RXC 
	input 			csi_rxc_lp_p_i,
	input 			csi_rxc_lp_n_i,
	output 			csi_rxc_hs_en_o,
	output 			csi_rxc_hs_term_en_o,
	input 			csi_rxc_i,
	
	//	MIPI-CSI RXD0
	output 			csi_rxd0_rst_o,
	output 			csi_rxd0_hs_en_o,
	output 			csi_rxd0_hs_term_en_o,
	
	input 			csi_rxd0_lp_p_i,
	input 			csi_rxd0_lp_n_i,
	input 	[7:0] 	csi_rxd0_hs_i,
	
	//	MIPI-CSI RXD1
	output 			csi_rxd1_rst_o,
	output 			csi_rxd1_hs_en_o,
	output 			csi_rxd1_hs_term_en_o,
	
	input 			csi_rxd1_lp_n_i,
	input 			csi_rxd1_lp_p_i,
	input 	[7:0] 	csi_rxd1_hs_i,
	
	//	MIPI-CSI RXD2
	output 			csi_rxd2_rst_o,
	output 			csi_rxd2_hs_en_o,
	output 			csi_rxd2_hs_term_en_o,
	
	input 			csi_rxd2_lp_p_i,
	input 			csi_rxd2_lp_n_i,
	input 	[7:0] 	csi_rxd2_hs_i,
	
	//	MIPI-CSI RXD3
	output 			csi_rxd3_rst_o,
	output 			csi_rxd3_hs_en_o,
	output 			csi_rxd3_hs_term_en_o,
	
	input 			csi_rxd3_lp_p_i,
	input 			csi_rxd3_lp_n_i,
	input 	[7:0] 	csi_rxd3_hs_i,
	
	//output 			csi_rxd0_fifo_rd_o, 
	//input 			csi_rxd0_fifo_empty_i, 
	//output 			csi_rxd1_fifo_rd_o, 
	//input 			csi_rxd1_fifo_empty_i, 
	//output 			csi_rxd2_fifo_rd_o, 
	//input 			csi_rxd2_fifo_empty_i, 
	//output 			csi_rxd3_fifo_rd_o, 
	//input 			csi_rxd3_fifo_empty_i, 
	
	
	
	////////////////////////////////////////////////////////////////
	//	DSI PWM & Reset Control 
	output 			dsi_pwm_o,			//	MIPI-DSI LCD PWM
	output 			dsi_resetn_o,		//	MIPI-DSI LCD Reset
	
	//	MIPI-DSI TXC / TXD
	output 			dsi_txc_rst_o,
	output 			dsi_txc_lp_p_oe,
	output 			dsi_txc_lp_p_o,
	output 			dsi_txc_lp_n_oe,
	output 			dsi_txc_lp_n_o,
	output 			dsi_txc_hs_oe,
	output 	[7:0] 	dsi_txc_hs_o,
	
	output 			dsi_txd0_rst_o,
	output 			dsi_txd0_hs_oe,
	output 	[7:0] 	dsi_txd0_hs_o,
	output 			dsi_txd0_lp_p_oe,
	output 			dsi_txd0_lp_p_o,
	output 			dsi_txd0_lp_n_oe,
	output 			dsi_txd0_lp_n_o,
	
	output 			dsi_txd1_rst_o,
	output 			dsi_txd1_lp_p_oe,
	output 			dsi_txd1_lp_p_o,
	output 			dsi_txd1_lp_n_oe,
	output 			dsi_txd1_lp_n_o,
	output 			dsi_txd1_hs_oe,
	output 	[7:0] 	dsi_txd1_hs_o,
	
	output 			dsi_txd2_rst_o,
	output 			dsi_txd2_lp_p_oe,
	output 			dsi_txd2_lp_p_o,
	output 			dsi_txd2_lp_n_oe,
	output 			dsi_txd2_lp_n_o,
	output 			dsi_txd2_hs_oe,
	output 	[7:0] 	dsi_txd2_hs_o,
	
	output 			dsi_txd3_rst_o,
	output 			dsi_txd3_lp_p_oe,
	output 			dsi_txd3_lp_p_o,
	output 			dsi_txd3_lp_n_oe,
	output 			dsi_txd3_lp_n_o,
	output 			dsi_txd3_hs_oe,
	output 	[7:0] 	dsi_txd3_hs_o,
	
	input 			dsi_txd0_lp_p_i,
	input 			dsi_txd0_lp_n_i,
	input 			dsi_txd1_lp_p_i,
	input 			dsi_txd1_lp_n_i,
	input 			dsi_txd2_lp_p_i,
	input 			dsi_txd2_lp_n_i,
	input 			dsi_txd3_lp_p_i,
	input 			dsi_txd3_lp_n_i,
	
	
	////////////////////////////////////////////////////////////////
	//	UART Interface
	input 		 	uart_rx_i,			//	Support 460800-8-N-1. 
	output 		 	uart_tx_o, 
	
	
	output 	[5:0] 	led_o,			//	
	
	
	////////////////////////////////////////////////////////////////
	//	CMOS Sensor
	output 			cmos_sclk,
	input 			cmos_sdat_IN,
	output 			cmos_sdat_OUT,
	output 			cmos_sdat_OE,
	
	//	CMOS Interface
	input 			cmos_pclk,
	input 			cmos_vsync,
	input 			cmos_href,
	input 	[7:0] 	cmos_data,
	input 			cmos_ctl1,
	output 			cmos_ctl2,
	output 			cmos_ctl3,
	////////////////////////////////////////////////////////////////
	//	CMOS2 Sensor
	output 			cmos2_sclk,
	input 			cmos2_sdat_IN,
	output 			cmos2_sdat_OUT,
	output 			cmos2_sdat_OE,
	
	//	CMOS2 Interface
	input 			cmos2_pclk,
	input 			cmos2_vsync,
	input 			cmos2_href,
	input 	[7:0] 	cmos2_data,
	input 			cmos2_ctl1,
	output 			cmos2_ctl2,
	output 			cmos2_ctl3,
	
	
	
	////////////////////////////////////////////////////////////////
	//	HDMI Interface
	output 			hdmi_txc_oe,
	output 			hdmi_txd0_oe,
	output 			hdmi_txd1_oe,
	output 			hdmi_txd2_oe,
	
	output 			hdmi_txc_rst_o,
	output 			hdmi_txd0_rst_o,
	output 			hdmi_txd1_rst_o,
	output 			hdmi_txd2_rst_o,
	
	output 	[9:0] 	hdmi_txc_o,
	output 	[9:0] 	hdmi_txd0_o,
	output 	[9:0] 	hdmi_txd1_o,
	output 	[9:0] 	hdmi_txd2_o,
	
	
	////////////////////////////////////////////////////////////////
	//	LVDS Interface
	output 			lvds_txc_oe,
	output 	[6:0] 	lvds_txc_o,
	output 			lvds_txc_rst_o,
	
	output 			lvds_txd0_oe,
	output 	[6:0] 	lvds_txd0_o,
	output 			lvds_txd0_rst_o,
	
	output 			lvds_txd1_oe,
	output 	[6:0] 	lvds_txd1_o,
	output 			lvds_txd1_rst_o,
	
	output 			lvds_txd2_oe,
	output 	[6:0] 	lvds_txd2_o,
	output 			lvds_txd2_rst_o,
	
	output 			lvds_txd3_oe,
	output 	[6:0] 	lvds_txd3_o,
	output 			lvds_txd3_rst_o,
	
	
	////////////////////////////////////////////////////////////////
	//	RGB LCD 5Inch 800x480
	output 			lcd_tp_sda_o,		//	TP SDA
	output 			lcd_tp_sda_oe,
	input 			lcd_tp_sda_i,
	
	output 			lcd_tp_scl_o,		//	TP SCL
	output 			lcd_tp_scl_oe,
	input 			lcd_tp_scl_i,
	
	output 			lcd_tp_int_o,		//	TP INT
	output 			lcd_tp_int_oe,
	input 			lcd_tp_int_i,
	
	output 			lcd_tp_rst_o,		//	TP RST
	
	output 			lcd_pwm_o,			//	Backlight
	output 			lcd_blen_o,
	
	//output 			lcd_pclk_o,			//	PCLK & SCK Mux
	output 			lcd_vs_o,			//	VS & SSN Mux. Fixed to 1. Use DE-Only mode. 
	output 			lcd_hs_o,			//	HS. Fixed to 1. Use DE-Only mode. 
	output 			lcd_de_o,			//	DE. 

	output 	[7:0] 	lcd_b7_0_o,			//	B7:B0. 
	output 	[7:0] 	lcd_g7_0_o,			//	G7:G0. Must output 8'hFF when access SPI. 
	output 	[7:0] 	lcd_r7_0_o,			//	R7:R0. 
	
	output 	[7:0] 	lcd_b7_0_oe,		//	B7:B0. 
	output 	[7:0] 	lcd_g7_0_oe,		//	G7:G0. Must output 8'hFF when access SPI. 
	output 	[7:0] 	lcd_r7_0_oe,		//	R7:R0. 

	input 	[7:0] 	lcd_b7_0_i,			//	B7:B0. 
	input 	[7:0] 	lcd_g7_0_i,			//	G7:G0. Must output 8'hFF when access SPI. 
	input 	[7:0] 	lcd_r7_0_i,			//	R7:R0. 
	
	//	SPI Pins
	output 			spi_sck_o, 
	output 			spi_ssn_o 			
);

	wire 			csi_rxd0_fifo_rd_o; 
	wire 			csi_rxd0_fifo_empty_i = 0;  
	wire 			csi_rxd1_fifo_rd_o;  
	wire 			csi_rxd1_fifo_empty_i = 0;  
	wire 			csi_rxd2_fifo_rd_o;  
	wire 			csi_rxd2_fifo_empty_i = 0;  
	wire 			csi_rxd3_fifo_rd_o;  
	wire 			csi_rxd3_fifo_empty_i = 0;  
	
	
	parameter 	SIM_DATA 	= 0; 
	
	//	Hardware Configuration
	assign clk_p_hi = 1'b0;	//	DDR3 Clock requires 180 degree shifted. 
	assign clk_p_lo = 1'b1;
	assign clk_n_hi = 1'b1;
	assign clk_n_lo = 1'b0; 
	
	//	System Clock Tree Control
	assign sys_pll_rstn_o = 1'b1; 	//	nrst; 	//	Reset whole system when nrst (K2) is pressed. 
	
	assign dsi_pll_rstn_o = sys_pll_lock; 
	assign ddr_pll_rstn_o = sys_pll_lock; 
	assign lvds_pll_rstn_o = sys_pll_lock; 
	
	wire 			w_pll_lock = sys_pll_lock && dsi_pll_lock && ddr_pll_lock && lvds_pll_lock; 
	
	//	Synchronize System Resets. 
	reg 			rstn_sys = 0, rstn_pixel = 0; 
	wire 			rst_sys = ~rstn_sys, rst_pixel = ~rstn_pixel; 
	
	reg 			rstn_dsi_refclk = 0, rstn_dsi_byteclk = 0; 
	wire 			rst_dsi_refclk = ~rstn_dsi_refclk, rst_dsi_byteclk = ~rstn_dsi_byteclk; 
	
	reg 			rstn_lvds_1x = 0; 
	wire 			rst_lvds_1x = ~rstn_lvds_1x; 
	
	reg 			rstn_27m = 0, rstn_54m = 0; 
	wire 			rst_27m = ~rstn_27m, rst_54m = ~rstn_54m; 
	
	//	Clock Gen
	always @(posedge clk_27m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_27m <= 0; else rstn_27m <= 1; end
	always @(posedge clk_54m or negedge w_pll_lock) begin if(~w_pll_lock) rstn_54m <= 0; else rstn_54m <= 1; end
	always @(posedge clk_sys or negedge w_pll_lock) begin if(~w_pll_lock) rstn_sys <= 0; else rstn_sys <= 1; end
	always @(posedge clk_pixel or negedge w_pll_lock) begin if(~w_pll_lock) rstn_pixel <= 0; else rstn_pixel <= 1; end
	always @(posedge dsi_refclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_refclk <= 0; else rstn_dsi_refclk <= 1; end
	always @(posedge dsi_byteclk_i or negedge w_pll_lock) begin if(~w_pll_lock) rstn_dsi_byteclk <= 0; else rstn_dsi_byteclk <= 1; end
	always @(posedge clk_lvds_1x or negedge w_pll_lock) begin if(~w_pll_lock) rstn_lvds_1x <= 0; else rstn_lvds_1x <= 1; end
	
	
	localparam 	CLOCK_MAIN 	= 96000000; 	//	System clock using 96MHz. 
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	Flash Burner Control
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire 			w_ustick, w_mstick; 
	
	wire  [7:0] 	w_dev_index_o;  
	wire  [7:0] 	w_dev_cmd_o;  
	wire  [31:0] 	w_dev_wdata_o;  
	wire  		w_dev_wvalid_o;  
	wire  		w_dev_rvalid_o;  
	wire 	[31:0] 	w_dev_rdata_i;  
	
	wire 			w_spi_ssn_o, w_spi_sck_o; 
	wire 	[3:0] 	w_spi_data_o, w_spi_data_oe; 
	wire 	[3:0] 	w_spi_data_i; 
	
	//	Flash Control
	reg 			r_flash_en = 0; 		//	0x00:0x00 Enable Flash
	
	always @(posedge clk_sys) begin
		r_flash_en <= (w_dev_wvalid_o && (w_dev_index_o == 8'h00) && (w_dev_cmd_o == 8'h00)) ? w_dev_wdata_o : r_flash_en; 
	end
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	LCD Data Mux
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	wire 	[7:0] 	w_lcd_b_o, w_lcd_g_o, w_lcd_r_o; 
	
	assign lcd_b7_0_o = r_flash_en ? {4'b0, w_spi_data_o[3:2], 2'b0} : w_lcd_b_o; 
	assign lcd_g7_0_o = r_flash_en ? {6'h0, w_spi_data_o[1:0]} : w_lcd_g_o; 
	assign lcd_r7_0_o = r_flash_en ? {8'h00} : w_lcd_r_o; 
	
	assign lcd_b7_0_oe = r_flash_en ? {4'b0, w_spi_data_oe[3:2], 2'b0} : 8'hFF; 
	assign lcd_g7_0_oe = r_flash_en ? {6'h0, w_spi_data_oe[1:0]} : 8'hFF; 
	assign lcd_r7_0_oe = r_flash_en ? {8'h00} : 8'hFF; 
	
	assign spi_sck_o = w_spi_sck_o; 
	assign spi_ssn_o = w_spi_ssn_o; 
	assign w_spi_data_i = {lcd_b7_0_i[3:2], lcd_g7_0_i[1:0]}; 
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	DDR3 Controller
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire			w_ddr3_ui_clk = clk_sys;
	wire			w_ddr3_ui_rst = rst_sys;
	wire			w_ddr3_ui_areset = rst_sys;
	wire			w_ddr3_ui_aresetn = rstn_sys;
	

	//	General AXI Interface 
	wire	[3:0] 	w_ddr3_awid;
	wire	[31:0]	w_ddr3_awaddr;
	wire	[7:0]		w_ddr3_awlen;
	wire			w_ddr3_awvalid;
	wire			w_ddr3_awready;
	
	wire 	[3:0]  	w_ddr3_wid;
	wire 	[127:0] 	w_ddr3_wdata;
	wire 	[15:0]	w_ddr3_wstrb;
	wire			w_ddr3_wlast;
	wire			w_ddr3_wvalid;
	wire			w_ddr3_wready;
	
	wire 	[3:0] 	w_ddr3_bid;
	wire 	[1:0] 	w_ddr3_bresp;
	wire			w_ddr3_bvalid;
	wire			w_ddr3_bready;
	
	wire	[3:0] 	w_ddr3_arid;
	wire	[31:0]	w_ddr3_araddr;
	wire	[7:0]		w_ddr3_arlen;
	wire			w_ddr3_arvalid;
	wire			w_ddr3_arready;
	
	wire 	[3:0] 	w_ddr3_rid;
	wire 	[127:0] 	w_ddr3_rdata;
	wire			w_ddr3_rlast;
	wire			w_ddr3_rvalid;
	wire			w_ddr3_rready;
	wire 	[1:0] 	w_ddr3_rresp;
	
	
	//	AXI Interface Request
	wire 	[3:0] 	w_ddr3_aid;
	wire 	[31:0] 	w_ddr3_aaddr;
	wire 	[7:0]  	w_ddr3_alen;
	wire 	[2:0]  	w_ddr3_asize;
	wire 	[1:0]  	w_ddr3_aburst;
	wire 	[1:0]  	w_ddr3_alock;
	wire			w_ddr3_avalid;
	wire			w_ddr3_aready;
	wire			w_ddr3_atype;
	
	wire 			w_ddr3_cal_done, w_ddr3_cal_pass; 
	
	//	Do not issue DDR read / write when ~cal_done. 
	reg 			r_ddr_unlock = 0; 
	always @(posedge w_ddr3_ui_clk or negedge w_ddr3_ui_aresetn) begin
		if(~w_ddr3_ui_aresetn)
			r_ddr_unlock <= 0; 
		else
			r_ddr_unlock <= w_ddr3_cal_done; 
	end
	
	DdrCtrl ddr3_ctl_axi (	
		.core_clk		(core_clk),
		.tac_clk		(tac_clk),
		.twd_clk		(twd_clk),	
		.tdqss_clk		(tdqss_clk),
		
		.reset		(reset),
		.cs			(cs),
		.ras			(ras),
		.cas			(cas),
		.we			(we),
		.cke			(cke),    
		.addr			(addr),
		.ba			(ba),
		.odt			(odt),
		
		.o_dm_hi		(o_dm_hi),
		.o_dm_lo		(o_dm_lo),
		
		.i_dq_hi		(i_dq_hi),
		.i_dq_lo		(i_dq_lo),
		.o_dq_hi		(o_dq_hi),
		.o_dq_lo		(o_dq_lo),
		.o_dq_oe		(o_dq_oe),
		
		.i_dqs_hi		(i_dqs_hi),
		.i_dqs_lo		(i_dqs_lo),
		.i_dqs_n_hi		(i_dqs_n_hi),
		.i_dqs_n_lo		(i_dqs_n_lo),
		.o_dqs_hi		(o_dqs_hi),
		.o_dqs_lo		(o_dqs_lo),
		.o_dqs_n_hi		(o_dqs_n_hi),
		.o_dqs_n_lo		(o_dqs_n_lo),
		.o_dqs_oe		(o_dqs_oe),
		.o_dqs_n_oe		(o_dqs_n_oe),
		
		.clk			(w_ddr3_ui_clk),
		.reset_n		(w_ddr3_ui_aresetn),
		
		.axi_avalid		(w_ddr3_avalid && r_ddr_unlock),	//	Enable command only when unlocked. 
		.axi_aready		(w_ddr3_aready),
		.axi_aaddr		(w_ddr3_aaddr),
		.axi_aid		(w_ddr3_aid),
		.axi_alen		(w_ddr3_alen),
		.axi_asize		(w_ddr3_asize),
		.axi_aburst		(w_ddr3_aburst),
		.axi_alock		(w_ddr3_alock),
		.axi_atype		(w_ddr3_atype),
		
		.axi_wid		(w_ddr3_wid),
		.axi_wvalid		(w_ddr3_wvalid),
		.axi_wready		(w_ddr3_wready),
		.axi_wdata		(w_ddr3_wdata),
		.axi_wstrb		(w_ddr3_wstrb),
		.axi_wlast		(w_ddr3_wlast),
		
		.axi_bvalid		(w_ddr3_bvalid),
		.axi_bready		(w_ddr3_bready),
		.axi_bid		(w_ddr3_bid),
		.axi_bresp		(w_ddr3_bresp),
		
		.axi_rvalid		(w_ddr3_rvalid),
		.axi_rready		(w_ddr3_rready),
		.axi_rdata		(w_ddr3_rdata),
		.axi_rid		(w_ddr3_rid),
		.axi_rresp		(w_ddr3_rresp),
		.axi_rlast		(w_ddr3_rlast),
		
		.shift		(shift),
		.shift_sel		(),
		.shift_ena		(shift_ena),
		
		.cal_ena		(1'b1),
		.cal_done		(w_ddr3_cal_done),
		.cal_pass		(w_ddr3_cal_pass)
	);
	
	assign w_ddr3_bready = 1'b1; 
	assign shift_sel = 5'b00100; 		//	ddr_tac_clk always use PLLOUT[2]. 
	
	
	AXI4_AWARMux #(.AID_LEN(4), .AADDR_LEN(32)) axi4_awar_mux (
		.aclk_i			(w_ddr3_ui_clk), 
		.arst_i			(w_ddr3_ui_rst), 
		
		.awid_i			(w_ddr3_awid),
		.awaddr_i			(w_ddr3_awaddr),
		.awlen_i			(w_ddr3_awlen),
		.awvalid_i			(w_ddr3_awvalid),
		.awready_o			(w_ddr3_awready),
		
		.arid_i			(w_ddr3_arid),
		.araddr_i			(w_ddr3_araddr),
		.arlen_i			(w_ddr3_arlen),
		.arvalid_i			(w_ddr3_arvalid),
		.arready_o			(w_ddr3_arready),
		
		.aid_o			(w_ddr3_aid),
		.aaddr_o			(w_ddr3_aaddr),
		.alen_o			(w_ddr3_alen),
		.atype_o			(w_ddr3_atype),
		.avalid_o			(w_ddr3_avalid),
		.aready_i			(w_ddr3_aready)
	);
	
	assign w_ddr3_asize = 4; 		//	Fixed 128 bits (16 bytes, size = 4)
	assign w_ddr3_aburst = 1; 
	assign w_ddr3_alock = 0; 
	
	//assign led_o[1:0] = {w_ddr3_cal_pass, w_ddr3_cal_done}; 
	
	
	
	

	assign cmos_ctl2 = 0;
	assign cmos_ctl3 = 0;
	assign cmos2_ctl2 = 0;
	assign cmos2_ctl3 = 0;
// //--------------------------------------------------------------------------------------------------------------------
// //--------------------------------------iic_config----------------------------------------------------------------
// //--------------------------------------------------------------------------------------------------------------------
// //--------------------------------------------------------------------------------------------------------------------
	
		
	//	CMOS Interface
	//input 			cmos_pclk,
	//input 			cmos_vsync,
	//input 			cmos_href,
	//input 	[7:0] 	cmos_data,
	//input 			cmos_ctl1,
	//output 			cmos_ctl2,
	//output 			cmos_ctl3,

	
	//	Output LED
	reg 	[3:0]		r_cmos_fv_o = 0; 
	reg 	[1:0] 	r_cmos_rx_vsync0_in = 0; 
	always @(posedge cmos_pclk) begin
		r_cmos_rx_vsync0_in <= {r_cmos_rx_vsync0_in, cmos_vsync}; 
		r_cmos_fv_o <= r_cmos_fv_o + ((r_cmos_rx_vsync0_in == 2'b01) ? 1 : 0); 
	end
	assign led_o[5] = r_cmos_fv_o[3]; 

	
	////////////////////////////////////////////////////////////////
	//	System Control. Can be removed for public. 
	
	localparam 	CLK_FREQ 	= 96_000_000; 	//	clk_sys is 96MHz. 
	localparam 	BAUD_RATE 	= 460_800; 		//	Use 460800-8-N-1. 
	
	
	//	SFR I/O Interface
	wire 	[7:0] 	w_sfr_addr_o; 	//	SFR Address (0xFF00 ~ 0xFFFF). 00:Power; 40~5F:Stream0; 60~7F:Stream1. 
	wire 	[7:0] 	w_sfr_wdata_o; 	//	SFR Write Data. 
	wire 			w_sfr_we_o; 		//	SFR WE. 
	reg 	[7:0] 	w_sfr_rdata_i; 	//	Must be valid after sfr_rd_o. 
	wire 			w_sfr_rd_o; 		//	SFR RD. 
	
	
	//	System Control Registers
	reg 			r_dsi_tx_rstn = 0; 	//	DSI TX Reset
	reg 	[7:0] 	r_dsi_pwm = 64; 		//	[6:0]PWM, [7]Pol
	reg 			r_dsi_resetn_o = 0; 	//	DSI Panel Reset
	reg 			r_dsi_data_rstn = 0; 	//	DSI TX Reset
	
	reg 	[3:0] 	r_dsi_lp_p_ovr = 0; 	
	reg 	[3:0] 	r_dsi_lp_n_ovr = 0; 	
	
	
	
	//	AXI-Lite Interface Bridge
	localparam 	CSI_AXILITE_ID 	= 0; 				//	Select DSI_TX when r_axi_sel = DSI_AXILITE_ID. 
	localparam 	DSI_AXILITE_ID 	= 1; 				//	Select DSI_TX when r_axi_sel = DSI_AXILITE_ID. 
	
	reg 	[7:0] 	r_axi_addr = 8'h18; 		//	0xE0 (RW)
	reg 	[31:0] 	r_axi_wdata = 32'h0000000A; 	//	0xE1~0xE4 (RW)
	wire 	[31:0] 	w_axi_rdata; 			//	0xE5~0xE8 (RO)
	reg 	[0:0] 	r_axi_sel = 1; 			//	0xE9[7:2] (RW)
	reg 			r_axi_r1w0 = 0; 			//	0xE9[1] (RW)
	reg 			r_axi_req = 0; 			//	0xE9[0] (WO, Single Cycle)
	reg 			r_axi_req_o = 0; 			//	Delayed of r_axi_req. 
	
	
	//	Buffered AXI Read Data
	reg 	[31:0] 	r_axi_rdata = 0; 		//	Use state machine
	reg 			r_axi_idle = 0; 		//	AXI Idle 
	
	reg 	[3:0] 	rs_axilite = 0; 		//	AXI Access
	wire 	[3:0] 	ws_axilite_idle = 0; 		
	wire 	[3:0] 	ws_axilite_write = 1; 
	wire 	[3:0] 	ws_axilite_read = 2; 
	wire 	[3:0] 	ws_axilite_endread = 3; 
	
	reg 			r_axi_awvalid = 0, r_axi_wvalid = 0, r_axi_arvalid = 0; 
	wire 			w_axi_awready, w_axi_wready, w_axi_arready, w_axi_rvalid; 
	
	
	reg 	[3:0] 	rc_axi_init = 0; 

	always @(posedge clk_sys or posedge rst_sys) begin
		if(rst_sys) begin
			r_dsi_tx_rstn <= 0; 
			r_dsi_pwm <= 64; 
			r_axi_req <= 0; 
			r_dsi_resetn_o <= 0; 
			r_dsi_data_rstn <= 0; 
			
			rs_axilite <= 0; 
			r_axi_awvalid <= 0; 
			r_axi_wvalid <= 0;
			r_axi_arvalid <= 0; 
			
			r_dsi_lp_p_ovr <= 0; 
			r_dsi_lp_n_ovr <= 0; 
			
			rc_axi_init <= 0; 
			r_axi_idle <= 0; 
			
		end else begin
			r_dsi_tx_rstn <= 1; 
			r_dsi_resetn_o <= 1; 
			r_dsi_data_rstn <= 1; 
			
		end
	end
	
	assign dsi_resetn_o = r_dsi_resetn_o; 
	
	assign csi_ctl0_oe = 0; 
	assign csi_ctl1_oe = 0; 
	
	
	PWMLite dsi_pwm (		//	#(.ENABLE_TICK(0), .PWM_BITS(7)) 
		.clk_i			(clk_sys),
		.rst_i			(rst_sys),
		.pwm_i			(r_dsi_pwm[6:0]),
		.pol_i			(r_dsi_pwm[7]), 
		.pwm_o			(dsi_pwm_o)
	);
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   获取图像
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//连接例化模块，获取CMOS信号
	wire r_cmos_vsync;
	wire r_cmos_href ;
	wire [7:0] r_cmos_data ;	
	wire r2_cmos_vsync;
	wire r2_cmos_href ;
	wire [7:0] r2_cmos_data ;	
	wire cmos_vsync_start;
	wire cmos2_vsync_start;
	CMOS_Capture_RAW_Gray #(
		.CMOS_FRAME_WAITCNT ( 2 ),
		.CMOS_PCLK_FREQ     ( 74_250_000     ))
	u_CMOS_Capture_RAW_Gray (
		.clk_cmos                (                 ),
		.rst_n                   ( rstn_sys                    ),
		.cmos_pclk               ( cmos_pclk                ),
		.cmos_vsync              ( cmos_vsync               ),
		.cmos_href               ( cmos_href                ),
		.cmos_data               ( cmos_data         [7:0]  ),
	
		.cmos_xclk               (                ),
		.cmos_frame_vsync        (  r_cmos_vsync),
		.cmos_frame_href         (  r_cmos_href ),
		.cmos_frame_data         (  r_cmos_data ),
		.cmos_fps_rate           (  ),
		.cmos_vsync_end          (  ),
		.cmos_vsync_start		 (	cmos_vsync_start),
		.pixel_cnt               (  ),
		.line_cnt                (  )
	);
	CMOS_Capture_RAW_Gray #(
		.CMOS_FRAME_WAITCNT ( 2 ),
		.CMOS_PCLK_FREQ     ( 74_250_000     ))
	u2_CMOS_Capture_RAW_Gray (
		.clk_cmos                (                 ),
		.rst_n                   ( rstn_sys                    ),
		.cmos_pclk               ( cmos2_pclk                ),
		.cmos_vsync              ( cmos2_vsync               ),
		.cmos_href               ( cmos2_href                ),
		.cmos_data               ( cmos2_data         [7:0]  ),
	
		.cmos_xclk               (                ),
		.cmos_frame_vsync        (  r2_cmos_vsync),
		.cmos_frame_href         (  r2_cmos_href ),
		.cmos_frame_data         (  r2_cmos_data ),
		.cmos_fps_rate           (  ),
		.cmos_vsync_end          (  ),
		.cmos_vsync_start		 (	cmos2_vsync_start),
		.pixel_cnt               (  ),
		.line_cnt                (  )
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   FAST
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire       FAST_VS;
	wire       FAST_HS;
	wire [7:0] FAST_Data;
	wire       FAST_VS2;
	wire       FAST_HS2;
	wire [7:0] FAST_Data2;
	
	FAST_Top u_FAST_Top (
    .i_clk                   ( clk_code                 ),
    .i_dvp_vs                ( r_cmos_vsync            ),
    .i_dvp_hs                ( r_cmos_href             ),
    .i_dvp_data              ( r_cmos_data             ),

    .o_fast_vs               ( FAST_VS          ),
    .o_fast_hs               ( FAST_HS          ),
    .o_fast_data             ( FAST_Data        )
);
	FAST_Top u_FAST_Top2 (
    .i_clk                   ( clk_code                  ),
    .i_dvp_vs                ( r2_cmos_vsync            ),
    .i_dvp_hs                ( r2_cmos_href             ),
    .i_dvp_data              ( r2_cmos_data             ),

    .o_fast_vs               ( FAST_VS2          ),
    .o_fast_hs               ( FAST_HS2          ),
    .o_fast_data             ( FAST_Data2        )
);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //   BRIEF
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    wire       BRIEF_start;
    wire       BRIEF_end;
    wire       BRIEF_valid;
    wire       BRIEF_value;

	wire       BRIEF_start2;
    wire       BRIEF_end2;
    wire       BRIEF_valid2;
    wire       BRIEF_value2;

    BRIEF_Descriptor u_BRIEF_Descriptor (
        .i_clk                   ( clk_code                  ),

        .i_dvp_vs                ( r_cmos_vsync            ),
        .i_dvp_hs                ( r_cmos_href             ),
        .i_dvp_data              ( r_cmos_data             ),

        .i_fast_vs               ( FAST_VS          ),
        .i_fast_hs               ( FAST_HS          ),
        .i_fast_data             ( FAST_Data        ),

        .o_orb_descriptor_start  ( BRIEF_start            ),
        .o_orb_descriptor_end    ( BRIEF_end              ),
        .o_orb_descriptor_valid  ( BRIEF_valid            ),
        .o_orb_descriptor_value  ( BRIEF_value            )
    );

    BRIEF_Descriptor u_BRIEF_Descriptor2 (
        .i_clk                   ( clk_code                  ),

        .i_dvp_vs                ( r2_cmos_vsync            ),
        .i_dvp_hs                ( r2_cmos_href             ),
        .i_dvp_data              ( r2_cmos_data             ),

        .i_fast_vs               ( FAST_VS2          ),
        .i_fast_hs               ( FAST_HS2          ),
        .i_fast_data             ( FAST_Data2        ),

        .o_orb_descriptor_start  ( BRIEF_start2            ),
        .o_orb_descriptor_end    ( BRIEF_end2              ),
        .o_orb_descriptor_valid  ( BRIEF_valid2            ),
        .o_orb_descriptor_value  ( BRIEF_value2            )
    );

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //   Discriptor Buffer
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    logic                ORB_Descriptor_0_Ready             ;
    logic                ORB_Descriptor_0_Ready_Ack         ;
    logic [15:0]         ORB_Descriptor_0_Length            ;
    logic                ORB_Descriptor_0_En                ;
    logic [15:0]         ORB_Descriptor_0_Address           ;
    logic [255:0]        ORB_Descriptor_0_Data              ;
    logic                ORB_Descriptor_0_Location_En       ;
    logic [15:0]         ORB_Descriptor_0_Location_Address  ;
    logic [31:0]         ORB_Descriptor_0_Location_Data     ;

    logic                ORB_Descriptor_1_Ready             ;
    logic                ORB_Descriptor_1_Ready_Ack         ;
    logic [15:0]         ORB_Descriptor_1_Length            ;
    logic                ORB_Descriptor_1_En                ;
    logic [15:0]         ORB_Descriptor_1_Address           ;
    logic [255:0]        ORB_Descriptor_1_Data              ;
    logic                ORB_Descriptor_1_Location_En       ;
    logic [15:0]         ORB_Descriptor_1_Location_Address  ;
    logic [31:0]         ORB_Descriptor_1_Location_Data     ;
    
    
    Descriptor_Buffer  u_CV_ORB_Descriptor_Buffer (
    .i_clk                                ( clk_sys                                ),
    .i_orb_descriptor_0_start             ( BRIEF_start              ),
    .i_orb_descriptor_0_end               ( BRIEF_end                ),
    .i_orb_descriptor_0_valid             ( BRIEF_valid              ),
    .i_orb_descriptor_0_value             ( BRIEF_value              ),
    .i_orb_descriptor_1_start             ( BRIEF_start2              ),
    .i_orb_descriptor_1_end               ( BRIEF_end2                ),
    .i_orb_descriptor_1_valid             ( BRIEF_valid2              ),
    .i_orb_descriptor_1_value             ( BRIEF_value2              ),

    .o_orb_descriptor_0_ready             ( ORB_Descriptor_0_Ready              ),
    .i_orb_descriptor_0_ready_ack         ( ORB_Descriptor_0_Ready_Ack          ),
    .o_orb_descriptor_0_length            ( ORB_Descriptor_0_Length             ),
    .i_orb_descriptor_0_en                ( ORB_Descriptor_0_En                 ),
    .i_orb_descriptor_0_address           ( ORB_Descriptor_0_Address            ),
    .o_orb_descriptor_0_data              ( ORB_Descriptor_0_Data               ),
    .i_orb_descriptor_0_location_en       ( ORB_Descriptor_0_Location_En        ),
    .i_orb_descriptor_0_location_address  ( ORB_Descriptor_0_Location_Address   ),
    .o_orb_descriptor_0_location_data     ( ORB_Descriptor_0_Location_Data      ),

    .o_orb_descriptor_1_ready             ( ORB_Descriptor_1_Ready              ),
    .i_orb_descriptor_1_ready_ack         ( ORB_Descriptor_1_Ready_Ack          ),
    .o_orb_descriptor_1_length            ( ORB_Descriptor_1_Length             ),
    .i_orb_descriptor_1_en                ( ORB_Descriptor_1_En                 ),
    .i_orb_descriptor_1_address           ( ORB_Descriptor_1_Address            ),
    .o_orb_descriptor_1_data              ( ORB_Descriptor_1_Data               ),
    .i_orb_descriptor_1_location_en       ( ORB_Descriptor_1_Location_En        ),
    .i_orb_descriptor_1_location_address  ( ORB_Descriptor_1_Location_Address   ),
    .o_orb_descriptor_1_location_data     ( ORB_Descriptor_1_Location_Data      )
);


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //   Match
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    logic                Match_Start;
    logic                Match_End;
    logic                Match_Location_En;
    logic [31:0]         Match_Location_0;
    logic [31:0]         Match_Location_1;
    
    Match_Descriptor u_match_descriptor(
    .i_clk                     ( clk_sys                      ),
    .i_orb_0_ready             ( ORB_Descriptor_0_Ready              ),
    .o_orb_0_ready_ack         ( ORB_Descriptor_0_Ready_Ack          ),
    .i_orb_0_valid_length      ( ORB_Descriptor_0_Length             ),
    .o_orb_0_brief_en          ( ORB_Descriptor_0_En                 ),
    .o_orb_0_brief_address     ( ORB_Descriptor_0_Address            ),
    .i_orb_0_brief_data        ( ORB_Descriptor_0_Data               ),
    .o_orb_0_location_en       ( ORB_Descriptor_0_Location_En        ),
    .o_orb_0_location_address  ( ORB_Descriptor_0_Location_Address   ),
    .i_orb_0_location_data     ( ORB_Descriptor_0_Location_Data      ),

    .i_orb_1_ready             ( ORB_Descriptor_1_Ready              ),
    .o_orb_1_ready_ack         ( ORB_Descriptor_1_Ready_Ack          ),
    .i_orb_1_valid_length      ( ORB_Descriptor_1_Length             ),
    .o_orb_1_brief_en          ( ORB_Descriptor_1_En                 ),
    .o_orb_1_brief_address     ( ORB_Descriptor_1_Address            ),
    .i_orb_1_brief_data        ( ORB_Descriptor_1_Data               ),
    .o_orb_1_location_en       ( ORB_Descriptor_1_Location_En        ),
    .o_orb_1_location_address  ( ORB_Descriptor_1_Location_Address   ),
    .i_orb_1_location_data     ( ORB_Descriptor_1_Location_Data      ),

    .o_match_start             ( Match_Start              ),
    .o_match_end               ( Match_End                ),
    .o_match_location_en       ( Match_Location_En        ),
    .o_match_location_0        ( Match_Location_0         ),
    .o_match_location_1        ( Match_Location_1         )
    );
	
	

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //   根据匹配结果获得裁剪参数
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	wire [15:0] diff_X;
	reg  [15:0] r_diff_X;
	assign diff_X = Match_Location_En ? Match_Location_0[15:0] - Match_Location_1[15:0] : 443;
	
	reg bias_flag;
	
	always@(posedge clk_sys or negedge rstn_sys)
	begin
		if(!rstn_sys || cmos_vsync_start) begin
			r_diff_X <= 443;
			bias_flag <= 0;
		end
		else begin
			if(~bias_flag && cmos_vsync)begin
				r_diff_X <= diff_X;
				bias_flag<= diff_X == 443 ? 0 : 1;//有效的diff_X，则不再赋值
			end
			else begin
				r_diff_X <= r_diff_X;
				bias_flag<= bias_flag;
			end
		end
	end

	wire Right_X_start;
	assign Right_X_start = 16'b010001100000 - r_diff_X;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   裁剪与拼接
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	parameter IMAGE_HSIZE_SOURCE  = 1280;
	parameter IMAGE_VSIZE_SOURCE  = 720;
	parameter IMAGE_HSIZE_TARGET  = 960;
	parameter IMAGE_YSIZE_TARGET  = 720 ;
	parameter PIXEL_DATA_WIDTH    = 8  ;
	wire  image_out_vsync                      ;
	wire  image_out_href                       ;
	wire  image_out_de                         ;
	wire  [PIXEL_DATA_WIDTH-1:0]  image_out_data ;
	wire  image_out_vsync2                      ;
	wire  image_out_href2                       ;
	wire  image_out_de2                         ;
	wire  [PIXEL_DATA_WIDTH-1:0]  image_out_data2 ;
	Sensor_Image_XYCrop #(
		.IMAGE_HSIZE_SOURCE ( IMAGE_HSIZE_SOURCE ),
		.IMAGE_VSIZE_SOURCE ( IMAGE_VSIZE_SOURCE ),
		.IMAGE_HSIZE_TARGET_LEFT ( 160                        ),
		.IMAGE_HSIZE_TARGET_RIGHT( 1120                                   ),
		.PIXEL_DATA_WIDTH   ( PIXEL_DATA_WIDTH   )) 
	 u_Sensor_Image_XYCrop (
		.clk                     ( cmos_pclk                                     ), //pclk  align with data
		.rst_n                   ( rstn_sys                                   ),
		.image_in_vsync          ( r_cmos_vsync                          ),//vsync 
		.image_in_href           ( r_cmos_href                           ),//hsync
		.image_in_de             ( r_cmos_href                             ),//data_valid , if dvp data doesn't have hsync,both use data_valid（data_enable)
		.image_in_data           ( r_cmos_data    [PIXEL_DATA_WIDTH-1:0] ),//dvp data
	
		.image_out_vsync         ( image_out_vsync                         ),//delay vsync ,just delay
		.image_out_href          ( image_out_href                          ),//delay data valid, after  XYCrop
		.image_out_de            ( image_out_de                            ),//delay data_en ,originally align with data
		.image_out_data          ( image_out_data   [PIXEL_DATA_WIDTH-1:0] )//out data ,align with data valid
	);
	
	Sensor_Image_XYCrop #(
		.IMAGE_HSIZE_SOURCE ( IMAGE_HSIZE_SOURCE ),
		.IMAGE_VSIZE_SOURCE ( IMAGE_VSIZE_SOURCE ),
		.IMAGE_HSIZE_TARGET_LEFT ( 593                        ),
		.IMAGE_HSIZE_TARGET_RIGHT( 1120                                   ),
		.PIXEL_DATA_WIDTH   ( PIXEL_DATA_WIDTH   )) 
	 u_Sensor_Image_XYCrop2 (
		.clk                     ( cmos2_pclk                                     ), //pclk  align with data
		.rst_n                   ( rstn_sys                                   ),
		.image_in_vsync          (  r2_cmos_vsync                        ),//vsync 
		.image_in_href           (  r2_cmos_href                         ),//hsync
		.image_in_de             (  r2_cmos_href                           ),//data_valid , if dvp data doesn't have hsync,both use data_valid（data_enable)
		.image_in_data           (  r2_cmos_data   [PIXEL_DATA_WIDTH-1:0] ),//dvp data
		
		
	
		.image_out_vsync         ( image_out_vsync2                         ),//delay vsync ,just delay
		.image_out_href          ( image_out_href2                          ),//delay data valid, after  XYCrop
		.image_out_de            ( image_out_de2                            ),//delay data_en ,originally align with data
		.image_out_data          ( image_out_data2   [PIXEL_DATA_WIDTH-1:0] )//out data ,align with data valid
	);


	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   FIFO实现拼接两张图的同一行读取
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	reg rd_en;
	reg [12:0] rd_cnt;
	wire[11:0] rd_count; // watch out the width , if the width doesn't equal to the fifo_ip  the modelsim won't display the correct result
	wire[11:0] wr_count;
	wire [7:0] rd_data1;
	wire [7:0] rd_data2;
	wire full_flag;
                asyn_fifo_4kx8  u1_asyn_fifo_4kx8(
    .almost_full_o                     (        ),
    .prog_full_o                       (        ),
    .full_o                            (   full_flag     ),
    .overflow_o                        (        ),
    .wr_ack_o                          (        ),
    .empty_o                           (        ),
    .almost_empty_o                    (        ),
    .underflow_o                       (        ),
    .rd_valid_o                        (        ),
    .wr_clk_i                          (   cmos_pclk     ),
    // .rd_clk_i                          (    cmos2_pclk    ),  ),
    .rd_clk_i                          (    clk_sys    ),
    .wr_en_i                           (    image_out_href    ),
    .rd_en_i                           (   rd_en     ),
    .wdata                             (    image_out_data    ),
    .wr_datacount_o                    (   wr_count     ),
    .rst_busy                          (        ),
    .rdata                             (   rd_data1     ),
    .rd_datacount_o                    (   rd_count     ),
    .a_rst_i                           (   ~image_out_vsync      ) 
                    );


	reg rd_en2;
	wire[11:0] rd_count2; // watch out the width , if the width doesn't equal to the fifo_ip  the modelsim won't display the correct result
	wire[11:0] wr_count2;
                asyn_fifo_4kx8  u2_asyn_fifo_4kx8(
    .almost_full_o                     (   ),
    .prog_full_o                       (   ),
    .full_o                            (   ),
    .overflow_o                        (   ),
    .wr_ack_o                          (   ),
    .empty_o                           (   ),
    .almost_empty_o                    (   ),
    .underflow_o                       (   ),
    .rd_valid_o                        (   ),
    .wr_clk_i                          (  cmos2_pclk  ),
    // .rd_clk_i                          ( cmos2_pclk  ), ),
    .rd_clk_i                          (  clk_sys  ),
    .wr_en_i                           (  image_out_href2 ),
    .rd_en_i                           (  rd_en2 ),
    .wdata                             (  image_out_data2  ),
    .wr_datacount_o                    (  wr_count2  ),
    .rst_busy                          (   ),
    .rdata                             (  rd_data2  ),
    .rd_datacount_o                    (  rd_count2  ),
    .a_rst_i                           (  ~image_out_vsync2   ) 
                    );
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   FIFO读使能状态机
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				parameter IDLE = 2'b00;
				parameter READ_SENSOR1 = 2'b01;
				parameter READ_SENSOR2 = 2'b10;
				reg [1:0] state;
				reg [10:0] pixel_count;
				always @(posedge clk_sys or negedge rstn_sys) begin
					if (!rstn_sys) begin
						state <= IDLE;
						rd_cnt <= 0;
						rd_en <=0;
						rd_en2 <=0;
						pixel_count <= 0;
					end
					else
					case (state)
					  IDLE:
						begin
							if (rd_count >= 960) begin
								state <= READ_SENSOR1;
								rd_en <=1;
							end
							else begin
								state <= IDLE;
								rd_en <=0;
								pixel_count <=0;
	
							end
						end 
						READ_SENSOR1:
						begin
							if (pixel_count == 959) begin
								state <= READ_SENSOR2;
								rd_en2 <=1;
								pixel_count <= pixel_count +1;
								rd_en <=0;
							end
							else begin
								state <= READ_SENSOR1;
								rd_en <=1;
								rd_en2 <=0;
								pixel_count <= pixel_count +1;
							end
						end
						READ_SENSOR2:
						begin
							if (pixel_count == 1919) begin
								state <= IDLE;
								rd_en2 <=0;
								rd_en <=0;
								pixel_count <= 0;
							end
							else begin
								state <= READ_SENSOR2;
								rd_cnt <= rd_cnt +1;
								rd_en2 <=1;
								rd_en <=0;
								pixel_count <= pixel_count +1;
	
							end
						end
						default: 
						begin
							state <= IDLE;
							rd_cnt <= 0;
							rd_en <=0;
							rd_en2 <=0;
							pixel_count <= 0;
							
						end
					endcase
				end
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   场同步（帧）对齐
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				wire  sync_vsync; //final out
				wire  data_i;    
				assign data_i = image_out_vsync;// change xxx to what you want to delay
				reg   [782:0] r_data;// Width x Delay_cycle = New_Width
				always@(posedge clk_sys or negedge rstn_sys)
				begin
					 if(!rstn_sys)
						r_data <= 'd0;
					 else 
						r_data <= {r_data,data_i};
				end
				assign sync_vsync = r_data[782]; //use the MSB as the delay_result
				
				wire final_wreq;
				assign final_wreq = rd_en | rd_en2;
				wire [7:0] wr_data;
				assign wr_data = rd_en?rd_data1 : rd_data2;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//   UART
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//分频
	wire	divide_clken;
	integer_divider	#(
		.DEVIDE_CNT	(52)	//115200bps * 16
	)
	u_integer_devider
	(
		.clk				(clk_sys),		//96MHz clock
		.rst_n				(rstn_sys),    //global reset
		//user interface
		.divide_clken		(divide_clken)
	);
	
	wire	clken_16bps = divide_clken;
	//Data receive for PC to FPGA.
	wire			rxd_flag;
	wire	[15:0]	rxd_data;
	uart_receiver	u_uart_receiver
	(
		//gobal clock
		.clk			(clk_sys),
		.rst_n			(rstn_sys),
		
		//uart interface
		.clken_16bps	(clken_16bps),	//clk_bps * 16
		.rxd			(uart_rx_i),		//uart txd interface
		
		//user interface
		.rxd_data		(rxd_data),		//uart data receive
		.rxd_flag		(rxd_flag)  	//uart data receive done
	);

	//---------------------------------
	//Data transfer from FPGA to PC.
	uart_transfer	u_uart_transfer
	(
		//gobal clock
		.clk			(clk_sys),
		.rst_n			(rstn_sys),
		
		//uart interface
		.clken_16bps	(clken_16bps),	//clk_bps * 16
		.txd			(uart_tx_o),  	//uart txd interface
			
		//user interface   
		.txd_en			(1),		//uart data transfer enable
		.txd_data		({7'b0,BRIEF_valid}), 	//uart transfer data	
		.txd_flag		() 			    //uart data transfer done
	);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	生成DDR控制信号
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	//	MIPI CSI RX
	
	//	The CSI RXC shall not be inverted. Data can be inverted with swapped LP data and flipped HS data. 
	localparam 	CSI_RXD_INV 	= 4'b1111; 
	localparam 	CSI_DATA_WIDTH 	= 8; 			
	localparam 	CSI_STRB_WIDTH 	= CSI_DATA_WIDTH / 8; 

	
	////////////////////////////////////////////////////////////////
	//	DDR R/W Control
	

	wire                            lcd_de;
	wire                            lcd_hs;      
	wire                            lcd_vs;
	wire 					  lcd_request; 
	wire            [7:0]           lcd_red, lcd_red2;
	wire            [7:0]           lcd_green, lcd_green2;
	wire            [7:0]           lcd_blue, lcd_blue2;
	wire            [15:0]          lcd_data;


	assign w_ddr3_awid = 0; 
	assign w_ddr3_wid = 0; 
	
	wire 			w_wframe_vsync; 
	wire 	[7:0] 	w_axi_tp; 
	//finally   final_wreq    wr_data   sync_vsync
	axi4_ctrl #(.C_RD_END_ADDR(1920 * 720), .C_W_WIDTH(CSI_DATA_WIDTH), .C_R_WIDTH(8), .C_ID_LEN(4)) u_axi4_ctrl (

		.axi_clk        (w_ddr3_ui_clk            ),
		.axi_reset      (w_ddr3_ui_rst            ),

		.axi_awaddr     (w_ddr3_awaddr       ),
		.axi_awlen      (w_ddr3_awlen        ),
		.axi_awvalid    (w_ddr3_awvalid      ),
		.axi_awready    (w_ddr3_awready      ),

		.axi_wdata      (w_ddr3_wdata        ),
		.axi_wstrb      (w_ddr3_wstrb        ),
		.axi_wlast      (w_ddr3_wlast        ),
		.axi_wvalid     (w_ddr3_wvalid       ),
		.axi_wready     (w_ddr3_wready       ),

		.axi_bid        (0          ),
		.axi_bresp      (0        ),
		.axi_bvalid     (1       ),

		.axi_arid       (w_ddr3_arid         ),
		.axi_araddr     (w_ddr3_araddr       ),
		.axi_arlen      (w_ddr3_arlen        ),
		.axi_arvalid    (w_ddr3_arvalid      ),
		.axi_arready    (w_ddr3_arready      ),

		.axi_rid        (w_ddr3_rid          ),
		.axi_rdata      (w_ddr3_rdata        ),
		.axi_rresp      (0        ),
		.axi_rlast      (w_ddr3_rlast        ),
		.axi_rvalid     (w_ddr3_rvalid       ),
		.axi_rready     (w_ddr3_rready       ),

		// .wframe_pclk    (cmos2_pclk          ),
		.wframe_pclk    (clk_sys          ),
		.wframe_vsync   (sync_vsync), //w_wframe_vsync   ),		//	Writter VSync. Flush on rising edge. Connect to EOF. 
		.wframe_data_en (final_wreq   ),
		.wframe_data    (wr_data),
		
		.rframe_pclk    (clk_pixel            ),
		.rframe_vsync   (~lcd_vs             ),		//	Reader VSync. Flush on rising edge. Connect to ~EOF. 
		.rframe_data_en (lcd_request             ),
		.rframe_data    (lcd_data           ),
		
		.tp_o 		(w_axi_tp)
	);
	assign led_o[3:0] = w_axi_tp; 
	
	
	
	
	////////////////////////////////////////////////////////////////
	//  LCD Timing Driver
	
	lcd_driver u_lcd_driver
	(
	    //  global clock
	    .clk        (clk_pixel   ),
	    .rst_n      (rstn_pixel), 
	    
	    //  lcd interface
	    .lcd_dclk   (               ),
	    .lcd_blank  (               ),
	    .lcd_sync   (               ),
	    .lcd_request(lcd_request    ), 	//	Request data 1 cycle ahead. 
	    .lcd_hs     (lcd_hs         ),
	    .lcd_vs     (lcd_vs         ),
	    .lcd_en     (lcd_de         ),
	    .lcd_rgb    ({lcd_red2,lcd_green2,lcd_blue2, lcd_red,lcd_green,lcd_blue}),
	    
	    //  user interface
	    .lcd_data   ({{3{lcd_data[15:8]}}, {3{lcd_data[7:0]}}}  )
	);
	
	wire             w_rgb_vs_o, w_rgb_hs_o, w_rgb_de_o; 
    wire     [23:0]     w_rgb_data_o; 
    FrameBoundCrop #(.SKIP_ROWS(2),.SKIP_COLS(0),.TOTAL_ROWS(1080),.TOTAL_COLS(1920)) inst_FrameCrop(
        .clk_i            (clk_pixel),
        .rst_i            (~rstn_pixel),
        
        .vs_i             (lcd_vs),
        .hs_i             (lcd_hs),
        .de_i             (lcd_de),
        .data_i            ({lcd_red,lcd_green,lcd_blue}),
        
        .vs_o             (w_rgb_vs_o),
        .hs_o             (w_rgb_hs_o),
        .de_o             (w_rgb_de_o),
        .data_o            (w_rgb_data_o)
    );
	
	////////////////////////////////////////////////////////////////
	//	HDMI Interface. 
	
	//	HDMI requires specific timing, thus is not compatible with LCD & LVDS & DSI. Must implement standalone. 
	
	assign hdmi_txd0_rst_o = rst_pixel; 
	assign hdmi_txd1_rst_o = rst_pixel; 
	assign hdmi_txd2_rst_o = rst_pixel; 
	assign hdmi_txc_rst_o = rst_pixel; 
	
	assign hdmi_txd0_oe = 1'b1; 
	assign hdmi_txd1_oe = 1'b1; 
	assign hdmi_txd2_oe = 1'b1; 
	assign hdmi_txc_oe = 1'b1; 
	
	//-------------------------------------
	//Digilent HDMI-TX IP Modified by CB elec.
	rgb2dvi #(.ENABLE_OSERDES(0)) u_rgb2dvi 
	(

		
		.oe_i 		(1), 			//	Always enable output
		.bitflip_i 		(4'b0000), 		//	Reverse clock & data lanes. 
		
		.aRst			(1'b0), 
		.aRst_n		(1'b1), 
		
		.PixelClk		(clk_pixel        ),//pixel clk = 74.25M
		.SerialClk		(     ),//pixel clk *5 = 371.25M
		
		.vid_pVSync		(w_rgb_vs_o), 
		.vid_pHSync		(w_rgb_hs_o), 
		.vid_pVDE		(w_rgb_de_o), 
		.vid_pData		(w_rgb_data_o), 
		
		.txc_o			(hdmi_txc_o), 
		.txd0_o			(hdmi_txd0_o), 
		.txd1_o			(hdmi_txd1_o), 
		.txd2_o			(hdmi_txd2_o)
	); 



endmodule


