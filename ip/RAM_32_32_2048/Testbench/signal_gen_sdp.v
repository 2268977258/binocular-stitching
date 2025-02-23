
module signal_gen_sdp (
    wclk,
    rclk,
    rstn,
    rdata_b,
    bram_rst,
    wclke,
    we,
    re,
    byteen,
    waddr,
    raddr,
    wdata_a,
    waddren,
    raddren,
    sim_end
);
//`include "bram_decompose.vh"
parameter       MEMORY_TYPE      = "SP_RAM";
parameter       RESET_RAM        = "ASYNC";
parameter       RESET_OUTREG     = "ASYNC";
parameter [0:0] WCLK_POLARITY    = 1'b1;
parameter [0:0] RCLK_POLARITY    = 1'b1;
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
parameter [0:0] WADDREN_POLARITY = 1'b1;
parameter [0:0] RADDREN_POLARITY = 1'b1;
parameter [0:0] RESET_ENABLE     = 1'b1;
parameter [0:0] WADDREN_ENABLE   = 1'b1;
parameter [0:0] RADDREN_ENABLE   = 1'b1;

parameter FAMILY                 = "TITANIUM";
parameter DATA_WIDTH_A           = 16;
parameter DATA_WIDTH_B           = 16;
parameter ADDR_WIDTH_A           = 4;
parameter ADDR_WIDTH_B           = 4;
parameter BYTEEN_WIDTH           = 2;

input                          wclk;
input                          rclk;
input                          rstn;

input  [DATA_WIDTH_B-1:0]      rdata_b;
output                         bram_rst;
output                         wclke;
output                         we;
output                         re; 
output     [BYTEEN_WIDTH-1:0]  byteen;
output reg [ADDR_WIDTH_A-1:0]  waddr = {ADDR_WIDTH_A{1'b0}};
output reg [ADDR_WIDTH_B-1:0]  raddr = {ADDR_WIDTH_B{1'b0}};
output reg [DATA_WIDTH_A-1:0]  wdata_a = {DATA_WIDTH_A{1'b0}};
//Titanium extra ports
output                         waddren;
output                         raddren;
output reg                     sim_end = 0;

localparam TEST_INIT = 0;
localparam TEST_INIT_VAL = 1;
localparam TEST_NORMAL_SCAN = 2;
localparam TEST_CLKEN_DISABLE = 3;
localparam TEST_CLKEN_DISABLE_RAND = 4;
localparam TEST_WEN_DISABLE = 5;
localparam TEST_WEN_DISABLE_RAND = 6;
localparam TEST_ADDREN_DISABLE = 7;
localparam TEST_ADDREN_DISABLE_RAND = 8;
localparam TEST_BYTEEN_DISABLE = 9;
localparam TEST_BYTEEN_DISABLE_RAND = 10;
localparam TEST_REN_DISABLE = 11;
localparam TEST_REN_DISABLE_RAND = 12;
localparam TEST_WR_SIMULT = 13;
localparam TEST_RST = 14;
localparam TEST_RANDOM1 = 15;
localparam TEST_RANDOM2 = 16;
localparam TEST_RANDOM3 = 17;
localparam TEST_END = 18;
localparam TEST_READOUT = 999;

localparam MAX_ADDR = ADDR_WIDTH_A > ADDR_WIDTH_B ? ADDR_WIDTH_A : ADDR_WIDTH_B;

wire rclk_i;
wire wclk_i;
assign rclk_i = RCLK_POLARITY ^~ rclk;
assign wclk_i = WCLK_POLARITY ^~ wclk;

reg                    r_wclke = ~WCLKE_POLARITY;
reg                    r_we = ~WE_POLARITY;
reg                    r_re = ~RE_POLARITY;
reg [BYTEEN_WIDTH-1:0] r_byteen = {BYTEEN_WIDTH{~BYTEEN_POLARITY}};
reg                    r_waddren = ~WADDREN_POLARITY;
reg                    r_raddren = ~RADDREN_POLARITY;
reg                    r_bram_rst = ~RST_POLARITY;
assign wclke = WCLKE_ENABLE ? r_wclke : WCLKE_POLARITY;
assign we = WE_ENABLE ? r_we : WE_POLARITY;
assign re = RE_ENABLE ? r_re : RE_POLARITY;
assign byteen = BYTEEN_ENABLE ? r_byteen : {BYTEEN_WIDTH{BYTEEN_POLARITY}};
assign waddren = FAMILY == "TRION" ? WADDREN_POLARITY : WADDREN_ENABLE ? r_waddren : WADDREN_POLARITY;
assign raddren = FAMILY == "TRION" ? RADDREN_POLARITY : RADDREN_ENABLE ? r_raddren : RADDREN_POLARITY;
assign bram_rst = RESET_ENABLE ? r_bram_rst : ~RST_POLARITY;

integer state = TEST_INIT;
integer next_state = TEST_INIT;
integer dummy = 0;
integer read_cnt = 0;
integer write_cnt = 0;

function [DATA_WIDTH_A-1:0] get_rand_dataa(input integer dummy);
    reg [DATA_WIDTH_A-1:0] temp;
    integer i;
    begin
        temp = {DATA_WIDTH_A{1'b0}};
        for(i=0 ; i<$rtoi($ceil(DATA_WIDTH_A/32.0)) ; i=i+1) begin
            temp = temp << 32 | $random();
        end
        get_rand_dataa = temp;
    end
endfunction

function [DATA_WIDTH_B-1:0] get_rand_datab(input integer dummy);
    reg [DATA_WIDTH_B-1:0] temp;
    integer i;
    begin
        temp = {DATA_WIDTH_B{1'b0}};
        for(i=0 ; i<$rtoi($ceil(DATA_WIDTH_B/32.0)) ; i=i+1) begin
            temp = temp << 32 | $random();
        end

        get_rand_datab = temp;
    end
endfunction

function [ADDR_WIDTH_A-1:0] get_rand_addra(input integer dummy);
    reg [ADDR_WIDTH_A-1:0] temp;
    integer i;
    begin
        temp = {ADDR_WIDTH_A{1'b0}};
        for(i=0 ; i<$rtoi($ceil(ADDR_WIDTH_A/32.0)) ; i=i+1) begin
            temp = temp << 32 | $random();
        end
        get_rand_addra = temp;
    end
endfunction

function [ADDR_WIDTH_B-1:0] get_rand_addrb(input integer dummy);
    reg [ADDR_WIDTH_B-1:0] temp;
    integer i;
    begin
        temp = {ADDR_WIDTH_B{1'b0}};
        for(i=0 ; i<$rtoi($ceil(ADDR_WIDTH_B/32.0)) ; i=i+1) begin
            temp = temp << 32 | $random();
        end
        get_rand_addrb = temp;
    end
endfunction

function get_rand_en(input integer dummy);
    integer random;
    integer temp;
    integer i;
    begin
        temp = 0;
        random = $random();
        for(i=0 ; i<32 ; i=i+1) begin
            temp = temp + random[0];
            random = random >> 1;
        end
        get_rand_en = temp[0];
    end
endfunction

function [BYTEEN_WIDTH-1:0] get_rand_byteen(input integer dummy);
    reg [BYTEEN_WIDTH-1:0] temp;
    integer i;
    begin
        temp = {BYTEEN_WIDTH{1'b0}};
        for(i=0 ; i<BYTEEN_WIDTH ; i=i+1) begin
            temp = temp << 1;
            temp[0] = get_rand_en(dummy);
        end

        get_rand_byteen = temp;
    end
endfunction

always @(posedge wclk_i) begin
    if (~rstn) begin
        state <= TEST_INIT;
        next_state <= TEST_INIT;
        dummy <= 0;
        write_cnt <= 0;
        r_wclke <= ~WCLKE_POLARITY;
        r_we <= ~WE_POLARITY;
        waddr <= {ADDR_WIDTH_A{1'b0}};
        r_byteen <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
        wdata_a <= {DATA_WIDTH_A{1'b0}};
        r_waddren <= ~WADDREN_POLARITY;
        r_bram_rst <= ~RST_POLARITY;
        sim_end <= 0;
    end else begin
        case (state)
        TEST_INIT: begin
            r_wclke       <= ~WCLKE_POLARITY;
            r_we          <= ~WE_POLARITY;
            r_byteen      <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            r_waddren      <= ~WADDREN_POLARITY;
            r_bram_rst    <= ~RST_POLARITY;
            waddr        <= {ADDR_WIDTH_A{1'b1}};
            wdata_a       <= 0;
            state       <= state + 1;
            write_cnt   <= 0;
        end

        TEST_INIT_VAL: begin
            state      <= TEST_READOUT;
            next_state <= state + 1;
        end

        TEST_NORMAL_SCAN,
        TEST_CLKEN_DISABLE,
        TEST_CLKEN_DISABLE_RAND,
        TEST_WEN_DISABLE,
        TEST_WEN_DISABLE_RAND,
        TEST_ADDREN_DISABLE,
        TEST_ADDREN_DISABLE_RAND,
        TEST_BYTEEN_DISABLE,
        TEST_BYTEEN_DISABLE_RAND: begin
            if (write_cnt == (1<<ADDR_WIDTH_A)) begin
                state       <= TEST_READOUT;
                next_state  <= state + 1;
                write_cnt   <= 0;

                waddr        <= 0;
                wdata_a       <= {DATA_WIDTH_A{1'b0}};
                r_wclke       <= ~WCLKE_POLARITY;
                r_we          <= ~WE_POLARITY;
                r_waddren      <= ~WADDREN_POLARITY;
                r_byteen      <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            end else begin
                write_cnt   <= write_cnt + 1;

                wdata_a       <= get_rand_dataa(dummy);
                waddr        <= write_cnt[0 +: ADDR_WIDTH_A];
                r_wclke       <= state == TEST_CLKEN_DISABLE ? ~WCLKE_POLARITY : 
                            state == TEST_CLKEN_DISABLE_RAND ? get_rand_en(dummy) : 
                            WCLKE_POLARITY;    
                r_we          <= state == TEST_WEN_DISABLE ? ~WE_POLARITY :
                            state == TEST_WEN_DISABLE_RAND ? get_rand_en(dummy) : 
                            WE_POLARITY;
                r_waddren      <= state == TEST_ADDREN_DISABLE ? ~WADDREN_POLARITY : 
                            state == TEST_ADDREN_DISABLE_RAND ? get_rand_en(dummy) : 
                            WADDREN_POLARITY;
                r_byteen      <= state == TEST_BYTEEN_DISABLE ? ~{BYTEEN_WIDTH{BYTEEN_POLARITY}} : 
                            state == TEST_BYTEEN_DISABLE_RAND ? get_rand_byteen(dummy) : 
                            {BYTEEN_WIDTH{BYTEEN_POLARITY}};
                            
                $display("%t ps - write data %h to address: %d ", $time(), wdata_a, waddr);
            end
        end

        TEST_REN_DISABLE, 
        TEST_REN_DISABLE_RAND: begin
            r_wclke   <= ~WCLKE_POLARITY;
            r_we      <= ~WE_POLARITY;
            r_byteen  <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            wdata_a   <= 0;

            if (read_cnt > (1<<ADDR_WIDTH_B)) begin
                state       <= state + 1;
                r_waddren   <= ~WADDREN_POLARITY;
                waddr       <= 0;
            end
        end

        TEST_WR_SIMULT: begin
            if (write_cnt == (1<<ADDR_WIDTH_A)) begin
                state       <= TEST_READOUT;
                next_state  <= state + 1;
                write_cnt   <= 0;

                waddr        <= 0;
                wdata_a       <= {DATA_WIDTH_A{1'b0}};
                r_wclke       <= ~WCLKE_POLARITY;
                r_we          <= ~WE_POLARITY;
                r_waddren      <= ~WADDREN_POLARITY;
                r_byteen      <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            end else begin
                write_cnt   <= write_cnt + 1;

                wdata_a       <= get_rand_dataa(dummy);
                waddr        <= write_cnt[0 +: ADDR_WIDTH_A];
                r_wclke       <= WCLKE_POLARITY; 
                r_we          <= WE_POLARITY;
                r_waddren     <= WADDREN_POLARITY;
                r_byteen      <= {BYTEEN_WIDTH{BYTEEN_POLARITY}};
                $display("%t ps - write data %h to address: %d ", $time(), wdata_a, waddr);
            end
        end

        TEST_RST: begin
            r_bram_rst  <= RST_POLARITY;
           //toggle all signal high to test reset function.
            r_we        <= WE_POLARITY;
            r_waddren   <= WADDREN_POLARITY;
            r_byteen    <= {BYTEEN_WIDTH{BYTEEN_POLARITY}};
            r_wclke     <= WCLKE_POLARITY;
            wdata_a      <= get_rand_dataa(dummy);
            waddr       <= write_cnt[0 +: ADDR_WIDTH_A];

            write_cnt   <= write_cnt + 1;

            if (write_cnt == (1<<ADDR_WIDTH_A)) begin
                r_bram_rst  <= ~RST_POLARITY;
                write_cnt   <= 0;
                state       <= state + 1;
            end 
        end

        TEST_RANDOM1, TEST_RANDOM2, TEST_RANDOM3: begin
            if (write_cnt == (1 << MAX_ADDR)) begin
                state       <= TEST_READOUT;
                next_state  <= state + 1;
                write_cnt   <= 0;

                r_bram_rst   <= 0;
                waddr        <= 0;
                wdata_a       <= {DATA_WIDTH_A{1'b0}};
                r_wclke       <= ~WCLKE_POLARITY;
                r_we          <= ~WE_POLARITY;
                r_waddren      <= ~WADDREN_POLARITY;
                r_byteen      <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            end else begin
                write_cnt   <= write_cnt + 1;

                waddr        <= get_rand_addra(dummy);
                wdata_a       <= get_rand_dataa(dummy);
                r_wclke       <= get_rand_en(dummy);
                r_we          <= get_rand_en(dummy);
                r_waddren      <= 1; //1; //cannot randomize--> latest recheck can
                r_byteen      <= get_rand_byteen(dummy);
                r_bram_rst    <= get_rand_en(dummy);
                $display("%t ps - write data %h to address: %d ", $time(), wdata_a, waddr);
            end
        end

        TEST_END: begin
            r_wclke       <= ~WCLKE_POLARITY;
            r_we          <= ~WE_POLARITY;
            r_byteen      <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            r_waddren      <= ~WADDREN_POLARITY;
            waddr        <= {ADDR_WIDTH_A{1'b1}};
            wdata_a       <= 0;
            state       <= state;

            if (write_cnt > 5) begin
                sim_end <= 1;
            end else begin
                write_cnt    <= write_cnt + 1;
            end
        end

        TEST_READOUT: begin
            r_wclke   <= ~WCLKE_POLARITY;
            r_we      <= ~WE_POLARITY;
            r_byteen  <= ~{BYTEEN_WIDTH{BYTEEN_POLARITY}};
            wdata_a   <= 0;

            if (read_cnt == (1<<ADDR_WIDTH_B)) begin
                state       <= next_state;
                r_waddren   <= ~WADDREN_POLARITY;
                waddr       <= 0;
                read_cnt    <= 0;
            end
        end

        endcase
    end 
end


always @(posedge rclk_i) begin
    case (state)
        TEST_REN_DISABLE,
        TEST_REN_DISABLE_RAND: begin
            r_re        <= state == TEST_REN_DISABLE_RAND ? get_rand_en(dummy) : ~RE_POLARITY;
            r_raddren   <= RADDREN_POLARITY;
            raddr       <= read_cnt[0 +: ADDR_WIDTH_A];
            read_cnt    <= read_cnt + 1;

            if (read_cnt == (1<<ADDR_WIDTH_B)) begin
                state       <= state + 1;
                r_raddren   <= ~RADDREN_POLARITY;
                read_cnt    <= 0;
                r_re        <= ~RE_POLARITY;
            end
        end
        
        TEST_WR_SIMULT: begin
            r_re       <= RE_POLARITY;
            r_raddren  <= RADDREN_POLARITY;
            raddr      <= read_cnt;
            read_cnt   <= read_cnt + 1;
            
            if (read_cnt == (1<<ADDR_WIDTH_B)) begin
            	read_cnt <= 0;
            end
        end
        
        TEST_RST: begin
            r_re      <= RE_POLARITY;
            r_raddren <= RADDREN_POLARITY;
            raddr     <= read_cnt[0 +: ADDR_WIDTH_A];
        end

        TEST_READOUT: begin
            r_re        <= RE_POLARITY;
            r_raddren   <= RADDREN_POLARITY;
            raddr       <= read_cnt; 
            read_cnt    <= read_cnt + 1;
            if (read_cnt == (1<<ADDR_WIDTH_B)) begin
            	state      <= next_state;
            	r_raddren  <= ~RADDREN_POLARITY;
            	raddr      <= 0;
            	read_cnt   <= 0;
            	r_re       <= ~RE_POLARITY;
            end
        end

        TEST_RANDOM1, TEST_RANDOM2, TEST_RANDOM3: begin
            r_re        <= get_rand_en(dummy);
            r_raddren   <= 1; //1; //cannot randomize--> latest recheck can
            raddr       <= get_rand_addrb(dummy);
            read_cnt    <= 0;
        end

        default: begin
            r_re <= ~RE_POLARITY;
            r_raddren <= ~RADDREN_POLARITY;
            read_cnt <= 0;
            raddr <= {ADDR_WIDTH_B{1'b0}};
        end
    endcase
end

initial begin
	$display("================");
    $display("Testbench begin!");
    $display("================");
end

always @(state) begin
	$display("\nSTATE : %d \n", state);
end

endmodule
