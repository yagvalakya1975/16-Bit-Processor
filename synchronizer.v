`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 01:08:46
// Design Name: 
// Module Name: synchronizer
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


module synchronizer
    #(parameter STAGES = 2)(
    input clk, reset_n,
    input D,
    output Q
    );
    
    reg [STAGES - 1:0] Q_reg;
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else
            Q_reg <= {D, Q_reg[STAGES - 1:1]};
    end
    
    assign Q = Q_reg[0];
endmodule