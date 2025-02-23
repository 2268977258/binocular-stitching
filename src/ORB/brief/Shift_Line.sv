module Shift_Line (
    input          i_clk,

    input          i_en,
    input          i_data,
    output         o_data
    );

parameter Pra_Depth=1080;
logic [9:0] Address_0;
logic [9:0] Address_1;

assign Address_0=500;
assign Address_1=Pra_Depth-Address_0-2;

logic Data_Temp;

Shift_RAM_1_1024 Shift_RAM_1_1024_A_0 (
//EFINITY_TEST
  .addr(Address_0),      
  .wdata_a(i_data),      
  .clk(i_clk),  
  .re(i_en),    
  .we(i_en),
  .rdata_a(Data_Temp)
);

Shift_RAM_1_1024 Shift_RAM_1_1024_A_1 (
//EFINITY_TEST
  .addr(Address_1),      
  .wdata_a(Data_Temp),      
  .clk(i_clk),  
  .re(i_en),    
  .we(i_en),
  .rdata_a(o_data)
);

endmodule