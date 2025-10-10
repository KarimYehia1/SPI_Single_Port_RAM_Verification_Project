package spi_slave_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import  spi_slave_seq_item_package::*;
  import spi_slave_config_pkg::*;
  import  spi_slave_driver_pkg::*;
  import spi_slave_monitor_pkg::*;
  import spi_slave_sequencer_package::*;

  class spi_slave_agent extends uvm_agent;
    `uvm_component_utils(spi_slave_agent)
      
    spi_slave_seq_item seq_item;
    spi_slave_config           s_cfg;
    spi_slave_driver       drv;
   spi_slave_sequencer sqr;
   spi_slave_monitor       mon;
    uvm_analysis_port #(spi_slave_seq_item) agt_ap;

    function new(string name = "spi_slave_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(spi_slave_config)::get(this, "", "CFG", s_cfg)) begin
        `uvm_fatal("build_phase", "unable to get configuration object")
      end
      sqr = spi_slave_sequencer::type_id::create("sqr", this);
      drv = spi_slave_driver::type_id::create("drv", this);
      mon = spi_slave_monitor::type_id::create("mon", this);
      agt_ap = new("agt_tb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.ss_vif = s_cfg.ss_vif;
      mon.ss_vif = s_cfg.ss_vif;
      drv.seq_item_port.connect(sqr.seq_item_export);
     mon.mon_ap.connect(agt_ap);
    endfunction
  endclass
endpackage
