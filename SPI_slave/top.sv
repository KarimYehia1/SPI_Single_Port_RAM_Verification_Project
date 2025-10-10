
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
    SLAVE DUT(ss_if.MOSI,ss_if.MISO,ss_if.SS_n,ss_if.clk,ss_if.rst_n,ss_if.rx_data,ss_if.rx_valid,ss_if.tx_data,ss_if.tx_valid);
    SPI_Slave dut(ss_if.MOSI,ss_if.SS_n,ss_if.clk,ss_if.rst_n,ss_if.rx_data_ref,ss_if.tx_valid,ss_if.tx_data,ss_if.MISO_ref,ss_if.rx_valid_ref);
    initial begin 
      uvm_config_db #(virtual spi_slave_if) :: set(null,"uvm_test_top","SPI_IF",ss_if);
    run_test ("spi_slave_test");
    end
endmodule
// constraint serial_comm
/* 
 {
      ((counter!=13 ) && (rx_data[9:8]==2'b00 || rx_data[9:8]==2'b01 || rx_data[9:8]==2'b10) ) -> (SS_n==0);
      (counter==13 && (rx_data[9:8]==2'b00 || rx_data[9:8]==2'b01 || rx_data[9:8]==2'b10)) -> (SS_n==1);
      ((counter!=23 )&& (rx_data[9:8]==2'b11)) -> (SS_n==0);
      (counter==23 &&  (rx_data[9:8]==2'b11)) -> (SS_n==1);
    }*/
   