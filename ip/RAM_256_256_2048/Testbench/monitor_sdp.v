
module monitor_sdp (
    rclk,
    wclk,
    bram_rst,
    rdata_b,
    wclke,
    we,
    re,
    waddr,
    raddr,
    byteen,
    wdata_a,
    waddren,
    raddren
);
//`include "bram_decompose.vh"
parameter       CLK_MODE = 2;
parameter       MEMORY_TYPE = "SP_RAM";	// 1:SP_RAM, 2:SDP_RAM, 3:TDP_RAM
parameter       RESET_RAM = "ASYNC";
parameter       RESET_OUTREG = "ASYNC";
parameter [0:0] WCLK_POLARITY = 1'b1;
parameter [0:0] RCLK_POLARITY = 1'b1;
parameter [0:0] WCLKE_POLARITY = 1'b1;
parameter [0:0] WE_POLARITY = 1'b1;
parameter [0:0] RE_POLARITY = 1'b1;
parameter [0:0] OUTPUT_REG = 1'b1;
parameter [0:0] BYTEEN_POLARITY = 1'b1;
parameter [0:0] WADDREN_POLARITY = 1'b1;
parameter [0:0] RADDREN_POLARITY = 1'b1;
parameter [0:0] WCLKE_ENABLE = 1'b1;
parameter [0:0] WE_ENABLE = 1'b1;
parameter [0:0] RE_ENABLE = 1'b1;
parameter [0:0] BYTEEN_ENABLE = 1'b1;
parameter [0:0] RST_POLARITY = 1'b1;
parameter [0:0] RESET_ENABLE = 1'b1;
parameter [0:0] WADDREN_ENABLE = 1'b1;
parameter [0:0] RADDREN_ENABLE = 1'b1;

parameter DATA_WIDTH_A          = 16;
parameter DATA_WIDTH_B          = 16;
parameter ADDR_WIDTH_A          = 4;
parameter ADDR_WIDTH_B          = 4;
parameter BYTEEN_WIDTH          = 2;
parameter GROUP_DATA_WIDTH      = 8;
parameter FAMILY                = "TITANIUM";	// 0:TRION, 1:TITANIUM
parameter WRITE_MODE            = "READ_FIRST";

input                           wclk;
input                           rclk;
input                           bram_rst;
input  [DATA_WIDTH_B-1:0]       rdata_b;
input                           wclke;
input                           we;
input                           re;
input  [ADDR_WIDTH_A-1:0]       waddr;
input  [ADDR_WIDTH_B-1:0]       raddr;
input  [BYTEEN_WIDTH-1:0]       byteen;
input  [DATA_WIDTH_A-1:0]       wdata_a;
//Titanium extra ports
input                           waddren;
input                           raddren;



wire rclk_i;
wire wclk_i;
assign rclk_i = RCLK_POLARITY ^~ rclk;
assign wclk_i = WCLK_POLARITY ^~ wclk;

localparam DEPTH = 2**ADDR_WIDTH_A;
reg [DATA_WIDTH_A-1:0] mem[0:DEPTH-1];
reg [ADDR_WIDTH_B-1:0] raddr_r = 0;
reg [ADDR_WIDTH_A-1:0] waddr_r = 0;
wire                   w_waddren;
wire                   w_raddren;
assign w_waddren = FAMILY == "TRION" ? WADDREN_POLARITY : waddren;
assign w_raddren = FAMILY == "TRION" ? RADDREN_POLARITY : raddren;

reg [DATA_WIDTH_A-1:0] mask_wdata;
reg [ADDR_WIDTH_A-1:0] waddr_i;
reg [ADDR_WIDTH_B-1:0] raddr_i;
reg [DATA_WIDTH_B-1:0] exp_rdata_r1 = 0;
reg [DATA_WIDTH_B-1:0] exp_rdata_r2 = 0;
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

wire [DATA_WIDTH_B-1:0] final_exp_rdata;
wire                    final_re;
wire                    final_we;
wire                    final_wclke;
wire                    final_dont_care;
integer i = 0;
integer success_cnt = 0;
integer failure_cnt = 0;
reg error_occur = 0;
integer stop_cnt = 0;

localparam WR_RATIO = (DATA_WIDTH_A / DATA_WIDTH_B);
localparam RW_RATIO = (DATA_WIDTH_B / DATA_WIDTH_A);
localparam WR_RATIO_WID = $clog2(WR_RATIO);
localparam RW_RATIO_WID = $clog2(RW_RATIO);
localparam DATA_WIDTH_MAX = DATA_WIDTH_A > DATA_WIDTH_B ? DATA_WIDTH_A : DATA_WIDTH_B;
localparam RATIO_WID = WR_RATIO_WID > RW_RATIO_WID ? WR_RATIO_WID : RW_RATIO_WID == 0 ? 1 : RW_RATIO_WID;
localparam BYTE_LAST = (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH >= 0 ? (BYTEEN_WIDTH-1)*GROUP_DATA_WIDTH : 0;

wire [RATIO_WID-1:0] data_sel;
generate
    if (WR_RATIO == 1) begin
        assign data_sel = 0;
    end else if (WR_RATIO > 1) begin
        assign data_sel = raddr_i[WR_RATIO_WID-1:0];
    end else begin
        assign data_sel = waddr_i[RW_RATIO_WID-1:0];
    end
endgenerate


function [DATA_WIDTH_B-1:0] get_rdata(input [ADDR_WIDTH_B-1:0] addr);
    integer i;
    integer mem_addr;
    reg [DATA_WIDTH_MAX-1:0] temp;
    begin
        if (WR_RATIO >= 1) begin    //write data width >= read data width
            mem_addr = addr >> WR_RATIO_WID;
            temp = mem[mem_addr];
            get_rdata = temp[data_sel*DATA_WIDTH_B +: DATA_WIDTH_B];
        end else begin
            mem_addr = addr << RW_RATIO_WID;
            for (i=0 ; i<RW_RATIO ; i=i+1) begin
                temp[i*DATA_WIDTH_A +: DATA_WIDTH_A] = mem[mem_addr + i];
                get_rdata = temp;
            end
        end
    end
endfunction

initial begin
    $readmemh("init_hex.mem", mem);
    if ((WR_RATIO_WID > 0 && RW_RATIO_WID != 0) || (RW_RATIO_WID > 0 && WR_RATIO_WID != 0)) begin
        $error("Unexpected Write Read Ratio. WR_RATIO: %d, RW_RATIO: %d, WR_RATIO_WID: %d, RW_RATIO_WID: %d", 
                WR_RATIO, RW_RATIO, WR_RATIO_WID, RW_RATIO_WID);
        #10 $stop;
    end
end

always @(*) begin
    if (w_waddren == WADDREN_POLARITY && wclke == WCLKE_POLARITY)
        waddr_i = waddr;
    else
        waddr_i = waddr_r;

    if (w_raddren == RADDREN_POLARITY && re == RE_POLARITY)
        raddr_i = raddr;
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
        mask_wdata[DATA_WIDTH_A-1 : BYTE_LAST] = 
            wdata_a[DATA_WIDTH_A-1 : BYTE_LAST];
    else
        mask_wdata[DATA_WIDTH_A-1 : BYTE_LAST] = 
            mem[waddr_i][DATA_WIDTH_A-1 : BYTE_LAST];
end


always @(posedge wclk_i) begin //write to another ram for verification
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

always @(posedge wclk_i) begin
    wdata_r1 <= wdata_a;
    wdata_r2 <= wdata_r1;
    we_r1 <= we;
    we_r2 <= we_r1;
    wclke_r1 <= wclke;
    wclke_r2 <= wclke_r1;
    
    if (w_waddren == WADDREN_POLARITY && wclke == WCLKE_POLARITY) begin
        waddr_r <= waddr;
    end
end

always @(posedge rclk_i) begin
    re_r1 <= re;
    re_r2 <= re_r1;

    if (re == RE_POLARITY && w_raddren == RADDREN_POLARITY) begin
        raddr_r <= raddr;
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

    if (re == RE_POLARITY) begin
        dont_care_r1 <= 0;
        if (FAMILY == "TITANIUM" && bram_rst == RST_POLARITY) begin
            exp_rdata_r1 <= {DATA_WIDTH_B{1'b0}};
        end else begin
            case (WRITE_MODE)
            "WRITE_FIRST": begin
                //write width must match read width in WRITE_FIRST mode
                if ((raddr_i >> WR_RATIO_WID) == (waddr_i >> RW_RATIO_WID) && wclke == WCLKE_POLARITY && we == WE_POLARITY && !(MEMORY_TYPE == "SP_ROM")) begin
// verilator lint_off SELRANGE
                    if (WR_RATIO >= 1) begin    //data width of write port >= read port
                        exp_rdata_r1 <= mask_wdata[data_sel*DATA_WIDTH_B +: DATA_WIDTH_B];
                    end else begin
                        exp_rdata_r1 <= get_rdata(raddr_i);
                        exp_rdata_r1[data_sel*DATA_WIDTH_A +: DATA_WIDTH_A] <= mask_wdata;
// verilator lint_on SELRANGE
                    end
                end else begin
                    exp_rdata_r1 <= get_rdata(raddr_i);
                end
            end

            "READ_FIRST": begin
                exp_rdata_r1 <= get_rdata(raddr_i);
            end

            "READ_UNKNOWN": begin
                if ((raddr_i >> WR_RATIO_WID) == (waddr_i >> RW_RATIO_WID) && wclke == WCLKE_POLARITY && we == WE_POLARITY && !(MEMORY_TYPE == "SP_ROM")) begin
                    exp_rdata_r1 <= {DATA_WIDTH_B{1'bx}};
                    dont_care_r1 <= 1;
                end else begin
                    exp_rdata_r1 <= get_rdata(raddr_i);
                end
            end
            endcase
        end
    end
end           

always @(*) begin
	if (FAMILY == "TITANIUM" && bram_rst == RST_POLARITY) begin
    	exp_rdata_r1 <= {DATA_WIDTH_B{1'b0}};
    end
end

always @(posedge rclk_i) begin //verify WRITE_MODE
    if (final_dont_care) begin
        //pass
    end else begin
        if (final_exp_rdata === rdata_b) begin
        	$display("%t ps - PASS! BRAM read data %h is match expected data %h ", $time(), rdata_b, final_exp_rdata);
            success_cnt <= success_cnt + 1;
            
        end else if (final_exp_rdata === {DATA_WIDTH_B{1'bx}} && rdata_b === {DATA_WIDTH_B{1'b0}}) //expected condition when initiated memory is less than BRAM depth
        begin
            $display("Warning check: user .mem file content less than BRAM depth");
            $display("Testbench proceed\n");
            success_cnt <= success_cnt + 1;
            
        end else begin
            $error("%t ps - FAIL! BRAM read data %h doesn't match expected data %h ", $time(), rdata_b, final_exp_rdata);
            $display("INFO: FAMILY: %s, MEMORY_TYPE: %s, WRITE_MODE: %s, ADDR_WIDTH_A: %d, DATA_WIDTH_B: %d, ADDR_WIDTH_B: %d, DATA_WIDTH_A: %d, GROUP_DATA_WIDTH: %d, ", FAMILY, MEMORY_TYPE, WRITE_MODE, ADDR_WIDTH_A, DATA_WIDTH_B, ADDR_WIDTH_B, DATA_WIDTH_A, GROUP_DATA_WIDTH);
            error_occur <= 1;
        end
    end
end

always @(posedge rclk_i) begin 
    if (error_occur) begin
        stop_cnt <= stop_cnt + 1;
        if (stop_cnt >= 10)
            $stop;
    end
end
endmodule
