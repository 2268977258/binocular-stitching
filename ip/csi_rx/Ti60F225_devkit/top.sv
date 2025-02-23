
// synopsys translate_off
`timescale 1 ns / 1 ps													
// synopsys translate_on

module top #(   //csi2 example design
    parameter PIXEL_BIT  = 24,
    parameter PACK_BIT   = 48,
    parameter HSA		 = 5,  //minimum value is pixel cnt value, eg: RGB888 - 2
    parameter HBP		 = 5,   //minimum value is pixel cnt value, eg: RGB888 - 2
    parameter HFP		 = 1024,
    parameter HACT_CNT	 = 1920,
    parameter VSA		 = 1,
    parameter VBP		 = 1,
    parameter VFP		 = 100,
    parameter VACT_CNT	 = 1080,
    parameter HS_BYTECLK_MHZ = 100,
    parameter DATATYPE = 6'h24     //24 - RGB888
)(
input 			mipi_clk,	//100MHz
input 			reset_n,  //sw5
output [3:0]	led,
input			pixel_clk,	//50Mhz
input           pll_locked,
output          pll_rstn,

input 			mipi_dphy_rx_clk_LP_P_IN,
input			mipi_dphy_rx_clk_LP_N_IN,
output			mipi_dphy_rx_clk_HS_TERM,
output			mipi_dphy_rx_clk_HS_ENA,
input 			mipi_dphy_rx_clk_CLKOUT,

input	[7:0]	mipi_dphy_rx_data0_HS_IN,
input			mipi_dphy_rx_data0_LP_P_IN,
input			mipi_dphy_rx_data0_LP_N_IN,
output          mipi_dphy_rx_data0_RST,
output			mipi_dphy_rx_data0_HS_TERM,
output			mipi_dphy_rx_data0_HS_ENA,
output 			mipi_dphy_rx_data0_FIFO_RD,
input 			mipi_dphy_rx_data0_FIFO_EMPTY,
output 			mipi_dphy_rx_data0_DLY_RST,
output 			mipi_dphy_rx_data0_DLY_INC,
output 			mipi_dphy_rx_data0_DLY_ENA,

input	[7:0]	mipi_dphy_rx_data1_HS_IN,
input			mipi_dphy_rx_data1_LP_P_IN,
input			mipi_dphy_rx_data1_LP_N_IN,
output          mipi_dphy_rx_data1_RST,
output			mipi_dphy_rx_data1_HS_TERM,
output			mipi_dphy_rx_data1_HS_ENA,
output 			mipi_dphy_rx_data1_FIFO_RD,
input 			mipi_dphy_rx_data1_FIFO_EMPTY,
output 			mipi_dphy_rx_data1_DLY_RST,
output 			mipi_dphy_rx_data1_DLY_INC,
output 			mipi_dphy_rx_data1_DLY_ENA,

input	[7:0]	mipi_dphy_rx_data2_HS_IN,
input			mipi_dphy_rx_data2_LP_P_IN,
input			mipi_dphy_rx_data2_LP_N_IN,
output          mipi_dphy_rx_data2_RST,
output			mipi_dphy_rx_data2_HS_TERM,
output			mipi_dphy_rx_data2_HS_ENA,
output 			mipi_dphy_rx_data2_FIFO_RD,
input 			mipi_dphy_rx_data2_FIFO_EMPTY,
output 			mipi_dphy_rx_data2_DLY_RST,
output 			mipi_dphy_rx_data2_DLY_INC,
output 			mipi_dphy_rx_data2_DLY_ENA,

input	[7:0]	mipi_dphy_rx_data3_HS_IN,
input			mipi_dphy_rx_data3_LP_P_IN,
input			mipi_dphy_rx_data3_LP_N_IN,
output          mipi_dphy_rx_data3_RST,
output			mipi_dphy_rx_data3_HS_TERM,
output			mipi_dphy_rx_data3_HS_ENA,
output 			mipi_dphy_rx_data3_FIFO_RD,
input 			mipi_dphy_rx_data3_FIFO_EMPTY,
output 			mipi_dphy_rx_data3_DLY_RST,
output 			mipi_dphy_rx_data3_DLY_INC,
output 			mipi_dphy_rx_data3_DLY_ENA,

input           mipi_dphy_tx_SLOWCLK,
output 			mipi_dphy_tx_HS_enable_C,
output  [7:0]   mipi_dphy_tx_clk_HS_OUT,
output          mipi_dphy_tx_clk_RST,
output			mipi_dphy_tx_clk_LP_P_OE,
output			mipi_dphy_tx_clk_LP_P_OUT,
output			mipi_dphy_tx_clk_LP_N_OE,
output			mipi_dphy_tx_clk_LP_N_OUT,

output			mipi_dphy_tx_data0_HS_OE,
output	[7:0]	mipi_dphy_tx_data0_HS_OUT,
output          mipi_dphy_tx_data0_RST,
output			mipi_dphy_tx_data0_LP_N_OE,
output			mipi_dphy_tx_data0_LP_N_OUT,
output			mipi_dphy_tx_data0_LP_P_OE,
output			mipi_dphy_tx_data0_LP_P_OUT,

output			mipi_dphy_tx_data1_HS_OE,
output	[7:0]	mipi_dphy_tx_data1_HS_OUT,
output          mipi_dphy_tx_data1_RST,
output			mipi_dphy_tx_data1_LP_N_OE,
output			mipi_dphy_tx_data1_LP_N_OUT,
output			mipi_dphy_tx_data1_LP_P_OE,
output			mipi_dphy_tx_data1_LP_P_OUT,

output			mipi_dphy_tx_data2_HS_OE,
output	[7:0]	mipi_dphy_tx_data2_HS_OUT,
output          mipi_dphy_tx_data2_RST,
output			mipi_dphy_tx_data2_LP_N_OE,
output			mipi_dphy_tx_data2_LP_N_OUT,
output			mipi_dphy_tx_data2_LP_P_OE,
output			mipi_dphy_tx_data2_LP_P_OUT,

output			mipi_dphy_tx_data3_HS_OE,
output	[7:0]	mipi_dphy_tx_data3_HS_OUT,
output          mipi_dphy_tx_data3_RST,
output			mipi_dphy_tx_data3_LP_N_OE,
output			mipi_dphy_tx_data3_LP_N_OUT,
output			mipi_dphy_tx_data3_LP_P_OE,
output			mipi_dphy_tx_data3_LP_P_OUT
);

localparam FIFO_WIDTH = 13;
localparam PIXEL_FIFO_DEPTH = 2048;  //set to a power of 2 value that is bigger than HACT_CNT
localparam CLOCK_FREQ_MHZ = 100;

logic rx_out_valid_1P, rx_out_hs_1P;
logic mipi_clk_reset_n, mipi_dphy_rx_reset_byte_HS_n, reset_pixel_n, mipi_dphy_tx_reset_byte_HS_n;
logic [21:0] count_led;
logic [5:0] datatype;
logic [15:0] word_count;
logic [FIFO_WIDTH-1:0] r_x_active_1P, r_y_active_1P;

assign pll_rstn = 1'b1;

always @ (posedge mipi_dphy_rx_clk_CLKOUT or negedge mipi_dphy_rx_reset_byte_HS_n) begin
    if (~mipi_dphy_rx_reset_byte_HS_n) begin
        count_led <= 22'h0;
    end
    else begin
        count_led <= count_led + 22'h1;
    end
end

assign	mipi_dphy_tx_clk_RST	= 1'b0;
assign	mipi_dphy_tx_data0_RST	= 1'b0;
assign  mipi_dphy_rx_data0_RST   = 1'b0;
assign	mipi_dphy_tx_data1_RST	= 1'b0;
assign  mipi_dphy_rx_data1_RST   = 1'b0;
assign	mipi_dphy_tx_data2_RST	= 1'b0;
assign  mipi_dphy_rx_data2_RST   = 1'b0;
assign	mipi_dphy_tx_data3_RST	= 1'b0;
assign  mipi_dphy_rx_data3_RST   = 1'b0;

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_clk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_clk),
	.o_srst	(mipi_clk_reset_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_rx_byteclk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_dphy_rx_clk_CLKOUT),
	.o_srst	(mipi_dphy_rx_reset_byte_HS_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_tx_byteclk_rst
(
	.i_arst	(reset_n),
	.i_clk	(mipi_dphy_tx_SLOWCLK),
	.o_srst	(mipi_dphy_tx_reset_byte_HS_n)
);

reset
#(
	.IN_RST_ACTIVE	("LOW"),
	.OUT_RST_ACTIVE	("LOW"),
	.CYCLE			(3)
)
inst_pixel_clk_rst
(
	.i_arst	(reset_n),
	.i_clk	(pixel_clk),
	.o_srst	(reset_pixel_n)
);

///////////////////// Start of VGA gen ////////////////
//-----------------------------------------------------------//
// 1280*16 VGA
//-----------------------------------------------------------//
logic [FIFO_WIDTH-1:0] video_x;
logic [FIFO_WIDTH-1:0] video_y;
logic video_valid, video_de, video_hs, video_vs;
logic tx_out_valid, tx_out_hs, tx_out_vs;
logic [PACK_BIT-1:0] tx_out_data;
logic [FIFO_WIDTH-1:0] pg_x;
logic [FIFO_WIDTH-1:0] pg_y;
logic pg_valid, pg_de, pg_hs, pg_vs;
logic [PIXEL_BIT-1:0] pg_data;

vga_gen
#(
	.H_SyncPulse	(HSA		),           
	.H_BackPorch	(HBP		),  	          
	.H_ActivePix	(HACT_CNT	),	           
	.H_FrontPorch	(HFP		),
	.V_SyncPulse	(VSA		),
	.V_BackPorch	(VBP		),
	.V_ActivePix	(VACT_CNT	),
	.V_FrontPorch	(VFP		),
	.FIFO_WIDTH	    (FIFO_WIDTH),
	.P_Cnt			(1		)
)
inst_vga_gen
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.out_x		(video_x),
	.out_y		(video_y),
	.out_valid	(video_valid),
	.out_de		(video_de),
	.out_hs		(video_hs),
	.out_vs		(video_vs)
);

pattern_gen
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.FIFO_WIDTH	(FIFO_WIDTH),  	          
	.H_ActivePix(HACT_CNT),
	.V_ActivePix(VACT_CNT)
)
inst_tx_pattern_gen
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(video_x),
	.in_y		(video_y),
	.in_valid	(video_valid),
	.in_de		(video_de),
	.in_hs		(video_hs),
	.in_vs		(video_vs),
	.in_pattern	(1),
	
	.out_x		(pg_x),
	.out_y		(pg_y),
	.out_valid	(pg_valid),
	.out_de		(pg_de),
	.out_hs		(pg_hs),
	.out_vs		(pg_vs),
	.out_data	(pg_data)
);

// Horizontal porch value must be multipled by PACK_BIT/PIXEL_BIT
datatype_gen
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.PACK_BIT	(PACK_BIT),  	          
	.FIFO_WIDTH	(FIFO_WIDTH)
)
inst_datatype_gen
(
	.in_pclk	(pixel_clk),
	.out_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(pg_x),
	.in_y		(pg_y),
	.in_valid	(pg_valid),
	.in_de		(pg_de),
	.in_hs		(pg_hs),
	.in_vs		(pg_vs),
	.in_data	(pg_data),
	
	.out_x		(),
	.out_y		(),
	.out_valid	(tx_out_valid),
	.out_de		(),
	.out_hs		(tx_out_hs),
	.out_vs		(tx_out_vs),
	.out_data	(tx_out_data)
);
///////////////////// end of VGA gen ////////////////

reg		[5:0]	r_tx_axi_araddr_1P;
reg				r_tx_axi_arvalid_1P;
wire			w_tx_axi_arready;
wire	[31:0]	w_tx_axi_rdata;
wire			w_tx_axi_rvalid;
reg				r_tx_axi_rready_1P;

efx_csi2_tx inst_efx_csi2_tx
(
    .reset_n			(reset_n),
    .clk				(mipi_clk),
    .reset_byte_HS_n	(mipi_dphy_tx_reset_byte_HS_n),
    .clk_byte_HS		(mipi_dphy_tx_SLOWCLK),
    .reset_pixel_n		(reset_pixel_n),
    .clk_pixel			(pixel_clk),
    // LVDS clock lane   
	.Tx_LP_CLK_P		(mipi_dphy_tx_clk_LP_P_OUT),
    .Tx_LP_CLK_P_OE     (mipi_dphy_tx_clk_LP_P_OE),
	.Tx_LP_CLK_N		(mipi_dphy_tx_clk_LP_N_OUT),
    .Tx_LP_CLK_N_OE     (mipi_dphy_tx_clk_LP_N_OE),
    .Tx_HS_C            (mipi_dphy_tx_clk_HS_OUT),
	.Tx_HS_enable_C		(mipi_dphy_tx_HS_enable_C),
	
	// ----- DLane 0 -----------
    // LVDS data lane
    .Tx_LP_D_P			({mipi_dphy_tx_data3_LP_P_OUT, mipi_dphy_tx_data2_LP_P_OUT, mipi_dphy_tx_data1_LP_P_OUT, mipi_dphy_tx_data0_LP_P_OUT}),
    .Tx_LP_D_P_OE       ({mipi_dphy_tx_data3_LP_P_OE, mipi_dphy_tx_data2_LP_P_OE, mipi_dphy_tx_data1_LP_P_OE, mipi_dphy_tx_data0_LP_P_OE}),
    .Tx_LP_D_N			({mipi_dphy_tx_data3_LP_N_OUT, mipi_dphy_tx_data2_LP_N_OUT, mipi_dphy_tx_data1_LP_N_OUT, mipi_dphy_tx_data0_LP_N_OUT}),
    .Tx_LP_D_N_OE       ({mipi_dphy_tx_data3_LP_N_OE, mipi_dphy_tx_data2_LP_N_OE, mipi_dphy_tx_data1_LP_N_OE, mipi_dphy_tx_data0_LP_N_OE}),
    .Tx_HS_D_0			(mipi_dphy_tx_data0_HS_OUT),
	.Tx_HS_D_1			(mipi_dphy_tx_data1_HS_OUT),
	.Tx_HS_D_2			(mipi_dphy_tx_data2_HS_OUT),
	.Tx_HS_D_3			(mipi_dphy_tx_data3_HS_OUT),
	.Tx_HS_enable_D		({mipi_dphy_tx_data3_HS_OE, mipi_dphy_tx_data2_HS_OE, mipi_dphy_tx_data1_HS_OE, mipi_dphy_tx_data0_HS_OE}),

    //AXI4-Lite Interface
    .axi_clk		(mipi_clk), 
    .axi_reset_n	(reset_n),
    .axi_awaddr		(6'b0),//Write Address. byte address.
    .axi_awvalid	(1'b1),//Write address valid.
    .axi_awready	(),//Write address ready.
    .axi_wdata		(32'b0),//Write data bus.
    .axi_wvalid		(1'b0),//Write valid.
    .axi_wready		(),//Write ready.
    .axi_bvalid		(),//Write response valid.
    .axi_bready		(1'b0),//Response ready.      
    .axi_araddr		(r_tx_axi_araddr_1P),//Read address. byte address.
    .axi_arvalid	(r_tx_axi_arvalid_1P),//Read address valid.
    .axi_arready	(w_tx_axi_arready),//Read address ready.
    .axi_rdata		(w_tx_axi_rdata),//Read data.
    .axi_rvalid		(w_tx_axi_rvalid),//Read valid.
//    .axi_rready		(r_tx_axi_rready_1P),//Read ready.
    .axi_rready		(1'b1),//Read ready.
	
    .hsync_vc0			(tx_out_hs),
    .hsync_vc1			(1'b0),
    .hsync_vc2			(1'b0),
    .hsync_vc3			(1'b0),
    .vsync_vc0			(tx_out_vs),
    .vsync_vc1			(1'b0),
    .vsync_vc2			(1'b0),
    .vsync_vc3			(1'b0),
    .datatype			(DATATYPE),   // data type of the Long Packet
    .pixel_data			(tx_out_data),
    .pixel_data_valid	(tx_out_valid),
	.haddr              (HACT_CNT),  //for RAW8 word_count = HACT_CNT
	.line_num			(0),
	.frame_num			(0),	
    .irq				()
);

////////////////////////MIPI RX//////////////////////
logic rx_out_valid, rx_out_hs, rx_out_vs;
logic [PACK_BIT-1:0] rx_out_data;
logic [FIFO_WIDTH-1:0] rx_unpack_x;
logic [FIFO_WIDTH-1:0] rx_unpack_y;
logic rx_unpack_valid, rx_unpack_de, rx_unpack_hs, rx_unpack_vs;
logic [PIXEL_BIT-1:0] rx_unpack_data, rx_unpack_data_1P;
logic [FIFO_WIDTH-1:0] golden_x;
logic [FIFO_WIDTH-1:0] golden_y;
logic golden_valid, golden_de, golden_hs, golden_vs;
logic [PIXEL_BIT-1:0] golden_data;
logic r_pass, r_fail;
logic [11:0] flash_cnt;
logic [2:0] error_bit;

reg		[5:0]	r_rx_axi_araddr_1P;
reg				r_rx_axi_arvalid_1P;
wire			w_rx_axi_arready;
wire	[31:0]	w_rx_axi_rdata;
wire			w_rx_axi_rvalid;
reg				r_rx_axi_rready_1P;

csi_rx inst_efx_csi2_rx
(
    .reset_n			(reset_n),
    .clk				(mipi_clk),
    .reset_byte_HS_n	(mipi_dphy_rx_reset_byte_HS_n),
    .clk_byte_HS		(mipi_dphy_rx_clk_CLKOUT),
    .reset_pixel_n		(reset_pixel_n),
    .clk_pixel			(pixel_clk),  
    // LVDS clock lane   
	.Rx_LP_CLK_P		(mipi_dphy_rx_clk_LP_P_IN),
	.Rx_LP_CLK_N		(mipi_dphy_rx_clk_LP_N_IN),
	.Rx_HS_enable_C		(mipi_dphy_rx_clk_HS_ENA),
	.LVDS_termen_C		(mipi_dphy_rx_clk_HS_TERM),
	
	// ----- DLane 0 -----------
    // LVDS data lane
    .Rx_LP_D_P			({mipi_dphy_rx_data3_LP_P_IN, mipi_dphy_rx_data2_LP_P_IN, mipi_dphy_rx_data1_LP_P_IN, mipi_dphy_rx_data0_LP_P_IN}),
	.Rx_LP_D_N			({mipi_dphy_rx_data3_LP_N_IN, mipi_dphy_rx_data2_LP_N_IN, mipi_dphy_rx_data1_LP_N_IN, mipi_dphy_rx_data0_LP_N_IN}),
	.Rx_HS_D_0			(mipi_dphy_rx_data0_HS_IN),
	.Rx_HS_D_1			(mipi_dphy_rx_data1_HS_IN),	
	.Rx_HS_D_2			(mipi_dphy_rx_data2_HS_IN),
	.Rx_HS_D_3			(mipi_dphy_rx_data3_HS_IN),
	.Rx_HS_enable_D		({mipi_dphy_rx_data3_HS_ENA, mipi_dphy_rx_data2_HS_ENA, mipi_dphy_rx_data1_HS_ENA, mipi_dphy_rx_data0_HS_ENA}),
	.LVDS_termen_D		({mipi_dphy_rx_data3_HS_TERM, mipi_dphy_rx_data2_HS_TERM, mipi_dphy_rx_data1_HS_TERM, mipi_dphy_rx_data0_HS_TERM}),
	.fifo_rd_enable     ({mipi_dphy_rx_data3_FIFO_RD, mipi_dphy_rx_data2_FIFO_RD, mipi_dphy_rx_data1_FIFO_RD, mipi_dphy_rx_data0_FIFO_RD}),
	.fifo_rd_empty      ({mipi_dphy_rx_data3_FIFO_EMPTY, mipi_dphy_rx_data2_FIFO_EMPTY, mipi_dphy_rx_data1_FIFO_EMPTY, mipi_dphy_rx_data0_FIFO_EMPTY}),
	
	.DLY_enable_D       (),
	.DLY_inc_D          (),
	.u_dly_enable_D     (),
	.u_dly_inc_D        (),
	
    //AXI4-Lite Interface
    .axi_clk		(mipi_clk), 
    .axi_reset_n	(reset_n),
    .axi_awaddr		(6'b0),//Write Address. byte address.
    .axi_awvalid	(1'b0),//Write address valid.
    .axi_awready	(),//Write address ready.
    .axi_wdata		(32'b0),//Write data bus.
    .axi_wvalid		(1'b0),//Write valid.
    .axi_wready		(),//Write ready.           
    .axi_bvalid		(),//Write response valid.
    .axi_bready		(1'b0),//Response ready.      
    .axi_araddr		(r_rx_axi_araddr_1P),//Read address. byte address.
    .axi_arvalid	(r_rx_axi_arvalid_1P),//Read address valid.
    .axi_arready	(w_rx_axi_arready),//Read address ready.
    .axi_rdata		(w_rx_axi_rdata),//Read data.
    .axi_rvalid		(w_rx_axi_rvalid),//Read valid.
//    .axi_rready		(r_rx_axi_rready_1P),//Read ready.
    .axi_rready		(1'b1),//Read ready.
	
    .hsync_vc0			(rx_out_hs),
    .hsync_vc1			(),
    .hsync_vc2			(),
    .hsync_vc3			(),
    .vsync_vc0			(rx_out_vs),
    .vsync_vc1			(),
    .vsync_vc2			(),
    .vsync_vc3			(),
    .vc					(),
	.word_count			(word_count),
	.shortpkt_data_field(),
	.datatype			(datatype),        // RAW8
    .pixel_per_clk		(),
	.pixel_data			(rx_out_data),
    .pixel_data_valid	(rx_out_valid),
    .irq				()

);

//------------- Unpack of RX pixel ---------------
//RAW8 for PIXEL_BIT 8, PACK_BIT 64
data_unpack
#(
	.PIXEL_BIT	(PIXEL_BIT),           
	.PACK_BIT	(PACK_BIT),  	          
	.FIFO_WIDTH	(FIFO_WIDTH)
)
inst_data_unpack
(
	.in_pclk	(pixel_clk),
	.in_rstn	(reset_pixel_n),
	
	.in_x		(r_x_active_1P),
	.in_y		(r_y_active_1P),
	.in_valid	(rx_out_valid),
	.in_de		(rx_out_hs),
	.in_hs		(rx_out_hs),
	.in_vs		(rx_out_vs),
	.in_data	(rx_out_data),
	
	.out_x		(rx_unpack_x),
	.out_y		(rx_unpack_y),
	.out_valid	(rx_unpack_valid),
	.out_de		(rx_unpack_de),
	.out_hs		(rx_unpack_hs),
	.out_vs		(rx_unpack_vs),
	.out_data	(rx_unpack_data)
);
//---------- End of unpack RX pixel -------------

//*******************************   
// MIPI-Rx-data comparator 
//*******************************   
pattern_gen
#(
    .PIXEL_BIT    (PIXEL_BIT),           
    .FIFO_WIDTH   (FIFO_WIDTH),                
    .H_ActivePix  (HACT_CNT),
    .V_ActivePix  (VACT_CNT)
)
inst_rx_pattern_gen
(
    .in_pclk    (pixel_clk),
    .in_rstn    (reset_pixel_n),
    
    .in_x        (rx_unpack_x),
    .in_y        (rx_unpack_y),
    .in_valid    (rx_unpack_valid),
    .in_de       (rx_unpack_de),
    .in_hs       (rx_unpack_hs),
    .in_vs       (rx_unpack_vs),
    .in_pattern  (1),
    
    .out_x        (golden_x),
    .out_y        (golden_y),
    .out_valid    (golden_valid),
    .out_de       (golden_de),
    .out_hs       (golden_hs),
    .out_vs       (golden_vs),
    .out_data     (golden_data)
);

always @(posedge pixel_clk or negedge reset_pixel_n) 
begin
    if (~reset_pixel_n) begin
        rx_out_valid_1P <= 1'b0;
        rx_out_hs_1P    <= 1'b0;
    end
	else begin
        rx_out_valid_1P <= rx_out_valid;
        rx_out_hs_1P    <= rx_out_hs;
    end
end

always @ (posedge pixel_clk or negedge reset_pixel_n)
begin
    if(~reset_pixel_n) begin
        rx_unpack_data_1P   <= {PIXEL_BIT{1'b0}};
        r_x_active_1P       <= {FIFO_WIDTH{1'b0}};
        r_y_active_1P       <= {FIFO_WIDTH{1'b0}};
        error_bit           <= 3'b000;
        r_fail              <= 1'b0;
        r_pass              <= 1'b0;
    end    
    else begin        
        rx_unpack_data_1P    <= rx_unpack_data;
        
        if (rx_out_valid) begin
            r_x_active_1P    <= r_x_active_1P + 1'b1;
        end
        else if (~rx_out_hs) begin
            r_x_active_1P    <= {FIFO_WIDTH{1'b0}};
        end
       
        if (~rx_out_hs && rx_out_hs_1P) begin
            r_y_active_1P    <= r_y_active_1P + 1'b1;
        end
        else if (~rx_out_vs) begin
            r_y_active_1P    <= {FIFO_WIDTH{1'b0}};
        end
        
        if (golden_valid && error_bit == 3'b000) begin
            if (golden_data !== rx_unpack_data_1P) begin
                error_bit    <= error_bit + 1'b1;
                r_pass <= 1'b0;
            end
            else begin
                r_pass <= 1'b1;
            end
        end
        
        if (error_bit > 3'b000) r_fail <= 1'b1;
    end
end

always @(posedge pixel_clk or negedge reset_pixel_n) 
begin
    if (~reset_pixel_n) begin
        flash_cnt <= 12'b0;
    end
	else if (~r_fail && rx_out_hs && ~rx_out_hs_1P) begin
        flash_cnt <= flash_cnt + 1'b1;
    end
end

assign led[0] = count_led[21];
assign led[1] = r_fail;
assign led[2] = r_pass;
assign led[3] = flash_cnt[11];

////////////////////////////////

localparam	s_idle			= 2'b00;
localparam	s_wait_arready	= 2'b01;
localparam	s_wait_rvalid	= 2'b10;

reg		[1:0]	r_tx_dbg_fsm_1P;
reg		[8:0]	r_tx_dbg_reg_1P	[0:7];
reg		[1:0]	r_rx_dbg_fsm_1P;
reg		[14:0]	r_rx_dbg_reg_1P	[0:15];

always@(negedge reset_n or posedge mipi_clk)
begin
	if (~reset_n)
	begin
		r_tx_dbg_fsm_1P		<= s_idle;
		r_tx_axi_arvalid_1P	<= 1'b0;
		r_tx_axi_araddr_1P	<= 6'b0;
		r_tx_axi_rready_1P	<= 1'b0;
		
		r_rx_dbg_fsm_1P		<= s_idle;
		r_rx_axi_arvalid_1P	<= 1'b0;
		r_rx_axi_araddr_1P	<= 6'b0;
		r_rx_axi_rready_1P	<= 1'b0;
	end
	else
	begin
		r_tx_axi_rready_1P	<= 1'b0;
		r_rx_axi_rready_1P	<= 1'b0;
		
		case (r_tx_dbg_fsm_1P)
			s_idle:
			begin
				r_tx_dbg_fsm_1P		<= s_wait_arready;
				r_tx_axi_arvalid_1P	<= 1'b1;
			end
			
			s_wait_arready:
			begin
				if (w_tx_axi_arready)
				begin
					r_tx_dbg_fsm_1P		<= s_wait_rvalid;
					r_tx_axi_arvalid_1P	<= 1'b0;
				end
			end
			
			s_wait_rvalid:
			begin
				if (w_tx_axi_rvalid)
				begin
					r_tx_dbg_fsm_1P		<= s_wait_arready;
					r_tx_axi_arvalid_1P	<= 1'b1;
					r_tx_axi_rready_1P	<= 1'b1;
					r_tx_axi_araddr_1P	<= r_tx_axi_araddr_1P+6'h4;
					if (r_tx_axi_araddr_1P == 6'h18)
						r_tx_axi_araddr_1P	<= 6'b0;
					
					r_tx_dbg_reg_1P[r_tx_axi_araddr_1P[4:2]]	<= w_tx_axi_rdata[8:0];
				end
			end
		endcase
		
		case (r_rx_dbg_fsm_1P)
			s_idle:
			begin
				r_rx_dbg_fsm_1P		<= s_wait_arready;
				r_rx_axi_arvalid_1P	<= 1'b1;
			end
			
			s_wait_arready:
			begin
				if (w_rx_axi_arready)
				begin
					r_rx_dbg_fsm_1P		<= s_wait_rvalid;
					r_rx_axi_arvalid_1P	<= 1'b0;
				end
			end
			
			s_wait_rvalid:
			begin
				if (w_rx_axi_rvalid)
				begin
					r_rx_dbg_fsm_1P		<= s_wait_arready;
					r_rx_axi_arvalid_1P	<= 1'b1;
					r_rx_axi_rready_1P	<= 1'b1;
					r_rx_axi_araddr_1P	<= r_rx_axi_araddr_1P+6'h4;
					if (r_rx_axi_araddr_1P == 6'h28)
						r_rx_axi_araddr_1P	<= 6'b0;
					
					r_rx_dbg_reg_1P[r_rx_axi_araddr_1P[5:2]]	<= w_rx_axi_rdata[14:0];
/*					r_rx_axi_araddr_1P	<= r_rx_axi_araddr_1P+6'h10;
					if (r_rx_axi_araddr_1P == 6'h30)
						r_rx_axi_araddr_1P	<= 6'b0;
					
					r_rx_dbg_reg_1P[r_rx_axi_araddr_1P[5:4]]	<= w_rx_axi_rdata[14:0];*/
				end
			end
		endcase
	end
end

endmodule
