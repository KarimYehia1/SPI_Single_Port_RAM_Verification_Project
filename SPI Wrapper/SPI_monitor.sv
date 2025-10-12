package SPI_monitor_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import SPI_pkg::*;

    class SPI_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_monitor)

        virtual SPI_if SPI_vif;
        SPI_seq_item seq_item;
        uvm_analysis_port #(SPI_seq_item) mon_ap;

        function new(string name = "SPI_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = SPI_seq_item::type_id::create("seq_item");
                //input rst_n, SS_n, MOSI, output MISO
                @(negedge SPI_vif.clk);
                seq_item.rst_n       = SPI_vif.rst_n;
                seq_item.SS_n        = SPI_vif.SS_n;
                seq_item.MOSI        = SPI_vif.MOSI;
                seq_item.MISO        = SPI_vif.MISO;
                seq_item.MISO_GOLDEN = SPI_vif.MISO_GOLDEN;
                mon_ap.write(seq_item);
            end
        endtask

    endclass 
    
endpackage