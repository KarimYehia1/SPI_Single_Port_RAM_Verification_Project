package SPI_pkg;
    typedef enum {IDLE, CHK_CMD, WRITE, READ_ADD, READ_DATA} current_st;
    typedef enum bit [0:2] {WR_ADDR=3'b000, WR_DATA=3'b001, RD_ADDR=3'b110, RD_DATA=3'b111} op_e;
    parameter MEM_DEPTH=256, ADDR_SIZE=8;
    int counter_allcases = 0;
    int counter_read = 0;
    logic SS_n_prev = 1;
endpackage