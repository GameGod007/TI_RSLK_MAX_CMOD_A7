`timescale 1ns / 1ps

//move x0 = stop
//move 01 = forward
//move 11 = backward
module motor(
input wire clk,
//input wire [7:0]duty,
input wire [1:0]move,
output reg DIR=0,
output reg PWM=0
);
//somewhat like clock division
reg [7:0] counter = 0;
reg [7:0] new_duty = 0;
always_ff@ (posedge clk)
begin 
    if(counter < 100) counter <= counter + 1;
    else counter <= 0;
    DIR <= move[1];
    //new_duty <= duty;
end

always_comb 
begin
    if(move[0])
        //create (duty)% duty cycle at PWM of motor
        PWM = (counter < 20) ? 1:0;
    else
        PWM = 0;
end 

endmodule

module motor_driver(
    input wire clk,
    input wire [2:0]drive,
    output wire PWML,PWMR,DIRL,DIRR,
    output reg nSLPR,nSLPL
);
reg [3:0]move;
always_comb begin
    case(drive)
    3'b000: move = 4'b0000;//0:stop
    3'b001: move = 4'b0101;//1:forward
    3'b010: move = 4'b0111;//2:CW
    3'b011: move = 4'b1101;//3:CCW
    3'b100: move = 4'b1111;//4:reverse
    default: move = 4'b0000;
    endcase
    nSLPR = 1;
    nSLPL = 1; 
end

motor motorL(
.clk(clk),
.move(move[3:2]),
.DIR(DIRL),
.PWM(PWML)
);

motor motorR(
.clk(clk),
.move(move[1:0]),
.DIR(DIRR),
.PWM(PWMR)
);
endmodule