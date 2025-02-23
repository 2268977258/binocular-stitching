module pattern_gen
#(
	parameter PIXEL_BIT		= 8,
	parameter FIFO_WIDTH	= 11,
	parameter H_ActivePix	= 1920,
	parameter V_ActivePix	= 1080
)
(
	input	in_pclk,
	input	in_rstn,
	
	input 	[FIFO_WIDTH-1:0]	in_x,
	input 	[FIFO_WIDTH-1:0]	in_y,
	input 						in_valid,
	input 						in_de,
	input 						in_hs,
	input 						in_vs,
	input	[2:0]				in_pattern,
	
	output 	[FIFO_WIDTH-1:0]	out_x,
	output 	[FIFO_WIDTH-1:0]	out_y,
	output 						out_valid,
	output 						out_de,
	output 						out_hs,
	output 						out_vs,
	output	[PIXEL_BIT-1:0]		out_data
);

/* VGA counter for the output display sync signals generator */
reg [FIFO_WIDTH-1:0]	r_out_x_1P;
reg [FIFO_WIDTH-1:0]	r_out_y_1P;
reg [PIXEL_BIT-1:0]		r_out_data_1P;
reg						r_out_vs_1P;
reg						r_out_hs_1P;
reg						r_out_de_1P;
reg						r_out_valid_1P;
reg [6:0]				r_frame_cnt;

/* VGA counter for the output display sync signals generator */
/* r_x_cnt for HSYNC and DEN */  
always @ (posedge in_pclk)
begin
	if(~in_rstn)
	begin
		r_out_x_1P		<= {FIFO_WIDTH{1'b0}};
		r_out_y_1P		<= {FIFO_WIDTH{1'b0}};
		r_out_data_1P	<= {PIXEL_BIT{1'b0}};
		r_frame_cnt		<= 7'b0;
		r_out_vs_1P		<= 1'b0;
		r_out_hs_1P		<= 1'b0;
		r_out_de_1P		<= 1'b0;
		r_out_valid_1P	<= 1'b0;
	end	
	else
	begin		
		r_out_vs_1P		<= in_vs;
	    r_out_hs_1P		<= in_hs;
	    r_out_de_1P		<= in_de;
		r_out_valid_1P	<= in_valid;
		r_out_x_1P		<= in_x;
		r_out_y_1P		<= in_y;
	end
end

pattern_gen2
#(
	.DW	(PIXEL_BIT)
)
inst_pattern_gen2
(
	.i_arstn	(in_rstn),
	.i_sysclk	(in_pclk),
	.i_pt_sel	(in_pattern),
	.i_af_sel	(3'b0),
	.i_load		(1'b0),
	.i_en		(in_valid),
	.i_seed		({PIXEL_BIT{1'b0}}),
	.o_pattern	(out_data)
);

assign	out_x		= r_out_x_1P;
assign	out_y		= r_out_y_1P;
assign	out_vs		= r_out_vs_1P;
assign	out_hs		= r_out_hs_1P;
assign	out_valid	= r_out_valid_1P;
assign	out_de		= r_out_de_1P;

endmodule
