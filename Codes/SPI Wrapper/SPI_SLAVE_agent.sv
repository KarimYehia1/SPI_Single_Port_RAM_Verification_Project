package spi_slave_agent_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import spi_slave_seq_item_package::*;
  import SPI_config_pkg::*;
  import spi_slave_driver_pkg::*;
  import spi_slave_monitor_pkg::*;
  import spi_slave_sequencer_package::*;

  class spi_slave_agent extends uvm_agent;
    `uvm_component_utils(spi_slave_agent)
      
    spi_slave_seq_item seq_item;
    SPI_config          s_cfg;
    spi_slave_driver       drv;
    spi_slave_sequencer sqr;
    spi_slave_monitor       mon;
    uvm_analysis_port #(spi_slave_seq_item) agt_ap;

    function new(string name = "spi_slave_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(SPI_config)::get(this, "", "CONFIG_SPI_SLAVE", s_cfg))
        `uvm_fatal("build_phase", "unable to get configuration object for SPI_SLAVE agent")

      if (s_cfg.is_active == UVM_ACTIVE) begin
        sqr = spi_slave_sequencer::type_id::create("sqr", this);
        drv = spi_slave_driver::type_id::create("drv", this);
      end
      mon = spi_slave_monitor::type_id::create("mon", this);
      agt_ap = new("agt_tb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (s_cfg.is_active == UVM_ACTIVE) begin
      drv.ss_vif = s_cfg.SPI_SLAVE_vif;
      drv.seq_item_port.connect(sqr.seq_item_export);
      end
      mon.ss_vif = s_cfg.SPI_SLAVE_vif;
      mon.mon_ap.connect(agt_ap);
    endfunction
  endclass
endpackage
