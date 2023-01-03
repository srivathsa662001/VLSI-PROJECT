//desiging a fifo for increment operation(counter),werite read opration write pointer and read pointer and logic for full and empty signal
module router_fifo(clk,reset,soft_reset,write_en,read_en,lfd_state,datain,full,empty,dataout);
input[7:0]datain;
input clk,reset,soft_reset,write_en,read_en,lfd_state;
output reg [7:0]dataout;
output reg full,empty;
reg[3:0]read_ptr,write_ptr;
reg[5:0]count;//for knowing the length of data byte 
reg[8:0]fifo[15:0];//9 BIT DATA WIDTH 1 BIT EXTRA FOR HEADER AND 16 DEPTH SIZE
integer i;
reg[4:0] increment;// it also act as status counter and act as the counter to say when the fifo is full are not
//lfd state (lode first data state)(we will load only address of the headder hear)
always @(posedge clk)
begin
    if(!reset)
    temp<=1'b0;
    else
    temp<=lfd_state;  //hear lfd state stores address it may be 00,0a,10,11  
end
// for increment
always@(posedge clk)
begin
    if(!reset)
    increment<=0;
    else if((!full && write_en)&&(!empty&&read_en))//these are logical operations
    increment<=increment;
    else if (!full && write_en)
    increment<=increment+1;//because data will be written
    else if(!empty&&read_en)
    increment<=increment-1;//because data is read
    else
    increment<=increment;
end
//full and empty logic
always@(increment)//at every change in counter we shoulf check whether fifo is full r not 
begin
    if(increment==0)
    empty<=1;
    else
    empty<=0;
    if(increment==4'b1111)//fifo full
    full<=1;
    else
    full<=0;
end

//fifo write logic
always@(posedge clk)
begin
    if(!reset||soft_reset)
    begin
        for(i=0;i<16;i=i+1)
        fifo[i]<=0;
    end
    else if(write_en && !full)
    {fifo[write_ptr[3:0]][8],fifo[write_ptr[3:0][7:0]]}<={temp,data_in};
    //temp=1 for header and 0 for other data 
end
//fifo read logic
always@(posedge clk)
begin
    if(!reset)
    dataout<=8'd0;
    else if(soft_reset)
    dataout<=8'bzz;
    else
    begin
        if(read_en&&!empty)
        dataout<=fifo[read_ptr[3:0]];
        if(count==0)//completly read
        dataout<=8'bz;
    end
end
//counter logic
always@(posedge clk)
begin
    if(read_en&&!empty) 
    begin
        if(fifo[read_ptr[3:0]][8])//a header byte is read, an internal counter is loaded with the payload
        //length of the packet plus(parity byte) and starts decrementing every clock till it reached
        count<=fifo[read_ptr[3:0]][7:2]+1'b1;
        else if(count!=6'd0)
        count<=count-1'b1;
    end
end

//pointer logic
always@(posedge clk)
begin
    if(!reset||soft_reset)
    begin
        read_ptr=5'd0;
        write_ptr=5'd0;
    end
    else
    begin
        if(write_en&&!full)
        write_ptr=write_ptr+1'b1;
        if(read_en&&!empty)
        read_ptr=read_ptr+1'b1;
    end
end
endmodule

        
    

 































