package SPI_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_driver_pkg::*;
  import SPI_monitor_pkg::*;
  import SPI_sequencer_pkg::*;
  import SPI_config_pkg::*;
  import SPI_seq_item_pkg::*;

  class SPI_agent extends uvm_agent;
    `uvm_component_utils(SPI_agent)

    SPI_sequencer sqr;
    SPI_driver drv;
    SPI_monitor mon;
    SPI_config SPI_cfg;
    uvm_analysis_port #(SPI_seq_item) agt_ap;

    function new(string name = "SPI_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db #(SPI_config)::get(this, "" , "CONFIG", SPI_cfg))
        `uvm_fatal("Build_Phase", "Error in Wrapper Interface in Agent");

      if (SPI_cfg.is_active == UVM_ACTIVE) begin
        sqr = SPI_sequencer::type_id::create("sqr", this);
        drv = SPI_driver::type_id::create("drv", this);
      end
      mon = SPI_monitor::type_id::create("mon", this);
      agt_ap = new("agt_ap", this);

    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (SPI_cfg.is_active == UVM_ACTIVE) begin
        drv.SPI_vif = SPI_cfg.SPI_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
      end
      mon.SPI_vif = SPI_cfg.SPI_vif;
      mon.mon_ap.connect(agt_ap);
    endfunction    

  endclass

endpackage