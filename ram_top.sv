import uvm_pkg::*;
import ram_test_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"
module ram_top();
    bit clk;
    initial begin
        forever begin
            #1 clk = ~clk;
        end
    end

    ram_if RAM_IF(clk);
    RAM DUT(RAM_IF.din,RAM_IF.clk,RAM_IF.rst_n,RAM_IF.rx_valid,RAM_IF.dout,RAM_IF.tx_valid);
    ram_ref ref_model(RAM_IF.clk, RAM_IF.rst_n, RAM_IF.din, RAM_IF.rx_valid, RAM_IF.dout_ref, RAM_IF.tx_valid_ref);

    initial begin
        uvm_config_db #(virtual ram_if)::set(null, "uvm_test_top", "RAM_IF", RAM_IF);
        run_test("ram_test");
    end

endmodule