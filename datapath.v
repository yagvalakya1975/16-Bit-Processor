`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2024 10:44:12
// Design Name: 
// Module Name: datapath
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


module datapath(
    input reset,
    input button,
    input [7:0] input_instruction,
    input clk, clk_enable,
    input dm_read_enable,dm_write_enable,
    input reg_write_en, alu_imm, display,
    input [1:0] data_to_reg,
    output reg [15:0] display_output,
    output [4:0] opcode,
    output [1:0] type,
    output [15:0] led_ins,
    input pc_butt
    );
    
    reg  [5:0] pc_current;
    wire [5:0] pc_next;
    wire [15:0] accumulator;
    wire [15:0] instruction;
    wire [2:0] reg_read_addr_1, reg_read_addr_2;
    wire [15:0] reg_read_data_1, reg_read_data_2;
    reg [15:0] register_write_data;
    wire [15:0] data_out_dataMemory;
    wire [5:0] data_memory_read_address;
    reg branch_actual;
    wire carry,overflow,bool,zero;
    wire [15:0] alu_second_input; 
    
    // PROGRAM COUNTER
    initial begin
        pc_current <= 6'd0;
    end
    always @(posedge pc_butt) begin
        pc_current <= pc_next;
    end
    
    assign pc_next = branch_actual?instruction[8:3]:(pc_current+1'b1);
    
    
    
    // INSTRUCTION MEMORY
    
    instruction_memory InstructionMemory(clk_enable, reset,clk,
        input_instruction,button,pc_current,
        instruction, led_ins);
    
    assign opcode = instruction[13:9];
    assign type = instruction[15:14];
    
    
    // DATA MEMORY
  
    assign data_memory_read_address = (display==1'b1)?instruction[8:3]:instruction[5:0];
    
    data_memory DataMemory(clk,clk_enable,
    data_memory_read_address,instruction[5:0],
    dm_read_enable,dm_write_enable,
    reg_read_data_1, data_out_dataMemory);
    
    
    // REGISTER
    always @(*) begin
        case (data_to_reg)
            2'b01: register_write_data = data_out_dataMemory; // DATA FROM MEMORY TO REGISTER
            2'b10: register_write_data = accumulator; // DATA FROM ACCUMULATOR TO REGISTER
            2'b11: register_write_data = instruction[5:0]; // IMMEDIATE DATA TO REGISTER
            default: register_write_data = 'b0;
        endcase
    end
    
    assign reg_read_addr_1 = (opcode == 5'b00010 | type == 2'b11 | alu_imm == 1'b1)?instruction[8:6]:instruction[5:3];
    assign reg_read_addr_2 = instruction[2:0];
    
    register_module Registers(clk,clk_enable,
    reg_write_en, instruction[8:6], register_write_data,
    reg_read_addr_1, reg_read_data_1,
    reg_read_addr_2, reg_read_data_2
    );

    // ARITHMETIC LOGIC UNIT
    
    assign alu_second_input = (alu_imm == 1'b0)?reg_read_data_2:{10'b0,instruction[5:0]};

    ALU ALU(clk, clk_enable, type, reg_read_data_1, alu_second_input, instruction[13:9],
    accumulator, carry,overflow,bool,zero);
    
   
    
    // JUMP INSTRUCTIONS
    always @(*) begin
        if (type==2'b10) begin
        case(opcode)
        5'b10100:begin
            case(instruction[2:0])
               3'b000: branch_actual = 1'b1; // UNCONDITIONAL
               3'b001: branch_actual = (bool==1)?1'b1:1'b0; // BOOL
               3'b010: branch_actual = (zero==1)?1'b1:1'b0; // ZERO
               3'b011: branch_actual = (carry==1)?1'b1:1'b0; // CARRY
               3'b100: branch_actual = (overflow==1)?1'b1:1'b0; // OVERFLOW
               default: branch_actual = 1'b0;
            endcase      
        end
        default: branch_actual = 1'b0; 
        endcase
        end
        else branch_actual = 1'b0;
    end
    
    // DISPLAY FUNCTION
    always @(negedge clk & clk_enable) begin
        if (type == 2'b11) begin
            case(opcode)
            5'b10101: display_output <= accumulator; // DISPLAY ACCUMULATOR
            5'b10110: display_output <= reg_read_data_1; // DISPLAY REGISTER
            5'b10111: display_output <= data_out_dataMemory; // DISPLAY MEMORY
            5'b11000: display_output <= {15'b0, bool}; // DISPLAY BOOL VALUE
            5'b11001: display_output <= {10'b0, pc_current};
            default: display_output <= accumulator;
            endcase
        end
    end
    
endmodule