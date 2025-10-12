package SPI_scoreboard_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import spi_slave_seq_item_package::*;
    import ram_seq_item_pkg::*;
    import SPI_SLAVE_shared_pkg::*;
    import RAM_shared_pkg::*;

    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)

        uvm_analysis_export #(SPI_seq_item)         sb_export_SPI;
        uvm_analysis_export #(spi_slave_seq_item)   sb_export_SPI_SLAVE;
        uvm_analysis_export #(ram_seq_item)         sb_export_RAM;
        uvm_tlm_analysis_fifo #(SPI_seq_item)       sb_fifo_SPI;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) sb_fifo_SPI_SLAVE;
        uvm_tlm_analysis_fifo #(ram_seq_item)       sb_fifo_RAM;
        SPI_seq_item seq_item_SPI;
        spi_slave_seq_item seq_item_SPI_SLAVE;
        ram_seq_item seq_item_RAM;

        int correct_counter = 0;
        int error_counter_SPI = 0;
        int error_counter_SPI_SLAVE = 0;
        int error_counter_RAM = 0;

        function new(string name = "SPI_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export_SPI = new("sb_export_SPI", this);
        sb_export_SPI_SLAVE = new("sb_export_SPI_SLAVE", this);
        sb_export_RAM = new("sb_export_RAM", this);
        sb_fifo_SPI = new("sb_fifo_SPI", this);
        sb_fifo_SPI_SLAVE = new("sb_fifo_SPI_SLAVE", this);
        sb_fifo_RAM = new("sb_fifo_RAM", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export_SPI.connect(sb_fifo_SPI.analysis_export);
            sb_export_SPI_SLAVE.connect(sb_fifo_SPI_SLAVE.analysis_export);
            sb_export_RAM.connect(sb_fifo_RAM.analysis_export);
        endfunction 

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo_SPI.get(seq_item_SPI);
                sb_fifo_SPI_SLAVE.get(seq_item_SPI_SLAVE);
                sb_fifo_RAM.get(seq_item_RAM);

                if (seq_item_SPI.MISO != seq_item_SPI.MISO_GOLDEN) begin
                    `uvm_error("ERROR", $sformatf("Error in Wrapper: rst_n=%b, SS_n=%b, MOSI=%b, MISO=%b, MISO_GOLDEN=%b", seq_item_SPI.rst_n, seq_item_SPI.SS_n, seq_item_SPI.MOSI, seq_item_SPI.MISO, seq_item_SPI.MISO_GOLDEN))
                    error_counter_SPI++;
                end

                //input tx_data, MOSI, SS_n, rst_n, tx_valid, output rx_data, rx_data_ref, MISO, MISO_ref, rx_valid, rx_valid_ref
                else if (seq_item_SPI_SLAVE.rx_data != seq_item_SPI_SLAVE.rx_data_ref || seq_item_SPI_SLAVE.rx_valid != seq_item_SPI_SLAVE.rx_valid_ref || seq_item_SPI_SLAVE.MISO != seq_item_SPI_SLAVE.MISO_ref) begin
                    `uvm_error("ERROR", $sformatf("Error in SPI_SLAVE"))
                    error_counter_SPI_SLAVE++;
                end

                //input rst_n, rx_valid, din, output tx_valid, tx_valid_ref, dout, dout_ref
                else if ((seq_item_RAM.dout != seq_item_RAM.dout_ref) || (seq_item_RAM.tx_valid != seq_item_RAM.tx_valid_ref)) begin
                    `uvm_error("ERROR", $sformatf("Error in RAM: rst_n=%b, rx_valid=%b, din=%b, tx_valid=%b, tx_valid_ref=%b, dout=%b, dout_ref=%b",
                    seq_item_RAM.rst_n, seq_item_RAM.rx_valid, seq_item_RAM.din, seq_item_RAM.tx_valid, seq_item_RAM.tx_valid_ref, seq_item_RAM.dout, seq_item_RAM.dout_ref))
                    error_counter_RAM++;
                end

                else correct_counter++;
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("Report Phase", $sformatf("Correct = %d", correct_counter), UVM_MEDIUM)
            `uvm_info("Report Phase", $sformatf("SPI Wrapper Errors = %d", error_counter_SPI), UVM_MEDIUM)
            `uvm_info("Report Phase", $sformatf("SPI_SLAVE Errors = %d", error_counter_SPI_SLAVE), UVM_MEDIUM)
            `uvm_info("Report Phase", $sformatf("RAM Errors = %d", error_counter_RAM), UVM_MEDIUM)
        endfunction

    endclass

endpackage