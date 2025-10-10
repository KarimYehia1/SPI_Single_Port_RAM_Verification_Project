vlib work
vlog *v
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/ss_if/*
run -all