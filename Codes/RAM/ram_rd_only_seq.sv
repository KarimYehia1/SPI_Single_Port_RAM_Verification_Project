package ram_rd_only_seq_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_rd_only_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_rd_only_seq)
    ram_seq_item item;

    function new(string name = "item");
        super.new(name);
    endfunction

    task body();
        item = ram_seq_item::type_id::create("item");
        repeat(1000) begin
        start_item(item);
        item.wr_only_constraint.constraint_mode(0);
        item.rd_only_constraint.constraint_mode(1);
        item.rd_wr_constraint.constraint_mode(0);
        assert(item.randomize());
        finish_item(item);
        end
    endtask

endclass
endpackage