module ram_ref(clk, rst_n, din, rx_valid, dout, tx_valid);
input clk, rst_n, rx_valid;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout;

parameter MEM_DEPTH = 256, ADDR_SIZE = 8;

reg [ADDR_SIZE-1 :0] mem [MEM_DEPTH-1 :0];

reg [ADDR_SIZE - 1 : 0] wr_address, rd_address;
always @(posedge clk) begin
    if(!rst_n) begin
      dout <= 0;
      wr_address <= 0;
      rd_address <= 0;
      tx_valid <= 0;
    end
    else begin
        if(rx_valid) begin
            case ({din[9:8]})
                2'b00: begin
                  wr_address <= din[7:0];
                  tx_valid <= 0;
                end
                2'b01: begin
                  mem[wr_address] <= din[7:0];
                  tx_valid <= 0;
                end
                2'b10: begin
                  rd_address <= din[7:0];
                  tx_valid <= 0;
                end
                2'b11: begin
                  dout <= mem[rd_address];
                  tx_valid <= 1;
                end
            endcase
        end
    end
end
endmodule