module pattern_gen2
(
	i_arstn,
	i_sysclk,
	i_pt_sel,
	i_af_sel,
	i_load,
	i_en,
	i_seed,
	o_pattern
);

parameter	DW	= 8;

input				i_arstn;
input				i_sysclk;
input	[2:0]		i_pt_sel;
input	[2:0]		i_af_sel;
input				i_load;
input				i_en;
input	[DW-1:0]	i_seed;
output	[DW-1:0]	o_pattern;

reg		[DW-1:0]	r_cnt_1P;

wire	[DW-1:0]	w_lfsr;

wire	[DW-1:0]	w_p_af		[0:1];
wire	[DW-1:0]	w_s_af		[0:7];
wire	[DW-1:0]	w_pattern	[0:7];

lfsr_wrapper
#(
	.DW(DW)
)
inst_lfsr
(
	.i_areset	(~i_arstn),
	.i_sysclk	(i_sysclk),
	.i_load		(i_load),
	.i_en		(i_en),
	.i_seed		(i_seed),
	.o_lfsr		(w_lfsr)
);

always@(negedge i_arstn or posedge i_sysclk)
begin
	if (~i_arstn)
		r_cnt_1P	<= {DW{1'b0}};
//	else if (i_load)
//		r_cnt_1P	<= i_seed;
	else if (i_en)
		r_cnt_1P	<= r_cnt_1P+1'b1;
end

assign	w_p_af[0]	= {DW/4{4'b0011}};
assign	w_p_af[1]	= {DW/8{8'b00001111}};
assign	w_s_af[0]	= {DW{r_cnt_1P[0]}};
assign	w_s_af[1]	= {DW{r_cnt_1P[1]}};
assign	w_s_af[2]	= {DW{r_cnt_1P[2]}};
assign	w_s_af[3]	= {DW{r_cnt_1P[3]}};
assign	w_s_af[4]	= {DW{r_cnt_1P[4]}};
assign	w_s_af[5]	= {DW{r_cnt_1P[5]}};
assign	w_s_af[6]	= {DW{r_cnt_1P[6]}};
assign	w_s_af[7]	= {DW{r_cnt_1P[7]}};

assign	w_pattern[0]	=	w_lfsr;					// stress test for performance
assign	w_pattern[1]	=	r_cnt_1P;				// debug
assign	w_pattern[2]	=	{DW{1'b0}};				// all 0s, detect stuck at 1 fault
assign	w_pattern[3]	=	{DW{1'b1}};				// all 1s, detect stuck at 0 fault
assign	w_pattern[4]	=	{DW/2{2'b01}};			// checkerboard 55, detect stuck at fault
assign	w_pattern[5]	=	{DW/2{2'b10}};			// checkerboard AA, detect stuck at fault
assign	w_pattern[6]	=	w_p_af[i_af_sel[0]];	// 
assign	w_pattern[7]	=	w_s_af[i_af_sel];		//

assign	o_pattern		=	w_pattern[i_pt_sel];

endmodule
