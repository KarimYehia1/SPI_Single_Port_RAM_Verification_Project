package ram_coverage_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_coverage extends uvm_component;
    `uvm_component_utils(ram_coverage)
    uvm_analysis_export #(ram_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
    ram_seq_item item;

    covergroup ram_cvr_gp;
    transaction_ordering_cp: coverpoint item.din[9:8]
    {
        bins all_values = {[0:3]};
        bins wr_data_after_wr_address = (0 => 1);
        bins rd_data_after_rd_address = (2 => 3);
        bins full_transition = (0 => 1 => 2 => 3);
    }

    rx_valid_cp: coverpoint item.rx_valid
    {
        bins rx_high = {1};
    }
    tx_valid_cp: coverpoint item.tx_valid
    {
        bins tx_high = {1};
    }

    cross_op_rx_cp: cross transaction_ordering_cp, rx_valid_cp;
    cross_op_tx_cp: cross transaction_ordering_cp, tx_valid_cp
    {
        // Cross bin for read data (3) when tx_valid is high (1)
        bins rd_data_tx_high = binsof(transaction_ordering_cp.all_values) intersect {3} && 
                              binsof(tx_valid_cp) intersect {1};
        option.cross_auto_bin_max = 0;
    }

    endgroup

    function new(string name = "cov", uvm_component parent = null);
        super.new(name, parent);
        ram_cvr_gp = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(item);
            ram_cvr_gp.sample();
        end
    endtask
endclass
endpackage