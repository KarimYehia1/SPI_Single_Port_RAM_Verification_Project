interface SPI_SLAVE_if (clk);
  //Inputs
  input bit clk;
  logic MOSI, rst_n, SS_n, tx_valid;
  logic [7:0] tx_data;
  //Outputs
  logic [9:0] rx_data,rx_data_ref;
  logic       rx_valid, MISO, MISO_ref, rx_valid_ref;

  modport DUT(input clk,MOSI,rst_n,SS_n,tx_data,tx_valid, output MISO,rx_data,rx_valid);
  
endinterface : SPI_SLAVE_if