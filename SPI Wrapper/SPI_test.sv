package SPI_test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_config_pkg::*;
  import SPI_env_pkg::*;
  import SPI_sequencer_pkg::*;
  import SPI_reset_sequence_pkg::*;
  import SPI_wr_only_sequence_pkg::*;
  import SPI_rd_only_sequence_pkg::*;
  import SPI_wr_rd_sequence_pkg::*;

  class SPI_test extends uvm_test;
    `uvm_component_utils(SPI_test)

    SPI_config SPI_cfg, SPI_SLAVE_cfg, RAM_cfg;
    SPI_env env;
    SPI_reset_sequence rst_seq;
    SPI_wr_only_sequence wr_only_seq;
    SPI_rd_only_sequence rd_only_seq;
    SPI_wr_rd_sequence wr_rd_seq; 

    function new(string name = "SPI_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = SPI_env::type_id::create("env",this);
      SPI_cfg = SPI_config::type_id::create("SPI_cfg");
      SPI_SLAVE_cfg = SPI_config::type_id::create("SPI_SLAVE_cfg");
      RAM_cfg = SPI_config::type_id::create("RAM_cfg");
      rst_seq = SPI_reset_sequence::type_id::create("rst_seq");
      wr_only_seq = SPI_wr_only_sequence::type_id::create("wr_only_seq");
      rd_only_seq = SPI_rd_only_sequence::type_id::create("rd_only_seq");
      wr_rd_seq = SPI_wr_rd_sequence::type_id::create("wr_rd_seq");
      
      if (!uvm_config_db #(virtual SPI_if)::get(this, "" , "SPI_IF", SPI_cfg.SPI_vif))
        `uvm_fatal("Build_Phase", "Error in Wrapper Interface in test");

      if (!uvm_config_db #(virtual SPI_SLAVE_if)::get(this, "" , "SPI_SLAVE_IF", SPI_SLAVE_cfg.SPI_SLAVE_vif))
        `uvm_fatal("Build_Phase", "Error in SPI_SLAVE Interface in test");
        
      if (!uvm_config_db #(virtual RAM_if)::get(this, "" , "RAM_IF", RAM_cfg.RAM_vif))
        `uvm_fatal("Build_Phase", "Error in RAM Interface in test");

      SPI_cfg.is_active = UVM_ACTIVE;
      SPI_SLAVE_cfg.is_active = UVM_PASSIVE;
      RAM_cfg.is_active = UVM_PASSIVE;  

      uvm_config_db #(SPI_config)::set(this, "*", "CONFIG", SPI_cfg);
      uvm_config_db #(SPI_config)::set(this, "*", "CONFIG_SPI_SLAVE", SPI_SLAVE_cfg);
      uvm_config_db #(SPI_config)::set(this, "*", "CONFIG_RAM", RAM_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      //reset sequence
      `uvm_info("Run_Phase", "Reset Sequence Start.", UVM_MEDIUM)
      rst_seq.start(env.agt.sqr);
      `uvm_info("Run_Phase", "Reset Sequence End.", UVM_MEDIUM)
      
      //Write only sequence
      `uvm_info("Run_Phase", "Write Only Sequence Start.", UVM_MEDIUM)
      wr_only_seq.start(env.agt.sqr);
      `uvm_info("Run_Phase", "Write Only Sequence End.", UVM_MEDIUM)

      //Read only sequence
      `uvm_info("Run_Phase", "Read Only Sequence Start.", UVM_MEDIUM)
      rd_only_seq.start(env.agt.sqr);
      `uvm_info("Run_Phase", "Read Only Sequence End.", UVM_MEDIUM)

      //Write and Read sequence
      `uvm_info("Run_Phase", "Write and Read Sequence Start.", UVM_MEDIUM)
      wr_rd_seq.start(env.agt.sqr);
      `uvm_info("Run_Phase", "Write and Read Sequence End.", UVM_MEDIUM)

      phase.drop_objection(this);
    endtask

  endclass: SPI_test

endpackage