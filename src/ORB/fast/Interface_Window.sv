/************************************************************************************
 Company: 			
 Author: 			han
 Author Email:		sciencefuture@163.com
 Create Date:    	2022-03-04
 Module Name:    	
 HDL Type:        Verilog HDL
 Description: 
	
 Additional Comments: 

************************************************************************************/

interface Interface_Window#(Pra_Width = 8)();
    logic                             image_vs;
    logic                             image_hs;
    logic                             image_en;//there are some invalid data for the shift window, marker the value

    logic[Pra_Width-1:0]              window_00;
    logic[Pra_Width-1:0]              window_01;
    logic[Pra_Width-1:0]              window_02;
    logic[Pra_Width-1:0]              window_03;
    logic[Pra_Width-1:0]              window_04;
    logic[Pra_Width-1:0]              window_05;
    logic[Pra_Width-1:0]              window_06;

    logic[Pra_Width-1:0]              window_10;
    logic[Pra_Width-1:0]              window_11;
    logic[Pra_Width-1:0]              window_12;
    logic[Pra_Width-1:0]              window_13;
    logic[Pra_Width-1:0]              window_14;
    logic[Pra_Width-1:0]              window_15;
    logic[Pra_Width-1:0]              window_16;

    logic[Pra_Width-1:0]              window_20;
    logic[Pra_Width-1:0]              window_21;
    logic[Pra_Width-1:0]              window_22;   
    logic[Pra_Width-1:0]              window_23;   
    logic[Pra_Width-1:0]              window_24;   
    logic[Pra_Width-1:0]              window_25;
    logic[Pra_Width-1:0]              window_26;

    logic[Pra_Width-1:0]              window_30;
    logic[Pra_Width-1:0]              window_31;
    logic[Pra_Width-1:0]              window_32;   
    logic[Pra_Width-1:0]              window_33;   
    logic[Pra_Width-1:0]              window_34;   
    logic[Pra_Width-1:0]              window_35;
    logic[Pra_Width-1:0]              window_36;

    logic[Pra_Width-1:0]              window_40;
    logic[Pra_Width-1:0]              window_41;
    logic[Pra_Width-1:0]              window_42;   
    logic[Pra_Width-1:0]              window_43;   
    logic[Pra_Width-1:0]              window_44;   
    logic[Pra_Width-1:0]              window_45;
    logic[Pra_Width-1:0]              window_46;

    logic[Pra_Width-1:0]              window_50;
    logic[Pra_Width-1:0]              window_51;
    logic[Pra_Width-1:0]              window_52;   
    logic[Pra_Width-1:0]              window_53;   
    logic[Pra_Width-1:0]              window_54;   
    logic[Pra_Width-1:0]              window_55;
    logic[Pra_Width-1:0]              window_56;

    logic[Pra_Width-1:0]              window_60;
    logic[Pra_Width-1:0]              window_61;
    logic[Pra_Width-1:0]              window_62;   
    logic[Pra_Width-1:0]              window_63;   
    logic[Pra_Width-1:0]              window_64;   
    logic[Pra_Width-1:0]              window_65;
    logic[Pra_Width-1:0]              window_66;





modport I_Window (input  image_vs,image_hs,image_en,
                            window_00,window_01,window_02,window_03,window_04,window_05,window_06,
                            window_10,window_11,window_12,window_13,window_14,window_15,window_16,
                            window_20,window_21,window_22,window_23,window_24,window_25,window_26,
                            window_30,window_31,window_32,window_33,window_34,window_35,window_36,
                            window_40,window_41,window_42,window_43,window_44,window_45,window_46,
                            window_50,window_51,window_52,window_53,window_54,window_55,window_56,
                            window_60,window_61,window_62,window_63,window_64,window_65,window_66
                            );
modport O_Window (output image_vs,image_hs,image_en,
                            window_00,window_01,window_02,window_03,window_04,window_05,window_06,
                            window_10,window_11,window_12,window_13,window_14,window_15,window_16,
                            window_20,window_21,window_22,window_23,window_24,window_25,window_26,
                            window_30,window_31,window_32,window_33,window_34,window_35,window_36,
                            window_40,window_41,window_42,window_43,window_44,window_45,window_46,
                            window_50,window_51,window_52,window_53,window_54,window_55,window_56,
                            window_60,window_61,window_62,window_63,window_64,window_65,window_66
                            );



endinterface //interfacename


