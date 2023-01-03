module  router_fsm_test();
reg clk,reset,packet_valid;
reg [1:0] datain;
reg fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_packet_valid;
wire write_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;
router_fsm a1(clk,reset,packet_valid,datain,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_packet_valid,write_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);
//clock generation
always
begin
    clk<=0;
    #5
    clk<=1;
end
///or it can be done in other ways as 
/*
initial
begin
    clk=1;
    forever
    #5 clk=~clk;
    end
 */
 task reset();
 begin
    reset=1'b0;
    #10;
    reset=1'b1;
 end
 endtask

 // or can be done in this way
 /*
 task reset:
 begin
    @(negedge clk)
    reset<=0;
    @(negedge clk)
    reset<=1;
end
*/
task task1();
begin
    packet_valid<=1'b0;
    datain=2'b10;
    fifo_full<=1'b0;
    fifo_empty_0<=1'b0;
    fifo_empty_1<=1'b1;
    fifo_empty_2<=1'b1;
    soft_reset_0<=1'b1;
    soft_reset_1<=1'b0;
    soft_reset_2<=1'b1;
    parity_done<=1'b1;
    low_packet_valid<=1'b1;
end
endtask
task task2();
begin
    packet_valid<=1'b0;
    datain=2'b01;
    fifo_full<=1'b0;
    fifo_empty_0<=1'b0;
    fifo_empty_1<=1'b1;
    fifo_empty_2<=1'b1;
    soft_reset_0<=1'b1;
    soft_reset_1<=1'b0;
    soft_reset_2<=1'b1;
    parity_done<=1'b1;
    low_packet_valid<=1'b1;
end
endtask
initial
begin
    reset
    #20;
    task1;
    #40;
    task2;
    #50;
    reset;
    #100;
    $finish;
end
endmodule