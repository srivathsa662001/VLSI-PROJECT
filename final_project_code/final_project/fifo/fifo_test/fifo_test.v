
module router_fifo_tb();
//parameter DELAY=10;
//parameter DEPTH=16, WIDTH=9, ADD_SIZE=5;
reg clk, reset, write_en, read_en, lfd_state, soft_reset;
reg [7:0]datain;
wire full, empty;
wire [7:0]dataout;
router_fifo a1 (clk,reset,soft_reset,write_en,read_en,lfd_state,datain,full,empty,dataout);
initial//initilise clock
begin
clk = 1;
forever
#5 clk=~clk;
end
initial
begin
reset=1'b0;
#10;
reset=1'b1;
soft_reset=1'b0;
lfd_state=1'b1;
write_enb=1'b1;
#10;
repeat(17)
begin
    datain=$random;
    #10
end
write_enb=1'b0;
#5;
read_enb=1'b1;
#100;
$finish;
end
endmodule
