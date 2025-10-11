package ram_scoreboard_pkg;
import uvm_pkg::*;
import ram_seq_item_pkg::*;
`include "uvm_macros.svh"

class ram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(ram_scoreboard)
    ram_seq_item item;
    uvm_analysis_export #(ram_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
    int error_count = 0, correct_count = 0;

    function new(string name = "sb", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(item);
            if(item.dout != item.dout_ref || item.tx_valid != item.tx_valid_ref) begin
                $display("Error, transation sent by dut is %s while dout_ref = %b and tx_ref = %b", item.convert2string_stimulus(), item.dout_ref, item.tx_valid_ref);
                error_count++;
            end
            else begin
                correct_count++;
            end
        end
    endtask
endclass
endpackage