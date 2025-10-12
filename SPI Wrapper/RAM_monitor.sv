package ram_monitor_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_monitor extends uvm_monitor;
    `uvm_component_utils(ram_monitor)

    ram_seq_item item;
    virtual RAM_if ram_vif;
    uvm_analysis_port #(ram_seq_item) mon_ap;

    function new(string name = "ram_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = ram_seq_item::type_id::create("item");
            @(negedge ram_vif.clk);
            //input rst_n, rx_valid, din, output tx_valid, tx_valid_ref, dout, dout_ref
            item.rst_n        = ram_vif.rst_n;
            item.rx_valid     = ram_vif.rx_valid;
            item.din          = ram_vif.din;
            item.tx_valid     = ram_vif.tx_valid;
            item.tx_valid_ref = ram_vif.tx_valid_ref;
            item.dout         = ram_vif.dout;
            item.dout_ref     = ram_vif.dout_ref;

            mon_ap.write(item);
        end
    endtask
endclass
endpackage