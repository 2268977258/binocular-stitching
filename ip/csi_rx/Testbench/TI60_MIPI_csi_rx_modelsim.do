onerror {quit -f}
vlib work
vlog -sv TI60_MIPI_csi_tb.sv
vlog reset.v
vlog -sv ./modelsim/csi_rx.sv
vlog -sv top.sv -f rx_filelist.f

vsim -t ps work.TI60_MIPI_csi_tb
run -all
