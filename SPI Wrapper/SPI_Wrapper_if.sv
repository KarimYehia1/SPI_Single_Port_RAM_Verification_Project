interface SPI_if (clk);
  //Parameters
  parameter MEM_DEPTH=256;
  parameter ADDR_SIZE=8;
  //Inputs
  input clk;
  logic rst_n, SS_n, MOSI;
  //Outputs
  logic MISO;
  //Outputs Golden
  logic MISO_GOLDEN;
endinterface : SPI_if