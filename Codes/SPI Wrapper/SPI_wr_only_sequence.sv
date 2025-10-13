package SPI_wr_only_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import SPI_pkg::*;

    class SPI_wr_only_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(SPI_wr_only_sequence)

        SPI_seq_item seq_item;

        function new(string name = "SPI_wr_only_sequence");
            super.new(name);
        endfunction

    task body();
        seq_item = SPI_seq_item::type_id::create("seq_item");
        //Write only
        repeat(5000) begin
            start_item(seq_item);
            //At the beginning of the operation, enable the write sequence and randomization
            if(counter_allcases == 0) begin
                seq_item.array_rand.rand_mode(1);
                seq_item.wr_only_constraint.constraint_mode(1);
                seq_item.rd_only_constraint.constraint_mode(0);
                seq_item.rd_wr_constraint.constraint_mode(0);
            end
            else begin
                //Disable all constraints and randomization because we are already in an operation
                seq_item.wr_only_constraint.constraint_mode(0);
                seq_item.rd_only_constraint.constraint_mode(0);
                seq_item.rd_wr_constraint.constraint_mode(0);
                seq_item.array_rand.rand_mode(0);
            end
            assert (seq_item.randomize());
            finish_item(seq_item);
        end

    endtask

endclass
endpackage