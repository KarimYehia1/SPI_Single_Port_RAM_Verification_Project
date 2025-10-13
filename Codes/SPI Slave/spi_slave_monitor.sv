package spi_slave_monitor_pkg;
 import uvm_pkg::*;
    `include "uvm_macros.svh"
    import  spi_slave_seq_item_package::*;
    import shared_pkg ::*;
class spi_slave_monitor extends uvm_monitor;
 `uvm_component_utils(spi_slave_monitor);
 virtual spi_slave_if ss_vif;
spi_slave_seq_item seq_item;
 uvm_analysis_port #(spi_slave_seq_item) mon_ap;
  function new(string name ="spi_slave_monitor",uvm_component parent =null);
    super.new(name,parent);
    endfunction
            function void build_phase( uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction
        
    task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        seq_item=spi_slave_seq_item::type_id::create("seq_item");
        @(negedge ss_vif.clk);
        seq_item.rst_n=ss_vif.rst_n;
        seq_item.MOSI=ss_vif.MOSI;
        seq_item.SS_n=ss_vif.SS_n;
        seq_item.MISO=ss_vif.MISO;
        seq_item.MISO_ref=ss_vif.MISO_ref;
        seq_item.tx_valid=ss_vif.tx_valid;
        seq_item.tx_data=ss_vif.tx_data;
        seq_item.rx_valid=ss_vif.rx_valid;
        seq_item.rx_data=ss_vif.rx_data;
        seq_item.rx_valid_ref=ss_vif.rx_valid_ref;
         seq_item.rx_data_ref=ss_vif.rx_data_ref;

        mon_ap.write(seq_item);
        `uvm_info ("run_phase",seq_item.convert2string_stimulus(),UVM_HIGH)
    end
    endtask
endclass
endpackage