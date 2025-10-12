package SPI_reset_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import SPI_pkg::*;

    class SPI_reset_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(SPI_reset_sequence)

        SPI_seq_item seq_item;

        function new(string name = "SPI_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = SPI_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.SS_n=0;
            seq_item.MOSI=0;
            finish_item(seq_item);            
        endtask

    endclass

endpackage