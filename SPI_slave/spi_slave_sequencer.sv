package spi_slave_sequencer_package ;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_package::*;
class spi_slave_sequencer extends uvm_sequencer #(spi_slave_seq_item);
  `uvm_component_utils(spi_slave_sequencer)
  function new(string name= "spi_slave_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction
endclass
endpackage