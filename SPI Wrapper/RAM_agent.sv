package ram_agent_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
import ram_sqr_pkg::*;
import ram_driver_pkg::*;
import ram_monitor_pkg::*;
import SPI_config_pkg::*;
`include "uvm_macros.svh"

class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)

    SPI_config cfg;
    ram_driver drv;
    ram_sqr sqr;
    ram_monitor mon;
    uvm_analysis_port #(ram_seq_item) agt_ap;

    function new(string name = "ram_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(SPI_config)::get(this, "", "CONFIG_RAM", cfg))
            `uvm_fatal("build_phase", "unable to get configuration object for RAM agent")

        if (cfg.is_active == UVM_ACTIVE) begin   
        sqr = ram_sqr::type_id::create("sqr", this);
        drv = ram_driver::type_id::create("drv", this);
        end
        mon = ram_monitor::type_id::create("mon", this);
        agt_ap = new("agt_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (cfg.is_active == UVM_ACTIVE) begin
        drv.ram_vif = cfg.RAM_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.ram_vif = cfg.RAM_vif;
        mon.mon_ap.connect(agt_ap);
    endfunction
endclass
endpackage