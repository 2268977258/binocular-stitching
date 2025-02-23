`timescale 1ns / 1ps
module DdrCtrl (
input clk,
input core_clk,
input twd_clk,
input tdqss_clk,
input tac_clk,
input reset_n,
output reset,
output cs,
output ras,
output cas,
output we,
output cke,
output [15:0] addr,
output [2:0] ba,
output odt,
output wr_busy,
input [31:0] wr_addr,
input wr_en,
input wr_addr_en,
output wr_ack,
output rd_busy,
input [31:0] rd_addr,
input rd_addr_en,
input rd_en,
output rd_valid,
output rd_ack,
output [2:0] shift,
output [4:0] shift_sel,
output shift_ena,
input cal_ena,
output cal_done,
output cal_pass,
output [6:0] cal_fail_log,
output [2:0] cal_shift_val,
output [1:0] o_dm_hi,
output [1:0] o_dm_lo,
input [1:0] i_dqs_hi,
input [1:0] i_dqs_lo,
input [1:0] i_dqs_n_hi,
input [1:0] i_dqs_n_lo,
output [1:0] o_dqs_hi,
output [1:0] o_dqs_lo,
output [1:0] o_dqs_n_hi,
output [1:0] o_dqs_n_lo,
output [1:0] o_dqs_oe,
output [1:0] o_dqs_n_oe,
input [15:0] i_dq_hi,
input [15:0] i_dq_lo,
output [15:0] o_dq_hi,
output [15:0] o_dq_lo,
output [15:0] o_dq_oe,
input [127:0] wr_data,
output [127:0] rd_data,
input [15:0] wr_datamask,
input [7:0] axi_aid,
input [31:0] axi_aaddr,
input [7:0] axi_alen,
input [2:0] axi_asize,
input [1:0] axi_aburst,
input [1:0] axi_alock,
input axi_avalid,
output axi_aready,
input axi_atype,
input [7:0] axi_wid,
input [127:0] axi_wdata,
input [15:0] axi_wstrb,
input axi_wlast,
input axi_wvalid,
output axi_wready,
output [7:0] axi_rid,
output [127:0] axi_rdata,
output axi_rlast,
output axi_rvalid,
input axi_rready,
output [1:0] axi_rresp,
output [7:0] axi_bid,
output [1:0] axi_bresp,
output axi_bvalid,
input axi_bready
);
	assign cal_done = 1; 
	assign cal_pass = 1; 
	
	//	Simulate using clk & reset_n. 
	
	wire 	[31:0] 	w_addr_o; 
	wire 			w_awready, w_arready; 
	wire 	[31:0] 	w_data_0 = w_addr_o + 0, w_data_1 = w_addr_o + 1, w_data_2 = w_addr_o + 2, w_data_3 = w_addr_o + 3; 
	
	AXI4_BRAM_Slave_Wrapper_RegO #(.AWID_LEN(8), .ARID_LEN(8)) axi4_slv_test (
		.aclk_i			(clk),
		.arst_i			(~reset_n),
		
		.s_axi_awid_i		(axi_aid),
		.s_axi_awaddr_i		(axi_aaddr),
		.s_axi_awlen_i		(axi_alen),		//	Burst_Length = AWLEN+1
		.s_axi_awsize_i		(axi_asize),		//	Bytes in transfer. 1, 2, 4, 8, 16, 32, 64, 128. Must <= WDATA_LEN / 8.
		.s_axi_awburst_i		(axi_aburst),	//	Burst Type. FIXED, INCR, WRAP, RESERVED. Wrap boundary = Burst_Length * WDATA_LEN / 8. Default: INCR
		.s_axi_awlock_i		(axi_alock),		//	Normal, Exclusive, Locked, Reserved
		.s_axi_awcache_i		(0),	//	NB, B, NCNB, NCB, WTNA, WTRA, WTWA, WTRWA, WBNA, WBRA, WBWA, WBRWA
		.s_axi_awprot_i		(0),		//	UA/PA, SA/NSA, DA/IA
		.s_axi_awqos_i		(0),		//	Higher for higher priority
		.s_axi_awregion_i		(0),	//	Address Map Extension
		.s_axi_awvalid_i		(axi_avalid && (axi_atype == 1)),	//	AType = 0 for read. 
		.s_axi_awready_o		(w_awready),
		
		.s_axi_wid_i		(axi_wid),
		.s_axi_wdata_i		(axi_wdata),
		.s_axi_wstrb_i		(axi_wstrb),		//	Write Strobe. Default: FF
		.s_axi_wlast_i		(axi_wlast),
		.s_axi_wvalid_i		(axi_wvalid),
		.s_axi_wready_o		(axi_wready),
		
		.s_axi_bid_o		(axi_bid),
		.s_axi_bresp_o		(axi_bresp),		//	OK, EXOK, SLVERR, DECERR
		.s_axi_bvalid_o		(axi_bvalid),
		.s_axi_bready_i		(axi_bready),
		
		.s_axi_arid_i		(axi_aid),
		.s_axi_araddr_i		(axi_aaddr),
		.s_axi_arlen_i		(axi_alen),		//	Burst_Length = ARLEN+1
		.s_axi_arsize_i		(axi_asize),		//	Bytes in transfer. 1, 2, 4, 8, 16, 32, 64, 128. Must <= RDATA_LEN / 8.
		.s_axi_arburst_i		(axi_aburst),	//	Burst Type. FIXED, INCR, WRAP, RESERVED. Wrap boundary = Burst_Length * WDATA_LEN / 8. Default: INCR
		.s_axi_arlock_i		(axi_alock),		//	Normal, Exclusive, Locked, Reserved
		.s_axi_arcache_i		(0),	//	NB, B, NCNB, NCB, WTNA, WTRA, WTWA, WTRWA, WBNA, WBRA, WBWA, WBRWA
		.s_axi_arprot_i		(0),		//	UA/PA, SA/NSA, DA/IA
		.s_axi_arqos_i		(0),		//	Higher for higher priority
		.s_axi_arregion_i		(0),	//	Address Map Extension
		.s_axi_arvalid_i		(axi_avalid && (axi_atype == 0)),
		.s_axi_arready_o		(w_arready),
		
		.s_axi_rid_o		(axi_rid),
		.s_axi_rdata_o		(axi_rdata),
		.s_axi_rresp_o		(axi_rresp),		//	OK, EXOK, SLVERR, DECERR
		.s_axi_rlast_o		(axi_rlast),
		.s_axi_rvalid_o		(axi_rvalid),
		.s_axi_rready_i		(axi_rready),
		
		
		.addr_o			(w_addr_o),
		.data_i			({w_data_3, w_data_2, w_data_1, w_data_0}),
		.data_o			(),
		.we_o 			()
	);
	
	//	Assert AREADY only if awready for write, or arready for read. 
	assign axi_aready = (axi_avalid && (axi_atype == 0) && w_arready) || (axi_avalid && (axi_atype == 1) && w_awready); 
	
	
	
	
endmodule


