package SPI_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_pkg::*;

    class SPI_seq_item extends uvm_sequence_item;
        `uvm_object_utils(SPI_seq_item)

        //Inputs
        rand logic rst_n, SS_n, MOSI;
        //Outputs
        logic MISO;
        //Outputs Golden
        logic MISO_GOLDEN;
        //array to help in MOSI randomization
        rand bit [0:10] array_rand;
        //Saving the last operation
        op_e old_operation;
        //array index to drive MOSI bit by bit
        int bit_index = 0; 


        //Constraints
        //RESET
        constraint reset {rst_n dist {0:/2, 1:/98};}

        //SS_n_high
        constraint SS_n_high {
            if ((array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR} && counter_allcases % 13 != 0)     //SS_n = 1 every 13 cycles
             || (array_rand[0:2] inside {RD_DATA} && counter_read % 23 != 0))                          //SS_n = 1 every 23 cycles
                SS_n==0;
            else 
                SS_n==1;
        }

        //Write only
        constraint wr_only_constraint {
            // Always constrain to write operations (address or data)
            array_rand[0:2] inside {WR_ADDR, WR_DATA};
        }

        //Read only
        constraint rd_only_constraint { 
            // Always constrain to read operations sequentially (address then data then address then ..etc)
            if(old_operation == RD_ADDR)
                array_rand[0:2] == RD_DATA;
            else if (old_operation == RD_DATA)
                array_rand[0:2] == RD_ADDR;
            else
                array_rand[0:2] inside {RD_ADDR, RD_DATA};
        }

        //Write and Read
        constraint rd_wr_constraint {
            if(old_operation == WR_ADDR) //Write_address
                array_rand[0:2] inside {WR_ADDR, WR_DATA};         // write_address or write_data 
            else if (old_operation == WR_DATA) //write_data
                array_rand[0:2] dist {RD_ADDR:/ 60, WR_ADDR:/ 40}; // read_address = 60%, write_address = 40%
            else if (old_operation == RD_ADDR) // Read_address
                array_rand[0:2] == RD_DATA; //read_data
            else // Read_data
                array_rand[0:2] dist {WR_ADDR:/ 60, RD_ADDR:/ 40}; // Write Address = 60%, Read Address = 40%
        }


        function void post_randomize;
            // Start of a new frame when SS_n goes low
            if (SS_n_prev && !SS_n)
                bit_index = -1; // will be incremented to 0 in the next step (don't drive MOSI in the same cycle SS_n goes low(IDLE -> CHK_CMD))

            // While SS_n is low -> drive MOSI bit-by-bit
            if (!SS_n) begin
                MOSI = array_rand[bit_index];
                bit_index++;
                if (bit_index > 10)
                    bit_index = 0; // wrap after full frame
            end

            // update operation tracking
            old_operation = op_e'(array_rand[0:2]);
            SS_n_prev = SS_n;
        endfunction


        function void update_counter_allcases;
            //Only increment counter when valid
            if (array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR})
                counter_allcases++;
            if (counter_allcases == 13)
                counter_allcases = 0;
        endfunction

        function void update_counter_read;
            //Only increment counter when valid
            if (array_rand[0:2] inside {RD_DATA})
                counter_read++;
            if (counter_read == 23)
                counter_read = 0;
        endfunction 

        function new(string name = "SPI_seq_item");
            super.new(name);
        endfunction

    endclass

endpackage