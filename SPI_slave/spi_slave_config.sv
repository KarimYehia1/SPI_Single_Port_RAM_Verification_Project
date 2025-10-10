package spi_slave_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
class spi_slave_config extends uvm_object;
    `uvm_object_utils(spi_slave_config) // factory store name of class 
   virtual spi_slave_if ss_vif; //  create interface inside configration class 
 function new(string name= "spi_slave_config");
     super.new(name);
 endfunction
endclass
endpackage
