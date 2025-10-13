package spi_slave_main_sequence_package;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_seq_item_package::*;
import shared_pkg::*;
class spi_slave_main_sequence extends  uvm_sequence #(spi_slave_seq_item);
 `uvm_object_utils(spi_slave_main_sequence);
 spi_slave_seq_item seq_item_main;
 function new(string name= "spi_slave_main_sequence");
     super.new(name);
 endfunction
 task body ;
 seq_item_main= spi_slave_seq_item :: type_id :: create("seq_item_main");
 repeat(1000) begin
 start_item(seq_item_main);
 seq_item_main.reset.constraint_mode(1);
 seq_item_main.serial_comm_all_cases.constraint_mode(1);
 seq_item_main.mosi_in.constraint_mode(1);
 seq_item_main.serial_comm_read_data.constraint_mode(0);
 seq_item_main.trans_ram.constraint_mode(0);
 if(counter_allcases==0) begin
  seq_item_main.array_rand.rand_mode(1);
    $display("array_rand=%b , time =%t ,conter=%d",seq_item_main.array_rand,$time,counter_allcases);
 end
 else begin 
  seq_item_main.array_rand.rand_mode(0);
 end
 assert (seq_item_main.randomize() with {seq_item_main.array_rand[0:2] inside {3'b000,3'b001,3'b110};} );
 seq_item_main.update_counter_allcases;
 finish_item(seq_item_main);
 end

 repeat(1000) begin
 start_item(seq_item_main);
 seq_item_main.reset.constraint_mode(1);
 seq_item_main.serial_comm_all_cases.constraint_mode(0);
 seq_item_main.mosi_in.constraint_mode(0);
 seq_item_main.serial_comm_read_data.constraint_mode(1);
 seq_item_main.trans_ram.constraint_mode(1);
 if(counter_read==0) begin
  seq_item_main.array_rand.rand_mode(1);
    $display("array_rand=%b , time =%t ,conter=%d",seq_item_main.array_rand,$time,counter_read);
 end
 else begin 
  seq_item_main.array_rand.rand_mode(0);
 end
 assert (seq_item_main.randomize() with {seq_item_main.array_rand[0:2] inside {3'b111};} );
 seq_item_main.update_counter_read;
 finish_item(seq_item_main);

 end 
 endtask

 endclass
endpackage
