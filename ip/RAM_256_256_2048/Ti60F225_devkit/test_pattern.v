module test_pattern  #(
	parameter TEST_PATTERN 	    = "READ", // "READ":Read All Location Only, "WriteRead": Write All, then Read All location
    parameter TEST_BYTEEN       = 1,
    
//Trion and Titanium parameters 
	parameter WADDR_WIDTH 	    = 14, 		
	parameter WDATA_WIDTH        = 32,
  	parameter BYTEEN_WIDTH        = 1,
    

    
	parameter WRITE_COUNT		= 100,
    parameter WE_POLARITY       = 1'b1,

		
	parameter RADDR_WIDTH  	    = 14, 		
	parameter RDATA_WIDTH       = 32,
	parameter READ_COUNT		= 100,
	parameter RE_POLARITY       = 1'b1,
    parameter OUTPUT_REG        = 1'b0,
    
    
    parameter GROUP_DATA        = 0
)   
(
   //Trion and Titanium ports
	clk,		// clock input for one clock mode

	reset, 
	
	start_in,
    
    rd_start_in,

	we,			// write enale   output 
    waddr, 		// Write address output
    wdata, 		// Write data 	 output    
    byteen,


	re,			// read enale   output 
    raddr, 		// read address output
    rdata, 		// read data 	 output    
	
	
	state,
	compare
     
 );

function integer log2;
	input	integer	val;
	integer	i;
	begin
		log2 = 0;
		for (i=0; 2**i<val; i=i+1)
			log2 = i+1;
	end
endfunction


localparam TEST_WRITE_COUNT = (WRITE_COUNT != (2**WADDR_WIDTH)) ? WRITE_COUNT: 2**WADDR_WIDTH;
localparam TEST_READ_COUNT  = (READ_COUNT  != (2**RADDR_WIDTH)) ? READ_COUNT : 2**RADDR_WIDTH;

localparam BYTEEN_WIDTH_    = (BYTEEN_WIDTH >1) ? BYTEEN_WIDTH: 2;

localparam TEST_PATTERN_WD_WIDTH = ((WDATA_WIDTH/BYTEEN_WIDTH)<WADDR_WIDTH ) ? (BYTEEN_WIDTH >1) ? (WDATA_WIDTH/BYTEEN_WIDTH): WADDR_WIDTH : WADDR_WIDTH;
localparam TEST_PATTERN_RD_WIDTH = ((RDATA_WIDTH/BYTEEN_WIDTH)<RADDR_WIDTH)  ? (BYTEEN_WIDTH >1) ? (RDATA_WIDTH/BYTEEN_WIDTH): RADDR_WIDTH : RADDR_WIDTH;

input clk;

input reset;
input start_in;
input rd_start_in;
output reg we;
output reg [WADDR_WIDTH-1:0] waddr;
output reg [WDATA_WIDTH-1:0] wdata;
output [BYTEEN_WIDTH_-1:0]byteen;

output reg re;
output reg [RADDR_WIDTH-1:0] raddr;
input wire [RDATA_WIDTH-1:0] rdata;

output [3:0] state;
output reg compare;

reg [WADDR_WIDTH-1:0] r_wcount;
reg [RADDR_WIDTH-1:0] r_rcount;

reg [BYTEEN_WIDTH_-1:0] r_shiftbyte;


reg [RADDR_WIDTH-1:0] r_rcount_1P;
reg [RADDR_WIDTH-1:0] r_rcount_2P;
reg [RADDR_WIDTH-1:0] r_rcount_3P;



reg r_start_in_1P;
reg r_start_in_2P;

reg r_rd_start_in_1P;
reg r_rd_start_in_2P;

reg r_re_1p;
reg r_re_2p;


reg [3:0] test_state;

reg [BYTEEN_WIDTH_-1:0] r_byteen;

reg [RDATA_WIDTH-1:0] r_rdata_1P;

assign state = test_state;

localparam STATE_IDLE  		= 4'd0;
localparam STATE_START 		= 4'd1;
localparam STATE_WE_START	= 4'd2;
localparam STATE_WE     	= 4'd3;
localparam STATE_WE_END	    = 4'd4;
localparam STATE_RE_START	= 4'd5;
localparam STATE_RE     	= 4'd6;
localparam STATE_RE_EXTRA 	= 4'd7;

localparam STATE_RE_END		= 4'd8;



localparam FIRST_ACCESS  	= (TEST_PATTERN=="READ")?STATE_RE_START:(TEST_PATTERN=="WriteRead")?STATE_WE_START:STATE_WE_START;

assign byteen =  (TEST_BYTEEN==0)? {BYTEEN_WIDTH_{1'b1}} : (BYTEEN_WIDTH >1)?r_byteen:2'b11;

localparam COMPARE_WIDTH = (RADDR_WIDTH>=RDATA_WIDTH)?RDATA_WIDTH: RADDR_WIDTH;

localparam DATA_MULTI_W   =  (WDATA_WIDTH<=TEST_PATTERN_WD_WIDTH) ?1: (WDATA_WIDTH/TEST_PATTERN_WD_WIDTH)+1;
localparam DATA_MULTI_R   =  (RDATA_WIDTH<=TEST_PATTERN_RD_WIDTH) ?1: (RDATA_WIDTH/TEST_PATTERN_RD_WIDTH)+1;

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
	
		test_state 	  <= STATE_IDLE;
		
		r_start_in_1P <= 1'b0;
		r_start_in_2P <= 1'b0;
        
        r_rd_start_in_1P <= 1'b0;
        r_rd_start_in_2P <= 1'b0;
        
		
		r_wcount      <= {WADDR_WIDTH{1'b0}};
		r_rcount      <= {RADDR_WIDTH{1'b0}};
		r_shiftbyte	  <= {BYTEEN_WIDTH_{1'b0}};
        
        r_rdata_1P    <= {RDATA_WIDTH{1'b0}};
        
		
	end 
	else 
	begin
	
		r_start_in_1P <= start_in;
		r_start_in_2P <= r_start_in_1P;
	
      	r_rd_start_in_1P <= rd_start_in;
		r_rd_start_in_2P <= r_rd_start_in_1P;
        
        r_rdata_1P       <= rdata;
    
		case (test_state)
			STATE_IDLE    :
			begin 
				if (r_start_in_1P & ~r_start_in_2P)
				begin
					test_state <= STATE_START;
				end
               else if (r_rd_start_in_1P & ~r_rd_start_in_2P)
			   begin
					test_state <= STATE_RE_START;
			   end  
			end 
			STATE_START   :
			begin 
				test_state <= FIRST_ACCESS; //STATE_RE_START;//STATE_WE_START;
			end 
			STATE_WE_START:
			begin 
				r_wcount   <= {WADDR_WIDTH{1'b0}};
				r_shiftbyte <= 1'b1;
				test_state <= STATE_WE;
			end 
			STATE_WE:
			begin 
				if (r_wcount == (TEST_WRITE_COUNT-1))
				begin
					test_state <= STATE_WE_END;
				end 
				else 
				begin
					r_wcount <= r_wcount+1'b1;
					test_state <= STATE_WE;
				end 
				
				r_shiftbyte <= {r_shiftbyte[BYTEEN_WIDTH_-2:0], r_shiftbyte[BYTEEN_WIDTH_-1]}; 
				
			end 
			STATE_WE_END  :
			begin 
				test_state <= STATE_RE_START;
			end 
			STATE_RE_START :
			begin 
				r_rcount   <= {WADDR_WIDTH{1'b0}};
				test_state <= STATE_RE;
			end 
			STATE_RE:
			begin 
				if (r_rcount == (TEST_READ_COUNT-1))
				begin
					if (OUTPUT_REG == 1'b0)
					begin
						test_state <= STATE_RE_END;
					end 
					else 
					begin
						test_state <= STATE_RE_EXTRA;
					end 
				end 
				else 
				begin
					r_rcount <= r_rcount+1'b1;
					test_state <= STATE_RE;
				end 
			end 
			STATE_RE_EXTRA:
			begin
				test_state <= STATE_RE_END;	
			end
			STATE_RE_END :
			begin 
				test_state <= STATE_IDLE;
			end 
		
		endcase 
			
	end 

end    


always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
	
		we <= ~WE_POLARITY;
		waddr <=   {WADDR_WIDTH{1'b0}};
		wdata <=   {WDATA_WIDTH{1'b0}};
		r_byteen<= {BYTEEN_WIDTH_{1'b0}};
		
		re  <= ~RE_POLARITY;
		raddr <= {RADDR_WIDTH{1'b0}};
		compare <= 1'b0;
		
		r_rcount_1P <= {RADDR_WIDTH{1'b0}}; 
		r_rcount_2P <= {RADDR_WIDTH{1'b0}}; 
        r_rcount_3P <= {RADDR_WIDTH{1'b0}}; 
        
		r_re_1p	<= 1'b0;
		r_re_2p	<= 1'b0;
		
	end 
	else 
	begin
	
		r_rcount_1P <= r_rcount;
		r_rcount_2P <= r_rcount_1P;
        r_rcount_3P <= r_rcount_2P;
        
		r_re_1p <= re;
		r_re_2p <= r_re_1p;
		
		if(test_state == STATE_WE)
		begin
			we <= WE_POLARITY;
			waddr <= r_wcount;
		//	wdata <= {DATA_MULTI_W{r_wcount[TEST_PATTERN_WD_WIDTH-1:0]}};
        	wdata <= (GROUP_DATA==0)? r_wcount  : ({(WDATA_WIDTH/WADDR_WIDTH){r_wcount[WADDR_WIDTH-1:0]}});
			r_byteen <= r_shiftbyte;
			re <= ~RE_POLARITY;
			raddr <= r_rcount;
			
			compare <= 1'b0;
			
		
		end 
		else if((test_state == STATE_RE)||(test_state == STATE_RE_EXTRA))
		begin
			we <= ~WE_POLARITY;
			waddr <= r_rcount;
			wdata <= {WDATA_WIDTH{1'b0}};
			r_byteen<= {BYTEEN_WIDTH_{1'b0}};
			
			re <= RE_POLARITY;
			raddr <= r_rcount;
		end 
		else 
		begin
			we <= ~WE_POLARITY;
			waddr <= {WADDR_WIDTH{1'b0}};
			wdata <= {WDATA_WIDTH{1'b0}};
			r_byteen<= {BYTEEN_WIDTH_{1'b0}};
			
			
			re  <= ~RE_POLARITY;
			raddr <= {RADDR_WIDTH{1'b0}};
						
			compare <= 1'b0;
		end 
		
       
      
        if (OUTPUT_REG == 1'b0)
        begin 
            if (r_re_1p== RE_POLARITY)
            begin
            
                //if( rdata == {DATA_MULTI_R{r_rcount_2P[TEST_PATTERN_RD_WIDTH-1:0]}} )
                if(r_rcount_2P[COMPARE_WIDTH-1:0] == rdata[COMPARE_WIDTH-1:0])
                begin
                    compare <= 1'b0;
                end 
                else
                begin
                    compare <= 1'b1;
                
                end 
            end 
		end 
        else 
        begin
            if (r_re_2p== RE_POLARITY)
            begin
            
                //if( rdata == {DATA_MULTI_R{r_rcount_2P[TEST_PATTERN_RD_WIDTH-1:0]}} )
                if(r_rcount_3P[COMPARE_WIDTH-1:0] == rdata[COMPARE_WIDTH-1:0])
                begin
                    compare <= 1'b0;
                end 
                else
                begin
                    compare <= 1'b1;
                
                end 
            end 
        
        end 
	end 

end   


 
endmodule