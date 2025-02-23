module write_pattern  #(
//Trion and Titanium parameters 
	parameter ADDR_WIDTH  	 = 14, 		
	parameter DATA_WIDTH     = 32,
	parameter PATTERN_COUNT		 = 100,
    parameter WE_POLARITY       = 1'b1
)   
(
   //Trion and Titanium ports
	clk,		// clock input for one clock mode

	reset, 
	
	start_in,

	we,			// write enale   output 
    addr, 		// Write address output
    data, 		// Write data 	 output     
	
	start_out,
	end_out
     
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


localparam OUT_COUNT = (PATTERN_COUNT != (2**ADDR_WIDTH)) ? PATTERN_COUNT: 2**ADDR_WIDTH;
localparam COUNT_WIDTH = ADDR_WIDTH;

//Trion and Titanium ports
input clk;

input reset;
input start_in;
output we;
output [ADDR_WIDTH-1:0] addr;
output [DATA_WIDTH-1:0] data;
output start_out;
output end_out;


reg r_start_in_1P;
reg r_start_in_2P;


reg [ADDR_WIDTH-1:0] r_count;
reg [ADDR_WIDTH-1:0]r_addr_1P;
reg [DATA_WIDTH-1:0]r_data_1P;
reg r_we;

reg r_wr_start;
reg r_wr_end;

assign addr = r_addr_1P; 
assign data = r_data_1P; 
assign we   = r_we; 
assign start_out = r_wr_start;
assign end_out   = r_wr_end;


reg r_start_count;

always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		r_start_in_1P <= 1'b0;
		r_start_in_2P <= 1'b0;
	
	
		r_count<= {ADDR_WIDTH{1'b0}};  
		r_addr_1P <= {ADDR_WIDTH{1'b0}};
		r_data_1P <= {DATA_WIDTH{1'b0}};
		r_we   <= ~WE_POLARITY;
		r_start_count <= 1'b0;
		r_wr_start <= 1'b0;
        r_wr_end <=1'b0;
	
	end 
	else 
	begin
	
		if (start_in==1'b0)
		begin
			r_count <= {ADDR_WIDTH{1'b0}};	
			r_start_count<= 1'b0;
			r_we	<= ~WE_POLARITY;
			
		end
	
		r_start_in_1P <= start_in;
		r_start_in_2P <= r_start_in_1P;
		
		if (r_start_in_1P  &&  ~r_start_in_2P)
		begin
			r_start_count <= 1'b1;
			r_wr_start <= 1'b0;
			r_wr_end <= 1'b0;
		end 
	
		if (r_start_count == 1'b1)
		begin
			r_count   <= r_count+1'b1;
			r_addr_1P <= r_count;
			r_data_1P <= r_count;
			r_we	<= WE_POLARITY;
			r_wr_start	<= 1'b1;
			
			if(r_count ==  (OUT_COUNT-1))
			begin
				r_start_count <= 1'b0;
				r_wr_end 	  <= 1'b1;
				r_we	<= ~WE_POLARITY;
			end 
			
		end 	
		
	end 

end    

 
endmodule