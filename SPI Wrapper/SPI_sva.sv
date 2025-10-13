module SPI_sva(input clk, rst_n, SS_n, MOSI, MISO);

//RESET
property RESET;
    @(posedge clk) !rst_n |=> !MISO;
endproperty

// Detect a READ_DATA command pattern (simplified example)
sequence READ_DATA_SEQUENCE;
    $fell(SS_n) ##1 (MOSI[->3] ##0 1'b1); // detect 3 bits + some end marker
endsequence

// Property: whenever SS_n is low, if READ_DATA_SEQUENCE does NOT start,
// then MISO must stay stable while SS_n is low.
property MISO_STABLE_NOT_READ;
    @(posedge clk) disable iff (!rst_n)
        $fell(SS_n) |=> 
            (not READ_DATA_SEQUENCE ##1 ($stable(MISO) throughout (!SS_n)) );
endproperty

// Assertions
RESET_assert: assert property (RESET);
READ_DATA_assert: assert property (MISO_STABLE_NOT_READ);

// Coverage
RESET_cover: cover property (RESET);
READ_DATA_cover: cover property (MISO_STABLE_NOT_READ);

endmodule