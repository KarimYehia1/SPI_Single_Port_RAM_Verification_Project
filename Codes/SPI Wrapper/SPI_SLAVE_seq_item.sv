package spi_slave_seq_item_package;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_SLAVE_shared_pkg::*;

  class spi_slave_seq_item extends uvm_sequence_item;
    `uvm_object_utils(spi_slave_seq_item)
  
    //Inputs
    logic [7:0] tx_data;
    logic  MOSI, SS_n, rst_n, tx_valid;
    //Outputs
    logic [9:0] rx_data, rx_data_ref;
    logic MISO, MISO_ref, rx_valid, rx_valid_ref;

    function new(string name= "spi_slave_seq_item");
      super.new(name);
    endfunction

endclass
endpackage