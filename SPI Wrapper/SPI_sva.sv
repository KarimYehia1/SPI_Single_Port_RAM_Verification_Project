module SPI_sva(input clk,rst_n,SS_n,MOSI, MISO);

//RESET
property RESET;
    @(posedge clk) !rst_n |=> !MISO
endproperty

//READ_DATA
sequence READ_DATA_SEQUENCE;
    SS_n ##1 !SS_n ##1 (!SS_n && MOSI) ##1 (!SS_n && MOSI) ##1 (!SS_n && MOSI);
endsequence

property READ_DATA;
    @(posedge clk) disable iff (!rst_n) not READ_DATA_SEQUENCE |-> $stable(MISO) throughout SS_n[->1]
endproperty

//Assertions
RESET_assert: assert property (RESET);
READ_DATA_assert: assert property (READ_DATA);

//Assertions Coverage
RESET_cover: cover property (RESET);
READ_DATA_cover: cover property (READ_DATA);
    
endmodule