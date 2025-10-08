package ram_seq_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

class ram_seq_item extends uvm_sequence_item;
    `uvm_object_utils(ram_seq_item)

    rand bit rst_n, rx_valid;
         bit tx_valid, tx_valid_ref;
    rand bit [9:0] din;
         bit [7:0] dout, dout_ref;
         op_e old_operation;

    function new(string name = "item");
        super.new(name);
    endfunction

    constraint rst_rx_constraint
    {
        rst_n dist {0:= 2, 1:= 98};
        rx_valid dist {0:= 2, 1:= 98};
    }

    constraint wr_only_constraint
    {
        // Always constrain to write operations (address or data)
        din[9:8] inside {WR_ADDR, WR_DATA};
    }

    constraint rd_only_constraint
    {
            din[9:8] inside {RD_ADDR, RD_DATA};
    }

    constraint rd_wr_constraint
    {
        if(old_operation == WR_ADDR) // wr_addr
        {
            din[9:8] inside {WR_ADDR, WR_DATA};   
        }
        else if (old_operation == WR_DATA) // wr_data
        {
            din[9:8] dist {RD_ADDR:= 60, WR_ADDR:= 40}; // read_address = 60%, write_address = 40%
        }
        else if (old_operation == RD_ADDR) // rd_addr
        {
            din[9:8] inside {RD_ADDR, RD_DATA};
        }
        else // rd_data
        {
            din[9:8] dist {WR_ADDR:= 60, RD_ADDR:= 40};
        }
    }

    function void post_randomize();
        old_operation = op_e'(din[9:8]);
    endfunction

    function string convert2string();
        return $sformatf("%s rst_n = %0b rx_valid = %0b tx_valid = %0b din = %b dout = %b", super.convert2string(), 
        rst_n, rx_valid, tx_valid, din, dout);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("rst_n = %0b rx_valid = %0b tx_valid = %0b din = %b dout = %b", rst_n, rx_valid, tx_valid, din, dout);
    endfunction
endclass
endpackage