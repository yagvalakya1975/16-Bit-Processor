`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2024 18:12:50
// Design Name: 
// Module Name: Top_processor
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


module Top_processor(
    input reset,
    input clk, clk_enable,
    input [7:0] input_instruction,
    input button,
    output [15:0] display_output,
    output [15:0] led_ins,
    input pc_butt
    );
    
    wire [4:0] opcode;
    wire [1:0] type; 
    wire mem_read_en, mem_write_en, reg_write_en, alu_imm;
    wire [1:0] data_to_reg;
    wire display;
    
    datapath DataPath(reset, button,input_instruction,clk, clk_enable,
    mem_read_en, mem_write_en,
    reg_write_en, alu_imm, display,data_to_reg,
    display_output, opcode, type, led_ins, pc_butt);
    
    Control_unit ControlUnit(opcode, type, mem_read_en, mem_write_en, reg_write_en, alu_imm, display, data_to_reg);
endmodule