module router_reg_tb();
reg clk, reset, packet_valid,fifo_full, detect_add, ld_state,laf_state, full_state, lfd_state, rst_int_reg;
reg [7:0] datain;
wire err, parity_done, low_packet_valid;
wire [7:0]dout;
integer i;
router_reg a1(clk,reset,packet_valid,datain,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid, dout);
//clock generation
initial
begin
    clk = 1;
    forever
    #5 clk=~clk;
end
task reset;
begin
    resetn=1'b0;
    #10;
    resetn=1'b1;
end
endtask
task packet1();
begin
    reg [7:0]header, payload_data, parity;
    reg [5:0]payloadlen;
    begin
        @(negedge clk);
        payloadlen=8;
        parity=0;
        detect_add=1'b1;
        packet_valid=1'b1;
        header={payloadlen,2'b10};
        datain=header;
        parity=parity^datain;
        @(negedge clk);
        detect_add=1'b0;
        lfd_state=1'b1;
        for(i=0;i<payloadlen;i=i+1)
        begin
            @(negedge clk);
            lfd_state=0;
            ld_state=1;
            payload_data={$random}%256;
            datain=payload_data;
            parity=parity^datain;
        end
        @(negedge clk);
        packet_valid=0;
        datain=parity;
        @(negedge clk);
        ld_state=0;
    end
end
endtask
task packet2();
begin
    reg [7:0]header, payload_data, parity;
    reg [5:0]payloadlen;
    begin
        @(negedge clk);
        payloadlen=8;
        parity=0;
        detect_add=1'b1;
        packet_valid=1'b1;
        header={payloadlen,2'b10};
        datain=header;
        parity=parity^datain;
        @(negedge clk);
        detect_add=1'b0;
        lfd_state=1'b1;
        for(i=0;i<payloadlen;i=i+1)
        begin
            @(negedge clk);
            lfd_state=0;
            ld_state=1;
            payload_data={$random}%256;
            datain=payload_data;
            parity=parity^datain;
        end
        @(negedge clk);
        packet_valid=0;
        datain=!parity;
        @(negedge clk);
        ld_state=0;
    end
end
endtask
initial
begin
    reset;
    fifo_full=1'b0;
    laf_state=1'b0;
    full_state=1'b0;
    #20;
    packet1();
    #105;
    packet2();
    $finish;
end
endmodule