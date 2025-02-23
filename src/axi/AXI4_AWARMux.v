`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    15:58:46 04/08/2023 
// Module Name:    AXI4_AWARMux 
//////////////////////////////////////////////////////////////////////////////////

//	AXI4 AW / AR Path Mux. 
//	This module works with Efinix AXI4-Modified Interface. 
//	atype_o = 1 for DDR Write, and atype_o = 0 for DDR Read. 

module AXI4_AWARMux #(
	parameter 	AID_LEN 	= 8, 
			AADDR_LEN 	= 32
)(
    input                               aclk_i                     ,
    input                               arst_i                     ,
	
	//	AW
    input              [AID_LEN-1:0]    awid_i                     ,
    input              [AADDR_LEN-1:0]  awaddr_i                   ,
    input              [   7:0]         awlen_i                    ,
    input                               awvalid_i                  ,
    output reg                          awready_o                  ,
	
	//	AR
    input              [AID_LEN-1:0]    arid_i                     ,
    input              [AADDR_LEN-1:0]  araddr_i                   ,
    input              [   7:0]         arlen_i                    ,
    input                               arvalid_i                  ,
    output reg                          arready_o                  ,
	
	//	A
    output             [AID_LEN-1:0]    aid_o                      ,
    output             [AADDR_LEN-1:0]  aaddr_o                    ,
    output             [   7:0]         alen_o                     ,
    output                              atype_o                    ,
    output reg                          avalid_o                   ,
    input                               aready_i                    
);

	//	R/W Wrapper. atype_o = 1 for DDR Write, and atype_o = 0 for DDR Read. 
	//	Assert R/W in round robin mode. 
	reg 	[1:0] 	rs_req = 0; 		//	DDR3 Request State Machine
	wire 	[1:0] 	ws_req_idle = 0; 
	wire 	[1:0] 	ws_req_bridge = 1; 
	wire 	[1:0] 	ws_req_inc = 2; 
	
	reg 			r_reqtype = 0; 	//	Type = 0 for read, and type = 1 for write. Toggle when aready. 
	reg 			r_reqen = 0; 	//	Request En
	
	always @(posedge aclk_i) begin
		//	Clear AREADY by default. 
		arready_o <= 0; 
		awready_o <= 0; 
		
		case (rs_req) 
			ws_req_idle: begin
					//	By default toggle reqtype when no commands. 
					rs_req <= ws_req_inc; 
					
					//	Type = 0 for read. 
					if(r_reqtype == 0) begin
						//	When read request, bridge to AR path. 
						if(arvalid_i) begin
							avalid_o <= 1; 
							rs_req <= ws_req_bridge; 
						end else begin
						end
					end else begin
						//	When write request, bridge to AR path. 
						if(awvalid_i) begin
							avalid_o <= 1; 
							rs_req <= ws_req_bridge; 
						end else begin
						end
					end
				end
			ws_req_bridge: begin
					if(aready_i) begin
						avalid_o <= 0; 
						
						//	Respond to AR / AW. 
						arready_o <= (r_reqtype == 0); 
						awready_o <= (r_reqtype == 1); 
						rs_req <= ws_req_inc; 
					end else begin
					end
				end
			ws_req_inc: begin
					r_reqtype <= r_reqtype + 1; 
					rs_req <= ws_req_idle; 
				end
		endcase
		
		if(arst_i) begin
			rs_req <= 0; 
			r_reqtype <= 0; 
			r_reqen <= 0; 
			
			//awready_o <= 0; 
			//arready_o <= 0; 
			avalid_o <= 0; 
		end else begin
		end
	end
	
	//	Type = 0 for read. Bridge to AR path. 
	assign aid_o = (r_reqtype == 0) ? arid_i : awid_i; 
	assign aaddr_o = (r_reqtype == 0) ? araddr_i : awaddr_i; 
	assign alen_o = (r_reqtype == 0) ? arlen_i : awlen_i; 
	assign atype_o = r_reqtype; 

endmodule
