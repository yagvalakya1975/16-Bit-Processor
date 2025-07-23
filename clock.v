`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2024 15:29:46
// Design Name: 
// Module Name: clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock(
    input clock_enable,
    output reg clk
    );
    initial begin
        clk <= 0;
    end
    always begin
        if (clock_enable) begin
        #5 clk = ~clk;
        end
        else clk <= 0;
    end
endmodule
