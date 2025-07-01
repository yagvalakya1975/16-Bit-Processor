`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2024 19:50:59
// Design Name: 
// Module Name: memory_data
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


module data_memory(
    input clk,
    input clock_enable,
    input [5:0] read_address,write_address,
    input read_enable,write_enable,
    input [15:0] data_in,
    output [15:0] data_out
);
    reg [15:0] memory [0:63];
    always @(posedge clk & write_enable & clock_enable) begin
        memory[write_address] <= data_in;
    end
    assign data_out = (read_enable==1'b1)?memory[read_address]:16'b0;
endmodule