`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    21:44:36 05/15/2023 
// Module Name:    dsi_init 
//////////////////////////////////////////////////////////////////////////////////
module dsi_init(
	input 			clk_i,
	input 			rst_i,
	
	input 	[27:0] 	delay_i,
	
	output reg	[7:0] 	awaddr_o,
	output reg			awvalid_o,
	input 			awready_i,
	
	output reg			wvalid_o,
	output reg	[31:0] 	wdata_o,
	input 			wready_i
);
	
	
	reg 	[27:0] 	rc_init = 0; 
	reg 			r_ready = 0; 
	
	reg 	[3:0] 	rs_ctl = 0; 
	
	wire 	[3:0] 	w_regcnt = 9; 
	reg 	[3:0] 	rc_addr = 0; 
	reg 	[39:0] 	w_regdata; 
	always @(*) begin
		w_regdata <= 0; 
		case (rc_addr)
			0:	w_regdata <= 40'h40_000014C8; 
			1:	w_regdata <= 40'h44_00000006; 
			2:	w_regdata <= 40'h48_0000000C; 
			3:	w_regdata <= 40'h4C_000002E2; 
			4:	w_regdata <= 40'h50_00000005; 
			5:	w_regdata <= 40'h54_00000008; 
			6:	w_regdata <= 40'h58_00000020; 
			7:	w_regdata <= 40'h5C_00000258; 
			8:	w_regdata <= 40'h18_0000000A; 
		endcase
	end
	
	always @(posedge clk_i or posedge rst_i) begin
		if(rst_i) begin
			rc_init <= 0; 
			r_ready <= 0; 
			
			awvalid_o <= 0; 
			wvalid_o <= 0; 
			rs_ctl <= 0; 
			rc_addr <= 0; 
		end else begin
			rc_init <= rc_init + 1; 
			r_ready <= r_ready | (rc_init >= delay_i); 
			
			//	Clear awvalid & wvalid. 
			if(awready_i)
				awvalid_o <= 0; 
			else begin
			end
			
			if(wready_i)
				wvalid_o <= 0; 
			else begin
			end
			
			case (rs_ctl)
				0: begin
						awaddr_o <= w_regdata[39:32]; 
						wdata_o <= w_regdata[31: 0]; 
						awvalid_o <= 1; 
						wvalid_o <= 1; 
						rs_ctl <= 1; 
					end
				1: begin
						if((~awvalid_o) && (~wvalid_o)) begin
							rs_ctl <= 2; 
						end else begin
						end
					end
				2: begin
						//	Write regcnt words. 
						if(rc_addr < w_regcnt - 1) begin
							rc_addr <= rc_addr + 1; 
							rs_ctl <= 0; 
						end else begin
						end
					end
			endcase
		end
	end
	
	
	
	
endmodule
