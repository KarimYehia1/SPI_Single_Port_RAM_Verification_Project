package SPI_driver_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;

    class SPI_driver extends uvm_driver #(SPI_seq_item);
        `uvm_component_utils(SPI_driver)

        virtual SPI_if SPI_vif;
        SPI_seq_item seq_item; 

        function new(string name = "SPI_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = SPI_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);
                //input rst_n, SS_n, MOSI, output MISO
                SPI_vif.rst_n = seq_item.rst_n;
                SPI_vif.SS_n  = seq_item.SS_n;
                SPI_vif.MOSI  = seq_item.MOSI;
                @(negedge SPI_vif.clk);
                seq_item_port.item_done();
            end
        endtask
    endclass 
endpackage