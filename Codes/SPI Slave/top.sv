
import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_slave_test_pkg::*;
import spi_slave_seq_item_package::*;
import shared_pkg::*;

module top();
    bit clk;
    initial begin 
      forever #2 clk=~clk;
    end
    spi_slave_if ss_if(clk);
    SLAVE DUT(ss_if);
    SPI_Slave dut(ss_if.MOSI,ss_if.SS_n,ss_if.clk,ss_if.rst_n,ss_if.rx_data_ref,ss_if.tx_valid,ss_if.tx_data,ss_if.MISO_ref,ss_if.rx_valid_ref);
    initial begin 
      uvm_config_db #(virtual spi_slave_if) :: set(null,"uvm_test_top","SPI_IF",ss_if);
    run_test ("spi_slave_test");
    end
endmodule
   