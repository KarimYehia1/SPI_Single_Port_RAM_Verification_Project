module SPI_Slave(MOSI,SS_n,clk,rst_n,rx_data,tx_valid,tx_data,MISO,rx_valid);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output  reg [9:0] rx_data;
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter  READ_DATA=3'b100;
reg ADDRESS_read; // this is signal to increment when  reading an address
reg[3:0] counter;
reg [2:0] cs ,ns;
always@(posedge clk) begin 
    if(~rst_n)
     cs<=IDLE;
     else 
     cs<=ns;
end
always@(*) begin 
    case(cs)
    IDLE: begin 
        if(SS_n)
        ns=IDLE;
        else 
        ns=CHK_CMD;
    end
   CHK_CMD : begin 
    if (SS_n)
    ns = IDLE;
    else begin
     if( ~MOSI) begin 
        ns=WRITE;
    end 
    else begin
        casex(ADDRESS_read)
        1'b0 : ns=READ_ADD;
        1'b1: ns=READ_DATA;
        1'bx: ns=READ_ADD;
        endcase
    end
   end
   end
   WRITE: begin
     if(SS_n==0 )
     ns=WRITE;
     else begin
        ns=IDLE;
     end
   end
   READ_ADD :  begin 
    if(SS_n==0) begin
    ns=READ_ADD;
    end
    else begin
        ns=IDLE;
    end
   end
   READ_DATA : begin 
    if(SS_n==0)
    ns=READ_DATA;
    else begin
        ns=IDLE;
    end
   end
    endcase
end
always @(posedge clk) begin
      if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        ADDRESS_read<= 0;
        MISO <= 0;
    end
    else begin
   case(cs)
    IDLE: rx_valid<=0;
    CHK_CMD : begin
         counter<=10;
    end
    WRITE  : begin 
        if(counter>0) begin
        rx_data[counter-1]<=MOSI;
        counter<=counter-1;
        end
        else begin
            rx_valid<=1;
        end
    end
    READ_ADD : begin 
         if(counter>0) begin
        rx_data[counter-1]<=MOSI;
        counter<=counter-1;
        end
        else begin
            rx_valid<=1;
            ADDRESS_read<=1;
        end
    end
   READ_DATA : begin 
    if (tx_valid) begin
        if(counter>0) begin
            MISO<=tx_data[counter-1];
             counter<=counter-1;
        end
         else begin
                ADDRESS_read <= 0;
                rx_valid<=0;
         end
    end
    else begin 
       if(counter>0) begin
        rx_data[counter-1]<=MOSI;
        counter<=counter-1;
       end
       else begin
        rx_valid<=1;
        counter<=9;
       end
    end
   end

   endcase
    end
end
endmodule
