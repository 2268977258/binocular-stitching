interface interface_image#(Pra_Width = 8)();
    logic                     image_vs;
    logic                     image_hs;
    logic                     image_en;
    logic[Pra_Width-1:0]      image_data;

modport i_image (input  image_vs,image_hs,image_en,image_data);

modport o_image (output  image_vs,image_hs,image_en,image_data);

endinterface