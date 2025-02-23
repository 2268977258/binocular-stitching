module lfsr_wrapper
#(
	parameter	DW	= 8
)
(
	input	i_areset,
	input	i_sysclk,
	input	i_load,
	input	i_en,
	input	[DW-1:0]i_seed,
	output	[DW-1:0]o_lfsr
);

wire	[7:0]c_num_nxor;
wire	[7:0]c_fb_bit0;
wire	[7:0]c_fb_bit1;
wire	[7:0]c_fb_bit2;
wire	[7:0]c_fb_bit3;
wire	[7:0]c_fb_bit4;

// XAPP_052
generate
	case (DW)
		8'd3:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd3;		assign	c_fb_bit1	= 8'd2;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd4:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd4;		assign	c_fb_bit1	= 8'd3;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end	// Tested
		8'd5:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd5;		assign	c_fb_bit1	= 8'd3;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd6:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd6;		assign	c_fb_bit1	= 8'd5;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd7:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd7;		assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd8:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd8;		assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd5;		assign	c_fb_bit3	= 8'd4;		assign	c_fb_bit4	= 8'd255;	end
		8'd9:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd9;		assign	c_fb_bit1	= 8'd5;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd10:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd10;	assign	c_fb_bit1	= 8'd7;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd11:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd11;	assign	c_fb_bit1	= 8'd9;		assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd12:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd12;	assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd4;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd13:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd13;	assign	c_fb_bit1	= 8'd4;		assign	c_fb_bit2	= 8'd3;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd14:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd14;	assign	c_fb_bit1	= 8'd5;		assign	c_fb_bit2	= 8'd3;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd15:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd15;	assign	c_fb_bit1	= 8'd14;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd16:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd16;	assign	c_fb_bit1	= 8'd15;	assign	c_fb_bit2	= 8'd13;	assign	c_fb_bit3	= 8'd4;		assign	c_fb_bit4	= 8'd255;	end
		8'd17:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd17;	assign	c_fb_bit1	= 8'd14;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd18:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd18;	assign	c_fb_bit1	= 8'd11;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd19:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd19;	assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd2;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd20:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd20;	assign	c_fb_bit1	= 8'd17;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd21:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd21;	assign	c_fb_bit1	= 8'd19;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd22:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd22;	assign	c_fb_bit1	= 8'd21;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd23:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd23;	assign	c_fb_bit1	= 8'd18;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd24:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd24;	assign	c_fb_bit1	= 8'd23;	assign	c_fb_bit2	= 8'd22;	assign	c_fb_bit3	= 8'd17;	assign	c_fb_bit4	= 8'd255;	end
		8'd25:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd25;	assign	c_fb_bit1	= 8'd22;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd26:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd26;	assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd2;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd27:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd27;	assign	c_fb_bit1	= 8'd5;		assign	c_fb_bit2	= 8'd2;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd28:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd28;	assign	c_fb_bit1	= 8'd25;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd29:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd29;	assign	c_fb_bit1	= 8'd27;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd30:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd30;	assign	c_fb_bit1	= 8'd6;		assign	c_fb_bit2	= 8'd4;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd31:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd31;	assign	c_fb_bit1	= 8'd28;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd32:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd32;	assign	c_fb_bit1	= 8'd22;	assign	c_fb_bit2	= 8'd2;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd33:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd33;	assign	c_fb_bit1	= 8'd20;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd34:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd34;	assign	c_fb_bit1	= 8'd27;	assign	c_fb_bit2	= 8'd2;		assign	c_fb_bit3	= 8'd1;		assign	c_fb_bit4	= 8'd255;	end
		8'd35:	begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd35;	assign	c_fb_bit1	= 8'd33;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
		8'd128:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd128;	assign	c_fb_bit1	= 8'd126;	assign	c_fb_bit2	= 8'd101;	assign	c_fb_bit3	= 8'd99;	assign	c_fb_bit4	= 8'd255;	end
		8'd168:	begin	assign	c_num_nxor	= 8'd4;	assign	c_fb_bit0	= 8'd168;	assign	c_fb_bit1	= 8'd166;	assign	c_fb_bit2	= 8'd153;	assign	c_fb_bit3	= 8'd151;	assign	c_fb_bit4	= 8'd255;	end
		default:begin	assign	c_num_nxor	= 8'd2;	assign	c_fb_bit0	= 8'd255;	assign	c_fb_bit1	= 8'd255;	assign	c_fb_bit2	= 8'd255;	assign	c_fb_bit3	= 8'd255;	assign	c_fb_bit4	= 8'd255;	end
	endcase
endgenerate

lfsr
#(
	.DW(DW)
)
inst_lfsr
(
	.c_num_nxor	(c_num_nxor),
	.c_fb_bit0	(c_fb_bit0),
	.c_fb_bit1	(c_fb_bit1),
	.c_fb_bit2	(c_fb_bit2),
	.c_fb_bit3	(c_fb_bit3),
	.c_fb_bit4	(c_fb_bit4),
	
	.i_areset	(i_areset),
	.i_sysclk	(i_sysclk),
	.i_load		(i_load),
	.i_en		(i_en),
	.i_seed		(i_seed),
	.o_lfsr		(o_lfsr)
);

endmodule

module lfsr
#(
	parameter	DW	= 8
)
(
	input	[7:0]c_num_nxor,
	input	[7:0]c_fb_bit0,
	input	[7:0]c_fb_bit1,
	input	[7:0]c_fb_bit2,
	input	[7:0]c_fb_bit3,
	input	[7:0]c_fb_bit4,
	
	input	i_areset,
	input	i_sysclk,
	input	i_load,
	input	i_en,
	input	[DW-1:0]i_seed,
	output	[DW-1:0]o_lfsr
);

reg		[DW-1:0]r_lfsr_1P;
reg		w_fb_0P;

//always@(posedge i_areset or posedge i_sysclk)
always@(posedge i_sysclk)
begin
	if (i_areset)
	begin
		r_lfsr_1P	<= {DW+1{1'b0}};
	end
	else if (i_load)
	begin
		r_lfsr_1P	<= i_seed;
	end
	else if (i_en)
	begin
		r_lfsr_1P	<= {r_lfsr_1P[DW-2:0], w_fb_0P};
	end
end

assign	o_lfsr	= r_lfsr_1P;

always@(*)
	if (c_num_nxor == 8'd5)
		w_fb_0P	= r_lfsr_1P[c_fb_bit4-1'b1] ^~ r_lfsr_1P[c_fb_bit3-1'b1] ^~ r_lfsr_1P[c_fb_bit2-1'b1] ^~ r_lfsr_1P[c_fb_bit1-1'b1] ^~ r_lfsr_1P[c_fb_bit0-1'b1];
	else if (c_num_nxor == 8'd4)
		w_fb_0P	= r_lfsr_1P[c_fb_bit3-1'b1] ^~ r_lfsr_1P[c_fb_bit2-1'b1] ^~ r_lfsr_1P[c_fb_bit1-1'b1] ^~ r_lfsr_1P[c_fb_bit0-1'b1];
	else
		w_fb_0P	= r_lfsr_1P[c_fb_bit1-1'b1] ^~ r_lfsr_1P[c_fb_bit0-1'b1];

endmodule
