module SPI_SLAVE (MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output  reg [9:0] rx_data;

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;
always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI) 
                    ns = WRITE;
                else begin
                      if (received_address) 
                        ns = READ_DATA; 
                    else
                        ns = READ_ADD;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter<=0; // reset 
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end

            READ_DATA : begin
                if (tx_valid) begin 
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                         rx_valid <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin // write data before going to read data
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end
// READ_ADD and READ_DATA is replaced
// counter not equal 0 at reset 
// rx_valid in read data 
//counter in read_data
`ifdef SIM 

sequence write_add_seq;
  (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 0)[*3];
endsequence
sequence write_data_seq;
  (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 0)[*2] ##1(MOSI==1);
endsequence
sequence read_add_seq;
  (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 1)[*2] ##1(MOSI==0);
endsequence

sequence read_data_seq;
  (SS_n==1) ##1 (SS_n==0) ##1 (MOSI == 1)[*3];
endsequence


property chck_rx_valid;
  @(posedge clk) disable iff(~rst_n)
    (write_add_seq or write_data_seq or read_add_seq or read_data_seq) |=> ##9 ($rose(rx_valid) && $rose(SS_n)[->1]);
endproperty

   property chck_reset ;
   @(posedge clk)   (~rst_n) |=>(MISO ==0 && rx_valid==0 && rx_data==0);
   endproperty

  property chck_state_idle;
   @(posedge clk) disable iff(~rst_n) (cs==IDLE && !SS_n) |=>(cs==CHK_CMD);
  endproperty
  property chck_state_write;
   @(posedge clk) disable iff(~rst_n) (cs==CHK_CMD && !SS_n && !MOSI) |=>  (cs==WRITE);
  endproperty
  property chck_state_read_add;
   @(posedge clk) disable iff(~rst_n)  (cs==CHK_CMD && !SS_n && MOSI && !received_address) |=>(cs==READ_ADD);
  endproperty
  property chck_state_read_data;
   @(posedge clk) disable iff(~rst_n)  (cs==CHK_CMD && !SS_n && MOSI && received_address) |=>(cs==READ_DATA);
  endproperty
   property chck_state_write_to_idle;
   @(posedge clk)  (cs==WRITE &&(~rst_n)) |=> (cs==IDLE);
   endproperty
   property chck_state_read_add_to_idle;
   @(posedge clk)  (cs==READ_ADD && (~rst_n)) |=> (cs==IDLE);
   endproperty
   property chck_state_read_datato_idle;
   @(posedge clk)  (cs==READ_DATA && (~rst_n)) |=> (cs==IDLE);
   endproperty

   
   assert property (chck_reset);
    assert property (chck_rx_valid);
     assert property (chck_state_idle);
    assert property (chck_state_write);
     assert property (chck_state_read_add);
     assert property (chck_state_read_data);
     assert property (chck_state_write_to_idle);
     assert property (chck_state_read_add_to_idle);
     assert property (chck_state_read_datato_idle);                                                                             

            cover property (chck_reset);
            cover property (chck_rx_valid);
            cover property (chck_state_idle);
            cover property (chck_state_write);
            cover property (chck_state_read_add);
            cover property (chck_state_read_data);
            cover property (chck_state_write_to_idle);
            cover property (chck_state_read_add_to_idle);
            cover property (chck_state_read_datato_idle);                   

`endif 
endmodule