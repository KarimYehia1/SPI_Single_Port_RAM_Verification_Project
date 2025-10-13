import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;

module top();
  logic clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //Interface
  SPI_if inter(clk);
  SPI_SLAVE_if inter_slave(clk);
  RAM_if inter_ram(clk);
  
  /*SPI Wrapper*/

  //DUT
  //module SPI_Wrapper (input clk,rst_n,SS_n,MOSI, output MISO);
  SPI_Wrapper #(inter.MEM_DEPTH, inter.ADDR_SIZE) DUT(inter.clk, inter.rst_n, inter.SS_n, inter.MOSI, inter.MISO);

  //GOLDEN
  //module SPI_Wrapper_GOLDEN (input clk,rst_n,SS_n,MOSI, output MISO);
  SPI_Wrapper_GOLDEN #(inter.MEM_DEPTH, inter.ADDR_SIZE) DUT_GOLDEN(inter.clk, inter.rst_n, inter.SS_n, inter.MOSI, inter.MISO_GOLDEN);


  /*SPI SLAVE*/

  //DUT
  //module SPI_SLAVE (MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);
  SPI_SLAVE DUT_SPI_SLAVE(inter_slave.MOSI, inter_slave.SS_n, inter_slave.clk, inter_slave.rst_n, inter_slave.rx_data,
                          inter_slave.tx_valid, inter_slave.tx_data, inter_slave.MISO, inter_slave.rx_valid);

  //GOLDEN
  //module SPI_SLAVE_GOLDEN (MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);
  SPI_SLAVE_GOLDEN DUT_SPI_SLAVE_GOLDEN(inter_slave.MOSI, inter_slave.SS_n, inter_slave.clk, inter_slave.rst_n, inter_slave.rx_data_ref,
                                        inter_slave.tx_valid, inter_slave.tx_data, inter_slave.MISO_ref, inter_slave.rx_valid_ref);
  assign inter_slave.rst_n    = DUT.rst_n;
  assign inter_slave.MOSI     = DUT.MOSI;
  assign inter_slave.SS_n     = DUT.SS_n;
  assign inter_slave.tx_valid = DUT.tx_valid;
  assign inter_slave.tx_data  = DUT.tx_data_dout;


  /*RAM*/

  //DUT
  //module RAM (din,clk,rst_n,rx_valid,dout,tx_valid);
  RAM DUT_RAM(inter_ram.din, inter_ram.clk, inter_ram.rst_n, inter_ram.rx_valid, inter_ram.dout, inter_ram.tx_valid);

  //GOLDEN
  //module RAM_GOLDEN (clk, rst_n, din, rx_valid, dout, tx_valid);
  RAM_GOLDEN #(inter_ram.MEM_DEPTH, inter_ram.ADDR_SIZE) DUT_RAM_GOLDEN(inter_ram.clk, inter_ram.rst_n, inter_ram.din,
               inter_ram.rx_valid, inter_ram.dout_ref, inter_ram.tx_valid_ref);
  assign inter_ram.rst_n     = DUT.rst_n;
  assign inter_ram.din       = DUT.rx_data_din;
  assign inter_ram.rx_valid  = DUT.rx_valid;

  
  //sva
  bind SPI_Wrapper SPI_sva Wrapper_BINDING(inter.clk, inter.rst_n, inter.SS_n, inter.MOSI, inter.MISO);
  bind RAM RAM_sva RAM_BINDING(inter_ram.din, inter_ram.clk, inter_ram.rst_n, inter_ram.rx_valid, inter_ram.dout, inter_ram.tx_valid);
  
  initial begin
    uvm_config_db #(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF", inter);
    uvm_config_db #(virtual SPI_SLAVE_if)::set(null, "uvm_test_top", "SPI_SLAVE_IF", inter_slave);
    uvm_config_db #(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", inter_ram);
    run_test("SPI_test");
  end
endmodule