package ram_driver_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_driver extends uvm_driver #(ram_seq_item);
    `uvm_component_utils(ram_driver)
    ram_seq_item item;
    virtual RAM_if ram_vif;

    function new(string name = "drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = ram_seq_item::type_id::create("item");
            seq_item_port.get_next_item(item);
            ram_vif.rst_n = item.rst_n;
            ram_vif.rx_valid = item.rx_valid;
            ram_vif.din = item.din;
            @(negedge ram_vif.clk);
            seq_item_port.item_done();
        end
    endtask
endclass
endpackage