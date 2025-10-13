vlib work
vlog -f src_files.list +define+SIM +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave -r /top/ss_if/*
run -all
coverage save spi.ucdb -onexit
