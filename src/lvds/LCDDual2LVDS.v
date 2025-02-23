`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    00:11:37 06/05/2023 
// Module Name:    LCDDual2LVDS 
//////////////////////////////////////////////////////////////////////////////////
module LCDDual2LVDS (
	input 			wclk_i,
	input 			wrst_i, 	
	input 			vs_i,		//	Reset on VS. 
	input 			de_i,
	input 	[47:0] 	data_i,	//	Dual lane raw rgb input (through FIFO). LCD requires B at Lsb. 
	
	input 			rclk_i,
	output 	[6:0] 	txc_o,
	output 	[6:0] 	txd0_o,
	output 	[6:0] 	txd1_o,
	output 	[6:0] 	txd2_o,
	output 	[6:0] 	txd3_o, 
	
	output 			vs_o, 	//	=0
	output 			hs_o, 	//	=0
	output 			de_o, 	//	DE
	output 	[23:0] 	data_o	//	DAT
);
	
	reg 			r_vs = 0; 
	reg 	[4:0] 	rc_rst = 0; 
	reg 			r_rst = 0; 
	always @(posedge wclk_i) begin
		r_vs <= vs_i; 
		if({r_vs, vs_i} == 2'b01) begin
			rc_rst <= 0; 
			r_rst <= 1; 
		end else begin
			rc_rst <= rc_rst + r_rst; 
			r_rst <= (&rc_rst) ? 0 : r_rst; 
		end
	end
	
	
	reg 	[2:0] 	r_de_r = 0; 
	reg 	[11:0] 	rc_rd = 0; 
	reg 			r_rd = 0; 
	wire 	[23:0] 	w_rdata; 
	
	always @(posedge rclk_i) begin
		r_de_r <= {r_de_r, de_i}; 
		
		rc_rd <= 0; 
		
		//	On falling DE start readout. 
		if(r_de_r[2:1] == 2'b10) begin
			rc_rd <= 0; 
			r_rd <= 1; 
		end else begin
			rc_rd <= rc_rd + 1; 
			
			if(rc_rd >= 1023)
				r_rd <= 0; 
			else begin
			end
		end
	end
	
	FIFO_W48R24 wfifo (
		.wr_clk_i		(wclk_i),
		.a_rst_i		(r_rst),
		.wr_en_i		(de_i),
		.wdata		(data_i),
		.wr_datacount_o	(),
		.full_o		(),
		
		.rd_clk_i		(rclk_i),
		.rd_en_i		(r_rd),
		.rdata		(w_rdata),
		.empty_o		(),
		.rd_datacount_o	(),
		
		.rst_busy		()
	);
	
	
	wire 	[7:0] 	lcd_blue  = w_rdata[ 7: 0]; 
	wire 	[7:0] 	lcd_green = w_rdata[15: 8]; 
	wire 	[7:0] 	lcd_red   = w_rdata[23:16]; 
	wire 			lcd_de    = r_rd; 
	
	wire    [7:0]   w_lvds_c0 = 7'b1100011;
	wire    [7:0]   w_lvds_d0 = {lcd_green[0],  lcd_red[5:0]};
	wire    [7:0]   w_lvds_d1 = {lcd_blue[1:0], lcd_green[5:1]};
	wire    [7:0]   w_lvds_d2 = {lcd_de, 2'b0,  lcd_blue[5:2]};   				//vs hs is reserved
	wire    [7:0]   w_lvds_d3 = {1'b0, lcd_blue[7:6], lcd_green[7:6], lcd_red[7:6]};
	
	assign  txc_o  = {w_lvds_c0[0], w_lvds_c0[1], w_lvds_c0[2], w_lvds_c0[3], w_lvds_c0[4], w_lvds_c0[5], w_lvds_c0[6]};
	assign  txd0_o = {w_lvds_d0[0], w_lvds_d0[1], w_lvds_d0[2], w_lvds_d0[3], w_lvds_d0[4], w_lvds_d0[5], w_lvds_d0[6]};
	assign  txd1_o = {w_lvds_d1[0], w_lvds_d1[1], w_lvds_d1[2], w_lvds_d1[3], w_lvds_d1[4], w_lvds_d1[5], w_lvds_d1[6]};
	assign  txd2_o = {w_lvds_d2[0], w_lvds_d2[1], w_lvds_d2[2], w_lvds_d2[3], w_lvds_d2[4], w_lvds_d2[5], w_lvds_d2[6]};
	assign  txd3_o = {w_lvds_d3[0], w_lvds_d3[1], w_lvds_d3[2], w_lvds_d3[3], w_lvds_d3[4], w_lvds_d3[5], w_lvds_d3[6]};
	
	assign vs_o = 0; 
	assign hs_o = 0; 
	assign de_o = lcd_de; 
	assign data_o = {lcd_red, lcd_green, lcd_blue}; 	//	DAT

endmodule
