`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2024 19:57:34
// Design Name: 
// Module Name: memory_instruction
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


module instruction_memory(
    input clk_enable,
    input reset,
    input clk,
    input [7:0] instruction,
    input button,
    input [5:0] read_address,
    output reg [15:0] instruction_out,
    output [15:0] led_ins
);
    reg [1:0] state, next_state;
    reg [15:0] memory [0:63];
    reg [5:0] counter; 
    
    initial begin
        state <= 0;
        counter <= 0;
    end
    
    always @(*)begin
        case (state)
            2'b00: next_state <= 2'b01;
            2'b01: next_state <= 2'b10;
            2'b10: next_state <= 2'b00;
        endcase
    end
    
    always @(posedge button ,negedge reset) begin
            if(reset==0)
            begin
            state<=0;
            counter<=0;
            end
            else
                begin
                if (state == 2'b00) begin
                    memory[counter] <= {instruction[5:0],10'b0};
                    state <= next_state;
                end
                else if (state == 2'b01) begin
                    memory[counter] <= memory[counter]|{6'b0,instruction[5:0],4'b0};
                    state <= next_state;
                end
                else if (state == 2'b10) begin
                    memory[counter] <= memory[counter]|{12'b0,instruction[3:0]};
                    counter <= counter + 1;
                    state <= next_state;
                end
              
                //in0 <= {state,14'b000000000001111};
            end
    end
    
    
     
// initial
// begin
//    memory[0] = 16'b01_00001_000_000001; // LOAD 16 IN R0
//    memory[1] = 16'b01_00001_001_000001; // LOAD 1 IN R1
//    memory[2] = 16'b00_01110_010_001_001; // SQUARE R1 STORE IN R2
//    memory[3] = 16'b00_10000_011_010_000; 
//    memory[4] = 16'b10_10100_000111_001;// BRANCH TO 7 IF R0<R2
//    memory[5] = 16'b00_00100_001_000001; // R1++
//    memory[6] = 16'b10_10100_000010_000; // UNCONDITIONAL JUMP TO 2
//    memory[7] = 16'b00_00110_001_000001; // R1--
//    memory[8] = 16'b11_10110_001_111111; // DISPLAY R1
// end
    
    always @(posedge clk & clk_enable) begin
        instruction_out = memory[read_address];
    end
    
    //assign instruction_out = memory[read_address];
    
    assign led_ins = memory[counter];
    
endmodule