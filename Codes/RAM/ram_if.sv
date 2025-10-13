interface ram_if(clk);
    parameter ADDR_SIZE = 8, MEM_DEPTH = 256;
    input bit clk;
    logic rst_n, rx_valid, tx_valid, tx_valid_ref;
    logic [ADDR_SIZE+1:0] din; // default word size + extra 2 bits 
    logic [ADDR_SIZE-1:0] dout, dout_ref;

endinterface