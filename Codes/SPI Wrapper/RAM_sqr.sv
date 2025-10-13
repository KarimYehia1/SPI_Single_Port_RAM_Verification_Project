package ram_sqr_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_sqr extends uvm_sequencer #(ram_seq_item);
    `uvm_component_utils(ram_sqr)

    function new(string name = "sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
endpackage