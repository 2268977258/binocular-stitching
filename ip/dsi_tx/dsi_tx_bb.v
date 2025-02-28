`timescale 1ns/1ps

module dsi_tx (
input reset_n,
input clk,
input reset_byte_HS_n,
input clk_byte_HS,
input reset_pixel_n,
input clk_pixel,
output irq,
input pixel_data_valid,
input [15:0] haddr,
input hsync,
input vsync,
input [63:0] pixel_data,
input [5:0] datatype,
input [1:0] vc,
input TurnRequest_dbg,
output TurnRequest_done,
input axi_rready,
output axi_rvalid,
output [31:0] axi_rdata,
output axi_arready,
input axi_arvalid,
input [6:0] axi_araddr,
input axi_bready,
output axi_bvalid,
output axi_wready,
input axi_wvalid,
input [31:0] axi_wdata,
output Tx_LP_CLK_P,
output Tx_LP_CLK_P_OE,
output Tx_LP_CLK_N,
output Tx_LP_CLK_N_OE,
output Tx_HS_enable_C,
output [3:0] Tx_LP_D_P,
output [7:0] Tx_HS_C,
output [3:0] Tx_LP_D_P_OE,
output [3:0] Tx_LP_D_N,
output [3:0] Tx_LP_D_N_OE,
output [7:0] Tx_HS_D_0,
output [7:0] Tx_HS_D_1,
output [7:0] Tx_HS_D_2,
output [7:0] Tx_HS_D_3,
output [3:0] Tx_HS_enable_D,
input Rx_LP_D_P,
input Rx_LP_D_N,
output axi_awready,
input axi_clk,
input axi_reset_n,
input [6:0] axi_awaddr,
input axi_awvalid
);


endmodule


