
// `timescale 1ns/1ps
`include "Shift_RAM_1_1024_define.vh"

module tb;
	
wire sim_end;
reg                      rstn = 0;

reg                      clk; //= ~CLK_POLARITY;
wire                     wclke;
wire                     we;
wire                     re; 
wire [ADDR_WIDTH_A-1:0]  addr;
wire [ADDR_WIDTH_A-1:0]  waddr;
wire [ADDR_WIDTH_B-1:0]  raddr;
wire [BYTEEN_WIDTH-1:0]  byteen;
//////// data input/output /////////////
wire [DATA_WIDTH_A-1:0]  wdata_a;
wire [DATA_WIDTH_B-1:0]  wdata_b;
wire [DATA_WIDTH_A-1:0]  rdata_a;
wire [DATA_WIDTH_B-1:0]  rdata_b;
//Titanium extra ports
wire                     bram_rst;
wire                     addren;

wire                     waddren;
wire                     raddren;
reg                      wclk;
reg                      rclk;
//assign wclk = clk;
//assign rclk = clk;

reg                        clk_a; 
reg                        clk_b; 
//assign clk_a = clk;
//assign clk_b = clk;
wire                        clke_a;
wire                        clke;
wire                        we_a;
wire [BYTEEN_WIDTH_A-1:0]   byteen_a;
wire [ADDR_WIDTH_A-1:0 ]    addr_a; 
wire                        clke_b;
wire                        we_b;
wire [BYTEEN_WIDTH_B-1:0]   byteen_b;
wire [ADDR_WIDTH_B-1:0 ]    addr_b; 
wire                        reset_a;
wire                        addren_a;
wire                        reset_b;
wire                        addren_b;
wire                        bram_rst_a;
wire                        bram_rst_b;
wire integer                state_a;
wire integer                state_b;

//////////////////// TRION and TITANIUM extra ports dependency /////////////////////////
wire w_bram_rst;
wire w_bram_rst_a;
wire w_bram_rst_b;
wire w_addren;
wire w_waddren;
wire w_raddren;
wire w_addren_a;
wire w_addren_b;

assign w_bram_rst   = (FAMILY=="TITANIUM")? bram_rst: {RST_POLARITY{1'b0}};
assign w_bram_rst_a = (FAMILY=="TITANIUM")? bram_rst_a: {RSTA_POLARITY{1'b0}};
assign w_bram_rst_b = (FAMILY=="TITANIUM")? bram_rst_b: {RSTB_POLARITY{1'b0}};
assign w_addren     = (FAMILY=="TITANIUM")? addren: {ADDREN_POLARITY{1'b1}};
assign w_waddren    = (FAMILY=="TITANIUM")? waddren: {WADDREN_POLARITY{1'b1}};
assign w_raddren    = (FAMILY=="TITANIUM")? raddren: {RADDREN_POLARITY{1'b1}};
assign w_addren_a   = (FAMILY=="TITANIUM")? addren_a: {ADDRENA_POLARITY{1'b1}};
assign w_addren_b   = (FAMILY=="TITANIUM")? addren_b: {ADDRENB_POLARITY{1'b1}};

////////////////////////// Byte Enable dependency ///////////////////////////////
wire w_byteen;
wire w_byteen_a;
wire w_byteen_b;

assign w_byteen     = (BYTEEN_ENABLE==1)? byteen: {BYTEEN_WIDTH{BYTEEN_POLARITY}};
assign w_byteen_a   = (BYTEENA_ENABLE==1)? byteen_a: {BYTEEN_WIDTH_A{BYTEENA_POLARITY}};
assign w_byteen_b   = (BYTEENB_ENABLE==1)? byteen_b: {BYTEEN_WIDTH_A{BYTEENA_POLARITY}};
////////////////////////////////////////////////////////////////////////////////////

initial begin
	//clk    <= 0;
	wclk   <= 0;
	rclk   <= 0;
	//clk_a  <= 0;
	//clk_b  <= 0;
end

//initial begin
//    #100
//    forever #1 clk = ~clk;
//end

initial begin
	#100
	forever #1 wclk =~ wclk;
end

initial begin
	#100
	forever #1 rclk =~ rclk;
end

assign clk    = wclk;
assign clk_a  = wclk;
assign clk_b  = rclk;

//initial begin
//	#100
//	forever #1500 clk_a =~ clk_a;
//end
//
//initial begin
//	#100
//	forever #3000 clk_b =~ clk_b;
//end

initial begin
    forever @(posedge sim_end) begin
    	$display("\n");
    	$display("=============================");
        $display("Simulation end. Pass the test");
        $display("=============================");
        $display("\n");
        $finish;
    end
end

generate
    
	if (FAMILY == "TITANIUM") begin
        if (MEMORY_TYPE == "SP_RAM") begin //single_port_ram
        	
        	localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        		    $stop;
        	    end
        	end
        	else if ((DATA_WIDTH_A != DATA_WIDTH_B) && WRITE_MODE == "WRITE_FIRST") begin
        		initial begin
        			$display("Warning: Mixed Width Mode is not supported in Titanium family when using WRITE_FIRST mode. Configuration disabled. Simulation end normally.");
        			#5
        			$stop;
        		end
        	end
        	else if (BYTEEN_ENABLE == 1) begin
        	
                Shift_RAM_1_1024 
                
                dut_spram (
                    .clk(clk),
                    .wclke(wclke),
                    .we(we),
                    .re(re),
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .rdata_a(rdata_a),
                    .reset(bram_rst), 
                    .addren(addren)
                );
                
                signal_gen_sp #(
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(addren)
                );
            end
            else if (BYTEEN_ENABLE == 0) begin
            	Shift_RAM_1_1024 
                
                dut_spram (
                    .clk(clk),
                    .wclke(wclke),
                    .we(we),
                    .re(re),
                    .addr(addr),
                    //.byteen(byteen),
                    .wdata_a(wdata_a),
                    .rdata_a(rdata_a),
                    .reset(bram_rst), 
                    .addren(addren)
                );
                
                signal_gen_sp #(
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(w_byteen),
                    .wdata_a(wdata_a),
                    .addren(addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(w_byteen),
                    .wdata_a(wdata_a),
                    .addren(addren)
                );
            end
        end else if (MEMORY_TYPE == "SP_ROM") begin //single_port_rom
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if ((DATA_WIDTH_A != DATA_WIDTH_B) && WRITE_MODE == "WRITE_FIRST") begin
        		initial begin
        			$display("Warning: Mixed Width Mode is not supported in Titanium family when using WRITE_FIRST mode. Configuration disabled. Simulation end normally.");
        			#5
        			$stop;
        		end
        	end
        	else begin   
        		
                Shift_RAM_1_1024 
                dut_sprom (
                    .clk(clk),
                    .addr(addr),
                    .re(re),
                    .rdata_a(rdata_a),
                    .reset(bram_rst),
                    .addren(addren)
                );
                
                
                signal_gen_sprom #(
                                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(addren)
                );
            end
        end else if (MEMORY_TYPE == "SDP_RAM") begin //simple dual port ram
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if ((DATA_WIDTH_A != DATA_WIDTH_B) && WRITE_MODE == "WRITE_FIRST") begin
        		initial begin
        			$display("Warning: Mixed Width Mode is not supported in Titanium family when using WRITE_FIRST mode. Configuration disabled. Simulation end normally.");
        			#5
        			$stop;
        		end
        	end
        	else if (BYTEEN_ENABLE == 1) begin
        	    if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        	    	
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        .clk(clk),
                        //.wclk(wclk),
                        //.rclk(wclk),
                        .reset(bram_rst),
                    
                        .wclke(wclke),
                        .byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(clk),
                        .rclk(clk),
                        .rstn(rstn),
                        
                        .bram_rst(bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(clk),
                        .rclk(clk),
                        .bram_rst(bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        //.clk(clk),
                        .wclk(wclk),
                        .rclk(rclk),
                        .reset(bram_rst),
                    
                        .wclke(wclke),
                        .byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(wclk),
                        .rclk(rclk),
                        .rstn(rstn),
                        
                        .bram_rst(bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(wclk),
                        .rclk(rclk),
                        .bram_rst(bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                end
            end
            else if (BYTEEN_ENABLE == 0) begin
            	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        	    	
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        .clk(clk),
                        //.wclk(wclk),
                        //.rclk(wclk),
                        .reset(bram_rst),
                    
                        .wclke(wclke),
                        //.byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(clk),
                        .rclk(clk),
                        .rstn(rstn),
                        
                        .bram_rst(bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(clk),
                        .rclk(clk),
                        .bram_rst(bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        //.clk(clk),
                        .wclk(wclk),
                        .rclk(rclk),
                        .reset(bram_rst),
                    
                        .wclke(wclke),
                        //.byteen(w_byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(wclk),
                        .rclk(rclk),
                        .rstn(rstn),
                        
                        .bram_rst(bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(wclk),
                        .rclk(rclk),
                        .bram_rst(bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(waddren),
                        .raddren(raddren)
                    );
                end
            end
        end else if (MEMORY_TYPE == "TDP_RAM") begin  //true_dual_port_ram
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if ((DATA_WIDTH_A != DATA_WIDTH_B) && WRITE_MODE == "WRITE_FIRST") begin
        		initial begin
        			$display("Warning: Mixed Width Mode is not supported in Titanium family when using WRITE_FIRST mode. Configuration disabled. Simulation end normally.");
        			#5
        			$stop;
        		end
        	end
        	else if (BYTEENA_ENABLE ==1) begin
        	    if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        .clk(clk),
                        .clke(clke),
                        //.clk_a(clk),
                        //.clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        //.clk_b(clk),
                        //.clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b),
                        .reset_a(bram_rst_a),
                        .addren_a(addren_a),
                        .reset_b(bram_rst_b),
                        .addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        //.clk(clk),
                        //.clke(clke),
                        .clk_a(clk_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        .clk_b(clk_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b),
                        .reset_a(bram_rst_a),
                        .addren_a(addren_a),
                        .reset_b(bram_rst_b),
                        .addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
            end
            else if (BYTEENA_ENABLE == 0) begin
            	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        .clk(clk),
                        .clke(clke),
                        //.clk_a(clk),
                        //.clke_a(clke_a),
                        //.byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        //.clk_b(clk),
                        //.clke_b(clke_b),
                        //.byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b),
                        .reset_a(bram_rst_a),
                        .addren_a(addren_a),
                        .reset_b(bram_rst_b),
                        .addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        //.clk(clk),
                        //.clke(clke),
                        .clk_a(clk_a),
                        .clke_a(clke_a),
                        //.byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        .clk_b(clk_b),
                        .clke_b(clke_b),
                        //.byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b),
                        .reset_a(bram_rst_a),
                        .addren_a(addren_a),
                        .reset_b(bram_rst_b),
                        .addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(bram_rst_a),
                        .addren_a(addren_a),
                        .bram_rst_b(bram_rst_b),
                        .addren_b(addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
            end
        end else if (MEMORY_TYPE == "DP_ROM") begin  //true_dual_port_rom
            
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if ((DATA_WIDTH_A != DATA_WIDTH_B) && WRITE_MODE == "WRITE_FIRST") begin
        		initial begin
        			$display("Warning: Mixed Width Mode is not supported in Titanium family when using WRITE_FIRST mode. Configuration disabled. Simulation end normally.");
        			#5
        			$stop;
        		end
        	end
        	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        
                Shift_RAM_1_1024             
                dut_dprom (
                    .clk(clk),
                    .clke(clke),
                    //.clk_a(clk),
                    //.clke_a(clke_a),
                    .addr_a(addr_a),
                    .rdata_a(rdata_a),
                    //.clk_b(clk),
                    //.clke_b(clke_b),
                    .addr_b(addr_b),
                    .rdata_b(rdata_b),
                    .reset_a(bram_rst_a),
                    .addren_a(addren_a),
                    .reset_b(bram_rst_b),
                    .addren_b(addren_b)
                );
                
                signal_gen_tdp #(
                
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLK_MODE(CLK_MODE),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .MEMORY_TYPE(MEMORY_TYPE),
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .rstn(rstn),
                    .clk_a(clk),
                    .rdata_a(rdata_a),
                    .clke_a(clke),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk),
                    .rdata_b(rdata_b),
                    .clke_b(clke),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(bram_rst_a),
                    .addren_a(addren_a),
                    .bram_rst_b(bram_rst_b),
                    .addren_b(addren_b),
                    .state_a(state_a),
                    .state_b(state_b),
                    .sim_end(sim_end)
                );
                
                monitor_tdp #(
                
                    
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_MODE(CLK_MODE),
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                    .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                    .WRITE_MODE_A(WRITE_MODE_A),
                    .WRITE_MODE_B(WRITE_MODE_B),
                    .FAMILY(FAMILY)
                    
                ) u_monitor (
                    .clk_a(clk),
                    .rdata_a(rdata_a),
                    .clke_a(clke),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk),
                    .rdata_b(rdata_b),
                    .clke_b(clke),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(bram_rst_a),
                    .addren_a(addren_a),
                    .bram_rst_b(bram_rst_b),
                    .addren_b(addren_b),
                    .state_a(state_a),
                    .state_b(state_b)
                );
         
            end
            else if (CLK_MODE == 2) begin //write clk independent to read clk.
        
                Shift_RAM_1_1024             
                dut_dprom (
                    //.clk(clk),
                    //.clke(clke),
                    .clk_a(clk_a),
                    .clke_a(clke_a),
                    .addr_a(addr_a),
                    .rdata_a(rdata_a),
                    .clk_b(clk_b),
                    .clke_b(clke_b),
                    .addr_b(addr_b),
                    .rdata_b(rdata_b),
                    .reset_a(bram_rst_a),
                    .addren_a(addren_a),
                    .reset_b(bram_rst_b),
                    .addren_b(addren_b)
                );
                
                signal_gen_tdp #(
                
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLK_MODE(CLK_MODE),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .MEMORY_TYPE(MEMORY_TYPE),
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .rstn(rstn),
                    .clk_a(clk_a),
                    .rdata_a(rdata_a),
                    .clke_a(clke_a),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk_b),
                    .rdata_b(rdata_b),
                    .clke_b(clke_b),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(bram_rst_a),
                    .addren_a(addren_a),
                    .bram_rst_b(bram_rst_b),
                    .addren_b(addren_b),
                    .state_a(state_a),
                    .state_b(state_b),
                    .sim_end(sim_end)
                );
                
                monitor_tdp #(
                
                    
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_MODE(CLK_MODE),
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                    .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                    .WRITE_MODE_A(WRITE_MODE_A),
                    .WRITE_MODE_B(WRITE_MODE_B),
                    .FAMILY(FAMILY)
                    
                ) u_monitor (
                    .clk_a(clk_a),
                    .rdata_a(rdata_a),
                    .clke_a(clke_a),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk_b),
                    .rdata_b(rdata_b),
                    .clke_b(clke_b),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(bram_rst_a),
                    .addren_a(addren_a),
                    .bram_rst_b(bram_rst_b),
                    .addren_b(addren_b),
                    .state_a(state_a),
                    .state_b(state_b)
                );
         
            end
        end else begin
            initial begin
                $error("Unexpected RAM/ROM type");
            end
        end
    end
    else if (FAMILY == "TRION") begin
    	if (MEMORY_TYPE == "SP_RAM") begin //single_port_ram
        	
        	localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        		    $stop;
        	    end
        	end
        	else if (BYTEEN_ENABLE == 1) begin
        	
                Shift_RAM_1_1024 
                
                dut_spram (
                    .clk(clk),
                    .wclke(wclke),
                    .we(we),
                    .re(re),
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .rdata_a(rdata_a)
                    //.reset({RST_POLARITY{1'b0}}), 
                    //.addren({ADDREN_POLARITY{1'b0}})
                );
                
                signal_gen_sp #(
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren)
                );
            end
            else if (BYTEEN_ENABLE == 0) begin
            	
            	Shift_RAM_1_1024 
                
                dut_spram (
                    .clk(clk),
                    .wclke(wclke),
                    .we(we),
                    .re(re),
                    .addr(addr),
                    //.byteen(byteen),
                    .wdata_a(wdata_a),
                    .rdata_a(rdata_a)
                    //.reset({RST_POLARITY{1'b0}}), 
                    //.addren({ADDREN_POLARITY{1'b0}})
                );
                
                signal_gen_sp #(
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(w_byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(w_byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren)
                );
            end
        end else if (MEMORY_TYPE == "SP_ROM") begin //single_port_rom
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else begin   
        		
                Shift_RAM_1_1024 
                dut_sprom (
                    .clk(clk),
                    .addr(addr),
                    .re(re),
                    .rdata_a(rdata_a)
                    //.reset(bram_rst),
                    //.addren(addren)
                );
                
                
                signal_gen_sprom #(
                                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    
                    .FAMILY(FAMILY)
                ) u_signal_gen (
                    .clk(clk),
                    .rstn(rstn),
                    
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren),
                    .sim_end(sim_end)
                );
                
                monitor_sp #(
                    .WRITE_MODE(WRITE_MODE),
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_POLARITY(CLK_POLARITY),
                    .WCLKE_POLARITY(WCLKE_POLARITY),
                    .WE_POLARITY(WE_POLARITY),
                    .RE_POLARITY(RE_POLARITY),
                    .OUTPUT_REG(OUTPUT_REG),
                    .BYTEEN_POLARITY(BYTEEN_POLARITY),
                    .WCLKE_ENABLE(WCLKE_ENABLE),
                    .WE_ENABLE(WE_ENABLE),
                    .RE_ENABLE(RE_ENABLE),
                    .BYTEEN_ENABLE(BYTEEN_ENABLE),
                    .RESET_RAM(RESET_RAM),
                    .RESET_OUTREG(RESET_OUTREG),
                    .RST_POLARITY(RST_POLARITY),
                    .ADDREN_POLARITY(ADDREN_POLARITY),
                    .RESET_ENABLE(RESET_ENABLE),
                    .ADDREN_ENABLE(ADDREN_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_A),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .BYTEEN_WIDTH(BYTEEN_WIDTH),
                    .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                    
                    .FAMILY(FAMILY)
                ) u_monitor (
                    .clk(clk),
                
                    .bram_rst(w_bram_rst),
                    .rdata_a(rdata_a),
                    .wclke(wclke),
                    .we(we),
                    .re(re), 
                    .addr(addr),
                    .byteen(byteen),
                    .wdata_a(wdata_a),
                    .addren(w_addren)
                );
            end
        end else if (MEMORY_TYPE == "SDP_RAM") begin //simple dual port ram
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if (BYTEEN_ENABLE == 1) begin
        	    if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        	    	
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        .clk(clk),
                        //.wclk(wclk),
                        //.rclk(wclk),
                        //.reset(bram_rst),
                    
                        .wclke(wclke),
                        .byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b)
                        //.waddren(waddren),
                        //.raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(clk),
                        .rclk(clk),
                        .rstn(rstn),
                        
                        .bram_rst(w_bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(clk),
                        .rclk(clk),
                        .bram_rst(w_bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        //.clk(clk),
                        .wclk(wclk),
                        .rclk(rclk),
                        //.reset(bram_rst),
                    
                        .wclke(wclke),
                        .byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b)
                        //.waddren(w_waddren),
                        //.raddren(w_raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(wclk),
                        .rclk(rclk),
                        .rstn(rstn),
                        
                        .bram_rst(w_bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(wclk),
                        .rclk(rclk),
                        .bram_rst(w_bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren)
                    );
                end
            end
            else if (BYTEEN_ENABLE == 0) begin
            	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        	    	
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        .clk(clk),
                        //.wclk(wclk),
                        //.rclk(wclk),
                        //.reset(bram_rst),
                    
                        .wclke(wclke),
                        //.byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b)
                        //.waddren(waddren),
                        //.raddren(raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(clk),
                        .rclk(clk),
                        .rstn(rstn),
                        
                        .bram_rst(w_bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(clk),
                        .rclk(clk),
                        .bram_rst(w_bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren)
                    );
                end
                else if (CLK_MODE == 2) begin 
                
                    Shift_RAM_1_1024 
                    dut_sdpram (
                        //.clk(clk),
                        .wclk(wclk),
                        .rclk(rclk),
                        //.reset(bram_rst),
                    
                        .wclke(wclke),
                        //.byteen(byteen),
                        .we(we),
                        .waddr(waddr),
                        .wdata_a(wdata_a),
                        .re(re),
                        .raddr(raddr),
                        .rdata_b(rdata_b)
                        //.waddren(w_waddren),
                        //.raddren(w_raddren)
                    );
                    
                    signal_gen_sdp #(
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .wclk(wclk),
                        .rclk(rclk),
                        .rstn(rstn),
                        
                        .bram_rst(w_bram_rst),
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren),
                        .sim_end(sim_end)
                    );
                    
                    monitor_sdp #(
                    
                        .WRITE_MODE(WRITE_MODE),
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .RESET_RAM(RESET_RAM),
                        .RESET_OUTREG(RESET_OUTREG),
                    
                        .WCLK_POLARITY(WCLK_POLARITY),
                        .RCLK_POLARITY(RCLK_POLARITY),
                        .WCLKE_POLARITY(WCLKE_POLARITY),
                        .WE_POLARITY(WE_POLARITY),
                        .RE_POLARITY(RE_POLARITY),
                        .OUTPUT_REG(OUTPUT_REG),
                        .BYTEEN_POLARITY(BYTEEN_POLARITY),
                        .WADDREN_POLARITY(WADDREN_POLARITY),
                        .RADDREN_POLARITY(RADDREN_POLARITY),
                        .WCLKE_ENABLE(WCLKE_ENABLE),
                        .WE_ENABLE(WE_ENABLE),
                        .RE_ENABLE(RE_ENABLE),
                        .BYTEEN_ENABLE(BYTEEN_ENABLE),
                        .RST_POLARITY(RST_POLARITY),
                        .RESET_ENABLE(RESET_ENABLE),
                        .WADDREN_ENABLE(WADDREN_ENABLE),
                        .RADDREN_ENABLE(RADDREN_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH(BYTEEN_WIDTH),
                        .GROUP_DATA_WIDTH(GROUP_DATA_WIDTH),
                        
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .wclk(wclk),
                        .rclk(rclk),
                        .bram_rst(w_bram_rst),
                    
                        .rdata_b(rdata_b),
                        .wclke(wclke),
                        .we(we),
                        .re(re), 
                        .waddr(waddr),
                        .raddr(raddr),
                        .byteen(w_byteen),
                        .wdata_a(wdata_a),
                        .waddren(w_waddren),
                        .raddren(w_raddren)
                    );
                end
            end
        end else if (MEMORY_TYPE == "TDP_RAM") begin  //true_dual_port_ram
        
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	else if (BYTEENA_ENABLE == 1) begin
        	    if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        .clk(clk),
                        .clke(clke),
                        //.clk_a(clk),
                        //.clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        //.clk_b(clk),
                        //.clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b)
                        //.reset_a(bram_rst_a),
                        //.addren_a(addren_a),
                        //.reset_b(bram_rst_b),
                        //.addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        //.clk(clk),
                        //.clke(clke),
                        .clk_a(clk_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        .clk_b(clk_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b)
                        //.reset_a(bram_rst_a),
                        //.addren_a(addren_a),
                        //.reset_b(bram_rst_b),
                        //.addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
            end
            else if (BYTEENA_ENABLE == 0) begin
            	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        .clk(clk),
                        .clke(clke),
                        //.clk_a(clk),
                        //.clke_a(clke_a),
                        //.byteen_a(byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        //.clk_b(clk),
                        //.clke_b(clke_b),
                        //.byteen_b(byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b)
                        //.reset_a(bram_rst_a),
                        //.addren_a(addren_a),
                        //.reset_b(bram_rst_b),
                        //.addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk),
                        .rdata_a(rdata_a),
                        .clke_a(clke),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk),
                        .rdata_b(rdata_b),
                        .clke_b(clke),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
                else if (CLK_MODE == 2) begin //write clk independent to read clk.
                
                    Shift_RAM_1_1024             
                    dut_tdpram (
                        //.clk(clk),
                        //.clke(clke),
                        .clk_a(clk_a),
                        .clke_a(clke_a),
                        //.byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .rdata_a(rdata_a),
                        .clk_b(clk_b),
                        .clke_b(clke_b),
                        //.byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .rdata_b(rdata_b)
                        //.reset_a(bram_rst_a),
                        //.addren_a(addren_a),
                        //.reset_b(bram_rst_b),
                        //.addren_b(addren_b)
                    );
                    
                    signal_gen_tdp #(
                    
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLK_MODE(CLK_MODE),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .MEMORY_TYPE(MEMORY_TYPE),
                        .FAMILY(FAMILY)
                        
                    ) u_signal_gen (
                        .rstn(rstn),
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b),
                        .sim_end(sim_end)
                    );
                    
                    monitor_tdp #(
                    
                        
                        .MEMORY_TYPE(MEMORY_TYPE),
                    
                        .CLK_MODE(CLK_MODE),
                        .CLKA_POLARITY(CLKA_POLARITY),
                        .CLKEA_POLARITY(CLKEA_POLARITY),
                        .WEA_POLARITY(WEA_POLARITY),
                        .OUTPUT_REG_A(OUTPUT_REG_A),
                        .BYTEENA_POLARITY(BYTEENA_POLARITY),
                        .CLKB_POLARITY(CLKB_POLARITY),
                        .CLKEB_POLARITY(CLKEB_POLARITY),
                        .WEB_POLARITY(WEB_POLARITY),
                        .OUTPUT_REG_B(OUTPUT_REG_B),
                        .BYTEENB_POLARITY(BYTEENB_POLARITY),
                        .CLKEA_ENABLE(CLKEA_ENABLE),
                        .WEA_ENABLE(WEA_ENABLE),
                        .BYTEENA_ENABLE(BYTEENA_ENABLE),
                        .CLKEB_ENABLE(CLKEB_ENABLE),
                        .WEB_ENABLE(WEB_ENABLE),
                        .BYTEENB_ENABLE(BYTEENB_ENABLE),
                        .RSTA_POLARITY(RSTA_POLARITY),
                        .RESET_RAM_A(RESET_RAM_A),
                        .RESET_OUTREG_A(RESET_OUTREG_A),
                        .ADDRENA_POLARITY(ADDRENA_POLARITY),
                        .RSTB_POLARITY(RSTB_POLARITY),
                        .RESET_RAM_B(RESET_RAM_B),
                        .RESET_OUTREG_B(RESET_OUTREG_B),
                        .ADDRENB_POLARITY(ADDRENB_POLARITY),
                        .RESET_A_ENABLE(RESET_A_ENABLE),
                        .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                        .RESET_B_ENABLE(RESET_B_ENABLE),
                        .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                        .DATA_WIDTH_A(DATA_WIDTH_A),
                        .DATA_WIDTH_B(DATA_WIDTH_B),
                        .ADDR_WIDTH_A(ADDR_WIDTH_A),
                        .ADDR_WIDTH_B(ADDR_WIDTH_B),
                        .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                        .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                        .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                        .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                        .WRITE_MODE_A(WRITE_MODE_A),
                        .WRITE_MODE_B(WRITE_MODE_B),
                        .FAMILY(FAMILY)
                        
                    ) u_monitor (
                        .clk_a(clk_a),
                        .rdata_a(rdata_a),
                        .clke_a(clke_a),
                        .byteen_a(w_byteen_a),
                        .we_a(we_a),
                        .addr_a(addr_a),
                        .wdata_a(wdata_a),
                        .clk_b(clk_b),
                        .rdata_b(rdata_b),
                        .clke_b(clke_b),
                        .byteen_b(w_byteen_b),
                        .we_b(we_b),
                        .addr_b(addr_b),
                        .wdata_b(wdata_b),
                        .bram_rst_a(w_bram_rst_a),
                        .addren_a(w_addren_a),
                        .bram_rst_b(w_bram_rst_b),
                        .addren_b(w_addren_b),
                        .state_a(state_a),
                        .state_b(state_b)
                    );
                end
            end
        end else if (MEMORY_TYPE == "DP_ROM") begin  //true_dual_port_rom
            
            localparam BYTEEN_ENABLE_LIMIT = (BYTEEN_ENABLE && BYTEENA_ENABLE && BYTEENB_ENABLE);
        	
        	if (WRITE_MODE == "NO_CHANGE" && BYTEEN_ENABLE_LIMIT) begin //"NO_CHANGE" mode cant support BYTE_ENABLE
        	    initial begin
        		    $display("Warning: BYTE ENABLE is not supported in NO_CHANGE mode. Configuration disabled");
        		    #5
        			$stop;
        	    end
        	end
        	if (CLK_MODE == 1) begin //clk becomes the master clk for write and read
        
                Shift_RAM_1_1024             
                dut_dprom (
                    .clk(clk),
                    .clke(clke),
                    //.clk_a(clk),
                    //.clke_a(clke_a),
                    .addr_a(addr_a),
                    .rdata_a(rdata_a),
                    //.clk_b(clk),
                    //.clke_b(clke_b),
                    .addr_b(addr_b),
                    .rdata_b(rdata_b)
                    //.reset_a(bram_rst_a),
                    //.addren_a(addren_a),
                    //.reset_b(bram_rst_b),
                    //.addren_b(addren_b)
                );
                
                signal_gen_tdp #(
                
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLK_MODE(CLK_MODE),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .MEMORY_TYPE(MEMORY_TYPE),
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .rstn(rstn),
                    .clk_a(clk),
                    .rdata_a(rdata_a),
                    .clke_a(clke),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk),
                    .rdata_b(rdata_b),
                    .clke_b(clke),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(w_bram_rst_a),
                    .addren_a(w_addren_a),
                    .bram_rst_b(w_bram_rst_b),
                    .addren_b(w_addren_b),
                    .state_a(state_a),
                    .state_b(state_b),
                    .sim_end(sim_end)
                );
                
                monitor_tdp #(
                
                    
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_MODE(CLK_MODE),
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                    .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                    .WRITE_MODE_A(WRITE_MODE_A),
                    .WRITE_MODE_B(WRITE_MODE_B),
                    .FAMILY(FAMILY)
                    
                ) u_monitor (
                    .clk_a(clk),
                    .rdata_a(rdata_a),
                    .clke_a(clke),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk),
                    .rdata_b(rdata_b),
                    .clke_b(clke),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(w_bram_rst_a),
                    .addren_a(w_addren_a),
                    .bram_rst_b(w_bram_rst_b),
                    .addren_b(w_addren_b),
                    .state_a(state_a),
                    .state_b(state_b)
                );
         
            end
            else if (CLK_MODE == 2) begin //write clk independent to read clk.
        
                Shift_RAM_1_1024             
                dut_dprom (
                    //.clk(clk),
                    //.clke(clke),
                    .clk_a(clk_a),
                    .clke_a(clke_a),
                    .addr_a(addr_a),
                    .rdata_a(rdata_a),
                    .clk_b(clk_b),
                    .clke_b(clke_b),
                    .addr_b(addr_b),
                    .rdata_b(rdata_b)
                    //.reset_a(bram_rst_a),
                    //.addren_a(addren_a),
                    //.reset_b(bram_rst_b),
                    //.addren_b(addren_b)
                );
                
                signal_gen_tdp #(
                
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLK_MODE(CLK_MODE),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .MEMORY_TYPE(MEMORY_TYPE),
                    .FAMILY(FAMILY)
                    
                ) u_signal_gen (
                    .rstn(rstn),
                    .clk_a(clk_a),
                    .rdata_a(rdata_a),
                    .clke_a(clke_a),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk_b),
                    .rdata_b(rdata_b),
                    .clke_b(clke_b),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(w_bram_rst_a),
                    .addren_a(w_addren_a),
                    .bram_rst_b(w_bram_rst_b),
                    .addren_b(w_addren_b),
                    .state_a(state_a),
                    .state_b(state_b),
                    .sim_end(sim_end)
                );
                
                monitor_tdp #(
                
                    
                    .MEMORY_TYPE(MEMORY_TYPE),
                
                    .CLK_MODE(CLK_MODE),
                    .CLKA_POLARITY(CLKA_POLARITY),
                    .CLKEA_POLARITY(CLKEA_POLARITY),
                    .WEA_POLARITY(WEA_POLARITY),
                    .OUTPUT_REG_A(OUTPUT_REG_A),
                    .BYTEENA_POLARITY(BYTEENA_POLARITY),
                    .CLKB_POLARITY(CLKB_POLARITY),
                    .CLKEB_POLARITY(CLKEB_POLARITY),
                    .WEB_POLARITY(WEB_POLARITY),
                    .OUTPUT_REG_B(OUTPUT_REG_B),
                    .BYTEENB_POLARITY(BYTEENB_POLARITY),
                    .CLKEA_ENABLE(CLKEA_ENABLE),
                    .WEA_ENABLE(WEA_ENABLE),
                    .BYTEENA_ENABLE(BYTEENA_ENABLE),
                    .CLKEB_ENABLE(CLKEB_ENABLE),
                    .WEB_ENABLE(WEB_ENABLE),
                    .BYTEENB_ENABLE(BYTEENB_ENABLE),
                    .RSTA_POLARITY(RSTA_POLARITY),
                    .RESET_RAM_A(RESET_RAM_A),
                    .RESET_OUTREG_A(RESET_OUTREG_A),
                    .ADDRENA_POLARITY(ADDRENA_POLARITY),
                    .RSTB_POLARITY(RSTB_POLARITY),
                    .RESET_RAM_B(RESET_RAM_B),
                    .RESET_OUTREG_B(RESET_OUTREG_B),
                    .ADDRENB_POLARITY(ADDRENB_POLARITY),
                    .RESET_A_ENABLE(RESET_A_ENABLE),
                    .ADDREN_A_ENABLE(ADDREN_A_ENABLE),
                    .RESET_B_ENABLE(RESET_B_ENABLE),
                    .ADDREN_B_ENABLE(ADDREN_B_ENABLE),
                    .DATA_WIDTH_A(DATA_WIDTH_A),
                    .DATA_WIDTH_B(DATA_WIDTH_B),
                    .ADDR_WIDTH_A(ADDR_WIDTH_A),
                    .ADDR_WIDTH_B(ADDR_WIDTH_B),
                    .BYTEEN_WIDTH_A(BYTEEN_WIDTH_A),
                    .BYTEEN_WIDTH_B(BYTEEN_WIDTH_B),
                    .GROUP_DATA_WIDTH_A(GROUP_DATA_WIDTH_A),
                    .GROUP_DATA_WIDTH_B(GROUP_DATA_WIDTH_B),
                    .WRITE_MODE_A(WRITE_MODE_A),
                    .WRITE_MODE_B(WRITE_MODE_B),
                    .FAMILY(FAMILY)
                    
                ) u_monitor (
                    .clk_a(clk_a),
                    .rdata_a(rdata_a),
                    .clke_a(clke_a),
                    .byteen_a(byteen_a),
                    .we_a(we_a),
                    .addr_a(addr_a),
                    .wdata_a(wdata_a),
                    .clk_b(clk_b),
                    .rdata_b(rdata_b),
                    .clke_b(clke_b),
                    .byteen_b(byteen_b),
                    .we_b(we_b),
                    .addr_b(addr_b),
                    .wdata_b(wdata_b),
                    .bram_rst_a(w_bram_rst_a),
                    .addren_a(w_addren_a),
                    .bram_rst_b(w_bram_rst_b),
                    .addren_b(addren_b),
                    .state_a(state_a),
                    .state_b(state_b)
                );
         
            end
        end else begin
            initial begin
                $error("Unexpected RAM/ROM type");
            end
        end
    end
endgenerate

localparam DEPTH = 2**DATA_WIDTH_A;
integer i;

integer rst_cnt = 0;
always @(posedge wclk) begin
    if (rst_cnt < 1000) begin
        rstn <= 0;
        rst_cnt <= rst_cnt + 1;
    end else begin
        rstn <= 1;
    end 
end




endmodule

