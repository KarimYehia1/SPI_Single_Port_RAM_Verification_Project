package ram_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import RAM_shared_pkg::*;

    class ram_seq_item extends uvm_sequence_item;
        `uvm_object_utils(ram_seq_item)
        //Inputs
        logic rst_n, rx_valid;
        logic [9:0] din;
        //Outputs
        logic tx_valid, tx_valid_ref;
        logic [7:0] dout, dout_ref;

        function new(string name = "ram_seq_item");
            super.new(name);
        endfunction
endclass
endpackage