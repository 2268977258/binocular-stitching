
//`define TEST_SP_RAM
`define TEST_SDP_RAM
//`define TEST_TDP_RAM
//`define TEST_SP_ROM
//`define TEST_TDP_ROM



module dpram_top_trion #(
)   
(
    i_arstn,

	o_pll_bram_RSTN,
	i_pll_bram_LOCKED,
	i_wclk,
    i_rclk,

   
    o_led0_r,
    o_led0_g,
    o_led0_b,
   
    o_led1_r,
    o_led1_g,
    o_led1_b,
   
    i_sw0,
    i_sw1,
    i_sw2,
    
 );

`ifdef TEST_SP_RAM
`define SINGLE_TEST

//Trion and Titanium parameters 
	parameter CLK_POLARITY  = 1'b1; 		//clk polarity,  0:falling edge, 1:rising edge
	
	parameter WCLKE_POLARITY = 1'b1; 		//wclke polarity, 0:active low, 1:active high
	parameter WE_POLARITY	 = 1'b1; 		//we polarity,    0:active low, 1:active high
	parameter WRITE_MODE  	 = "WRITE_FIRST";//write mode,  	  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
											//				  "READ_UNKNOWN": Read and writes are unsynchronized, therefore, the results of the address can conflict.
	parameter RE_POLARITY    = 1'b1; 		// re polarity,	  0:active low  , 1:active high
	parameter OUTPUT_REG     = 1'b1; 		// Output register enable, 1:add pipe-line read register

	parameter BYTEEN_POLARITY = 1'b1;		//byteen polarity,    0:active low, 1:active high   

	//Port Enable  
	parameter WCLKE_ENABLE 		= 1'b1; 	//1: Enalbe the port for waddren pin  , 0: dislable 
	
	parameter WE_ENABLE 		= 1'b1;		//1: Enalbe the port for WE pin , 0: dislable 
	parameter RE_ENABLE 		= 1'b1;		//1: Enalbe the port for RE pin , 0: dislable 
	parameter BYTEEN_ENABLE 	= 1'b1;		//1: Enalbe the port for Byteen pins , 0: dislable 

	//Titanium extra paramters 
	parameter RST_POLARITY 	    = 1'b1;    	// rst polarity
	parameter RESET_RAM 	    = "ASYNC"; 	// reset mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG 	    = "ASYNC"; 	// reset mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDREN_POLARITY  = 1'b1;    	// addren polarity


	//Port Enable  
	parameter RESET_ENABLE 		= 1'b1;		//1: Enalbe the port for reset pin  , 0: dislable 
		
	parameter ADDREN_ENABLE 	= 1'b1;		//1: Enalbe the port for addren pin  , 0: dislable 

`endif 

`ifdef TEST_SDP_RAM
`define SINGLE_TEST

//Trion and Titanium parameters 
	parameter CLK_POLARITY  = 1'b1; 		//clk polarity,  0:falling edge, 1:rising edge
		
	parameter WCLK_POLARITY  = 1'b1; 		//wclk polarity,  0:falling edge, 1:rising edge

	parameter WCLKE_POLARITY = 1'b1; 		//wclke polarity, 0:active low, 1:active high
	parameter WE_POLARITY	 = 1'b1; 		//we polarity,    0:active low, 1:active high
	parameter WRITE_MODE  	 = "READ_FIRST";//write mode,  	  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
	parameter RCLK_POLARITY  = 1'b1; 		// rclk polarity, 0:falling edge, 1:rising edge
	parameter RE_POLARITY    = 1'b1; 		// re polarity,	  0:active low  , 1:active high
	parameter OUTPUT_REG     = 1'b0; 		// Output register enable, 1:add pipe-line read register

	parameter BYTEEN_POLARITY = 1'b1;		//byteen polarity,    0:active low, 1:active high   

	//Port Enable  
	parameter CLK_MODE			= 2;		//1: ONE CLK Mode, CLK pin will provide the clock source to the memory
											//2: TWO CLK Mode, wclk pin will provide the clock source for write operation , rclk pin will provide the clock source for read operation

	parameter WCLKE_ENABLE 		= 1'b1; 	//1: Enalbe the port for waddren pin  , 0: dislable 
	
	parameter WE_ENABLE 		= 1'b1;		//1: Enalbe the port for WE pin , 0: dislable 
	parameter RE_ENABLE 		= 1'b1;		//1: Enalbe the port for RE pin , 0: dislable 
	parameter BYTEEN_ENABLE 	= 1'b1;		//1: Enalbe the port for Byteen pins , 0: dislable 

	//Titanium extra paramters 
	parameter RST_POLARITY 	    = 1'b1;    	// rst polarity
	parameter RESET_RAM 	    = "ASYNC"; 	// reset mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG 	    = "ASYNC"; 	// reset mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter WADDREN_POLARITY  = 1'b1;    	// waddren polarity
	parameter RADDREN_POLARITY  = 1'b1;     // raddren polarity


	//Port Enable  
	parameter RESET_ENABLE 		= 1'b1;		//1: Enalbe the port for reset pin  , 0: dislable 
		
	parameter WADDREN_ENABLE 	= 1'b1;		//1: Enalbe the port for waddren pin  , 0: dislable 
	parameter RADDREN_ENABLE 	= 1'b1;		//1: Enalbe the port for raddren pin  , 0: dislable 
	parameter DATA_WIDTH_A      = 16;
	parameter DATA_WIDTH_B      = 16;
	parameter ADDR_WIDTH_A      = 3;
	parameter ADDR_WIDTH_B      = 3;
	parameter BYTEEN_WIDTH      = 1;
	parameter GROUP_DATA_WIDTH  = 16;
	parameter FAMILY            = "TRION";

`endif

`ifdef TEST_TDP_RAM
`define DUAL_TEST

	//Trion and Titanium parameters
	parameter CLK_POLARITY  = 1'b1; 		//clk polarity for one clk mode,  0:falling edge, 1:rising edge 
	parameter CLKE_POLARITY = 1'b1; 		//clke polarity for one clk mode, 0:active low, 1:active high
	
	parameter CLKA_POLARITY  = 1'b1; 		//clk A polarity,  0:falling edge, 1:rising edge
	parameter CLKEA_POLARITY = 1'b1; 		//clke A polarity, 0:active low, 1:active high
	parameter WEA_POLARITY	 = 1'b0; 		//we A polarity,    0:active low, 1:active high
	parameter WRITE_MODE_A 	 = "WRITE_FIRST";//write mode A,  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
											//				  "READ_UNKNOWN": Read and writes are unsynchronized, therefore, the results of the address can conflict.
	parameter OUTPUT_REG_A   	= 1'b1; 	// Output register enable, 1:add pipe-line read register
	parameter BYTEENA_POLARITY  = 1'b1;     // byteen polarity		0:active low, 1:active high 
	
	parameter CLKB_POLARITY  = 1'b1; 		//clk A polarity,  0:falling edge, 1:rising edge
	parameter CLKEB_POLARITY = 1'b1; 		//clke A polarity, 0:active low, 1:active high
	parameter WEB_POLARITY	 = 1'b0; 		//we B polarity,    0:active low, 1:active high
	parameter WRITE_MODE_B 	 = "WRITE_FIRST";//write mode A,  "READ_FIRST" 	:Old memory content is read. (default)
											//			  	  "WRITE_FIRST" :Write data is passed to the read port.
											//				  "READ_UNKNOWN": Read and writes are unsynchronized, therefore, the results of the address can conflict.
	parameter OUTPUT_REG_B   	= 1'b1; 	// Output register enable, 1:add pipe-line read register
	parameter BYTEENB_POLARITY  = 1'b1;     // byteen polarity		0:active low, 1:active high 
	
	
	//Port Enable  
	parameter CLK_MODE			= 1;		//1: ONE CLK Mode, CLK pin will provide the clock source to the memory
											//2: TWO CLK Mode, clk_a and clk_b 
	parameter CLKEA_ENABLE 		= 1'b1; 	//1: Enalbe the port for clke_a pin  , 0: dislable 
	parameter WEA_ENABLE 		= 1'b1;		//1: Enable the port for we_a pin , 0: disable 
	parameter BYTEENA_ENABLE 	= 1'b1;		//1: Enable the port for Byteen_a pins , 0: disable 

	parameter CLKEB_ENABLE 		= 1'b1; 	//1: Enalbe the port for clke_b pin  , 0: dislable 
	parameter WEB_ENABLE 		= 1'b1;		//1: Enable the port for we_b pin , 0: disable 
	parameter BYTEENB_ENABLE 	= 1'b1;		//1: Enable the port for Byteen_b pins , 0: disable 

	
	//Titanium extra paramters 
	parameter RSTA_POLARITY 	= 1'b1;    	// rst A polarity
	parameter RESET_RAM_A 	    = "ASYNC"; 	// reset A mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG_A 	= "ASYNC"; 	// reset A mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDRENA_POLARITY  = 1'b1;    	// addrena polarity
	
	parameter RSTB_POLARITY 	= 1'b1;    	// rst A polarity
	parameter RESET_RAM_B 	    = "ASYNC"; 	// reset A mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG_B 	= "ASYNC"; 	// reset A mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDRENB_POLARITY  = 1'b1;   	// addrenb polarity

	//Port Enable  
	parameter RESET_A_ENABLE 	= 1'b1;		//1: Enable the port for reset_a pin  , 0: disable 
	parameter ADDREN_A_ENABLE 	= 1'b1;		//1: Enable the port for addren_a pin  , 0: disable 
	
	parameter RESET_B_ENABLE 	= 1'b1;		//1: Enable the port for reset_b pin  , 0: disable 
	parameter ADDREN_B_ENABLE 	= 1'b1;		//1: Enable the port for addren_b pin  , 0: disable 

`endif 


`ifdef TEST_SP_ROM
    `define SINGLE_TEST
    parameter WE_POLARITY    = 1'b1; 		// re polarity,	  0:active low  , 1:active high


//Trion and Titanium parameters 
	parameter CLK_POLARITY  = 1'b1; 		//clk polarity,  0:falling edge, 1:rising edge
	
	parameter RE_POLARITY    = 1'b1; 		// re polarity,	  0:active low  , 1:active high
	parameter OUTPUT_REG     = 1'b0; 		// Output register enable, 1:add pipe-line read register

	parameter RE_ENABLE 		= 1'b1;		//1: Enable  the port for RE pin , 0: disable 
	parameter BYTEEN_ENABLE 	= 1'b1;		//1: Enable  the port for Byteen pins , 0: disable 

	//Titanium extra paramters 
	parameter RST_POLARITY 	    = 1'b1;    	// rst polarity
	parameter RESET_RAM 	    = "ASYNC"; 	// reset mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG 	    = "ASYNC"; 	// reset mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDREN_POLARITY  = 1'b1;    	// addren polarity


	//Port Enable  
	parameter RESET_ENABLE 		= 1'b1;		//1: Enable  the port for reset pin  , 0: disable 
		
	parameter ADDREN_ENABLE 	= 1'b1;		//1: Enable  the port for addren pin  , 0: disable 


`endif 

`ifdef TEST_TDP_ROM
	`define DUAL_TEST
    parameter WEA_POLARITY	 = 1'b1; 		//we A polarity,    0:active low, 1:active high
    parameter WEB_POLARITY	 = 1'b1; 		//we A polarity,    0:active low, 1:active high
    
    
    
	//Trion and Titanium parameters
	parameter CLK_POLARITY  = 1'b1; 		//clk polarity for one clk mode,  0:falling edge, 1:rising edge 
	parameter CLKE_POLARITY = 1'b1; 		//clke polarity for one clk mode, 0:active low, 1:active high
	
	parameter CLKA_POLARITY  = 1'b1; 		//clk A polarity,  0:falling edge, 1:rising edge
	parameter CLKEA_POLARITY = 1'b1; 		//clke A polarity, 0:active low, 1:active high
	
	parameter OUTPUT_REG_A   	= 1'b0; 	// Output register enable, 1:add pipe-line read register
	parameter BYTEENA_POLARITY  = 1'b1;     // byteen polarity		0:active low, 1:active high 
	
	parameter CLKB_POLARITY  = 1'b1; 		//clk A polarity,  0:falling edge, 1:rising edge
	parameter CLKEB_POLARITY = 1'b1; 		//clke A polarity, 0:active low, 1:active high
	
	parameter OUTPUT_REG_B   	= 1'b0; 	// Output register enable, 1:add pipe-line read register
	parameter BYTEENB_POLARITY  = 1'b1;     // byteen polarity		0:active low, 1:active high 
	
	
	//Port Enable  
	parameter CLK_MODE			= 2;		//1: ONE CLK Mode, CLK pin will provide the clock source to the memory
											//2: TWO CLK Mode, clk_a and clk_b 
	parameter CLKEA_ENABLE 		= 1'b1; 	//1: Enalbe the port for clke_a pin  , 0: dislable 

	parameter CLKEB_ENABLE 		= 1'b1; 	//1: Enalbe the port for clke_b pin  , 0: dislable 

	
	//Titanium extra paramters 
	parameter RSTA_POLARITY 	= 1'b1;    	// rst A polarity
	parameter RESET_RAM_A 	    = "ASYNC"; 	// reset A mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG_A 	= "ASYNC"; 	// reset A mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDRENA_POLARITY  = 1'b1;    	// addrena polarity
	
	parameter RSTB_POLARITY 	= 1'b1;    	// rst A polarity
	parameter RESET_RAM_B 	    = "ASYNC"; 	// reset A mode on ram,  "NONE": RST signals does not affect the RAM output.
											//					  "ASYNC": RAM output resets asynchronously to RCLK.
											//                     "SYNC": RAM output resets synchronously to RCLK. 
	parameter RESET_OUTREG_B 	= "ASYNC"; 	// reset A mode on output register
											//					   "NONE": RST signals does not affect the RAM output register		
											//					  "ASYNC": RAM output register resets asynchronously to RCLK.
	parameter ADDRENB_POLARITY  = 1'b1;   	// addrenb polarity

	//Port Enable  
	parameter RESET_A_ENABLE 	= 1'b1;		//1: Enable the port for reset_a pin  , 0: disable 
	parameter ADDREN_A_ENABLE 	= 1'b1;		//1: Enable the port for addren_a pin  , 0: disable 
	
	parameter RESET_B_ENABLE 	= 1'b1;		//1: Enable the port for reset_b pin  , 0: disable 
	parameter ADDREN_B_ENABLE 	= 1'b1;	    //1: Enable the port for addren_b pin  , 0: disable   
`endif



`include "bram_decompose.vh"


	input   i_arstn;

	output  o_pll_bram_RSTN;
	input 	i_pll_bram_LOCKED;
	input   i_wclk;
    input   i_rclk;

    
    output	o_led0_r;
    output	o_led0_g;
    output	o_led0_b;
    
    output	o_led1_r;
    output	o_led1_g;
    output	o_led1_b;
    
    input   i_sw0;
    input   i_sw1;
    input   i_sw2;
    
 //   output   [DATA_WIDTH_B-1:0]  rdata;





 
 
assign o_pll_bram_RSTN  = 1'b1;//i_arstn;

//assign w_re = RE_POLARITY;

reg [2:0] r_led0_rgb;
reg [2:0] r_led1_rgb;

wire w_pattern_rst;
wire w_bram_rst;
wire [2:0] w_state;

assign {o_led0_r,o_led0_g,o_led0_b} = r_led0_rgb;
assign {o_led1_r,o_led1_g,o_led1_b} = r_led1_rgb;
 



`ifdef DUAL_TEST  

reset_ctrl
#(
	.NUM_RST		(2),
	.CYCLE			(10),
	.IN_RST_ACTIVE	(2'b00),
	.OUT_RST_ACTIVE	({2{ RSTA_POLARITY }})
)
inst_reset_mcu_ctrl
(
	.i_arst				({2{i_pll_bram_LOCKED}}),
	.i_clk				({2{i_wclk}}),
	.o_srst				({w_pattern_rst,w_bram_rst})
); 

wire w_wclke;
wire [BYTEEN_WIDTH_A-1:0] w_byteen_A;

//Titanium extra ports
wire w_addren_A;
wire [ADDR_WIDTH_A-1:0] w_addr_A;
wire w_we_A;
wire [DATA_WIDTH_A-1:0] w_wdata_A;

wire w_raddren_A;
wire w_re_A;
wire  [DATA_WIDTH_A-1:0] w_rdata_A;

wire [2:0] w_state_A;


wire [BYTEEN_WIDTH_B-1:0] w_byteen_B;
wire w_addren_B;
wire [ADDR_WIDTH_B-1:0] w_addr_B;
wire w_we_B;
wire [DATA_WIDTH_B-1:0] w_wdata_B;

wire w_raddren_B;
wire w_re_B;
wire  [DATA_WIDTH_B-1:0] w_rdata_B;

wire [2:0] w_state_B;


localparam TEST_PORT_WRITE      = 1;        //0: write port A, 1: write port B
localparam TEST_BYTEEN_A         = 0;        //1: Shifting the Byten Enable in test.
localparam TEST_BYTEEN_B         = 0;        //1: Shifting the Byten Enable in test.


localparam TEST_PATTERN_A 	    = (TEST_PORT_WRITE ==0)? "WriteRead": "READ";
localparam TEST_PATTERN_B 	    = (TEST_PORT_WRITE ==0)? "READ": "WriteRead";
   


	wire w_compare_A;
	test_pattern  #(
	//Trion and Titanium parameters 
		.WADDR_WIDTH (ADDR_WIDTH_A),	
		.WDATA_WIDTH (DATA_WIDTH_A),
		.WRITE_COUNT (TOTAL_SIZE_A),
        .BYTEEN_WIDTH(BYTEEN_WIDTH_A),
        
        .TEST_PATTERN(TEST_PATTERN_A),
        .TEST_BYTEEN(TEST_BYTEEN_A),    
             
		.WE_POLARITY (WEA_POLARITY),
	
			
		.RADDR_WIDTH (ADDR_WIDTH_A),	
		.RDATA_WIDTH (DATA_WIDTH_A),
		.READ_COUNT	 (TOTAL_SIZE_A),
		.RE_POLARITY (WEA_POLARITY),
        .OUTPUT_REG  (OUTPUT_REG_A),
        
        .GROUP_DATA (GROUP_DATA_WIDTH)
	)
	inst_test_pattern_A   
	(
	//Trion and Titanium ports
		.clk(i_wclk),		// clock input for one clock mode
	
		.reset(w_pattern_rst), 
		
		.start_in(i_sw0),
        .rd_start_in(i_sw2),
	
		.we(w_we_A),		// write enale   output 
		.waddr(w_addr_A), 	// Write address output
		.wdata(w_wdata_A), 	// Write data 	 output    
        .byteen(w_byteen_A), 
	
	
		.re(w_re_A),		// read enale   output 
		.raddr(), 	// read address output
		.rdata(w_rdata_A), 	// read data 	 output    
			
		.state(w_state),
		.compare(w_compare_A)
	);
 
 
	wire w_compare_B;
	test_pattern  #(
	//Trion and Titanium parameters 
		.WADDR_WIDTH (ADDR_WIDTH_B),	
		.WDATA_WIDTH (DATA_WIDTH_B),
		.WRITE_COUNT (TOTAL_SIZE_B),
        .BYTEEN_WIDTH(BYTEEN_WIDTH_B),

        .TEST_PATTERN(TEST_PATTERN_B),
        .TEST_BYTEEN(TEST_BYTEEN_B),
        
		.WE_POLARITY (WEB_POLARITY),
	
			
		.RADDR_WIDTH (ADDR_WIDTH_B),	
		.RDATA_WIDTH (DATA_WIDTH_B),
		.READ_COUNT	 (TOTAL_SIZE_B),
		.RE_POLARITY (WEB_POLARITY),
        .OUTPUT_REG  (OUTPUT_REG_B),
        
         .GROUP_DATA (GROUP_DATA_WIDTH)
	)
	inst_test_pattern_B   
	(
	//Trion and Titanium ports
		.clk(i_wclk),		// clock input for one clock mode
	
		.reset(w_pattern_rst), 
		
		.start_in(i_sw1),
        .rd_start_in(i_sw2),
	
		.we(w_we_B),			// write enale   output 
		.waddr(w_addr_B), 	// Write address output
		.wdata(w_wdata_B), 	// Write data 	 output    
        .byteen(w_byteen_B), 

	
		.re(w_re_B),		// read enale   output 
		.raddr(), 		// read address output
		.rdata(w_rdata_B), // read data 	 output    
			
		.state(w_state_B),
		.compare(w_compare_B)
	);
 
	always@(*)
	begin
	
		if (w_compare_A)
			r_led1_rgb <= 3'b100;
		else 
			r_led1_rgb <= 3'b001;
		
	//	r_led0_rgb = w_state;
	end  
	
	always@(*)
	begin
	
		if (w_compare_B)
			r_led0_rgb <= 3'b100;
		else 
			r_led0_rgb <= 3'b001;
		
		//r_led0_rgb = w_state;
	end  

`else


reset_ctrl
#(
	.NUM_RST		(2),
	.CYCLE			(10),
	.IN_RST_ACTIVE	(2'b00),
	.OUT_RST_ACTIVE	({2{ RST_POLARITY }})
)
inst_reset_mcu_ctrl
(
	.i_arst				({2{i_pll_bram_LOCKED}}),
	.i_clk				({2{i_wclk}}),
	.o_srst				({w_pattern_rst,w_bram_rst})
); 

wire w_wclke;
wire [BYTEEN_WIDTH-1:0] w_byteen;

//Titanium extra ports
wire w_waddren;
wire [ADDR_WIDTH_A-1:0] w_waddr;
wire w_we;
wire [DATA_WIDTH_A-1:0] w_wdata;

wire w_raddren;
wire [ADDR_WIDTH_B-1:0] w_raddr;
wire  [DATA_WIDTH_B-1:0] w_rdata;
wire w_wr_start;
wire w_wr_end;



wire w_re;

localparam TEST_PATTERN	    = "WriteRead";
 wire w_compare;
test_pattern  #(
    .TEST_PATTERN(TEST_PATTERN),

//Trion and Titanium parameters 
	.WADDR_WIDTH (ADDR_WIDTH_A),	
	.WDATA_WIDTH (DATA_WIDTH_A),
	.WRITE_COUNT (TOTAL_SIZE_A),
    .WE_POLARITY (WE_POLARITY),

		
	.RADDR_WIDTH (ADDR_WIDTH_B),	
	.RDATA_WIDTH (DATA_WIDTH_B),
	.READ_COUNT	 (TOTAL_SIZE_B),
	.RE_POLARITY (RE_POLARITY),
    .OUTPUT_REG  (OUTPUT_REG)
)
inst_test_pattern   
(
   //Trion and Titanium ports
	.clk(i_wclk),		// clock input for one clock mode

	.reset(w_pattern_rst), 
	
	.start_in(i_sw0),

	.we(w_we),			// write enale   output 
    .waddr(w_waddr), 	// Write address output
    .wdata(w_wdata), 	// Write data 	 output    


	.re(w_re),		// read enale   output 
    .raddr(w_raddr), 		// read address output
    .rdata(w_rdata), // read data 	 output    
		
	.state(w_state),
    .compare(w_compare)
 );
 
always@(*)
begin

    if (w_compare)
        r_led1_rgb <= 3'b100;  //FAIL : 6th LED will ON
    else 
        r_led1_rgb <= 3'b001;  //PASS : 4th LED will ON
    
    r_led0_rgb = w_state;
end  
 
 
 `endif
 
 

 
 
`ifdef TEST_SP_RAM

assign w_waddren = ADDREN_POLARITY;

assign w_wclke  = WCLKE_POLARITY;
assign w_byteen  ={BYTEEN_WIDTH {BYTEEN_POLARITY} };


 efx_single_port_ram #(
	.CLK_POLARITY    	(CLK_POLARITY   ),	
	.WCLKE_POLARITY  	(WCLKE_POLARITY ),	
	.WE_POLARITY	 	(WE_POLARITY	),	
	.WRITE_MODE  	 	(WRITE_MODE  	),	
	.RE_POLARITY     	(RE_POLARITY    ),	
	.OUTPUT_REG      	(OUTPUT_REG     ),	
	.BYTEEN_POLARITY 	(BYTEEN_POLARITY),	
	.WCLKE_ENABLE 		(WCLKE_ENABLE 	),	
	.WE_ENABLE 			(WE_ENABLE 		),	
	.RE_ENABLE 			(RE_ENABLE 		),	
	.BYTEEN_ENABLE 		(BYTEEN_ENABLE 	),	

	//Titanium extra paramters 
	.RST_POLARITY 	    (RST_POLARITY	), 	
	.RESET_RAM 	    	(RESET_RAM 	    ),
	.RESET_OUTREG 	    (RESET_OUTREG 	),
	.ADDREN_POLARITY  	(ADDREN_POLARITY),
	.RESET_ENABLE 		(RESET_ENABLE 	),
	.ADDREN_ENABLE 		(ADDREN_ENABLE 	)

)   
inst_memory
(
	.clk	(i_wclk	),
	.wclke	(w_wclke	),
    .byteen	(w_byteen	),
    .we		(w_we   ), 
    .addr	(w_waddr), 
    .wdata	(w_wdata),
    .re		(w_re   ), 
    .rdata	(w_rdata), 
	.reset	(w_bram_rst),
	.addren (w_waddren )
 );
 
 `endif
 
 
 `ifdef TEST_SP_ROM

assign w_waddren = ADDREN_POLARITY;



 efx_single_port_rom #(
	.CLK_POLARITY    	(CLK_POLARITY   ),	
	.RE_POLARITY     	(RE_POLARITY    ),	
	.OUTPUT_REG      	(OUTPUT_REG     ),	
	.RE_ENABLE 			(RE_ENABLE 		),	

	//Titanium extra paramters 
	.RST_POLARITY 	    (RST_POLARITY	), 	
	.RESET_RAM 	    	(RESET_RAM 	    ),
	.RESET_OUTREG 	    (RESET_OUTREG 	),
	.ADDREN_POLARITY  	(ADDREN_POLARITY),
	.RESET_ENABLE 		(RESET_ENABLE 	),
	.ADDREN_ENABLE 		(ADDREN_ENABLE 	)

)   
inst_memory
(
	.clk	(i_wclk	),
    .addr	(w_waddr), 
    .re		(w_re   ), 
    .rdata	(w_rdata), 
	.reset	(w_bram_rst),
	.addren (w_waddren )
 );
 
 `endif
 
`ifdef TEST_SDP_RAM


assign w_waddren = WADDREN_POLARITY;
assign w_raddren = RADDREN_POLARITY;
assign w_wclke  = WCLKE_POLARITY;
assign w_byteen  = {BYTEEN_WIDTH {BYTEEN_POLARITY} };

 efx_simple_dual_port_ram #(
	.CLK_POLARITY    	(CLK_POLARITY   ),

	.WCLK_POLARITY    	(WCLK_POLARITY  ),		
	.WCLKE_POLARITY  	(WCLKE_POLARITY ),	
	.WE_POLARITY	 	(WE_POLARITY	),	
	.WRITE_MODE  	 	(WRITE_MODE  	),	
	
	.RCLK_POLARITY    	(RCLK_POLARITY  ),	
	.RE_POLARITY     	(RE_POLARITY    ),	
	.OUTPUT_REG      	(OUTPUT_REG     ),	
	.BYTEEN_POLARITY 	(BYTEEN_POLARITY),
	.CLK_MODE			(CLK_MODE),
	.WCLKE_ENABLE 		(WCLKE_ENABLE 	),	
	.WE_ENABLE 			(WE_ENABLE 		),	
	.RE_ENABLE 			(RE_ENABLE 		),	
	.BYTEEN_ENABLE 		(BYTEEN_ENABLE 	),	
	
	.DATA_WIDTH_A		(DATA_WIDTH_A	),
	.DATA_WIDTH_B		(DATA_WIDTH_B	),
	.ADDR_WIDTH_A		(ADDR_WIDTH_A	),
	.ADDR_WIDTH_B		(ADDR_WIDTH_B	),
	.BYTEEN_WIDTH		(BYTEEN_WIDTH	),
	.FAMILY		(FAMILY	),

	//Titanium extra paramters 
	.RST_POLARITY 	    (RST_POLARITY	), 	
	.RESET_RAM 	    	(RESET_RAM 	    ),
	.RESET_OUTREG 	    (RESET_OUTREG 	),
	.RADDREN_POLARITY  	(RADDREN_POLARITY),
	.WADDREN_POLARITY  	(WADDREN_POLARITY),
	.RESET_ENABLE 		(RESET_ENABLE 	),
	.RADDREN_ENABLE 	(RADDREN_ENABLE ),
	.WADDREN_ENABLE 	(WADDREN_ENABLE	)

)   
inst_memory
(
	.clk	(i_wclk	),  //for 1 clock mode 
	
	.wclk	(i_wclk	),  //for 2 clock mode 
	.wclke	(w_wclke	),
    .byteen	(w_byteen	),
    .we		(w_we   ), 
    .waddr	(w_waddr), 
    .wdata	({~w_wdata[7:0],w_wdata[7:0]}),
	
	.rclk	(i_wclk	),  //i_rclk for 2 clock mode 
    .re		(w_re   ),
	.raddr	(w_raddr), 	
	.rdata	(w_rdata), 
	
	.reset	(w_bram_rst),
	.waddren (w_waddren ),
	.raddren (w_raddren )
 );
 
 `endif
 
 `ifdef TEST_TDP_RAM
	

assign w_addren_A = ADDRENA_POLARITY;
assign w_clke_A  = CLKEA_POLARITY;
assign w_byteen_A  ={BYTEEN_WIDTH {BYTEENA_POLARITY} };

assign w_addren_B = ADDRENB_POLARITY;
assign w_clke_B  = CLKEB_POLARITY;
assign w_byteen_B  ={BYTEEN_WIDTH {BYTEENB_POLARITY} };


 efx_true_dual_port_ram #(
	
	//Trion and Titanium parameters
	.CLK_POLARITY 	 ( CLK_POLARITY  ),
	.CLKE_POLARITY 	 ( CLKE_POLARITY ),					
	.CLKA_POLARITY   ( CLKA_POLARITY  ),
	.CLKEA_POLARITY  ( CLKEA_POLARITY ),
	.WEA_POLARITY	 ( WEA_POLARITY	  ),
	.WRITE_MODE_A 	 ( WRITE_MODE_A   ),
	.OUTPUT_REG_A    ( OUTPUT_REG_A   ),
	.BYTEENA_POLARITY( BYTEENA_POLARITY),
	.CLKB_POLARITY   ( CLKB_POLARITY  ),
	.CLKEB_POLARITY  ( CLKEB_POLARITY ),
	.WEB_POLARITY	 ( WEB_POLARITY	  ),
	.WRITE_MODE_B 	 ( WRITE_MODE_B   ),
	.OUTPUT_REG_B    ( OUTPUT_REG_B   ),
	.BYTEENB_POLARITY(BYTEENB_POLARITY),
	
	
	//Port Enable  
	.CLK_MODE		(CLK_MODE		),			
	.CLKEA_ENABLE 	(CLKEA_ENABLE 	),
	.WEA_ENABLE 	(WEA_ENABLE 	),	
	.BYTEENA_ENABLE (BYTEENA_ENABLE ),   
	.CLKEB_ENABLE 	(CLKEB_ENABLE 	),
	.WEB_ENABLE 	(WEB_ENABLE 	),	
	.BYTEENB_ENABLE (BYTEENB_ENABLE ),

	
	//Titanium extra paramters 
	.RSTA_POLARITY 	    (RSTA_POLARITY 	   ),
	.RESET_RAM_A 		(RESET_RAM_A 	   ),		  	
	.RESET_OUTREG_A 	(RESET_OUTREG_A    ),
	.ADDRENA_POLARITY   (ADDRENA_POLARITY  ),
	.RSTB_POLARITY 	    (RSTB_POLARITY 	   ),
	.RESET_RAM_B 	    (RESET_RAM_B 	   ),
	.RESET_OUTREG_B 	(RESET_OUTREG_B    ),
	.ADDRENB_POLARITY   (ADDRENB_POLARITY  ),
 
	//Port Enable  
	.RESET_A_ENABLE 	(RESET_A_ENABLE ),
	.ADDREN_A_ENABLE    (ADDREN_A_ENABLE),
	.RESET_B_ENABLE 	(RESET_B_ENABLE ),
	.ADDREN_B_ENABLE    (ADDREN_B_ENABLE)
)   
inst_memory
(
	//Trion and Titanium ports
	.clk(i_wclk),	// for 1 clock mode 
	.clke(w_clke_A),		// for 1 clock mode
    
	.clk_a(i_wclk), //for 2 clock mode	
	.clke_a(w_clke_A),		
    .byteen_a(w_byteen_A),	
    .we_a(w_we_A), 		
	.addr_a(w_addr_A), 	
    .wdata_a(w_wdata_A),	
	.rdata_a(w_rdata_A), 	
  
	.clk_b(i_rclk), 		//for 2 clock mode		
	.clke_b(w_clke_B),		
    .byteen_b(w_byteen_B),	
    .we_b(w_we_B), 		
	.addr_b(w_addr_B), 	
    .wdata_b(w_wdata_B),	
	.rdata_b(w_rdata_B), 	
	     
	//Titanium extra ports
	.reset_a(w_bram_rst),	
	.addren_a(w_addren_A),	
	.reset_b(w_bram_rst),	
	.addren_b(w_addren_B)	
	
 );	
 
 `endif 
 
 
 
`ifdef TEST_TDP_ROM
	

assign w_addren_A = ADDRENA_POLARITY;
assign w_clke_A  = CLKEA_POLARITY;
assign w_byteen_A  ={BYTEEN_WIDTH {BYTEENA_POLARITY} };

assign w_addren_B = ADDRENB_POLARITY;
assign w_clke_B  = CLKEB_POLARITY;
assign w_byteen_B  ={BYTEEN_WIDTH {BYTEENB_POLARITY} };


 efx_true_dual_port_rom #(
	
	//Trion and Titanium parameters
	.CLK_POLARITY 	 ( CLK_POLARITY  ),
	.CLKE_POLARITY 	 ( CLKE_POLARITY ),					
	.CLKA_POLARITY   ( CLKA_POLARITY  ),
	.CLKEA_POLARITY  ( CLKEA_POLARITY ),
	
    .OUTPUT_REG_A    ( OUTPUT_REG_A   ),
	.CLKB_POLARITY   ( CLKB_POLARITY  ),
	.CLKEB_POLARITY  ( CLKEB_POLARITY ),
	.OUTPUT_REG_B    ( OUTPUT_REG_B   ),
	
	
	//Port Enable  
	.CLK_MODE		(CLK_MODE		),			
	.CLKEA_ENABLE 	(CLKEA_ENABLE 	),
	.CLKEB_ENABLE 	(CLKEB_ENABLE 	),
	
	
	//Titanium extra paramters 
	.RSTA_POLARITY 	    (RSTA_POLARITY 	   ),
	.RESET_RAM_A 		(RESET_RAM_A 	   ),		  	
	.RESET_OUTREG_A 	(RESET_OUTREG_A    ),
	.ADDRENA_POLARITY   (ADDRENA_POLARITY  ),
	.RSTB_POLARITY 	    (RSTB_POLARITY 	   ),
	.RESET_RAM_B 	    (RESET_RAM_B 	   ),
	.RESET_OUTREG_B 	(RESET_OUTREG_B    ),
	.ADDRENB_POLARITY   (ADDRENB_POLARITY  ),
 
	//Port Enable  
	.RESET_A_ENABLE 	(RESET_A_ENABLE ),
	.ADDREN_A_ENABLE    (ADDREN_A_ENABLE),
	.RESET_B_ENABLE 	(RESET_B_ENABLE ),
	.ADDREN_B_ENABLE    (ADDREN_B_ENABLE)
)   
inst_memory
(
	//Trion and Titanium ports
	.clk(i_wclk),	// for 1 clock mode 
	.clke(w_clke_A),		// for 1 clock mode
    
	.clk_a(i_wclk), //for 2 clock mode	
	.clke_a(w_clke_A),		
    .addr_a(w_addr_A), 	
    .rdata_a(w_rdata_A), 	
  
	.clk_b(i_rclk), 		//for 2 clock mode		
	.clke_b(w_clke_B),		
    .addr_b(w_addr_B), 	
    .rdata_b(w_rdata_B), 	
	     
	//Titanium extra ports
	.reset_a(w_bram_rst),	
	.addren_a(w_addren_A),	
	.reset_b(w_bram_rst),	
	.addren_b(w_addren_B)	
	
 );	
 
 `endif 
 
endmodule