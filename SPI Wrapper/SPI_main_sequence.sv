package SPI_main_sequence_package;
  import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import SPI_pkg::*;

    class SPI_main_sequence extends uvm_sequence #(SPI_seq_item);
        `uvm_object_utils(SPI_main_sequence)

        SPI_seq_item seq_item_main;

        function new(string name = "SPI_main_sequence");
            super.new(name);
        endfunction

    task body();
      seq_item_main =SPI_seq_item::type_id::create("seq_item_main");
      repeat(10000) begin
        start_item(seq_item_main);
        seq_item_main.SS_n_0.constraint_mode(0);
        seq_item_main.wr_only_constraint.constraint_mode(0);
        seq_item_main.rd_only_constraint.constraint_mode(0);
        seq_item_main.rd_wr_constraint.constraint_mode(0);
        seq_item_main.serial_comm_all_cases.constraint_mode(1);
        seq_item_main.mosi_in.constraint_mode(1);
        seq_item_main.serial_comm_read_data.constraint_mode(0);
        if(counter_allcases == 0) begin
          seq_item_main.array_rand.rand_mode(1);
          //$display("array_rand=%b , time =%t ,counter=%d",seq_item_main.array_rand, $time, counter_allcases);
        end
        else seq_item_main.array_rand.rand_mode(0);
        assert (seq_item_main.randomize() with {seq_item_main.array_rand[0:2] inside {WR_ADDR,WR_DATA,RD_ADDR};} );
        seq_item_main.update_counter_allcases;
        finish_item(seq_item_main);
      end

      repeat(10000) begin
        start_item(seq_item_main);
        seq_item_main.SS_n_0.constraint_mode(0);
        seq_item_main.wr_only_constraint.constraint_mode(0);
        seq_item_main.rd_only_constraint.constraint_mode(0);
        seq_item_main.rd_wr_constraint.constraint_mode(0);
        seq_item_main.serial_comm_all_cases.constraint_mode(0);
        seq_item_main.mosi_in.constraint_mode(0);
        seq_item_main.serial_comm_read_data.constraint_mode(1);
        if(counter_read == 0) begin
          seq_item_main.array_rand.rand_mode(1);
          //$display("array_rand=%b , time =%t ,conter=%d",seq_item_main.array_rand,$time,counter_read);
        end
        else seq_item_main.array_rand.rand_mode(0);
        assert (seq_item_main.randomize() with {seq_item_main.array_rand[0:2] inside {RD_DATA};} );
        seq_item_main.update_counter_read;
        finish_item(seq_item_main);
      end 
    endtask

 endclass
endpackage