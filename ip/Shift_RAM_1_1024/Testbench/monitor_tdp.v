
//TODO: separate RAM models and checking logic
module monitor_tdp (
	//Trion and Titanium ports
	clk_a, 		// A-port clk
	rdata_a, 	// A-port read address output
	clke_a,		// A-port clk enable
    byteen_a,	// A-port Byteen input 
    we_a, 		// A-port write enable 
	addr_a, 	// A-port address input
    wdata_a,	// A-port write data input
    state_a,

	clk_b, 		// B-port clk
	rdata_b, 	// B-port read address output
	clke_b,		// B-port clk enable
    byteen_b,	// B-port Byteen input 
    we_b, 		// B-port write enable 
	addr_b, 	// B-port address input
    wdata_b,	// B-port write data input
    state_b,
	     
	//Titanium extra ports
	bram_rst_a,	// A-port reset 
	addren_a,	// A-port address enable
	
	bram_rst_b,	// B-port reset 
	addren_b	// B-port address enable
);
//`include "bram_decompose.vh"
parameter       MEMORY_TYPE = "SP_RAM";	// 1:SP_RAM, 2:SDP_RAM, 3:TDP_RAM
parameter       CLK_MODE = 2;
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

parameter DATA_WIDTH_A          = 16;
parameter DATA_WIDTH_B          = 16;
parameter ADDR_WIDTH_A          = 4;
parameter ADDR_WIDTH_B          = 4;
parameter BYTEEN_WIDTH_A        = 2;
parameter BYTEEN_WIDTH_B        = 2;
parameter GROUP_DATA_WIDTH_A    = 8;
parameter GROUP_DATA_WIDTH_B    = 8;
parameter WRITE_MODE_A          = "READ_FIRST";
parameter WRITE_MODE_B          = "READ_FIRST";
parameter FAMILY                = "TITANIUM";

input                       clk_a; 
input  [DATA_WIDTH_A-1:0 ]  rdata_a;
input                       clke_a;
input                       we_a;
input [BYTEEN_WIDTH_A-1:0]  byteen_a;                                      
input [ADDR_WIDTH_A-1:0 ]   addr_a; 
input [DATA_WIDTH_A-1:0 ]   wdata_a;
input                       bram_rst_a;
input                       addren_a;
input signed [31:0]         state_a;

input                       clk_b; 
input  [DATA_WIDTH_B-1:0 ]  rdata_b;
input                       clke_b;
input                       we_b;
input [BYTEEN_WIDTH_B-1:0]  byteen_b;
input [ADDR_WIDTH_B-1:0 ]   addr_b; 
input [DATA_WIDTH_B-1:0 ]   wdata_b;
input                       bram_rst_b;
input                       addren_b;
input signed [31:0]         state_b;

//localparam WRITE_MODE_B = DECOMPOSE_WRITE_MODE;
//localparam WRITE_MODE_A = DECOMPOSE_WRITE_MODE;

wire clk_a_i;
wire clk_b_i;
wire we_a_i;
wire we_b_i;
wire addren_a_i;
wire addren_b_i;
wire bram_rst_a_i;
wire bram_rst_b_i;
wire clke_a_i;
wire clke_b_i;
wire [BYTEEN_WIDTH_A-1:0] byteen_a_i;
wire [BYTEEN_WIDTH_B-1:0] byteen_b_i;
assign clk_a_i = CLKA_POLARITY ~^ clk_a;
assign clk_b_i = CLKB_POLARITY ~^ clk_b;
assign we_a_i = WEA_POLARITY ~^ we_a;
assign we_b_i = WEB_POLARITY ~^ we_b;
assign addren_a_i = FAMILY == "TRION" ? 1'b1 : ADDRENA_POLARITY ~^ addren_a;
assign addren_b_i = FAMILY == "TRION" ? 1'b1 : ADDRENB_POLARITY ~^ addren_b;
assign bram_rst_a_i = RSTA_POLARITY ~^ bram_rst_a;
assign bram_rst_b_i = RSTB_POLARITY ~^ bram_rst_b;
assign clke_a_i = (MEMORY_TYPE == "TDP_RAM")? CLKEA_POLARITY ~^ clke_a: CLKEA_POLARITY;
assign clke_b_i = (MEMORY_TYPE == "TDP_RAM")? CLKEB_POLARITY ~^ clke_b: CLKEB_POLARITY;
assign byteen_a_i = {BYTEEN_WIDTH_A{BYTEENA_POLARITY}} ~^ byteen_a;
assign byteen_b_i = {BYTEEN_WIDTH_B{BYTEENB_POLARITY}} ~^ byteen_b;

localparam DEPTH_A = 2**ADDR_WIDTH_A;
localparam DEPTH_B = 2**ADDR_WIDTH_B;
localparam DWA = DATA_WIDTH_A;
localparam DWB = DATA_WIDTH_B;
localparam AB_RATIO = (DATA_WIDTH_A / DATA_WIDTH_B);
localparam BA_RATIO = (DATA_WIDTH_B / DATA_WIDTH_A);
localparam AB_RATIO_WID = $clog2(AB_RATIO);
localparam BA_RATIO_WID = $clog2(BA_RATIO);
localparam DATA_WIDTH_MAX = DATA_WIDTH_A > DATA_WIDTH_B ? DATA_WIDTH_A : DATA_WIDTH_B;
localparam RATIO_WID = AB_RATIO_WID > BA_RATIO_WID ? AB_RATIO_WID : BA_RATIO_WID == 0 ? 1 : BA_RATIO_WID;    
reg [DATA_WIDTH_A-1:0] mem_reg[DEPTH_A-1:0];
reg [DATA_WIDTH_A*DEPTH_A-1:0] mem;
reg [ADDR_WIDTH_A-1:0] r_addr_a = 0;
reg [ADDR_WIDTH_B-1:0] r_addr_b = 0;

reg [DATA_WIDTH_A-1:0] mask_wdata_a;
reg [DATA_WIDTH_B-1:0] mask_wdata_b;
reg [DATA_WIDTH_A-1:0] mask_wdata_temp_a;
reg [DATA_WIDTH_B-1:0] mask_wdata_temp_b;
reg [ADDR_WIDTH_A-1:0] addr_a_i;
reg [ADDR_WIDTH_B-1:0] addr_b_i;
reg [ADDR_WIDTH_A-1:0] addr_a_r1 = 0;
reg [ADDR_WIDTH_B-1:0] addr_b_r1 = 0;
reg [ADDR_WIDTH_A-1:0] addr_a_r2 = 0;
reg [ADDR_WIDTH_B-1:0] addr_b_r2 = 0;
reg [DATA_WIDTH_A-1:0] exp_rdata_a_r1 = 0;
reg [DATA_WIDTH_A-1:0] exp_rdata_a_r2 = 0;
reg                    we_a_r1 = 0; 
reg                    we_a_r2 = 0; 
reg                    wclke_a_r1 = 0; 
reg                    wclke_a_r2 = 0; 
reg [DATA_WIDTH_A-1:0] wdata_a_r1 = 0;
reg [DATA_WIDTH_A-1:0] wdata_a_r2 = 0;
reg [DATA_WIDTH_B-1:0] exp_rdata_b_r1 = 0;
reg [DATA_WIDTH_B-1:0] exp_rdata_b_r2 = 0;
reg                    we_b_r1 = 0; 
reg                    we_b_r2 = 0; 
reg                    wclke_b_r1 = 0; 
reg                    wclke_b_r2 = 0; 
reg [DATA_WIDTH_B-1:0] wdata_b_r1 = 0;
reg [DATA_WIDTH_B-1:0] wdata_b_r2 = 0;

wire [DATA_WIDTH_A-1:0] final_exp_rdata_a;
wire [DATA_WIDTH_B-1:0] final_exp_rdata_b;
wire                    final_we_a;
wire                    final_we_b;
wire                    final_clke_a;
wire                    final_clke_b;
wire                    wr_same_addr;
wire [RATIO_WID-1:0]    data_sel;
assign wr_same_addr = addr_a_i >> BA_RATIO_WID == addr_b_i >> AB_RATIO_WID;
integer i = 0;
integer success_cnt = 0;
integer failure_cnt = 0;
integer collision_cnt = 0;
 
generate
    if (AB_RATIO == 1) begin
        assign data_sel = 0;
    end else if (AB_RATIO > 1) begin
        assign data_sel = addr_b_i[AB_RATIO_WID-1:0];
    end else begin
        assign data_sel = addr_a_i[BA_RATIO_WID-1:0];
    end
endgenerate


initial begin
    $readmemh("init_hex.mem", mem_reg);

    for (i=0; i<DEPTH_A ; i=i+1) begin
        mem[i*DWA +: DWA] = mem_reg[i];
    end
end

initial begin
    if ((AB_RATIO_WID > 0 && BA_RATIO_WID != 0) ||
        (BA_RATIO_WID > 0 && AB_RATIO_WID != 0)) begin
        $error("Unexpected Write Read Ratio. AB_RATIO: %0d, BA_RATIO: %0d, AB_RATIO_WID: %0d, BA_RATIO_WID: %0d", 
                AB_RATIO, BA_RATIO, AB_RATIO_WID, BA_RATIO_WID);
        #10 $stop;
    end

    if (DATA_WIDTH_A*DEPTH_A != DATA_WIDTH_B*DEPTH_B) begin
        $error("Size of Port A and Port B mismatch. DATA_WIDTH_A: %0d, DEPTH_A: %0d, DATA_WIDTH_B: %0d, DEPTH_B: %0d", DATA_WIDTH_A, DEPTH_A, DATA_WIDTH_B, DEPTH_B);
        #10 $stop;
    end
    
    if ($rtoi($ceil($itor(DATA_WIDTH_A)/GROUP_DATA_WIDTH_A)) != BYTEEN_WIDTH_A) begin
        $error("byte enable width of Port A mismatch. DATA_WIDTH_A: %0d, GROUP_DATA_WIDTH_A: %0d, BYTEEN_WIDTH_A: %0d", DATA_WIDTH_A, GROUP_DATA_WIDTH_A, BYTEEN_WIDTH_A);
        #10 $stop;
    end
    
    if ($rtoi($ceil($itor(DATA_WIDTH_B)/GROUP_DATA_WIDTH_B)) != BYTEEN_WIDTH_B) begin
        $error("byte enable width of Port B mismatch. DATA_WIDTH_B: %0d, GROUP_DATA_WIDTH_B: %0d, BYTEEN_WIDTH_B: %0d", DATA_WIDTH_B, GROUP_DATA_WIDTH_B, BYTEEN_WIDTH_B);
        #10 $stop;
    end
end

generate
    //port a
    if (OUTPUT_REG_A) begin
        assign final_exp_rdata_a = exp_rdata_a_r2;
        assign final_we_a = we_a_r2;
        assign final_clke_a = wclke_a_r2;
    end else begin
        assign final_exp_rdata_a = exp_rdata_a_r1;
        assign final_we_a = we_a_r1;
        assign final_clke_a = wclke_a_r1;
    end

    //port b
    if (OUTPUT_REG_B) begin
        assign final_exp_rdata_b = exp_rdata_b_r2;
        assign final_we_b = we_b_r2;
        assign final_clke_b = wclke_b_r2;
    end else begin
        assign final_exp_rdata_b = exp_rdata_b_r1;
        assign final_we_b = we_b_r1;
        assign final_clke_b = wclke_b_r1;
    end
endgenerate


always @(*) begin   //port a b
    if (addren_a_i && clke_a_i)
        addr_a_i = addr_a;
    else
        addr_a_i = r_addr_a;

    if (addren_b_i && clke_b_i)
        addr_b_i = addr_b;
    else
        addr_b_i = r_addr_b;

    mask_wdata_temp_a = mem[addr_a_i*DWA +: DWA];
    mask_wdata_temp_b = mem[addr_b_i*DWB +: DWB];
    
    for(i=0 ; i<BYTEEN_WIDTH_A-1 ; i=i+1) begin
        if (byteen_a_i[i]) 
            mask_wdata_temp_a[i*GROUP_DATA_WIDTH_A +: GROUP_DATA_WIDTH_A] = wdata_a[i*GROUP_DATA_WIDTH_A +: GROUP_DATA_WIDTH_A];
        else
            mask_wdata_temp_a[i*GROUP_DATA_WIDTH_A +: GROUP_DATA_WIDTH_A] = mem[addr_a_i*DWA+i*GROUP_DATA_WIDTH_A +: GROUP_DATA_WIDTH_A];
    end
    //last group of data may not be integer multiple
    if (byteen_a_i[BYTEEN_WIDTH_A-1])
        mask_wdata_temp_a[DWA-1 : (BYTEEN_WIDTH_A-1)*GROUP_DATA_WIDTH_A] = 
            wdata_a[DWA-1 : (BYTEEN_WIDTH_A-1)*GROUP_DATA_WIDTH_A];
    else
        mask_wdata_temp_a[DWA-1 : (BYTEEN_WIDTH_A-1)*GROUP_DATA_WIDTH_A] = 
            mem[addr_a_i*DWA+(BYTEEN_WIDTH_A-1)*GROUP_DATA_WIDTH_A +: DWA-(BYTEEN_WIDTH_A-1)*GROUP_DATA_WIDTH_A];

    for(i=0 ; i<BYTEEN_WIDTH_B-1 ; i=i+1) begin
        if (byteen_b_i[i]) 
            mask_wdata_temp_b[i*GROUP_DATA_WIDTH_B +: GROUP_DATA_WIDTH_B] = wdata_b[i*GROUP_DATA_WIDTH_B +: GROUP_DATA_WIDTH_B];
        else
            mask_wdata_temp_b[i*GROUP_DATA_WIDTH_B +: GROUP_DATA_WIDTH_B] = mem[addr_b_i*DWB+i*GROUP_DATA_WIDTH_B +: GROUP_DATA_WIDTH_B];
    end 
    //last group of data may not be integer multiple
    if (byteen_b_i[BYTEEN_WIDTH_B-1])
        mask_wdata_temp_b[DWB-1 : (BYTEEN_WIDTH_B-1)*GROUP_DATA_WIDTH_B] = 
            wdata_b[DWB-1 : (BYTEEN_WIDTH_B-1)*GROUP_DATA_WIDTH_B];
    else
        mask_wdata_temp_b[DWB-1 : (BYTEEN_WIDTH_B-1)*GROUP_DATA_WIDTH_B] = 
            mem[addr_b_i*DWB+(BYTEEN_WIDTH_B-1)*GROUP_DATA_WIDTH_B +: DWB-(BYTEEN_WIDTH_B-1)*GROUP_DATA_WIDTH_B];

    mask_wdata_a = mask_wdata_temp_a;
    mask_wdata_b = mask_wdata_temp_b;
    if (wr_same_addr && clke_a_i && we_a_i && clke_b_i && we_b_i) begin   //addra & b may have different width
        if (AB_RATIO >= 1) begin    //data width of port a >= port b
            if (mask_wdata_temp_a[data_sel*DWB +: DWB] == mask_wdata_temp_b) 
                mask_wdata_b = mask_wdata_temp_b;
            else
                mask_wdata_b = {DWB{1'bx}};
        end else begin
            if (mask_wdata_b[data_sel*DWA +: DWA] == mask_wdata_temp_a) 
                mask_wdata_b[data_sel*DWA +: DWA] = mask_wdata_temp_b[data_sel*DWA +: DWA];
            else
                mask_wdata_b[data_sel*DWA +: DWA] = {DWA{1'bx}};
        end
    end
    
    if (wr_same_addr && clke_a_i && we_a_i && clke_b_i && we_b_i) begin   //addra & b may have different width
        if (AB_RATIO >= 1) begin    //data width of port a >= port b
            if (mask_wdata_a[data_sel*DWB +: DWB] == mask_wdata_temp_b) 
                mask_wdata_a[data_sel*DWB +: DWB] = mask_wdata_temp_a[data_sel*DWB +: DWB];
            else
                mask_wdata_a[data_sel*DWB +: DWB] = {DWB{1'bx}};
        end else begin
            if (mask_wdata_b[data_sel*DWA +: DWA] == mask_wdata_temp_a) 
                mask_wdata_a = mask_wdata_temp_a;
            else
                mask_wdata_a = {DWA{1'bx}};
        end
    end
end

always @(posedge clk_a_i) begin
    if (clke_a_i && we_a_i && !(MEMORY_TYPE == "DP_ROM")) begin
        mem[addr_a_i*DWA +: DWA] <= mask_wdata_a;

        if (wr_same_addr)
            collision_cnt <= collision_cnt + 1;
    end
end

always @(posedge clk_b_i) begin
    if (clke_b_i && we_b_i && !(MEMORY_TYPE == "DP_ROM")) begin
        mem[addr_b_i*DWB +: DWB] <= mask_wdata_b;
    end
end

always @(posedge clk_a_i) begin
    addr_a_r1   <= addr_a_i;
    wdata_a_r1  <= wdata_a;
    we_a_r1     <= we_a_i;
    wclke_a_r1  <= clke_a_i;
    addr_a_r2   <= addr_a_r1;
    wdata_a_r2  <= wdata_a_r1;
    we_a_r2     <= we_a_r1;
    wclke_a_r2  <= wclke_a_r1;
    
    if (addren_a_i && clke_a_i) begin
        r_addr_a <= addr_a;
    end

    if (FAMILY == "TITANIUM") begin
        if (clke_a_i) begin
            exp_rdata_a_r2 <= exp_rdata_a_r1; 
        end 
    end else begin          //clock enable doesn't affect output registers in Trion
        exp_rdata_a_r2 <= exp_rdata_a_r1; 
    end

    if (clke_a_i) begin
        if (FAMILY == "TITANIUM" && bram_rst_a_i) begin
            exp_rdata_a_r1 <= {DWA{1'b0}};
        end else begin
            case (WRITE_MODE_A)
            "WRITE_FIRST": begin
                if (!we_a_i) begin
                    if (clke_b_i && we_b_i && wr_same_addr) begin
                        if (AB_RATIO >= 1) begin
                            exp_rdata_a_r1 <= mem[addr_a_i*DWA +: DWA];
                            exp_rdata_a_r1[data_sel*DWB +: DWB] <= mask_wdata_b;
                        end else begin
                            exp_rdata_a_r1 <= mask_wdata_b[data_sel*DWA +: DWA];
                        end
                    end else begin
                        exp_rdata_a_r1 <= mem[addr_a_i*DWA +: DWA];
                    end
                end else if (we_a_i && !(MEMORY_TYPE == "DP_ROM")) begin
                    exp_rdata_a_r1 <= mask_wdata_a;
                end
            end

            "READ_FIRST": begin
                exp_rdata_a_r1 <= mem[addr_a_i*DWA +: DWA];
            end

            "NO_CHANGE": begin
                if (!we_a_i) begin
                    exp_rdata_a_r1 <= mem[addr_a_i*DWA +: DWA];
                end else if (!(MEMORY_TYPE == "DP_ROM")) begin
                    exp_rdata_a_r1 <= exp_rdata_a_r1;
                end
            end
            endcase
        end
    end
end

always @(posedge clk_b_i) begin
    addr_b_r1   <= addr_b_i;
    wdata_b_r1  <= wdata_b;
    we_b_r1     <= we_b_i;
    wclke_b_r1  <= clke_b_i;
    addr_b_r2   <= addr_b_r1;
    wdata_b_r2  <= wdata_b_r1;
    we_b_r2     <= we_b_r1;
    wclke_b_r2  <= wclke_b_r1;
    
    if (addren_b_i && clke_b_i) begin
        r_addr_b <= addr_b;
    end

    if (FAMILY == "TITANIUM") begin
        if (clke_b_i) begin
            exp_rdata_b_r2 <= exp_rdata_b_r1; 
        end 
    end else begin          //clock enable doesn't affect output registers in Trion
        exp_rdata_b_r2 <= exp_rdata_b_r1; 
    end

    if (clke_b_i) begin
        if (FAMILY == "TITANIUM" && bram_rst_b_i) begin
            exp_rdata_b_r1 <= {DWB{1'b0}};
        end else begin
            case (WRITE_MODE_B)
            "WRITE_FIRST": begin
                if (!we_b_i) begin
                    if (clke_a_i && we_a_i && wr_same_addr) begin
                        if (AB_RATIO >= 1) begin
                            exp_rdata_b_r1 <= mask_wdata_a[data_sel*DWB +: DWB];
                        end else begin
                            exp_rdata_b_r1 <= mem[addr_b_i*DWB +: DWB];
                            exp_rdata_b_r1[data_sel*DWA +: DWA] <= mask_wdata_a;
                        end
                    end else begin
                        exp_rdata_b_r1 <= mem[addr_b_i*DWB +: DWB];
                    end
                end else if (we_b_i && !(MEMORY_TYPE == "DP_ROM")) begin
                    exp_rdata_b_r1 <= mask_wdata_b;
                end
            end

            "READ_FIRST": begin
                exp_rdata_b_r1 <= mem[addr_b_i*DWB +: DWB];
            end

            "NO_CHANGE": begin
                if (!we_b_i) begin
                    exp_rdata_b_r1 <= mem[addr_b_i*DWB +: DWB];
                end else if (!(MEMORY_TYPE == "DP_ROM")) begin
                    exp_rdata_b_r1 <= exp_rdata_b_r1;
                end
            end
            endcase
        end
    end
end

always @(*) begin
	if (FAMILY == "TITANIUM" && bram_rst_a_i) begin
		exp_rdata_a_r1 <= {DWA{1'b0}};
	end
	
	if (FAMILY == "TITANIUM" && bram_rst_b_i) begin
		exp_rdata_b_r1 <= {DWB{1'b0}};
	end
end


integer acnt = 0;
always @(posedge clk_a_i) begin //verify WRITE_MODE
    if (state_a != 0) begin
        for(acnt=0 ; acnt<DWB ; acnt=acnt+1) begin
            if (final_exp_rdata_a[acnt] === 1'bx) begin
                //pass
            end else begin
                if (final_exp_rdata_a[acnt] === rdata_a[acnt]) begin
                	$display("%t ps - PASS! BRAM_A read data %h is match expected data %h ", $time(), rdata_a[acnt], final_exp_rdata_a[acnt]);
                    success_cnt <= success_cnt + 1;
                end else begin
                    $error("%t ps - FAIL! BRAM_A read data %h doesn't match expected data %h ", $time(), rdata_a[acnt], final_exp_rdata_a[acnt]);
                    $display("info: FAMILY: %s, MEMORY_TYPE: %s, WRITE_MODE_A: %s, ADDR_WIDTH_A: %d, DWB: %d, ADDR_WIDTH_B: %d, DWA: %d, GROUP_DATA_WIDTH_A: %d, GROUP_DATA_WIDTH_A: %d, GROUP_DATA_WIDTH_B: %d, ", FAMILY, MEMORY_TYPE, WRITE_MODE_A, ADDR_WIDTH_A, DWB, ADDR_WIDTH_B, DWA, GROUP_DATA_WIDTH_A, GROUP_DATA_WIDTH_A, GROUP_DATA_WIDTH_B);
                    #10 $stop;
                end
            end
        end
    end
end

integer bcnt = 0;
always @(posedge clk_b_i) begin //verify WRITE_MODE
    if (state_b != 0) begin
        for(bcnt=0 ; bcnt<DWB ; bcnt=bcnt+1) begin
            if (final_exp_rdata_b[bcnt] === 1'bx) begin //TODO: add collision check
                //pass
            end else begin
                if (final_exp_rdata_b[bcnt] === rdata_b[bcnt]) begin
                	$display("%t ps - PASS! BRAM_B read data %h is match expected data %h ", $time(), rdata_b[bcnt], final_exp_rdata_b[bcnt]);
                    success_cnt <= success_cnt + 1;
                end else begin
                    $error("%t ps - FAIL! BRAM_B read data %h doesn't match expected data %h ", $time(), rdata_b[bcnt], final_exp_rdata_b[bcnt]);
                    $display("info: FAMILY: %s, MEMORY_TYPE: %s, WRITE_MODE_B: %s, ADDR_WIDTH_A: %d, DWB: %d, ADDR_WIDTH_B: %d, DWA: %d, GROUP_DATA_WIDTH_A: %d, GROUP_DATA_WIDTH_A: %d, GROUP_DATA_WIDTH_B: %d, ", FAMILY, MEMORY_TYPE, WRITE_MODE_B, ADDR_WIDTH_A, DWB, ADDR_WIDTH_B, DWA, GROUP_DATA_WIDTH_A, GROUP_DATA_WIDTH_A, GROUP_DATA_WIDTH_B);
                    #10 $stop;
                end
            end
        end
    end
end
endmodule
