localparam TOTAL_SIZE_A = 1024;
localparam TOTAL_SIZE_B = 1024;
localparam GROUP_COLUMNS       = 1;
parameter DECOMPOSE_WRITE_MODE = "READ_FIRST";
localparam bram_table_size = 1;
localparam bram_table_loop_mode = 0;
localparam bram_mapping_size = 1;
localparam rMux_mapping_A_size = 0;
localparam rMux_mapping_B_size = 0;
localparam wen_sel_mapping_A_size = 0;
localparam wen_sel_mapping_B_size = 0;
localparam data_mapping_table_A_size = 0;
localparam data_mapping_table_B_size = 0;
localparam address_mapping_table_A_size = 0;
localparam address_mapping_table_B_size = 0;


function integer bram_feature_table;
input integer index;//Mode type 
input integer val_; //Address_width, data_width, en_width, reserved 
case (index)
0: bram_feature_table=(val_==0)?9:(val_==1)?20:(val_==2)?2:(val_==3)?2:(val_==4)?0:0;
1: bram_feature_table=(val_==0)?9:(val_==1)?16:(val_==2)?2:(val_==3)?2:(val_==4)?1:0;
2: bram_feature_table=(val_==0)?10:(val_==1)?10:(val_==2)?1:(val_==3)?2:(val_==4)?0:0;
3: bram_feature_table=(val_==0)?10:(val_==1)?8:(val_==2)?1:(val_==3)?2:(val_==4)?1:0;
4: bram_feature_table=(val_==0)?11:(val_==1)?5:(val_==2)?1:(val_==3)?2:(val_==4)?0:0;
5: bram_feature_table=(val_==0)?11:(val_==1)?4:(val_==2)?1:(val_==3)?2:(val_==4)?1:0;
6: bram_feature_table=(val_==0)?12:(val_==1)?2:(val_==2)?1:(val_==3)?2:(val_==4)?1:0;
7: bram_feature_table=(val_==0)?13:(val_==1)?1:(val_==2)?1:(val_==3)?2:(val_==4)?1:0;
   endcase
endfunction  


function integer bram_decompose_table;
input integer index;//Mode type 
input integer val_; //Port A index, Port B Index, Number of Items in Loop, Port A Start, Port B Start, reserved 
case (index)
   0: bram_decompose_table=(val_==0)?   2:(val_==1)?   2:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   endcase
endfunction  


function integer bram_mapping_table;
input integer index;//Mode type 
input integer val_;//            Y,              X,              DataA [MSB],    DataA [LSB],    DataA Repeat,   Read MuxA,      Wen0 SelA,      Wen1 SelA,      Byteen A,       DataB [MSB],    DataB [LSB],    DataB Repeat,   Read MuxB,      Wen0 SelB,      Wen1 SelB,      Byteen B,       Addr Width A    Data Width A    Addr Width B    Data Width B    
case (index)
   0: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   0:(val_== 2)?   0:(val_== 3)?   0:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   0:(val_==10)?   0:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  10:(val_==17)?  10:(val_==18)?  10:(val_==19)?  10:0;
   endcase
endfunction  


function integer rMux_mapping_table_A;
input integer index;//Mode type 
input integer val_;//            PortA Addr MSB, PortA Addr LSB, DataA[MSB],     DataA[LSB],     MuxSelA[MSB],   MuxSelA[LSB],   Bypass,         
rMux_mapping_table_A = 0; 
endfunction  


function integer rMux_mapping_table_B;
input integer index;//Mode type 
input integer val_;//            PortB Addr MSB, PortB Addr LSB, DataB[MSB],     DataB[LSB],     MuxSelB[MSB],   MuxSelB[LSB],   Bypass,         
rMux_mapping_table_B = 0; 
endfunction  


function integer wen_sel_mapping_table_A;
input integer index;//Mode type 
input integer val_;//              PortA Addr MSB,   PortA Addr LSB,   WenSelA[MSB],     WenSelA[LSB],     Bypass,         
wen_sel_mapping_table_A = 0; 
endfunction  


function integer wen_sel_mapping_table_B;
input integer index;//Mode type 
input integer val_;//            PortB Addr MSB, PortB Addr LSB, WenSelB[MSB],   WenSelB[LSB],   Bypass,         
wen_sel_mapping_table_B = 0; 
endfunction  


function integer data_mapping_table_A;
input integer index;// 
data_mapping_table_A = 0; 
endfunction  


function integer data_mapping_table_B;
input integer index;// 
data_mapping_table_B = 0; 
endfunction  


function integer address_mapping_table_A;
input integer index;// 
address_mapping_table_A = 0; 
endfunction  


function integer address_mapping_table_B;
input integer index;// 
address_mapping_table_B = 0; 
endfunction  
