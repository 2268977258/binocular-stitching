
/************************************************************************************
 Company:             
 Author:             han
 Author Email:       sciencefuture@163.com
 Create Date:        2023-06-05
 Module Name:        
 HDL Type:        Verilog HDL
 Description: 

 Additional Comments: 

************************************************************************************/

module Descriptor_Buffer(
    input              i_clk,
    //start and end分别在开始和结束的一刻为1
    //主要控制写入，start复位RAM读写控制数据，每个valid写入数据，end后保持内部数据
    input              i_orb_descriptor_0_start,
    input              i_orb_descriptor_0_end,
    input              i_orb_descriptor_0_valid,
    input  [287:0]     i_orb_descriptor_0_value,

    input              i_orb_descriptor_1_start,
    input              i_orb_descriptor_1_end,
    input              i_orb_descriptor_1_valid,
    input  [287:0]     i_orb_descriptor_1_value,

    output             o_orb_descriptor_0_ready,//buffer 数据ready
    input              i_orb_descriptor_0_ready_ack,//match 可以接受数据的握手
    output  [15:0]     o_orb_descriptor_0_length,//buffer内的有效数据长度
    input              i_orb_descriptor_0_en,//match的读数据请求
    input   [15:0]     i_orb_descriptor_0_address,//match的读数据地址
    output  [255:0]    o_orb_descriptor_0_data,//读出的数据
    input              i_orb_descriptor_0_location_en,//同上，match读位置的请求、地址、位置
    input   [15:0]     i_orb_descriptor_0_location_address,
    output  [31:0]     o_orb_descriptor_0_location_data,

    output             o_orb_descriptor_1_ready,
    input              i_orb_descriptor_1_ready_ack,
    output  [15:0]     o_orb_descriptor_1_length,
    input              i_orb_descriptor_1_en,
    input   [15:0]     i_orb_descriptor_1_address,
    output  [255:0]    o_orb_descriptor_1_data,
    input              i_orb_descriptor_1_location_en,
    input   [15:0]     i_orb_descriptor_1_location_address,
    output  [31:0]     o_orb_descriptor_1_location_data

    );

/*************************************************************************
                For image 0
**************************************************************************/
logic  [11:0]     RAM_Write_0_Address=0;
logic             RAM_Write_0_En=0;
logic  [287:0]    RAM_Write_0_Value=0;

always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_0_start)
    begin
        RAM_Write_0_En<=0;
        RAM_Write_0_Address<=0;
        RAM_Write_0_Value<=0;
    end
    else if(i_orb_descriptor_0_valid)
    begin
        RAM_Write_0_En<=1;
        RAM_Write_0_Address<=RAM_Write_0_Address+1;
        RAM_Write_0_Value<=i_orb_descriptor_0_value;
    end
    else
    begin
        RAM_Write_0_En<=0;
        RAM_Write_0_Address<=RAM_Write_0_Address;
        RAM_Write_0_Value<=0;
    end
end
//length为已经写入特征点数量
logic  [15:0]     ORB_Descriptor_0_Length=0;
logic             ORB_Descriptor_0_Ready=0;
always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_0_end)
    begin
        ORB_Descriptor_0_Length<=RAM_Write_0_Address;
    end
    else
    begin
        ORB_Descriptor_0_Length<=ORB_Descriptor_0_Length;
    end
end
//assign o_orb_descriptor_0_length=ORB_Descriptor_0_Length;

always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_0_end)
    begin
        ORB_Descriptor_0_Ready<=1;
    end
    else if(i_orb_descriptor_0_ready_ack)
    begin
        ORB_Descriptor_0_Ready<=0;
    end
    else
    begin
        ORB_Descriptor_0_Ready<=ORB_Descriptor_0_Ready;
    end
end
assign o_orb_descriptor_0_length=ORB_Descriptor_0_Length;
assign o_orb_descriptor_0_ready=ORB_Descriptor_0_Ready;




RAM_256_256_2048 RAM_256_256_2048_0 (
  .clk(i_clk),    // input wire clka
  .we(RAM_Write_0_En),      // input wire ena
  .waddr(RAM_Write_0_Address[10:0]),  // input wire [10 : 0] addra
  .wdata_a(RAM_Write_0_Value[287:32]),    // input wire [255 : 0] dina

  .re(i_orb_descriptor_0_en),      // input wire enb
  .raddr(i_orb_descriptor_0_address[10:0]),  // input wire [10 : 0] addrb
  .rdata_b(o_orb_descriptor_0_data)  // output wire [255 : 0] doutb
);


RAM_32_32_2048 RAM_32_32_2048_0 (
  .clk(i_clk),    // input wire clka
  .we(RAM_Write_0_En),      // input wire ena
  .waddr(RAM_Write_0_Address[10:0]),  // input wire [10 : 0] addra
  .wdata_a({RAM_Write_0_Value[31:0]}),    // input wire [31 : 0] dina

  .re(i_orb_descriptor_0_location_en),      // input wire enb
  .raddr(i_orb_descriptor_0_location_address[10:0]),  // input wire [10 : 0] addrb
  .rdata_b(o_orb_descriptor_0_location_data)  // output wire [31 : 0] doutb
);


/*************************************************************************
                For image 1
**************************************************************************/
logic  [11:0]     RAM_Write_1_Address=0;
logic             RAM_Write_1_En=0;
logic  [287:0]    RAM_Write_1_Value=0;

always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_1_start)
    begin
        RAM_Write_1_En<=0;
        RAM_Write_1_Address<=0;
        RAM_Write_1_Value<=0;
    end
    else if(i_orb_descriptor_1_valid)
    begin
        RAM_Write_1_En<=1;
        RAM_Write_1_Address<=RAM_Write_1_Address+1;
        RAM_Write_1_Value<=i_orb_descriptor_1_value;
    end
    else
    begin
        RAM_Write_1_En<=0;
        RAM_Write_1_Address<=RAM_Write_1_Address;
        RAM_Write_1_Value<=0;
    end
end

logic  [15:0]     ORB_Descriptor_1_Length=0;
logic             ORB_Descriptor_1_Ready=0;
always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_1_end)
    begin
        ORB_Descriptor_1_Length<=RAM_Write_1_Address;
    end
    else
    begin
        ORB_Descriptor_1_Length<=ORB_Descriptor_1_Length;
    end
end
//assign o_orb_descriptor_1_length=ORB_Descriptor_1_Length;

always_ff @(posedge i_clk)
begin
    if(i_orb_descriptor_1_end)
    begin
        ORB_Descriptor_1_Ready<=1;
    end
    else if(i_orb_descriptor_1_ready_ack)
    begin
        ORB_Descriptor_1_Ready<=0;
    end
    else
    begin
        ORB_Descriptor_1_Ready<=ORB_Descriptor_1_Ready;
    end
end
assign o_orb_descriptor_1_length=ORB_Descriptor_1_Length;
assign o_orb_descriptor_1_ready=ORB_Descriptor_1_Ready;




RAM_256_256_2048 RAM_256_256_2048_1 (
  .clk(i_clk),    // input wire clka
  .we(RAM_Write_1_En),      // input wire ena
  .waddr(RAM_Write_1_Address[10:0]),  // input wire [10 : 0] addra
  .wdata_a(RAM_Write_1_Value[287:32]),    // input wire [255 : 0] dina

  .re(i_orb_descriptor_1_en),      // input wire enb
  .raddr(i_orb_descriptor_1_address[10:0]),  // input wire [10 : 0] addrb
  .rdata_b(o_orb_descriptor_1_data)  // output wire [255 : 0] doutb
);


RAM_32_32_2048 RAM_32_32_2048_1 (
  .clk(i_clk),    // input wire clka
  .we(RAM_Write_1_En),      // input wire ena
  .waddr(RAM_Write_1_Address[10:0]),  // input wire [10 : 0] addra
  .wdata_a({RAM_Write_1_Value[31:0]}),    // input wire [31 : 0] dina

  .re(i_orb_descriptor_1_location_en),      // input wire enb
  .raddr(i_orb_descriptor_1_location_address[10:0]),  // input wire [10 : 0] addrb
  .rdata_b(o_orb_descriptor_1_location_data)  // output wire [31 : 0] doutb
);


endmodule
