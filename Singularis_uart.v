`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2024 00:15:16
// Design Name: 
// Module Name: Singularis_uart
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


module Singularis_uart(
    input clk, clk_en, reset_n,
    //input rd_uart,
    input rx,           

    input [7:0] w_data, 
    input wr_uart, 
    
    output tx_full,
    output rx_empty,    
    output tx,

    output [6:0] sseg,
    output [0:7] AN,
    output DP,
    //output [15:0] display_out,
    output clk_en_out,
    output [15:0] led_ins,
    input pc_butt
    );
    assign clk_en_out = clk_en;
    reg [24:0] count_slow;
    wire [7:0] instr;
   // reg [19:0] count_slow_reg, count_slow_next;
    wire clock_slow;
    wire [15:0] display_out;
    wire rx_empty_wire;
    Top_processor Top_g(reset_n, clk, clk_en, instr, button_debounced, display_out,led_ins, pc_butt);
    terminal_demo uart(display_out ,clk, reset_n, clock_slow, rx_empty_wire, rx, w_data, wr_uart ,tx_full ,tx ,sseg ,AN ,DP ,instr,button_debounced);
    
    
    assign rx_empty = rx_empty_wire;
    /*clk_wiz_0 CLK
   (
    // Clock out ports
    .clk_out1(clk_new),     // output clk_out1
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
    ); */
    
    
    /*initial begin 
        count_slow_reg <= 0;
    end
    
    always@(*) begin
        count_slow_reg <= count_slow_next;
    end
    
    always@(posedge clk) begin
        count_slow_next = count_slow_reg + 1;
    end
    
    assign slow_clk = count_slow_reg[19];*/
    initial begin
        count_slow = 0;
    end
    
    always@(posedge clk) begin
        if(rx_empty_wire == 0)begin
            count_slow <= count_slow + 1; 
            // clock_slow <= ~clock_slow;
        end
    end
    assign slow_clk_led = clock_slow;
    assign clock_slow = count_slow[24];
endmodule
