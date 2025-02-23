localparam TOTAL_SIZE_A = 2048;
localparam TOTAL_SIZE_B = 2048;
localparam GROUP_COLUMNS       = 1;
parameter DECOMPOSE_WRITE_MODE = "READ_FIRST";
localparam bram_table_size = 52;
localparam bram_table_loop_mode = 0;
localparam bram_mapping_size = 52;
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
   0: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   1: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   2: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   3: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   4: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   5: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   6: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   7: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   8: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   9: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  10: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  11: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  12: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  13: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  14: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  15: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  16: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  17: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  18: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  19: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  20: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  21: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  22: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  23: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  24: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  25: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  26: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  27: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  28: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  29: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  30: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  31: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  32: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  33: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  34: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  35: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  36: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  37: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  38: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  39: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  40: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  41: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  42: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  43: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  44: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  45: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  46: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  47: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  48: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  49: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  50: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
  51: bram_decompose_table=(val_==0)?   4:(val_==1)?   4:(val_==2)?   1:(val_==3)?   0:(val_==4)?   0:0;
   endcase
endfunction  


function integer bram_mapping_table;
input integer index;//Mode type 
input integer val_;//            Y,              X,              DataA [MSB],    DataA [LSB],    DataA Repeat,   Read MuxA,      Wen0 SelA,      Wen1 SelA,      Byteen A,       DataB [MSB],    DataB [LSB],    DataB Repeat,   Read MuxB,      Wen0 SelB,      Wen1 SelB,      Byteen B,       Addr Width A    Data Width A    Addr Width B    Data Width B    
case (index)
   0: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   0:(val_== 2)?   4:(val_== 3)?   0:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   0:(val_== 7)?   0:(val_== 8)?   0:(val_== 9)?   4:(val_==10)?   0:(val_==11)?   0:(val_==12)?   0:(val_==13)?   0:(val_==14)?   0:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   1: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   1:(val_== 2)?   9:(val_== 3)?   5:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   1:(val_== 7)?   1:(val_== 8)?   0:(val_== 9)?   9:(val_==10)?   5:(val_==11)?   0:(val_==12)?   0:(val_==13)?   1:(val_==14)?   1:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   2: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   2:(val_== 2)?  14:(val_== 3)?  10:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   2:(val_== 7)?   2:(val_== 8)?   0:(val_== 9)?  14:(val_==10)?  10:(val_==11)?   0:(val_==12)?   0:(val_==13)?   2:(val_==14)?   2:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   3: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   3:(val_== 2)?  19:(val_== 3)?  15:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   3:(val_== 7)?   3:(val_== 8)?   0:(val_== 9)?  19:(val_==10)?  15:(val_==11)?   0:(val_==12)?   0:(val_==13)?   3:(val_==14)?   3:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   4: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   4:(val_== 2)?  24:(val_== 3)?  20:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   4:(val_== 7)?   4:(val_== 8)?   0:(val_== 9)?  24:(val_==10)?  20:(val_==11)?   0:(val_==12)?   0:(val_==13)?   4:(val_==14)?   4:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   5: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   5:(val_== 2)?  29:(val_== 3)?  25:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   5:(val_== 7)?   5:(val_== 8)?   0:(val_== 9)?  29:(val_==10)?  25:(val_==11)?   0:(val_==12)?   0:(val_==13)?   5:(val_==14)?   5:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   6: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   6:(val_== 2)?  34:(val_== 3)?  30:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   6:(val_== 7)?   6:(val_== 8)?   0:(val_== 9)?  34:(val_==10)?  30:(val_==11)?   0:(val_==12)?   0:(val_==13)?   6:(val_==14)?   6:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   7: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   7:(val_== 2)?  39:(val_== 3)?  35:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   7:(val_== 7)?   7:(val_== 8)?   0:(val_== 9)?  39:(val_==10)?  35:(val_==11)?   0:(val_==12)?   0:(val_==13)?   7:(val_==14)?   7:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   8: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   8:(val_== 2)?  44:(val_== 3)?  40:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   8:(val_== 7)?   8:(val_== 8)?   0:(val_== 9)?  44:(val_==10)?  40:(val_==11)?   0:(val_==12)?   0:(val_==13)?   8:(val_==14)?   8:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
   9: bram_mapping_table=(val_== 0)?   0:(val_== 1)?   9:(val_== 2)?  49:(val_== 3)?  45:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?   9:(val_== 7)?   9:(val_== 8)?   0:(val_== 9)?  49:(val_==10)?  45:(val_==11)?   0:(val_==12)?   0:(val_==13)?   9:(val_==14)?   9:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  10: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  10:(val_== 2)?  54:(val_== 3)?  50:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  10:(val_== 7)?  10:(val_== 8)?   0:(val_== 9)?  54:(val_==10)?  50:(val_==11)?   0:(val_==12)?   0:(val_==13)?  10:(val_==14)?  10:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  11: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  11:(val_== 2)?  59:(val_== 3)?  55:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  11:(val_== 7)?  11:(val_== 8)?   0:(val_== 9)?  59:(val_==10)?  55:(val_==11)?   0:(val_==12)?   0:(val_==13)?  11:(val_==14)?  11:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  12: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  12:(val_== 2)?  64:(val_== 3)?  60:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  12:(val_== 7)?  12:(val_== 8)?   0:(val_== 9)?  64:(val_==10)?  60:(val_==11)?   0:(val_==12)?   0:(val_==13)?  12:(val_==14)?  12:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  13: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  13:(val_== 2)?  69:(val_== 3)?  65:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  13:(val_== 7)?  13:(val_== 8)?   0:(val_== 9)?  69:(val_==10)?  65:(val_==11)?   0:(val_==12)?   0:(val_==13)?  13:(val_==14)?  13:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  14: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  14:(val_== 2)?  74:(val_== 3)?  70:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  14:(val_== 7)?  14:(val_== 8)?   0:(val_== 9)?  74:(val_==10)?  70:(val_==11)?   0:(val_==12)?   0:(val_==13)?  14:(val_==14)?  14:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  15: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  15:(val_== 2)?  79:(val_== 3)?  75:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  15:(val_== 7)?  15:(val_== 8)?   0:(val_== 9)?  79:(val_==10)?  75:(val_==11)?   0:(val_==12)?   0:(val_==13)?  15:(val_==14)?  15:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  16: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  16:(val_== 2)?  84:(val_== 3)?  80:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  16:(val_== 7)?  16:(val_== 8)?   0:(val_== 9)?  84:(val_==10)?  80:(val_==11)?   0:(val_==12)?   0:(val_==13)?  16:(val_==14)?  16:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  17: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  17:(val_== 2)?  89:(val_== 3)?  85:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  17:(val_== 7)?  17:(val_== 8)?   0:(val_== 9)?  89:(val_==10)?  85:(val_==11)?   0:(val_==12)?   0:(val_==13)?  17:(val_==14)?  17:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  18: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  18:(val_== 2)?  94:(val_== 3)?  90:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  18:(val_== 7)?  18:(val_== 8)?   0:(val_== 9)?  94:(val_==10)?  90:(val_==11)?   0:(val_==12)?   0:(val_==13)?  18:(val_==14)?  18:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  19: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  19:(val_== 2)?  99:(val_== 3)?  95:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  19:(val_== 7)?  19:(val_== 8)?   0:(val_== 9)?  99:(val_==10)?  95:(val_==11)?   0:(val_==12)?   0:(val_==13)?  19:(val_==14)?  19:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  20: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  20:(val_== 2)? 104:(val_== 3)? 100:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  20:(val_== 7)?  20:(val_== 8)?   0:(val_== 9)? 104:(val_==10)? 100:(val_==11)?   0:(val_==12)?   0:(val_==13)?  20:(val_==14)?  20:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  21: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  21:(val_== 2)? 109:(val_== 3)? 105:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  21:(val_== 7)?  21:(val_== 8)?   0:(val_== 9)? 109:(val_==10)? 105:(val_==11)?   0:(val_==12)?   0:(val_==13)?  21:(val_==14)?  21:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  22: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  22:(val_== 2)? 114:(val_== 3)? 110:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  22:(val_== 7)?  22:(val_== 8)?   0:(val_== 9)? 114:(val_==10)? 110:(val_==11)?   0:(val_==12)?   0:(val_==13)?  22:(val_==14)?  22:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  23: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  23:(val_== 2)? 119:(val_== 3)? 115:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  23:(val_== 7)?  23:(val_== 8)?   0:(val_== 9)? 119:(val_==10)? 115:(val_==11)?   0:(val_==12)?   0:(val_==13)?  23:(val_==14)?  23:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  24: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  24:(val_== 2)? 124:(val_== 3)? 120:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  24:(val_== 7)?  24:(val_== 8)?   0:(val_== 9)? 124:(val_==10)? 120:(val_==11)?   0:(val_==12)?   0:(val_==13)?  24:(val_==14)?  24:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  25: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  25:(val_== 2)? 129:(val_== 3)? 125:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  25:(val_== 7)?  25:(val_== 8)?   0:(val_== 9)? 129:(val_==10)? 125:(val_==11)?   0:(val_==12)?   0:(val_==13)?  25:(val_==14)?  25:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  26: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  26:(val_== 2)? 134:(val_== 3)? 130:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  26:(val_== 7)?  26:(val_== 8)?   0:(val_== 9)? 134:(val_==10)? 130:(val_==11)?   0:(val_==12)?   0:(val_==13)?  26:(val_==14)?  26:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  27: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  27:(val_== 2)? 139:(val_== 3)? 135:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  27:(val_== 7)?  27:(val_== 8)?   0:(val_== 9)? 139:(val_==10)? 135:(val_==11)?   0:(val_==12)?   0:(val_==13)?  27:(val_==14)?  27:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  28: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  28:(val_== 2)? 144:(val_== 3)? 140:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  28:(val_== 7)?  28:(val_== 8)?   0:(val_== 9)? 144:(val_==10)? 140:(val_==11)?   0:(val_==12)?   0:(val_==13)?  28:(val_==14)?  28:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  29: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  29:(val_== 2)? 149:(val_== 3)? 145:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  29:(val_== 7)?  29:(val_== 8)?   0:(val_== 9)? 149:(val_==10)? 145:(val_==11)?   0:(val_==12)?   0:(val_==13)?  29:(val_==14)?  29:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  30: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  30:(val_== 2)? 154:(val_== 3)? 150:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  30:(val_== 7)?  30:(val_== 8)?   0:(val_== 9)? 154:(val_==10)? 150:(val_==11)?   0:(val_==12)?   0:(val_==13)?  30:(val_==14)?  30:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  31: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  31:(val_== 2)? 159:(val_== 3)? 155:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  31:(val_== 7)?  31:(val_== 8)?   0:(val_== 9)? 159:(val_==10)? 155:(val_==11)?   0:(val_==12)?   0:(val_==13)?  31:(val_==14)?  31:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  32: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  32:(val_== 2)? 164:(val_== 3)? 160:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  32:(val_== 7)?  32:(val_== 8)?   0:(val_== 9)? 164:(val_==10)? 160:(val_==11)?   0:(val_==12)?   0:(val_==13)?  32:(val_==14)?  32:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  33: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  33:(val_== 2)? 169:(val_== 3)? 165:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  33:(val_== 7)?  33:(val_== 8)?   0:(val_== 9)? 169:(val_==10)? 165:(val_==11)?   0:(val_==12)?   0:(val_==13)?  33:(val_==14)?  33:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  34: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  34:(val_== 2)? 174:(val_== 3)? 170:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  34:(val_== 7)?  34:(val_== 8)?   0:(val_== 9)? 174:(val_==10)? 170:(val_==11)?   0:(val_==12)?   0:(val_==13)?  34:(val_==14)?  34:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  35: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  35:(val_== 2)? 179:(val_== 3)? 175:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  35:(val_== 7)?  35:(val_== 8)?   0:(val_== 9)? 179:(val_==10)? 175:(val_==11)?   0:(val_==12)?   0:(val_==13)?  35:(val_==14)?  35:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  36: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  36:(val_== 2)? 184:(val_== 3)? 180:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  36:(val_== 7)?  36:(val_== 8)?   0:(val_== 9)? 184:(val_==10)? 180:(val_==11)?   0:(val_==12)?   0:(val_==13)?  36:(val_==14)?  36:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  37: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  37:(val_== 2)? 189:(val_== 3)? 185:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  37:(val_== 7)?  37:(val_== 8)?   0:(val_== 9)? 189:(val_==10)? 185:(val_==11)?   0:(val_==12)?   0:(val_==13)?  37:(val_==14)?  37:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  38: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  38:(val_== 2)? 194:(val_== 3)? 190:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  38:(val_== 7)?  38:(val_== 8)?   0:(val_== 9)? 194:(val_==10)? 190:(val_==11)?   0:(val_==12)?   0:(val_==13)?  38:(val_==14)?  38:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  39: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  39:(val_== 2)? 199:(val_== 3)? 195:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  39:(val_== 7)?  39:(val_== 8)?   0:(val_== 9)? 199:(val_==10)? 195:(val_==11)?   0:(val_==12)?   0:(val_==13)?  39:(val_==14)?  39:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  40: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  40:(val_== 2)? 204:(val_== 3)? 200:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  40:(val_== 7)?  40:(val_== 8)?   0:(val_== 9)? 204:(val_==10)? 200:(val_==11)?   0:(val_==12)?   0:(val_==13)?  40:(val_==14)?  40:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  41: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  41:(val_== 2)? 209:(val_== 3)? 205:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  41:(val_== 7)?  41:(val_== 8)?   0:(val_== 9)? 209:(val_==10)? 205:(val_==11)?   0:(val_==12)?   0:(val_==13)?  41:(val_==14)?  41:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  42: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  42:(val_== 2)? 214:(val_== 3)? 210:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  42:(val_== 7)?  42:(val_== 8)?   0:(val_== 9)? 214:(val_==10)? 210:(val_==11)?   0:(val_==12)?   0:(val_==13)?  42:(val_==14)?  42:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  43: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  43:(val_== 2)? 219:(val_== 3)? 215:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  43:(val_== 7)?  43:(val_== 8)?   0:(val_== 9)? 219:(val_==10)? 215:(val_==11)?   0:(val_==12)?   0:(val_==13)?  43:(val_==14)?  43:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  44: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  44:(val_== 2)? 224:(val_== 3)? 220:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  44:(val_== 7)?  44:(val_== 8)?   0:(val_== 9)? 224:(val_==10)? 220:(val_==11)?   0:(val_==12)?   0:(val_==13)?  44:(val_==14)?  44:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  45: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  45:(val_== 2)? 229:(val_== 3)? 225:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  45:(val_== 7)?  45:(val_== 8)?   0:(val_== 9)? 229:(val_==10)? 225:(val_==11)?   0:(val_==12)?   0:(val_==13)?  45:(val_==14)?  45:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  46: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  46:(val_== 2)? 234:(val_== 3)? 230:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  46:(val_== 7)?  46:(val_== 8)?   0:(val_== 9)? 234:(val_==10)? 230:(val_==11)?   0:(val_==12)?   0:(val_==13)?  46:(val_==14)?  46:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  47: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  47:(val_== 2)? 239:(val_== 3)? 235:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  47:(val_== 7)?  47:(val_== 8)?   0:(val_== 9)? 239:(val_==10)? 235:(val_==11)?   0:(val_==12)?   0:(val_==13)?  47:(val_==14)?  47:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  48: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  48:(val_== 2)? 244:(val_== 3)? 240:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  48:(val_== 7)?  48:(val_== 8)?   0:(val_== 9)? 244:(val_==10)? 240:(val_==11)?   0:(val_==12)?   0:(val_==13)?  48:(val_==14)?  48:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  49: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  49:(val_== 2)? 249:(val_== 3)? 245:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  49:(val_== 7)?  49:(val_== 8)?   0:(val_== 9)? 249:(val_==10)? 245:(val_==11)?   0:(val_==12)?   0:(val_==13)?  49:(val_==14)?  49:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  50: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  50:(val_== 2)? 254:(val_== 3)? 250:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  50:(val_== 7)?  50:(val_== 8)?   0:(val_== 9)? 254:(val_==10)? 250:(val_==11)?   0:(val_==12)?   0:(val_==13)?  50:(val_==14)?  50:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
  51: bram_mapping_table=(val_== 0)?   0:(val_== 1)?  51:(val_== 2)? 255:(val_== 3)? 255:(val_== 4)?   0:(val_== 5)?   0:(val_== 6)?  51:(val_== 7)?  51:(val_== 8)?   0:(val_== 9)? 255:(val_==10)? 255:(val_==11)?   0:(val_==12)?   0:(val_==13)?  51:(val_==14)?  51:(val_==15)?   0:(val_==16)?  11:(val_==17)?   5:(val_==18)?  11:(val_==19)?   5:0;
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
