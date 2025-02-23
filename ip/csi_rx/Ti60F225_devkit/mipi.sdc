# PLL Constraints
#################
create_clock -period 10.000 mipi_clk   
create_clock -period 10.000 mipi_dphy_rx_clk_CLKOUT
create_clock -period 15 pixel_clk
create_clock -period 10.000 mipi_dphy_tx_SLOWCLK

set_clock_groups -exclusive -group {mipi_clk} -group {mipi_dphy_rx_clk_CLKOUT} -group {pixel_clk} -group {jtag_inst1_TCK}
set_clock_groups -exclusive -group {mipi_clk} -group {mipi_dphy_tx_SLOWCLK} -group {pixel_clk} -group {jtag_inst1_TCK}

# GPIO Constraints
####################

# LVDS RX GPIO Constraints
############################

# LVDS Rx Constraints
####################

# LVDS Tx Constraints
####################

# MIPI TX Constraints
#####################################
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.301 [get_ports {mipi_dphy_tx_HS_enable_C}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_HS_enable_C}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_clk_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_clk_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_clk_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_clk_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_clk_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_clk_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_clk_LP_P_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_clk_LP_P_OUT}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max -2.033 [get_ports {mipi_dphy_tx_data0_HS_OUT[7] mipi_dphy_tx_data0_HS_OUT[6] mipi_dphy_tx_data0_HS_OUT[5] mipi_dphy_tx_data0_HS_OUT[4] mipi_dphy_tx_data0_HS_OUT[3] mipi_dphy_tx_data0_HS_OUT[2] mipi_dphy_tx_data0_HS_OUT[1] mipi_dphy_tx_data0_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min -1.385 [get_ports {mipi_dphy_tx_data0_HS_OUT[7] mipi_dphy_tx_data0_HS_OUT[6] mipi_dphy_tx_data0_HS_OUT[5] mipi_dphy_tx_data0_HS_OUT[4] mipi_dphy_tx_data0_HS_OUT[3] mipi_dphy_tx_data0_HS_OUT[2] mipi_dphy_tx_data0_HS_OUT[1] mipi_dphy_tx_data0_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.301 [get_ports {mipi_dphy_tx_data0_HS_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data0_HS_OE}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data0_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data0_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data0_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data0_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data0_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data0_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data0_LP_P_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data0_LP_P_OUT}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max -2.033 [get_ports {mipi_dphy_tx_data1_HS_OUT[7] mipi_dphy_tx_data1_HS_OUT[6] mipi_dphy_tx_data1_HS_OUT[5] mipi_dphy_tx_data1_HS_OUT[4] mipi_dphy_tx_data1_HS_OUT[3] mipi_dphy_tx_data1_HS_OUT[2] mipi_dphy_tx_data1_HS_OUT[1] mipi_dphy_tx_data1_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min -1.385 [get_ports {mipi_dphy_tx_data1_HS_OUT[7] mipi_dphy_tx_data1_HS_OUT[6] mipi_dphy_tx_data1_HS_OUT[5] mipi_dphy_tx_data1_HS_OUT[4] mipi_dphy_tx_data1_HS_OUT[3] mipi_dphy_tx_data1_HS_OUT[2] mipi_dphy_tx_data1_HS_OUT[1] mipi_dphy_tx_data1_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.301 [get_ports {mipi_dphy_tx_data1_HS_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data1_HS_OE}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data1_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data1_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data1_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data1_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data1_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data1_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data1_LP_P_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data1_LP_P_OUT}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max -2.033 [get_ports {mipi_dphy_tx_data2_HS_OUT[7] mipi_dphy_tx_data2_HS_OUT[6] mipi_dphy_tx_data2_HS_OUT[5] mipi_dphy_tx_data2_HS_OUT[4] mipi_dphy_tx_data2_HS_OUT[3] mipi_dphy_tx_data2_HS_OUT[2] mipi_dphy_tx_data2_HS_OUT[1] mipi_dphy_tx_data2_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min -1.385 [get_ports {mipi_dphy_tx_data2_HS_OUT[7] mipi_dphy_tx_data2_HS_OUT[6] mipi_dphy_tx_data2_HS_OUT[5] mipi_dphy_tx_data2_HS_OUT[4] mipi_dphy_tx_data2_HS_OUT[3] mipi_dphy_tx_data2_HS_OUT[2] mipi_dphy_tx_data2_HS_OUT[1] mipi_dphy_tx_data2_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.301 [get_ports {mipi_dphy_tx_data2_HS_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data2_HS_OE}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data2_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data2_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data2_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data2_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data2_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data2_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data2_LP_P_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data2_LP_P_OUT}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max -2.033 [get_ports {mipi_dphy_tx_data3_HS_OUT[7] mipi_dphy_tx_data3_HS_OUT[6] mipi_dphy_tx_data3_HS_OUT[5] mipi_dphy_tx_data3_HS_OUT[4] mipi_dphy_tx_data3_HS_OUT[3] mipi_dphy_tx_data3_HS_OUT[2] mipi_dphy_tx_data3_HS_OUT[1] mipi_dphy_tx_data3_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min -1.385 [get_ports {mipi_dphy_tx_data3_HS_OUT[7] mipi_dphy_tx_data3_HS_OUT[6] mipi_dphy_tx_data3_HS_OUT[5] mipi_dphy_tx_data3_HS_OUT[4] mipi_dphy_tx_data3_HS_OUT[3] mipi_dphy_tx_data3_HS_OUT[2] mipi_dphy_tx_data3_HS_OUT[1] mipi_dphy_tx_data3_HS_OUT[0]}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.301 [get_ports {mipi_dphy_tx_data3_HS_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data3_HS_OE}]

set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data3_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data3_LP_N_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data3_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data3_LP_N_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data3_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data3_LP_P_OE}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -max 3.302 [get_ports {mipi_dphy_tx_data3_LP_P_OUT}]
set_output_delay -clock mipi_dphy_tx_SLOWCLK -min 2.311 [get_ports {mipi_dphy_tx_data3_LP_P_OUT}]

# MIPI RX Constraints
#####################################
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data0_HS_IN[7] mipi_dphy_rx_data0_HS_IN[6] mipi_dphy_rx_data0_HS_IN[5] mipi_dphy_rx_data0_HS_IN[4] mipi_dphy_rx_data0_HS_IN[3] mipi_dphy_rx_data0_HS_IN[2] mipi_dphy_rx_data0_HS_IN[1] mipi_dphy_rx_data0_HS_IN[0]}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data0_HS_IN[7] mipi_dphy_rx_data0_HS_IN[6] mipi_dphy_rx_data0_HS_IN[5] mipi_dphy_rx_data0_HS_IN[4] mipi_dphy_rx_data0_HS_IN[3] mipi_dphy_rx_data0_HS_IN[2] mipi_dphy_rx_data0_HS_IN[1] mipi_dphy_rx_data0_HS_IN[0]}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max -2.033 [get_ports {mipi_dphy_rx_data0_FIFO_EMPTY}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min -1.385 [get_ports {mipi_dphy_rx_data0_FIFO_EMPTY}]

set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data0_FIFO_RD}]
set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data0_FIFO_RD}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data1_HS_IN[7] mipi_dphy_rx_data1_HS_IN[6] mipi_dphy_rx_data1_HS_IN[5] mipi_dphy_rx_data1_HS_IN[4] mipi_dphy_rx_data1_HS_IN[3] mipi_dphy_rx_data1_HS_IN[2] mipi_dphy_rx_data1_HS_IN[1] mipi_dphy_rx_data1_HS_IN[0]}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data1_HS_IN[7] mipi_dphy_rx_data1_HS_IN[6] mipi_dphy_rx_data1_HS_IN[5] mipi_dphy_rx_data1_HS_IN[4] mipi_dphy_rx_data1_HS_IN[3] mipi_dphy_rx_data1_HS_IN[2] mipi_dphy_rx_data1_HS_IN[1] mipi_dphy_rx_data1_HS_IN[0]}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max -2.033 [get_ports {mipi_dphy_rx_data1_FIFO_EMPTY}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min -1.385 [get_ports {mipi_dphy_rx_data1_FIFO_EMPTY}]

set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data1_FIFO_RD}]
set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data1_FIFO_RD}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data2_HS_IN[7] mipi_dphy_rx_data2_HS_IN[6] mipi_dphy_rx_data2_HS_IN[5] mipi_dphy_rx_data2_HS_IN[4] mipi_dphy_rx_data2_HS_IN[3] mipi_dphy_rx_data2_HS_IN[2] mipi_dphy_rx_data2_HS_IN[1] mipi_dphy_rx_data2_HS_IN[0]}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data2_HS_IN[7] mipi_dphy_rx_data2_HS_IN[6] mipi_dphy_rx_data2_HS_IN[5] mipi_dphy_rx_data2_HS_IN[4] mipi_dphy_rx_data2_HS_IN[3] mipi_dphy_rx_data2_HS_IN[2] mipi_dphy_rx_data2_HS_IN[1] mipi_dphy_rx_data2_HS_IN[0]}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max -2.033 [get_ports {mipi_dphy_rx_data2_FIFO_EMPTY}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min -1.385 [get_ports {mipi_dphy_rx_data2_FIFO_EMPTY}]

set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data2_FIFO_RD}]
set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data2_FIFO_RD}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data3_HS_IN[7] mipi_dphy_rx_data3_HS_IN[6] mipi_dphy_rx_data3_HS_IN[5] mipi_dphy_rx_data3_HS_IN[4] mipi_dphy_rx_data3_HS_IN[3] mipi_dphy_rx_data3_HS_IN[2] mipi_dphy_rx_data3_HS_IN[1] mipi_dphy_rx_data3_HS_IN[0]}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data3_HS_IN[7] mipi_dphy_rx_data3_HS_IN[6] mipi_dphy_rx_data3_HS_IN[5] mipi_dphy_rx_data3_HS_IN[4] mipi_dphy_rx_data3_HS_IN[3] mipi_dphy_rx_data3_HS_IN[2] mipi_dphy_rx_data3_HS_IN[1] mipi_dphy_rx_data3_HS_IN[0]}]

set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -max -2.033 [get_ports {mipi_dphy_rx_data3_FIFO_EMPTY}]
set_input_delay -clock mipi_dphy_rx_clk_CLKOUT -min -1.385 [get_ports {mipi_dphy_rx_data3_FIFO_EMPTY}]

set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -max 2.695 [get_ports {mipi_dphy_rx_data3_FIFO_RD}]
set_output_delay -clock mipi_dphy_rx_clk_CLKOUT -min 1.887 [get_ports {mipi_dphy_rx_data3_FIFO_RD}]
