`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:52:52 05/15/2023
// Design Name:   dsi_init
// Module Name:   D:/SVN_Path/DevKitProjects/Ti60/Dev/Ti60_SC130GS_DDR_DSI/src/dsi/dsi_init_tb.v
// Project Name:  Ti60_SC130GS_DDR_DSI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dsi_init
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dsi_init_tb;

	// Inputs
	reg clk_i;
	reg rst_i;
	reg [27:0] delay_i;
	reg awready_i;
	reg wready_i;

	// Outputs
	wire [7:0] awaddr_o;
	wire awvalid_o;
	wire wvalid_o;
	wire [31:0] wdata_o;

	// Instantiate the Unit Under Test (UUT)
	dsi_init uut (
		.clk_i(clk_i), 
		.rst_i(rst_i), 
		.delay_i(delay_i), 
		.awaddr_o(awaddr_o), 
		.awvalid_o(awvalid_o), 
		.awready_i(awready_i), 
		.wvalid_o(wvalid_o), 
		.wdata_o(wdata_o), 
		.wready_i(wready_i)
	);

	initial begin
		// Initialize Inputs
		clk_i = 0;
		rst_i = 1;
		delay_i = 63;
		awready_i = 1;
		wready_i = 1;

		// Wait 100 ns for global reset to finish
		#100; rst_i = 0; #96; 
        
		// Add stimulus here

	end
	
	always #5 clk_i = ~clk_i; 
      
endmodule

