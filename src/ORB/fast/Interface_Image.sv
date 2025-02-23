/************************************************************************************
 Company: 			
 Author: 			han
 Author Email:		sciencefuture@163.com
 Create Date:    	2021-02-09
 Module Name:    	
 HDL Type:        Verilog HDL
 Description: 
	
 Additional Comments: 

************************************************************************************/

interface Interface_Image#(Pra_Width = 8)();
    logic                     image_vs;
    logic                     image_hs;
    logic                     image_en;
    logic[Pra_Width-1:0]      image_data;

modport I_Image (input  image_vs,image_hs,image_en,image_data);

modport O_Image (output  image_vs,image_hs,image_en,image_data);

endinterface //interfacename


