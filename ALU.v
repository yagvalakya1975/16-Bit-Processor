`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2024 15:51:34
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk, clk_enable,
    input [1:0] type,
    input [15:0] r1,r2,
    input [4:0] opcode,
    output reg [15:0] accumulator,
    output reg carry,overflow,bool,zero
    );
    
    always @(negedge clk & clk_enable) begin
        if (type==2'b00) begin
        case (opcode)
            5'b00011: begin {carry,accumulator} = r1 + r2; // ADD
                        overflow = (r1[14] & r2[14]) ^ (r1[15] & r2[15]);
                        bool=1'b0;
                        zero = (r1 + r2 == 0)? 1'b1:1'b0;
                      end
            5'b00100: begin 
                        {carry,accumulator} = r1 + r2; // ADD IMMEDIATE
                        overflow = (r1[14] & r2[14]) ^ (r1[15] & r2[15]);
                        bool=1'b0;
                        zero = (r1 + r2 == 0)? 1'b1:1'b0;
                       end
            5'b00101: begin {carry,accumulator} = r1 - r2; // SUBTRACT
                        overflow = (r1[14] & r2[14]) ^ (r1[15] & r2[15]);
                        bool=1'b0;
                        zero = (r1 - r2 == 0)? 1'b1:1'b0;
                      end
            5'b00110: begin 
                        {carry,accumulator} = r1 - r2; // SUBTRACT IMMEDIATE
                        overflow = (r1[14] & r2[14]) ^ (r1[15] & r2[15]);
                        bool=1'b0;
                        zero = (r1 - r2 == 0)? 1'b1:1'b0;
                        end
            5'b01110: begin  // MULTIPLY
                        {carry,accumulator} = r1*r2; 
                        overflow =1'b0 ; 
                        bool=1'b0;
                        zero = (r1*r2 == 0)? 1'b1:1'b0;
                        end
            5'b01111: begin 
                        {carry,accumulator} = r1*r2;  // MULTIPLY IMMEDIATE
                        overflow =1'b0 ; 
                        bool=1'b0;
                        zero = (r1*r2 == 0)? 1'b1:1'b0;
                        end
            5'b10000: begin bool = (r1>r2)?1:0; // R1 > R2
                        accumulator = 'b0;
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
            5'b11001: begin 
                        bool = (r1<r2)?1:0; // R1 < R2
                        accumulator = 'b0;
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
            5'b10001: begin bool = (r1>r2)?1'b1:1'b0; // R1 > IMMEDIATE VALUE
                        accumulator = 'b0;
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
            5'b00111:begin begin bool = (r1<r2)?1'b1:1'b0; // R1 < IMMEDIATE VALUE
                        accumulator = 'b0;
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
                        end
            5'b10010: begin bool = (r1==r2)?1:0; // R1 EQUAL TO R2
                        accumulator = 'b0; 
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
            5'b10011: begin bool = (r1==r2)?1:0;  // R2 EQUALT TO R2 IMMEDIATE
                        accumulator = 'b0; 
                        carry = 1'b0;
                        overflow =1'b0;
                        zero = 1'b0;
                        end
            5'b01000: begin accumulator = r1<<r2; // LEFT SHIFT
                        carry = (r2 >= 1 && r2 <= 5) ? r1[5 - r2 + 1] : 1'b0;
                        overflow = 1'b0;
                        zero = 1'b0;
                        bool= 1'b0;
                        end
            5'b01001: begin accumulator = r1>>r2; // RIGHT SHIFT
                        carry = (r2 >= 1 && r2 <= 5) ? r1[5 - r2 + 1] : 1'b0;
                        overflow = 1'b0;
                        zero = 1'b0;
                        bool= 1'b0;
                        end
            5'b01010: begin accumulator = r1&r2; // BITWISE AND
                         carry = 1'b0;
                         overflow = 1'b0;
                         zero = (r1 & r2 == 0)? 1'b1:1'b0; 
                         bool= 1'b0;  
                        end
            5'b01011: begin accumulator = r1|r2; // BITWISE OR
                         carry = 1'b0;
                         overflow = 1'b0;
                         zero = (r1 | r2 == 0)? 1'b1:1'b0;
                         bool= 1'b0;   
                        end
            5'b01100: begin accumulator = r1^r2; // BITWISE XOR
                         carry = 1'b0;
                         overflow = 1'b0;
                         zero = (r1 ^ r2 == 0)? 1'b1:1'b0;
                         bool= 1'b0;   
                        end
            5'b01101: begin accumulator = ~r1; // NEGATION
                         carry = 1'b0;
                         overflow = 1'b0; 
                         zero = (~r1 == 0)? 1'b1:1'b0; 
                         bool= 1'b0; 
                        end
            default: begin
                         accumulator = 'b0;
                         carry = 1'b0;
                         overflow = 1'b0;
                         zero = 1'b0;
                         bool =1'b0;
                        end
            
        endcase
        end
        end
endmodule