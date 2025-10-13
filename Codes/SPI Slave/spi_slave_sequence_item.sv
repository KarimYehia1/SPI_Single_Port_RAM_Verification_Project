package spi_slave_seq_item_package;
import uvm_pkg::*;
 `include "uvm_macros.svh"
import shared_pkg::*;
class spi_slave_seq_item extends uvm_sequence_item;
  `uvm_object_utils(spi_slave_seq_item);
 rand logic [7:0] tx_data;
 logic [9:0] rx_data ,rx_data_ref;
 logic rx_valid, MISO,MISO_ref ,rx_valid_ref;
  logic MOSI;
 rand logic SS_n;
 rand logic rst_n;
 rand logic tx_valid;
 rand bit[0:10] array_rand;

  function new(string name= "spi_slave_seq_item");
     super.new(name);
 endfunction
   //reset
    constraint reset 
    {
      rst_n  dist { 1:/98 , 0:/2};
    }
    //SS_n for all cases
    constraint serial_comm_all_cases
    {
      if(  array_rand[0:2] inside {3'b000, 3'b001, 3'b110} && counter_allcases%14 !=0) {
         SS_n==0;
      }
       else 
        { 
          SS_n==1;
        }
    }
    //SS_n for read data
    constraint serial_comm_read_data{
     if(  array_rand[0:2] inside {3'b111} && counter_read%24 !=0) {
         SS_n==0;
      }
       else 
        { 
          SS_n==1;
        }
    }
    //tx_valid for read data
    constraint trans_ram
    {
            if (array_rand[0:2] == 3'b111  && counter_read==23) 
              {
                tx_valid==1;
              } 
              if(array_rand[0:2] != 3'b111)
                {
                  tx_valid==0;
                }
    } 
    // array_rand for all cases
    constraint mosi_in
    {
      if (SS_n_prev && !SS_n)
      array_rand[0:2] inside {3'b000, 3'b001, 3'b110 , 3'b111};
    }
    
    
    function void post_randomize;
      SS_n_prev=SS_n;
       if(counter_allcases<11 )
        MOSI=array_rand[counter_allcases];
    endfunction
    function update_counter_allcases;
     counter_allcases++;
    if (counter_allcases==14 )
    counter_allcases=0;
    endfunction

    function update_counter_read;
     counter_read++;
    if (counter_read==24 )
    counter_read=0;
    endfunction 

 function string convert2string();
 return $sformatf("%s reset = 0b%0b , mosi=%b , miso=%b , ss_n = %b ",super.convert2string(),rst_n,MOSI,MISO,SS_n);
 endfunction
 function string convert2string_stimulus();
 return $sformatf("reset = 0b%0b , mosi=%b , ss_n = %b ",rst_n,MOSI,SS_n);
 endfunction
endclass
endpackage