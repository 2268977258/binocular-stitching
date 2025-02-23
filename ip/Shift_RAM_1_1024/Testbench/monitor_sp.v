
module monitor_sp (
    clk,
    bram_rst,
    rdata_a,
    wclke,
    we,
    re,
    addr,
    byteen,
    wdata_a,
    addren
);
//`include "bram_decompose.vh"
parameter       MEMORY_TYPE      = "SP_RAM";	
parameter       RESET_RAM        = "ASYNC";
parameter       RESET_OUTREG     = "ASYNC";
parameter [0:0] CLK_POLARITY     = 1'b1;
parameter [0:0] WCLKE_POLARITY   = 1'b1;
parameter [0:0] WE_POLARITY      = 1'b1;
parameter [0:0] RE_POLARITY      = 1'b1;
parameter [0:0] OUTPUT_REG       = 1'b1;
parameter [0:0] BYTEEN_POLARITY  = 1'b1;
parameter [0:0] WCLKE_ENABLE     = 1'b1;
parameter [0:0] WE_ENABLE        = 1'b1;
parameter [0:0] RE_ENABLE        = 1'b1;
parameter [0:0] BYTEEN_ENABLE    = 1'b1;
parameter [0:0] RST_POLARITY     = 1'b1;
parameter [0:0] ADDREN_POLARITY  = 1'b1;
parameter [0:0] RESET_ENABLE     = 1'b1;
parameter [0:0] ADDREN_ENABLE    = 1'b1;

parameter DATA_WIDTH_A           = 16;
parameter DATA_WIDTH_B           = 16;
parameter ADDR_WIDTH_A           = 4;
parameter BYTEEN_WIDTH           = 2;
parameter GROUP_DATA_WIDTH       = 8;
parameter FAMILY                 = "TITANIUM"; // 0:TRION, 1:TITANIUM
parameter WRITE_MODE             = "READ_FIRST";


input                           clk;
input                           bram_rst;
input  [DATA_WIDTH_A-1:0]       rdata_a;
input                           wclke;
input                           we;
input                           re;
input  [ADDR_WIDTH_A-1:0]       addr;
input  [BYTEEN_WIDTH-1:0]       byteen;
input  [DATA_WIDTH_A-1:0]       wdata_a;
//Titanium extra ports
input                           addren;



wire clk_i;
assign clk_i = CLK_POLARITY ~^ clk;

localparam DEPTH = 2**ADDR_WIDTH_A;
reg [DATA_WIDTH_A-1:0] mem[0:DEPTH-1];
reg [ADDR_WIDTH_A-1:0] raddr_r = 0;
reg [ADDR_WIDTH_A-1:0] waddr_r = 0;
wire                   w_addren;
assign w_addren = FAMILY == "TRION" ? ADDREN_POLARITY : addren;

reg [DATA_WIDTH_A-1:0] mask_wdata;
reg [ADDR_WIDTH_A-1:0] waddr_i;
reg [ADDR_WIDTH_A-1:0] raddr_i;
reg [DATA_WIDTH_A-1:0] exp_rdata_r1 = 0;
reg [DATA_WIDTH_A-1:0] exp_rdata_r2 = 0;
reg                    dont_care_r1 = 0;
reg                    dont_care_r2 = 0;
reg                    re_r1 = ~RE_POLARITY; 
reg                    re_r2 = ~RE_POLARITY; 
reg                    we_r1 = ~WE_POLARITY; 
reg                    we_r2 = ~WE_POLARITY; 
reg                    wclke_r1 = ~WCLKE_POLARITY; 
reg                    wclke_r2 = ~WCLKE_POLARITY; 
reg [DATA_WIDTH_A-1:0] wdata_r1 = 0;
reg [DATA_WIDTH_A-1:0] wdata_r2 = 0;

wire [DATA_WIDTH_A-1:0] final_exp_rdata;
wire                    final_re;
wire                    final_we;
wire                    final_wclke;
wire                    final_dont_care;
integer i = 0;
integer success_cnt = 0;
integer failure_cnt = 0;
reg error_occur = 0;
integer stop_cnt = 0;

initial begin
    $readmemh("init_hex.mem", mem);
end

always @(*) begin
    if (w_addren == ADDREN_POLARITY && wclke == WCLKE_POLARITY)
        waddr_i = addr;
    else
        waddr_i = waddr_r;
        
    if (w_addren == ADDREN_POLARITY && re == RE_POLARITY)
        raddr_i = addr;
    else
        raddr_i = raddr_r;

    mask_wdata = mem[waddr_i];
    
    for(i=0 ; i<BYTEEN_WIDTH-1 ; i=i+1) begin
        if (byteen[i] == BYTEEN_POLARITY) 
            mask_wdata[i*GROUP_DATA_WIDTH +: GROUP_DATA_WIDTH] = wdata_a[i*GROUP_DATA_WIDTH +: GROUP_DATA_WIDTH];
        else
            mask_wdata[i*GROUP_DATA_WIDTH +: GROUP_DATA_WIDTH] = mem[waddr_i][i*GROUP_DATA_WIDTH +: GROUP_DATA_WIDTH];
    end

    if (byteen[BYTEEN_WIDTH-1] == BYTEEN_POLARITY) //last group of data may not be integer multiple
        mask_wdata[DATA_WIDTH_A-1 : (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH] = 
            wdata_a[DATA_WIDTH_A-1 : (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH];
    else
        mask_wdata[DATA_WIDTH_A-1 : (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH] = 
            mem[waddr_i][DATA_WIDTH_A-1 : (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH];
end


always @(posedge clk_i) begin //write to another ram for verification
    if (wclke == WCLKE_POLARITY && we == WE_POLARITY && !(MEMORY_TYPE == "SP_ROM")) begin
        mem[waddr_i] <= mask_wdata;
    end
end

generate
    if (OUTPUT_REG) begin
        assign final_exp_rdata = exp_rdata_r2;
        assign final_re = re_r2;
        assign final_we = we_r2;
        assign final_wclke = wclke_r2;
        assign final_dont_care = dont_care_r2;
    end else begin
        assign final_exp_rdata = exp_rdata_r1;
        assign final_re = re_r1;
        assign final_we = we_r1;
        assign final_wclke = wclke_r1;
        assign final_dont_care = dont_care_r1;
    end
endgenerate

always @(posedge clk_i) begin
    wdata_r1 <= wdata_a;
    wdata_r2 <= wdata_r1;
    re_r1 <= re;
    re_r2 <= re_r1;
    we_r1 <= we;
    we_r2 <= we_r1;
    wclke_r1 <= wclke;
    wclke_r2 <= wclke_r1;
    
    if (w_addren == ADDREN_POLARITY && wclke == WCLKE_POLARITY) begin
        waddr_r <= addr;
    end

    if (re == RE_POLARITY && w_addren == ADDREN_POLARITY) begin
        raddr_r <= addr;
    end

    if (FAMILY == "TITANIUM") begin
        if (re == RE_POLARITY) begin
            dont_care_r2 <= dont_care_r1;
            exp_rdata_r2 <= exp_rdata_r1; 
        end 
    end else begin          //RE doesn't affect output_reg registers in Trion
        dont_care_r2 <= dont_care_r1;
        exp_rdata_r2 <= exp_rdata_r1; 
    end

    //if (FAMILY == 1 && bram_rst == RST_POLARITY) begin
    //	exp_rdata_r1 <= {DATA_WIDTH_A{1'b0}};
    //end
    	
    if (re == RE_POLARITY) begin
        dont_care_r1 <= 0;
        if (FAMILY == "TITANIUM" && bram_rst == RST_POLARITY) begin
        	exp_rdata_r1 <= {DATA_WIDTH_A{1'b0}};
        end else begin
        
            case (WRITE_MODE)
            "WRITE_FIRST": begin
                if (raddr_i == waddr_i && wclke == WCLKE_POLARITY && we == WE_POLARITY && !(MEMORY_TYPE == "SP_ROM")) begin
                    exp_rdata_r1 <= mask_wdata;
                end else begin
                    exp_rdata_r1 <= mem[raddr_i];
                end
            end
            
            "READ_FIRST": begin
                exp_rdata_r1 <= mem[raddr_i];
            end
            
            "READ_UNKNOWN": begin
                if (raddr_i == waddr_i && wclke == WCLKE_POLARITY && we == WE_POLARITY && !(MEMORY_TYPE == "SP_ROM")) begin
                    exp_rdata_r1 <= {DATA_WIDTH_A{1'bx}};
                    dont_care_r1 <= 1;
                end else begin
                    exp_rdata_r1 <= mem[raddr_i];
                end
            end
            endcase
        end
    end
end

always @(*) begin
	if (FAMILY == "TITANIUM" && bram_rst == RST_POLARITY) begin
    	exp_rdata_r1 <= {DATA_WIDTH_A{1'b0}};
    end
end

always @(posedge clk_i) begin //verify WRITE_MODE
    // if (WRITE_MODE == "READ_UNKNOWN" && final_exp_rdata === {DATA_WIDTH_A{1'bx}}) begin
    if (final_dont_care) begin
        //pass
    end else begin
        if (final_exp_rdata === rdata_a) begin
        	$display("%t ps - PASS! BRAM read data %h is match expected data %h ", $time(), rdata_a, final_exp_rdata);
            success_cnt <= success_cnt + 1;
            
        end else if (final_exp_rdata === {DATA_WIDTH_A{1'bx}} && rdata_a === {DATA_WIDTH_A{1'b0}}) //expected condition when initiated memory is less than BRAM depth
        begin
            success_cnt <= success_cnt + 1;
            
        end else begin
            $error("%t ps - FAIL! BRAM read data %h doesn't match expected data %h ", $time(), rdata_a, final_exp_rdata);
            $display("info: FAMILY: %s, MEMORY_TYPE: %s, WRITE_MODE: %s, ADDR_WIDTH_A: %d, DATA_WIDTH_B: %d, DATA_WIDTH_A: %d, GROUP_DATA_WIDTH: %d ", FAMILY, MEMORY_TYPE, WRITE_MODE, ADDR_WIDTH_A, DATA_WIDTH_B, DATA_WIDTH_A, GROUP_DATA_WIDTH);
            error_occur <= 1;
        end
    end
end

always @(posedge clk_i) begin 
    if (error_occur) begin
        stop_cnt <= stop_cnt + 1;
        if (stop_cnt >= 10)
            $stop;
    end
end
endmodule
