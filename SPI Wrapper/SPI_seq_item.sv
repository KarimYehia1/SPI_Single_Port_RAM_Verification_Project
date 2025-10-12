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

        //Constraints
        //RESET
        constraint reset {rst_n dist {0:/2, 1:/98};}

        //SS_n_0
        constraint SS_n_0 {SS_n == 0;}

        //SS_n_13_cycles
        constraint serial_comm_all_cases {
            if (array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR} && counter_allcases % 14 != 0)
                SS_n==0;
            else 
                SS_n==1;
        }

        //SS_n_23_cycles
        constraint serial_comm_read_data {
            if(array_rand[0:2] inside {RD_DATA} && counter_read % 24 != 0)
                SS_n==0;
            else 
                SS_n==1;
        }
   
        //MOSI
        constraint mosi_in {
        if (SS_n_prev && !SS_n)
            array_rand[0:2] inside {WR_ADDR, WR_DATA, RD_ADDR , RD_DATA};
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
            old_operation = op_e'(array_rand[0:2]);
            SS_n_prev = SS_n;
            if(counter_allcases < 11)
                MOSI = array_rand[counter_allcases];
        endfunction

        function update_counter_allcases;
            counter_allcases++;
            if (counter_allcases == 14)
                counter_allcases = 0;
        endfunction

        function update_counter_read;
            counter_read++;
            if (counter_read == 24)
                counter_read = 0;
        endfunction 

        function new(string name = "SPI_seq_item");
            super.new(name);
        endfunction

    endclass

endpackage