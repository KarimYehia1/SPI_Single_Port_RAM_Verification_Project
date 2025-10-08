package ram_test_pkg;
import uvm_pkg::*;
import ram_env_pkg::*;
import ram_cfg_obj_pkg::*;
import ram_seq_item_pkg::*;
import ram_reset_seq_pkg::*;
import ram_wr_only_seq_pkg::*;
import ram_rd_only_seq_pkg::*;
import ram_wr_rd_seq_pkg::*;
`include "uvm_macros.svh"

class ram_test extends uvm_test;
    `uvm_component_utils(ram_test)
    ram_cfg_obj ram_cfg;
    virtual ram_if ram_vif;
    ram_env env;
    ram_reset_seq rst_seq;
    ram_wr_only_seq wr_only_seq;
    ram_rd_only_seq rd_only_seq;
    ram_wr_rd_seq wr_rd_seq;


    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ram_cfg = ram_cfg_obj::type_id::create("cfg_object");
        env = ram_env::type_id::create("env", this);
        rst_seq = ram_reset_seq::type_id::create("rst_seq");
        wr_only_seq = ram_wr_only_seq::type_id::create("wr_only_seq");
        rd_only_seq = ram_rd_only_seq::type_id::create("rd_only_seq");
        wr_rd_seq = ram_wr_rd_seq::type_id::create("wr_rd_seq");

        if(!uvm_config_db #(virtual ram_if)::get(this, "", "RAM_IF", ram_cfg.ram_vif)) begin
            `uvm_fatal("build_phase", "unable to get virtual interface of ram")
        end

        uvm_config_db #(ram_cfg_obj)::set(this, "*", "RAM_CFG", ram_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase", "rst signal asserted", UVM_LOW)
        rst_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "rst signal deasserted", UVM_LOW)
        phase.drop_objection(this);

        phase.raise_objection(this);
        `uvm_info("run_phase", "write only sequence started", UVM_LOW)
        wr_only_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "write only sequence ended", UVM_LOW)
        phase.drop_objection(this);

        phase.raise_objection(this);
        `uvm_info("run_phase", "read only sequence started", UVM_LOW)
        rd_only_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "read only sequence ended", UVM_LOW)
        phase.drop_objection(this);

        phase.raise_objection(this);
        `uvm_info("run_phase", "write & read sequence started", UVM_LOW)
        wr_rd_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "write & read sequence ended", UVM_LOW)
        phase.drop_objection(this);
        
    endtask
endclass
endpackage