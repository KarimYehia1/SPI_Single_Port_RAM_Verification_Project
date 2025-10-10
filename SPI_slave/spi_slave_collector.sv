package  spi_slave_collector_package ;
import uvm_pkg::*;
`include "uvm_macros.svh"
 import  spi_slave_seq_item_package::*;
 import shared_pkg::*;
class spi_slave_coverage extends uvm_component;
  `uvm_component_utils(spi_slave_coverage)

  uvm_analysis_export #(spi_slave_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(spi_slave_seq_item) cov_fifo;
  spi_slave_seq_item seq_item_cov;
  covergroup covcode ;
  reciver_data: coverpoint seq_item_cov.rx_data[9:8];
  ss_n_allcases : coverpoint seq_item_cov.SS_n iff (seq_item_cov.array_rand[0:2] inside {3'b000,3'b001,3'b110})
  {
    bins trans_all_cases= (1 => 0[*13] =>1) ;
   
  }
  ss_n_read_data : coverpoint seq_item_cov.SS_n  iff ( seq_item_cov.array_rand[0:2] == 3'b111)
  {
     bins trans_read= (1 => 0[*23] =>1) ;
  }
  ss_n : coverpoint seq_item_cov.SS_n
  {
    bins ss_n_val={0};
  }
  // bins trans_read_data =(1=>0[*23] =>1) iff(seq_item_cov.rx_data[9:8]==2'b11);bins ss_n_val={0};
  mosi: coverpoint seq_item_cov.MOSI 
  {
    bins write_add = (0=>0=>0);
    bins write_data = (0=>0=>1);
    bins read_add = (1=>1=>0);
    bins read_data =(1=>1=>1);
    bins mosi_val_low={0};
     bins mosi_val_high={1};
  }
  cross_mosi_ss_n : cross mosi,ss_n
  {
     option.cross_auto_bin_max=0;
     bins ss_n_low_mosi_low = binsof(ss_n.ss_n_val) && binsof(mosi.mosi_val_low);
     bins ss_n_low_mosi_high = binsof(ss_n.ss_n_val)  && binsof(mosi.mosi_val_high);
  }

  endgroup

  function new(string name = "spi_slave_coverage", uvm_component parent = null);
    super.new(name, parent);
    covcode=new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo   = new("cov_fifo", this);
  endfunction

  function void connect_phase(uvm_phase phase) ;
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin 
    cov_fifo.get(seq_item_cov);
    covcode.sample();
  end
  endtask

endclass
endpackage