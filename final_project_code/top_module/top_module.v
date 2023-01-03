module router_top(input clk, reset, packet_valid, read_enb_0, read_enb_1, read_enb_2,
input [7:0]datain,
output vldout_0, vldout_1, vldout_2, err, busy,
output [7:0]data_out_0, data_out_1, data_out_2);
wire [2:0]w_enb;
wire [2:0]soft_reset;
wire [2:0]read_enb;
wire [2:0]empty;
wire [2:0]full;
wire lfd_state_w;
wire [7:0]data_out_temp[2:0];
wire [7:0]dout;
genvar a;
generate
    for(a=0;a<3;a=a+1)
    begin:fifo
    router_fifo f(clk,reset,soft_reset,write_en,read_en,lfd_state,datain,full,empty,dataout);
    end
endgenerate
router_reg r(clk,reset,packet_valid,datain,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout);
router_fsm a1(clk,reset,packet_valid,datain,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_packet_valid,write_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);
router_sync a1 (clk,reset,detect_add,write_en_reg,read_en_0,read_en1,read_en_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,datain,vld_out_0,vld_out_1,vld_out_2,write_enb, fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
assign read_enb[0]= read_enb_0;
assign read_enb[1]= read_enb_1;
assign read_enb[2]= read_enb_2; 
assign data_out_0=data_out_temp[0]; 
assign data_out_1=data_out_temp[1]; 
assign data_out_2=data_out_temp[2];
endmodule
