
package spi_slave_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_env_pkg::*;
 import spi_slave_reset_sequence_package::*;
 import spi_slave_main_sequence_package::*;
import spi_slave_config_pkg ::*;
class spi_slave_test extends uvm_test;
    `uvm_component_utils(spi_slave_test);
   spi_slave_env  env;
   spi_slave_config   s_cfg;
    spi_slave_reset_sequence rst_seq;
   spi_slave_main_sequence main_seq;
    function new(string name ="spi_slave_test",uvm_component parent =null);
    super.new(name,parent);
    endfunction
    function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env =spi_slave_env :: type_id :: create("env",this);
    s_cfg = spi_slave_config   :: type_id :: create ("s_cfg");
    rst_seq= spi_slave_reset_sequence :: type_id :: create ("rst_seq");
    main_seq=spi_slave_main_sequence :: type_id :: create("main_seq");

    if(!uvm_config_db #(virtual spi_slave_if) :: get(this,"","SPI_IF",s_cfg.ss_vif))
    `uvm_fatal("build_phase","Test - unable to get the virtual interface");
    uvm_config_db #(spi_slave_config) :: set(this,"*","CFG",s_cfg);
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
     `uvm_info("run_phase","reset_asserted",UVM_LOW)
     rst_seq.start(env.agt.sqr);
     `uvm_info("run_phase","reset_deasserted",UVM_LOW)
    
     `uvm_info ("run_phase","stimulus generation begin",UVM_LOW)
      main_seq.start(env.agt.sqr);
       `uvm_info ("run_phase","stimulus generation done",UVM_LOW)
    phase.drop_objection(this);
    endtask
endclass: spi_slave_test
endpackage