`timescale 1ns / 10ps

module test_top(
output wire PWML,PWMR,DIRL,DIRR,nSLPR,nSLPL
);
localparam period = 83;
reg clk,reset,start;
reg [5:0]bumper = 6'b111111;;

//12MHz clock just like the CMOD A7 oscillator
always 
begin
    clk = 1'b1; 
    #83; // high for 83 * timescale = 83 ns

    clk = 1'b0;
    #83; // low for 83 * timescale = 83 ns
end

top DUT(.sysclk(clk),.bmp(bumper),.rst(reset),.start(start),.PWML(PWML),.PWMR(PWMR),.DIRL(DIRL),.DIRR(DIRR),.nSLPR(nSLPR),.nSLPL(nSLPL));

initial
begin
    //reset the signals
    reset = 1;
    #(2 * period);
    reset = 0;
    #period;
    
    //robot started
    start = 1;
    #(2 * period);
    start = 0;
    #2000000000;
    
    bumper = 6'b111110;
    #(2 * period);
    bumper = 6'b111111;
    #2000000000;
    #2000000000;
    
    bumper = 6'b011111;
    #(2 * period);
    bumper = 6'b111111;
    #2000000000;
    #2000000000;
    
    bumper = 6'b110011;
    #(2 * period);
    bumper = 6'b111111;
    #2000000000;
    #2000000000;
end
endmodule
