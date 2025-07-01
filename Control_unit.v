`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 03:15:50
// Design Name: 
// Module Name: Control_unit
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


module Control_unit(
    input [4:0] opcode,
    input [1:0] instr_type,
    output reg mem_read_en, mem_write_en, reg_write_en, alu_imm, display,
    output reg [1:0] data_to_reg                  //Branch cases are defined later
    );
    always@ (*) begin
        case(instr_type)
            2'b01:begin  //Load or store
                    casez(opcode)
                        5'b00000:begin //load
                            mem_read_en = 1;
                            mem_write_en = 0;
                            data_to_reg = 2'b01;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b00001:begin //load immediate
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b11;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b00010:begin //store
                            mem_read_en = 0;
                            mem_write_en = 1;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end
                        default:begin
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end               
                    endcase
            end
             2'b00:begin  //Arithmetic and logical
                    casex(opcode)
                        5'b00011:begin //Add
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b00100:begin //Add immediate
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 1;
                            display = 0;
                        end
                        5'b00101:begin //sub
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b00110:begin //sub immediate
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 1;
                            display = 0;
                        end
                        5'b11001: begin // Less than
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b00111:begin //Less than immediate
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            display = 0;
                            alu_imm = 1;
                        end
                        5'b0100x:begin //left and right shift
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b0101x:begin //AND and OR
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b01100:begin //XOR
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b01101:begin //negation
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b01110:begin //MULTIPLY
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b01111:begin //MULTIPLY imm
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b10;
                            reg_write_en = 1;
                            alu_imm = 1;
                            display = 0;
                        end
                        5'b10000:begin //greater
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b10001:begin //greater imm
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 1;
                            display = 0;
                        end
                        5'b10010:begin //equal
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end
                        5'b10011:begin //equal imm
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 1;
                            display = 0;
                        end
                        default:begin
                            mem_read_en = 0;
                            mem_write_en = 0;
                            data_to_reg = 2'b00;
                            reg_write_en = 0;
                            alu_imm = 0;
                            display = 0;
                        end              
                    endcase
            end
            2'b11:begin // DISPLAY  
                mem_write_en = 0;
                data_to_reg = 2'b00;
                alu_imm = 0;
                reg_write_en = 0;
                case (opcode)
                    5'b10101: begin // DISPLAY ACCUMULATOR
                        mem_read_en = 0;
                        display = 1;
                    end
                    5'b10110: begin // DISPLAY REGISTER
                        mem_read_en = 0;
                        display = 1;
                    end
                    5'b10111: begin // DISPLAY DATA MEMORY
                        mem_read_en = 1;
                        display = 1;
                    end
                    5'b11000: begin // DISPLAY BOOL
                        mem_read_en = 0;
                        display = 1;
                    end
                    default: begin
                        mem_write_en = 0;
                        data_to_reg = 2'b00;
                        alu_imm = 0;
                        reg_write_en = 0;
                        mem_read_en = 0;
                        display = 0;
                    end
                endcase
            end
            default: begin
                        mem_write_en = 0;
                        data_to_reg = 2'b00;
                        alu_imm = 0;
                        reg_write_en = 0;
                        mem_read_en = 0;
                        display = 0;
                        end
        endcase
    end
endmodule