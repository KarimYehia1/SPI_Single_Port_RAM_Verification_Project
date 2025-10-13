package spi_slave_reset_sequence_package;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_package::*;
class spi_slave_reset_sequence extends  uvm_sequence #(spi_slave_seq_item);
 `uvm_object_utils(spi_slave_reset_sequence);
 spi_slave_seq_item seq_item;
 function new(string name= "spi_slave_reset_sequence");
     super.new(name);
 endfunction
 task body ;
 seq_item= spi_slave_seq_item :: type_id :: create("seq_item");
 start_item(seq_item);
        seq_item.rst_n=1;
        seq_item.rx_valid=0;
        seq_item.tx_valid=0;
        seq_item.SS_n=1;
 finish_item(seq_item);
 endtask
endclass
endpackage
