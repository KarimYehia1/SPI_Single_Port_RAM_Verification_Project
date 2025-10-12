module SLAVE (spi_slave_if.DUT ss_if);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;
always @(posedge ss_if.clk) begin
    if (~ss_if.rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (ss_if.SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (ss_if.SS_n)
                ns = IDLE;
            else begin
                if (~ss_if.MOSI) 
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
            if (ss_if.SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (ss_if.SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (ss_if.SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge ss_if.clk) begin
    if (~ss_if.rst_n) begin 
        ss_if.rx_data <= 0;
        ss_if.rx_valid <= 0;
        received_address <= 0;
        ss_if.MISO <= 0;
        counter<=0; // reset 
    end
    else begin
        case (cs)
            IDLE : begin
                ss_if.rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    ss_if.rx_data[counter-1] <= ss_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    ss_if.rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    ss_if.rx_data[counter-1] <= ss_if.MOSI;
                    counter <= counter - 1;
                end
                else begin
                    ss_if.rx_valid <= 1;
                    received_address <= 1;
                end
            end

            READ_DATA : begin
                if (ss_if.tx_valid) begin 
                    if (counter > 0) begin
                        ss_if.MISO <= ss_if.tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                         ss_if.rx_valid <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin // write data before going to read data
                        ss_if.rx_data[counter-1] <= ss_if.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        ss_if.rx_valid <= 1;
                        counter <= 9;
                    end
                end
            end
        endcase
    end
end
// READ_ADD and READ_DATA is replaced
// counter not equal 0 at reset 
 `ifdef SIM 

sequence write_add_seq;
  (ss_if.SS_n==1) ##1 (ss_if.SS_n==0) ##1 (ss_if.MOSI == 0)[*3];
endsequence
sequence write_data_seq;
  (ss_if.SS_n==1) ##1 (ss_if.SS_n==0) ##1 (ss_if.MOSI == 0)[*2] ##1(ss_if.MOSI==1);
endsequence
sequence read_add_seq;
  (ss_if.SS_n==1) ##1 (ss_if.SS_n==0) ##1 (ss_if.MOSI == 1)[*2] ##1(ss_if.MOSI==0);
endsequence

sequence read_data_seq;
  (ss_if.SS_n==1) ##1 (ss_if.SS_n==0) ##1 (ss_if.MOSI == 1)[*3];
endsequence


property chck_rx_valid;
  @(posedge ss_if.clk) disable iff(~ss_if.rst_n)
    (write_add_seq or write_data_seq or read_add_seq or read_data_seq) |=> ##9 ($rose(ss_if.rx_valid) && $rose(ss_if.SS_n)[->1]);
endproperty

   property chck_reset ;
   @(posedge ss_if.clk)   (~ss_if.rst_n) |=>(ss_if.MISO ==0 && ss_if.rx_valid==0 && ss_if.rx_data==0);
   endproperty

  property chck_state_idle;
   @(posedge ss_if.clk) disable iff(~ss_if.rst_n) (cs==IDLE && !ss_if.SS_n) |=>(cs==CHK_CMD);
  endproperty
  property chck_state_write;
   @(posedge ss_if.clk) disable iff(~ss_if.rst_n) (cs==CHK_CMD && !ss_if.SS_n && !ss_if.MOSI) |=>  (cs==WRITE);
  endproperty
  property chck_state_read_add;
   @(posedge ss_if.clk) disable iff(~ss_if.rst_n)  (cs==CHK_CMD && !ss_if.SS_n && ss_if.MOSI && !received_address) |=>(cs==READ_ADD);
  endproperty
  property chck_state_read_data;
   @(posedge ss_if.clk) disable iff(~ss_if.rst_n)  (cs==CHK_CMD && !ss_if.SS_n && ss_if.MOSI && received_address) |=>(cs==READ_DATA);
  endproperty
   property chck_state_write_to_idle;
   @(posedge ss_if.clk)  (cs==WRITE &&(~ss_if.rst_n)) |=> (cs==IDLE);
   endproperty
   property chck_state_read_add_to_idle;
   @(posedge ss_if.clk)  (cs==READ_ADD && (~ss_if.rst_n)) |=> (cs==IDLE);
   endproperty
   property chck_state_read_datato_idle;
   @(posedge ss_if.clk)  (cs==READ_DATA && (~ss_if.rst_n)) |=> (cs==IDLE);
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