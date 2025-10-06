package ram_agent_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
import ram_sqr_pkg::*;
import ram_driver_pkg::*;
import ram_monitor_pkg::*;
import ram_cfg_obj_pkg::*;
`include "uvm_macros.svh"

class ram_agent extends uvm_agent;
    `uvm_component_utils(ram_agent)
    ram_cfg_obj cfg;
    ram_driver drv;
    ram_sqr sqr;
    ram_monitor mon;
    uvm_analysis_port #(ram_seq_item) agt_ap;

    function new(string name = "agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = ram_cfg_obj::type_id::create("cfg");
        sqr = ram_sqr::type_id::create("sqr", this);
        drv = ram_driver::type_id::create("drv", this);
        mon = ram_monitor::type_id::create("mon", this);
        agt_ap = new("agt_ap", this);

        if(!uvm_config_db #(ram_cfg_obj)::get(this, "", "RAM_CFG", cfg)) begin
            `uvm_fatal("build_phase", "unable to get cfg object")
        end

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.ram_vif = cfg.ram_vif;
        mon.ram_vif = cfg.ram_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_ap.connect(agt_ap);
    endfunction
endclass
endpackage