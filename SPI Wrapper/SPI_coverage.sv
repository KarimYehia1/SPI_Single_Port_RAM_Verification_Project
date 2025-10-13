package SPI_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_seq_item_pkg::*;
    import spi_slave_seq_item_package::*;
    import ram_seq_item_pkg::*;
    import SPI_SLAVE_shared_pkg::*;
    import RAM_shared_pkg::*;

    class SPI_coverage extends uvm_scoreboard;
        `uvm_component_utils(SPI_coverage)

        uvm_analysis_export #(SPI_seq_item)         cov_export_SPI;
        uvm_analysis_export #(spi_slave_seq_item)   cov_export_SPI_SLAVE;
        uvm_analysis_export #(ram_seq_item)         cov_export_RAM;
        uvm_tlm_analysis_fifo #(SPI_seq_item)       cov_fifo_SPI;
        uvm_tlm_analysis_fifo #(spi_slave_seq_item) cov_fifo_SPI_SLAVE;
        uvm_tlm_analysis_fifo #(ram_seq_item)       cov_fifo_RAM;
        SPI_seq_item seq_item_SPI;
        spi_slave_seq_item seq_item_SPI_SLAVE;
        ram_seq_item seq_item_RAM;

        //Covergroups
        covergroup cvr_grp_SPI_SLAVE;
            reciver_data: coverpoint seq_item_SPI_SLAVE.rx_data[9:8];

            SS_n_allcases : coverpoint seq_item_SPI_SLAVE.SS_n {
                bins trans_all_cases= (1 => 0[*13] =>1);
            }

            SS_n_read_data : coverpoint seq_item_SPI_SLAVE.SS_n {
                bins trans_read= (1 => 0[*22] => 1) ;
            }

            SS_n : coverpoint seq_item_SPI_SLAVE.SS_n {bins SS_n_val={0};}

            // bins trans_read_data =(1=>0[*23] =>1) iff(seq_item_SPI_SLAVE.rx_data[9:8]==2'b11);bins SS_n_val={0};
            mosi: coverpoint seq_item_SPI_SLAVE.MOSI {
                bins write_add = (0=>0=>0);
                bins write_data = (0=>0=>1);
                bins read_add = (1=>1=>0);
                bins read_data =(1=>1=>1);
                bins mosi_val_low={0};
                bins mosi_val_high={1};
            }

            cross_mosi_SS_n : cross mosi,SS_n {
                option.cross_auto_bin_max=0;
                bins SS_n_low_mosi_low = binsof(SS_n.SS_n_val) && binsof(mosi.mosi_val_low);
                bins SS_n_low_mosi_high = binsof(SS_n.SS_n_val)  && binsof(mosi.mosi_val_high);
            }

        endgroup

        covergroup cvr_grp_RAM;
            transaction_ordering_cp: coverpoint seq_item_RAM.din[9:8] {
                bins all_values = {[0:3]};
                // Bins for specific transitions (They take many cycles to occur, as we have long operations)
                bins wr_data_after_wr_address = (0[*14] => 1[*10]);
                bins rd_data_after_rd_address = (2[*13] => 3[*10]);
                bins full_transition = (0[*14] => 1[*12] => 3 => 2[*13] => 3[*10]);
            }

            rx_valid_cp: coverpoint seq_item_RAM.rx_valid {
                bins rx_high = {1};
            }

            tx_valid_cp: coverpoint seq_item_RAM.tx_valid {
                bins tx_high = {1};
            }

            //When the sequence bins are hit, cross coverage checks if they hit while rx_valid is high at the same time
            cross_op_rx_cp: cross transaction_ordering_cp, rx_valid_cp;

            cross_op_tx_cp: cross transaction_ordering_cp, tx_valid_cp {
                // Cross bin for read data (3) when tx_valid is high (1)
                bins rd_data_tx_high = binsof(transaction_ordering_cp.all_values) intersect {3} && 
                                       binsof(tx_valid_cp) intersect {1};
                option.cross_auto_bin_max = 0;
            }

        endgroup

        function new(string name = "SPI_coverage", uvm_component parent = null);
            super.new(name, parent);
            //Create Covergroups
            cvr_grp_SPI_SLAVE = new();
            cvr_grp_RAM = new();
        endfunction

        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export_SPI = new("cov_export_SPI", this);
        cov_export_SPI_SLAVE = new("cov_export_SPI_SLAVE", this);
        cov_export_RAM = new("cov_export_RAM", this);
        cov_fifo_SPI = new("cov_fifo_SPI", this);
        cov_fifo_SPI_SLAVE = new("cov_fifo_SPI_SLAVE", this);
        cov_fifo_RAM = new("cov_fifo_RAM", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export_SPI.connect(cov_fifo_SPI.analysis_export);
            cov_export_SPI_SLAVE.connect(cov_fifo_SPI_SLAVE.analysis_export);
            cov_export_RAM.connect(cov_fifo_RAM.analysis_export);
        endfunction  

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo_SPI.get(seq_item_SPI);
                cov_fifo_SPI_SLAVE.get(seq_item_SPI_SLAVE);
                cov_fifo_RAM.get(seq_item_RAM);
                //Covergroups sample
                cvr_grp_SPI_SLAVE.sample();
                cvr_grp_RAM.sample();
            end
        endtask

    endclass

endpackage