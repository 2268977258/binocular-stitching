
module signal_gen_tdp (
    rstn,

	//Trion and Titanium ports
	clk_a, 		// A-port clk
	rdata_a, 	// A-port read address output
	clke_a,		// A-port clk enable
    byteen_a,	// A-port Byteen input 
    we_a, 		// A-port write enable 
	addr_a, 	// A-port address input
    wdata_a,	// A-port write data input
  
	clk_b, 		// B-port clk
	rdata_b, 	// B-port read address output
	clke_b,		// B-port clk enable
    byteen_b,	// B-port Byteen input 
    we_b, 		// B-port write enable 
	addr_b, 	// B-port address input
    wdata_b,	// B-port write data input
	     
	//Titanium extra ports
	bram_rst_a,	// A-port reset 
	addren_a,	// A-port address enable
	
	bram_rst_b,	// B-port reset 
	addren_b,	// B-port address enable

    state_a,
    state_b,
    sim_end
);

//`include "bram_decompose.vh"
//Trion and Titanium parameters
parameter CLKA_POLARITY     = 1'b1; 		
parameter CLKEA_POLARITY    = 1'b1; 		
parameter WEA_POLARITY	    = 1'b1; 		
parameter OUTPUT_REG_A   	= 1'b1; 	
parameter [0:0] BYTEENA_POLARITY  = 1'b1;     
parameter CLKB_POLARITY     = 1'b1; 		
parameter CLKEB_POLARITY    = 1'b1; 		
parameter WEB_POLARITY	    = 1'b1; 		
parameter OUTPUT_REG_B   	= 1'b1; 	
parameter [0:0] BYTEENB_POLARITY  = 1'b1;     
//Port Enable  
parameter CLK_MODE			= 2;		
parameter CLKEA_ENABLE 		= 1'b1; 	
parameter WEA_ENABLE 		= 1'b1;		
parameter BYTEENA_ENABLE 	= 1'b1;		
parameter CLKEB_ENABLE 		= 1'b1; 	
parameter WEB_ENABLE 		= 1'b1;		
parameter BYTEENB_ENABLE 	= 1'b1;		
//Titanium extra paramters 
parameter RSTA_POLARITY 	= 1'b1;    	
parameter RESET_RAM_A 	    = "SYNC"; 	
parameter RESET_OUTREG_A 	= "NONE"; 	
parameter ADDRENA_POLARITY  = 1'b1;    	
parameter RSTB_POLARITY 	= 1'b1;    	
parameter RESET_RAM_B 	    = "SYNC"; 	
parameter RESET_OUTREG_B 	= "NONE"; 	
parameter ADDRENB_POLARITY  = 1'b1;   	
//Port Enable  
parameter RESET_A_ENABLE 	= 1'b1;		
parameter ADDREN_A_ENABLE 	= 1'b1;		
parameter RESET_B_ENABLE 	= 1'b1;		
parameter ADDREN_B_ENABLE 	= 1'b1;	

parameter DATA_WIDTH_A           = 16;
parameter DATA_WIDTH_B           = 16;
parameter ADDR_WIDTH_A           = 4;
parameter ADDR_WIDTH_B           = 4;
parameter BYTEEN_WIDTH_A         = 2;
parameter BYTEEN_WIDTH_B         = 2;
parameter FAMILY                 = "TITANIUM";
parameter MEMORY_TYPE            = "TDP_RAM";

input                       rstn;
output                      sim_end;
//Trion and Titanium ports
input                       clk_a; 
input [DATA_WIDTH_A-1:0 ]   rdata_a;
output                      clke_a;
output                      we_a;
output [BYTEEN_WIDTH_A-1:0] byteen_a;
output [ADDR_WIDTH_A-1:0 ]  addr_a; 
output [DATA_WIDTH_A-1:0 ]  wdata_a;
output                      bram_rst_a;
output                      addren_a;
output signed [31:0]        state_a;

input                       clk_b; 
input [DATA_WIDTH_B-1:0 ]   rdata_b;
output                      clke_b;
output                      we_b;
output [BYTEEN_WIDTH_B-1:0] byteen_b;
output [ADDR_WIDTH_B-1:0 ]  addr_b; 
output [DATA_WIDTH_B-1:0 ]  wdata_b;
output                      bram_rst_b;
output                      addren_b;
output signed [31:0]        state_b;

//localparam WRITE_MODE_B = WRITE_MODE;
//localparam WRITE_MODE_A = WRITE_MODE;

wire w_we_a;
wire w_clke_a;
wire [BYTEEN_WIDTH_A-1:0] w_byteen_a;
wire [ADDR_WIDTH_A-1:0 ] w_addr_a; 
wire [DATA_WIDTH_A-1:0 ] w_wdata_a;
wire w_bram_rst_a;
wire w_addren_a;

wire w_we_b;
wire w_clke_b;
wire [BYTEEN_WIDTH_B-1:0] w_byteen_b;
wire [ADDR_WIDTH_B-1:0 ] w_addr_b; 
wire [DATA_WIDTH_B-1:0 ] w_wdata_b;
wire w_bram_rst_b;
wire w_addren_b;

wire clk_a_i;
wire clk_b_i;

wire sim_end_a;
wire sim_end_b;
assign clk_a_i = CLKA_POLARITY ~^ clk_a;
assign clk_b_i = CLKB_POLARITY ~^ clk_b;

assign clke_a = CLKEA_ENABLE ? w_clke_a~^CLKEA_POLARITY : CLKEA_POLARITY;
assign we_a = WEA_ENABLE ? w_we_a~^WEA_POLARITY : WEA_POLARITY;
assign byteen_a = BYTEENA_ENABLE ? w_byteen_a~^{BYTEEN_WIDTH_A{BYTEENA_POLARITY}} : {BYTEEN_WIDTH_A{BYTEENA_POLARITY}};
assign addren_a = FAMILY == "TRION" ? ADDRENA_POLARITY : ADDREN_A_ENABLE ? w_addren_a~^ADDRENA_POLARITY : ADDRENA_POLARITY;
assign bram_rst_a = RESET_A_ENABLE ? w_bram_rst_a~^RSTA_POLARITY : ~RSTA_POLARITY;
assign wdata_a = w_wdata_a;
assign addr_a = w_addr_a;

assign clke_b       = CLKEB_ENABLE    ? w_clke_b ~^ CLKEB_POLARITY : CLKEB_POLARITY;
assign we_b         = WEB_ENABLE      ? w_we_b ~^ WEB_POLARITY : WEB_POLARITY;
assign byteen_b     = BYTEENB_ENABLE  ? w_byteen_b ~^ {BYTEEN_WIDTH_B{BYTEENB_POLARITY}} : {BYTEEN_WIDTH_B{BYTEENB_POLARITY}};
assign addren_b     = FAMILY == "TRION" ? ADDRENB_POLARITY : ADDREN_B_ENABLE ? w_addren_b ~^ ADDRENB_POLARITY : ADDRENB_POLARITY;
assign bram_rst_b   = RESET_B_ENABLE  ? w_bram_rst_b ~^ RSTB_POLARITY : ~RSTB_POLARITY;
assign wdata_b      = w_wdata_b;
assign addr_b       = w_addr_b;

assign sim_end = sim_end_a && sim_end_b;

generate
	if (MEMORY_TYPE == "TDP_RAM") 
	begin
        
		tdp_test_pattern #(
            .SEED_INIT(999),
            .ADDR_WIDTH(ADDR_WIDTH_A),
            .DATA_WIDTH(DATA_WIDTH_A),
            .BYTEEN_WIDTH(BYTEEN_WIDTH_A),
            .SCAN_MODE(0)
        ) tdp_test_pattern_a (
            .clk(clk_a_i),
            .rstn(rstn),
            .sim_end(sim_end_a),
        
            .addr(w_addr_a),
            .wdata(w_wdata_a),
            .clke(w_clke_a),
            .we(w_we_a),
            .byteen(w_byteen_a),
            .addren(w_addren_a),
            .bram_rst(w_bram_rst_a),
            .state_out(state_a)
        );
        
        tdp_test_pattern #(
            .SEED_INIT(666),
            .ADDR_WIDTH(ADDR_WIDTH_B),
            .DATA_WIDTH(DATA_WIDTH_B),
            .BYTEEN_WIDTH(BYTEEN_WIDTH_B),
            .SCAN_MODE(1)
        ) tdp_test_pattern_b (
            .clk(clk_b_i),
            .rstn(rstn),
            .sim_end(sim_end_b),
        
            .addr(w_addr_b),
            .wdata(w_wdata_b),
            .clke(w_clke_b),
            .we(w_we_b),
            .byteen(w_byteen_b),
            .addren(w_addren_b),
            .bram_rst(w_bram_rst_b),
            .state_out(state_b)
        );
    end
    else if (MEMORY_TYPE == "DP_ROM")
    begin
    	
    	dp_test_pattern_rom #(
            .SEED_INIT(999),
            .ADDR_WIDTH(ADDR_WIDTH_A),
            .DATA_WIDTH(DATA_WIDTH_A),
            .BYTEEN_WIDTH(BYTEEN_WIDTH_A),
            .SCAN_MODE(0)
        ) dp_test_pattern_a (
            .clk(clk_a_i),
            .rstn(rstn),
            .sim_end(sim_end_a),
        
            .addr(w_addr_a),
            .wdata(w_wdata_a),
            .clke(w_clke_a),
            .we(w_we_a),
            .byteen(w_byteen_a),
            .addren(w_addren_a),
            .bram_rst(w_bram_rst_a),
            .state_out(state_a)
        );
        
        dp_test_pattern_rom #(
            .SEED_INIT(666),
            .ADDR_WIDTH(ADDR_WIDTH_B),
            .DATA_WIDTH(DATA_WIDTH_B),
            .BYTEEN_WIDTH(BYTEEN_WIDTH_B),
            .SCAN_MODE(1)
        ) dp_test_pattern_b (
            .clk(clk_b_i),
            .rstn(rstn),
            .sim_end(sim_end_b),
        
            .addr(w_addr_b),
            .wdata(w_wdata_b),
            .clke(w_clke_b),
            .we(w_we_b),
            .byteen(w_byteen_b),
            .addren(w_addren_b),
            .bram_rst(w_bram_rst_b),
            .state_out(state_b)
        );
        
    end
endgenerate
    	 

endmodule
