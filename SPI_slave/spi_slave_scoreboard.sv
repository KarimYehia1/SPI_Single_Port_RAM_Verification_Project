package spi_slave_scoreboard_pkg;
 import uvm_pkg::*;
    `include "uvm_macros.svh"
    import  spi_slave_seq_item_package::*; 
    class spi_slave_scoreboard extends uvm_scoreboard ;
     `uvm_component_utils(spi_slave_scoreboard);
     uvm_analysis_export #(spi_slave_seq_item) sb_export;
     uvm_tlm_analysis_fifo  #(spi_slave_seq_item) sb_fifo;
    spi_slave_seq_item sq_item_sb;
     int err_count=0;
     int correct_count=0;
     function new(string name ="spi_slave_scoreboard",uvm_component parent =null);
    super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export",this);
    sb_fifo = new("sb_fifo" , this);
    endfunction

    function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase (uvm_phase phase);
  super.run_phase(phase);
  forever begin
  sb_fifo.get(sq_item_sb);
  if (sq_item_sb.MISO != sq_item_sb.MISO_ref || sq_item_sb.rx_valid !=sq_item_sb.rx_valid_ref || sq_item_sb.rx_data!=sq_item_sb.rx_data_ref) begin
    `uvm_error("run_phase",$sformatf("Comparison failed, Transaction received by the DUT: %s While the reference out:0b%0b",
sq_item_sb.convert2string(),sq_item_sb.MISO_ref))

    err_count++;
  end
  else begin
    `uvm_info("run_phase",$sformatf("Correct ALU out: %s", sq_item_sb.convert2string()), UVM_HIGH)
    correct_count++;
  end
  end
endtask

function void report_phase(uvm_phase phase) ;
super. report_phase (phase) ;
 `uvm_info("report_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM);
`uvm_info("report_phase", $sformatf("Total failed transactions: %0d", err_count), UVM_MEDIUM);
endfunction
    endclass
 endpackage