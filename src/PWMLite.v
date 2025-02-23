`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:	06:46:28 12/22/2020 
// Module Name:	PWMLite 
//////////////////////////////////////////////////////////////////////////////////

//	PWM Lite Controller. 
//	The maximum PWM frequency is 31.25KHz. 

module PWMLite (
	input 				clk_i,
	input 				rst_i,
	input 	[6:0] 	pwm_i,
	input					pol_i, 
	output 				pwm_o
);
	
	
	reg	[6:0]	rc_pwm = 0; 
	reg				r_pwm = 0; 
	always @(posedge clk_i) begin
		rc_pwm <= rc_pwm + 1; 
		r_pwm <= (pwm_i >= rc_pwm); 
	end
	
	assign pwm_o = r_pwm ^ pol_i; 
	
endmodule
