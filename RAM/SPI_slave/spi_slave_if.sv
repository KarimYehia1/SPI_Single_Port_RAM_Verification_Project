
interface spi_slave_if (clk);
  input  bit clk;
 logic           MOSI, rst_n, SS_n, tx_valid;
 logic      [7:0] tx_data;
logic [9:0] rx_data,rx_data_ref;
logic       rx_valid, MISO,MISO_ref , rx_valid_ref;
endinterface : spi_slave_if