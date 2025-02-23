module Shift_Pixel (
    input          i_clk,

    input          i_en,
    input          i_data,
    output         o_data
    );

parameter Pra_Depth=1;
logic [9:0] Address;
assign Address=Pra_Depth-1;

Shift_RAM_1_1024 Shift_RAM_1_1024 (
  .addr(Address),      
  .wdata_a(i_data),      
  .clk(i_clk),  
  .re(i_en),   
  .we(i_en), 
  .rdata_a(o_data)      
);


endmodule
