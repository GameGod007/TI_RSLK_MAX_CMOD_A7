`timescale 1ns / 1ps

module clock_divider(
input wire sysclk, //12MHz
output reg Mclk = 0, //Motor driver clk
output reg Cclk = 0 //Controller module clk
    );
    
//counters
integer count_m = 0;
integer count_c = 0;

//divider values
//division_value = clk/(2*desired freq - 1)
localparam divm = 6000000;//6MHz
localparam divc = 6000;//1kHz for debouncer

//Motor clocking
always@ (posedge sysclk)
begin
    if (count_m == divm)
    begin
        count_m <=0;
        Mclk <= ~Mclk;
    end
    else
    begin
        count_m <= count_m+1;
        Mclk <= Mclk;
    end
end

//debouncer clocking
always@ (posedge sysclk)
begin
    if (count_c == divc)
    begin
        count_c <=0;
        Cclk <= ~Cclk;
    end
    else
    begin
        count_c <= count_c+1;
        Cclk <= Cclk;
    end
end

endmodule
