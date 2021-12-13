`timescale 1ns / 1ps

module controller(
input wire clk,rst,start,
input wire [5:0]bmp,
output reg [2:0]drive
    );
parameter SEC=3000000;//time divition for counter to manage how long the motors run
//mask bits that are used to check bumper switches for certain situations
parameter ouchR = 6'b000111;
parameter ouchL = 6'b111000;
parameter ouchF = 6'b001100;// rarely hits the bumpers like this but i included it just in case

reg [31:0] timer,nxt_timer;//keeps track of real time
reg [5:0] bump,new_bump;//store the bumper switch input for a while when switching states

//states    
enum {idle,forward,reverse,right,left,turnaround} curr,nxt;

//state and variable updates
always_ff @(posedge clk) begin
    if(rst) begin
        timer <= 0;
        curr <= idle;
        bump <= 0;
    end
    else begin
        timer <= nxt_timer;
        curr <= nxt; 
        bump <= new_bump;
    end   
end

//nxt & curr state logic
// states have self explanatory names with respect to robot movement direction
always_comb begin
    nxt = curr;
    nxt_timer = timer;
    new_bump = bump;
    unique case(curr)
    idle: begin
        drive = 0;
        if(start) nxt = forward;
    end 
    forward: begin
        drive = 1;
        if(!bmp[0] || !bmp[1] || !bmp[2] || !bmp[3] || !bmp[4] || !bmp[5])begin
            nxt = reverse;
            nxt_timer = 3 * SEC;
            new_bump = ~bmp;
        end 
    end
    reverse: begin
        drive = 4;
        if(timer == 0)begin
            if(bump & ouchF) begin
                nxt_timer = 4 * SEC;
                nxt = turnaround;
            end
            else if(bump & ouchR) begin
                nxt_timer = 2 * SEC;
                nxt = left;
            end
            else if(bump & ouchL) begin
                nxt_timer = 2 * SEC;
                nxt = right;
            end
        end
        else begin 
            nxt_timer = timer - 1;
        end 
    end
    right: begin
        drive = 2;
        if(timer == 0) begin
            nxt = forward;
        end
        else nxt_timer = timer - 1;
    end
    left: begin
        drive = 3;
        if(timer == 0) begin
            nxt = forward;
        end
        else nxt_timer = timer - 1;
    end
    turnaround: begin
        drive = 2;
        if(timer == 0) begin
            nxt = forward;
        end
        else nxt_timer = timer - 1;
    end
    endcase
end
endmodule
