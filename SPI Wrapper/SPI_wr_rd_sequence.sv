package SPI_wr_rd_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import SPI_pkg::*;

    class SPI_wr_rd_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(SPI_wr_rd_sequence)

        SPI_seq_item seq_item;

        function new(string name = "SPI_wr_rd_sequence");
            super.new(name);
        endfunction

    task body();
        seq_item = SPI_seq_item::type_id::create("seq_item");
        repeat(10000) begin
            start_item(seq_item);
            seq_item.serial_comm_all_cases.constraint_mode(0);
            seq_item.serial_comm_read_data.constraint_mode(0);
            seq_item.mosi_in.constraint_mode(0);
            seq_item.wr_only_constraint.constraint_mode(0);
            seq_item.rd_only_constraint.constraint_mode(0);
            seq_item.rd_wr_constraint.constraint_mode(1);
            assert(seq_item.randomize());
            finish_item(seq_item);
        end
    endtask

endclass
endpackage