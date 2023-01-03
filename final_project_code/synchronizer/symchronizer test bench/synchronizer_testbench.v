module router_sync_tb();
reg clk,reset,detect_add,write_en_reg,read_en_0,read_en1,read_en_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
reg [1:0]datain;
wire vld_out_0,vld_out_1,vld_out_2;
wire [2:0]write_enb;
reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
router_sync a1 (clk,reset,detect_add,write_en_reg,read_en_0,read_en1,read_en_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,datain,vld_out_0,vld_out_1,vld_out_2,write_enb, fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
//clock generation
initial
begin
    clk = 1;
    forever 
    #5 clk=~clk;
end
task reset;
begin
    reset=1'b0;
    #10;
    reset=1'b1;
end
endtask
task task1();
begin
    detect_add=1'b1;
    datain=2'b10;
    read_enb_0=1'b0;
    read_enb_1=1'b1;
    read_enb_2=1'b0;
    write_enb_reg=1'b1;
    full_0=1'b0;
    full_1=1'b1;
    full_2=1'b1;
    empty_0=1'b1;
    empty_1=1'b0;
    empty_2=1'b0;
end
endtask
initial
begin
    reset;
    #5;
    task1();
    #1000;
    $finish;
end
endmodule