interface interface_windows#(Pra_Width = 8)();   //为滑动窗口输入与输出配置端口与寄存器

    logic                             image_vs;//垂直同步
    logic                             image_hs;//水平同步
    logic                             image_en;//使能信号


    //为储存各像素亮度值分配寄存器
logic [Pra_Width-1:0] window_00 [31];
logic [Pra_Width-1:0] window_01 [31];
logic [Pra_Width-1:0] window_02 [31];
logic [Pra_Width-1:0] window_03 [31];
logic [Pra_Width-1:0] window_04 [31];
logic [Pra_Width-1:0] window_05 [31];
logic [Pra_Width-1:0] window_06 [31];
logic [Pra_Width-1:0] window_07 [31];
logic [Pra_Width-1:0] window_08 [31];
logic [Pra_Width-1:0] window_09 [31];
logic [Pra_Width-1:0] window_10 [31];
logic [Pra_Width-1:0] window_11 [31];
logic [Pra_Width-1:0] window_12 [31];
logic [Pra_Width-1:0] window_13 [31];
logic [Pra_Width-1:0] window_14 [31];
logic [Pra_Width-1:0] window_15 [31];
logic [Pra_Width-1:0] window_16 [31];
logic [Pra_Width-1:0] window_17 [31];
logic [Pra_Width-1:0] window_18 [31];
logic [Pra_Width-1:0] window_19 [31];
logic [Pra_Width-1:0] window_20 [31];
logic [Pra_Width-1:0] window_21 [31];
logic [Pra_Width-1:0] window_22 [31];
logic [Pra_Width-1:0] window_23 [31];
logic [Pra_Width-1:0] window_24 [31];
logic [Pra_Width-1:0] window_25 [31];
logic [Pra_Width-1:0] window_26 [31];
logic [Pra_Width-1:0] window_27 [31];
logic [Pra_Width-1:0] window_28 [31];
logic [Pra_Width-1:0] window_29 [31];
logic [Pra_Width-1:0] window_30 [31];


modport i_window (input  image_vs,image_hs,image_en,
                            window_00,window_01,window_02,window_03,window_04,window_05,window_06,
                            window_07,window_08,window_09,window_10,window_11,window_12,window_13,
                            window_14,window_15,window_16,window_17,window_18,window_19,window_20,
                            window_21,window_22,window_23,window_24,window_25,window_26,window_27,
                            window_28,window_29,window_30
                            );  //输入端口
modport o_window (output image_vs,image_hs,image_en,
                            window_00,window_01,window_02,window_03,window_04,window_05,window_06,
                            window_07,window_08,window_09,window_10,window_11,window_12,window_13,
                            window_14,window_15,window_16,window_17,window_18,window_19,window_20,
                            window_21,window_22,window_23,window_24,window_25,window_26,window_27,
                            window_28,window_29,window_30
                            );  //输出端口



endinterface 