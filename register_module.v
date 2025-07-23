`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2024 19:24:33
// Design Name: 
// Module Name: register_module
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


module register_module(
    input    clk, 
    input clock_enable, 
 input    reg_write_en,
 input  [2:0] reg_write_dest,
 input  [15:0] reg_write_data,
 
 input  [2:0] reg_read_addr_1,
 output  [15:0] reg_read_data_1,
 
 input  [2:0] reg_read_addr_2,
 output  [15:0] reg_read_data_2
   
    );
    reg [15:0] register [0:7];
  
 always @ (posedge clk & clock_enable) begin
   if(reg_write_en) begin
    register[reg_write_dest] <= reg_write_data;
   end
 end
 

 assign reg_read_data_1 = register[reg_read_addr_1];
 assign reg_read_data_2 = register[reg_read_addr_2];

endmodule