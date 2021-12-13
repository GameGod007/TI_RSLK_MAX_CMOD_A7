`timescale 1ns / 1ps

module top(
input wire sysclk, //12MHz clock
//Bumper switches
input wire [5:0]bmp,
//fpga switches
input wire rst,start,
//Motor signals
output wire PWML,PWMR,DIRL,DIRR,nSLPR,nSLPL
    );

wire [2:0]drive;
 
 //wrapper for motor driver   
 motor_driver motor_wrap(
.clk(sysclk),
.drive(drive),//control signal
.PWML(PWML),
.PWMR(PWMR),
.DIRL(DIRL),
.DIRR(DIRR),
.nSLPR(nSLPR),
.nSLPL(nSLPL)
); 

controller controls(
.clk(sysclk),.rst(rst),.start(start),
.bmp(bmp),
.drive(drive)
    ); 

endmodule
