module RAM_sva(input [9:0] din, input clk,rst_n,rx_valid, input [7:0] dout, input tx_valid);
    rst_n_assertion: assert property (@(posedge clk) (!rst_n) |=> (dout == 0) && (tx_valid == 0));
    tx_valid_0_assertion: assert property (@(posedge clk) disable iff(!rst_n) (!(din[8] && din[9])) |=> (tx_valid == 0));
    tx_valid_1_assertion: assert property (@(posedge clk) disable iff(!rst_n) ((din[8] && din[9])) |=> (tx_valid == 1) |=> $fell(tx_valid)[->1]);
    wr_addr_then_wr_data_assertion: assert property (@(posedge clk) disable iff(!rst_n) ((!din[8] && !din[9])) |=> (din[8] && !din[9])[->1]);
    rd_addr_then_rd_data_assertion: assert property (@(posedge clk) disable iff(!rst_n) ((!din[8] && din[9])) |=> (din[8] && din[9])[->1]);

endmodule