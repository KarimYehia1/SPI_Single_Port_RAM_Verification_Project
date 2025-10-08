vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.ram_top -classdebug -uvmcontrol=all -cover
run 0
add wave /ram_top/RAM_IF/*
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/correct_count \
sim:/uvm_root/uvm_test_top/env/sb/error_count
add wave /ram_top/DUT/sva_inst/rst_n_assertion
run -all