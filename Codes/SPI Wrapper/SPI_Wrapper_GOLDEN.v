module SPI_Wrapper_GOLDEN (input clk,rst_n,SS_n,MOSI, output MISO);
parameter MEM_DEPTH=256, ADDR_SIZE=8;
wire [ADDR_SIZE+1:0] rx_data_din;
wire [ADDR_SIZE-1:0] tx_data_dout;
wire rx_valid,tx_valid;

/*module SPI_SLAVE_GOLDEN (MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);*/

SPI_SLAVE_GOLDEN DUT_SPI_GOLDEN(.clk(clk),.rst_n(rst_n),.SS_n(SS_n),.MOSI(MOSI),.tx_valid(tx_valid),.tx_data(tx_data_dout),.MISO(MISO),.rx_valid(rx_valid),.rx_data(rx_data_din));

/*module RAM_GOLDEN (clk, rst_n, din, rx_valid, dout, tx_valid);*/

RAM_GOLDEN #(.MEM_DEPTH(MEM_DEPTH),.ADDR_SIZE(ADDR_SIZE)) DUT_RAM_GOLDEN(.din(rx_data_din),.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid), .dout(tx_data_dout),.tx_valid(tx_valid));

endmodule