package ram_reset_seq_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_reset_seq extends uvm_sequence #(ram_seq_item);
    `uvm_object_utils(ram_reset_seq)
    ram_seq_item item;

    function new(string name = "item");
        super.new(name);
    endfunction

    task body();
        // Assert reset
        item = ram_seq_item::type_id::create("item");
        start_item(item);
        item.rst_n = 0;
        item.rx_valid = 0;
        item.tx_valid = 0;
        item.din = 0;
        finish_item(item);
        
        // Hold reset for 5 cycles
        repeat(5) begin
            start_item(item);
            item.rst_n = 0;
            item.rx_valid = 0;
            item.tx_valid = 0;
            item.din = 0;
            finish_item(item);
        end
        
        // Deassert reset
        start_item(item);
        item.rst_n = 1;
        item.rx_valid = 0;
        item.tx_valid = 0;
        item.din = 0;
        finish_item(item);
    endtask

endclass
endpackage