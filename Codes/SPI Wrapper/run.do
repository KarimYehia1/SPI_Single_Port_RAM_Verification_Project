vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave /top/inter/*
coverage save SPI.ucdb -onexit
run -all




#vcover report SPI.ucdb -details -annotate -all -output coverage_SPI.txt