package SPI_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_agent_pkg::*;
  import spi_slave_agent_pkg::*;
  import ram_agent_pkg::*;
  import SPI_scoreboard_pkg::*;
  import SPI_coverage_pkg::*;

  class SPI_env extends uvm_env;
    `uvm_component_utils(SPI_env)

    SPI_agent agt;
    spi_slave_agent SPI_SLAVE_agt;
    ram_agent RAM_agt;
    SPI_scoreboard sb;
    SPI_coverage cov;

    function new(string name = "SPI_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = SPI_agent::type_id::create("agt", this);
      SPI_SLAVE_agt = spi_slave_agent::type_id::create("SPI_SLAVE_agt", this);
      RAM_agt = ram_agent::type_id::create("RAM_agt", this);
      sb = SPI_scoreboard::type_id::create("sb", this);
      cov = SPI_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agt.agt_ap.connect(sb.sb_export_SPI);
      agt.agt_ap.connect(cov.cov_export_SPI);
      SPI_SLAVE_agt.agt_ap.connect(sb.sb_export_SPI_SLAVE);
      SPI_SLAVE_agt.agt_ap.connect(cov.cov_export_SPI_SLAVE);
      RAM_agt.agt_ap.connect(sb.sb_export_RAM);
      RAM_agt.agt_ap.connect(cov.cov_export_RAM);
    endfunction  

  endclass

endpackage