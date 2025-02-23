module Shift_9_Line_6_Pixel (
    input          i_clk,

    input          i_en,
    input          i_data,
    output         o_data
    );

parameter Pra_Shift_Pixels=6;

logic Data;

Shift_Pixel  #(.Pra_Depth(Pra_Shift_Pixels))
Shift_Pixel (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( i_data    ),
    .o_data                  ( Data    )
);

parameter Pra_Shift_Line_Number=9;


logic [Pra_Shift_Line_Number-1:0] Shift_Temp;


Shift_Line  DIP_Shift_Line_0 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Data    ),
    .o_data                  ( Shift_Temp[0]    )
);

Shift_Line  DIP_Shift_Line_1 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[0]    ),
    .o_data                  ( Shift_Temp[1]    )
);

Shift_Line  DIP_Shift_Line_2 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[1]    ),
    .o_data                  ( Shift_Temp[2]    )
);

Shift_Line  DIP_Shift_Line_3 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[2]    ),
    .o_data                  ( Shift_Temp[3]    )
);

Shift_Line  DIP_Shift_Line_4 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[3]    ),
    .o_data                  ( Shift_Temp[4]    )
);

Shift_Line  DIP_Shift_Line_5 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[4]    ),
    .o_data                  ( Shift_Temp[5]    )
);

Shift_Line  DIP_Shift_Line_6 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[5]    ),
    .o_data                  ( Shift_Temp[6]    )
);

Shift_Line  DIP_Shift_Line_7 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[6]    ),
    .o_data                  ( Shift_Temp[7]    )
);

Shift_Line  DIP_Shift_Line_8 (
    .i_clk                   ( i_clk     ),
    .i_en                    ( i_en      ),
    .i_data                  ( Shift_Temp[7]    ),
    .o_data                  ( Shift_Temp[8]    )
);


assign o_data=Shift_Temp[8];


endmodule
