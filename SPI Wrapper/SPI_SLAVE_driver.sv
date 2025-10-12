 
 package spi_slave_driver_pkg;
 import uvm_pkg::*;
    `include "uvm_macros.svh"
    import spi_slave_seq_item_package::*;
    import SPI_SLAVE_shared_pkg ::*;
class spi_slave_driver extends uvm_driver #(spi_slave_seq_item);
 `uvm_component_utils(spi_slave_driver);
 virtual SPI_SLAVE_if ss_vif;
 spi_slave_seq_item seq_item;
 function new(string name ="spi_slave_driver",uvm_component parent =null);
    super.new(name,parent);
    endfunction
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin 
      seq_item =  spi_slave_seq_item :: type_id :: create ( "seq_item");
      seq_item_port.get_next_item(seq_item);
      ss_vif.rst_n=seq_item.rst_n;
      ss_vif.SS_n=seq_item.SS_n;
      ss_vif.MOSI=seq_item.MOSI;
      ss_vif.tx_valid=seq_item.tx_valid;
      ss_vif.tx_data=seq_item.tx_data;
      @(negedge ss_vif.clk);
      seq_item_port.item_done();
    end
    endtask
endclass
 endpackage