`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 01:08:46
// Design Name: 
// Module Name: terminal_demo
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


module terminal_demo(
    input [15:0] display_out,
    input clk, reset_n,
    
    // Receiver port
    input rd_uart,      // left push button
    output rx_empty,    // LED0
    input rx,           
    
    // Transmitter port
    input [7:0] w_data, // SW0 -> SW7
    input wr_uart,      // right push button
    output tx_full,     // LED1
    output tx,
    
    // Sseg signals
    output [6:0] sseg,
    output [0:7] AN,
    output DP,
    output [7:0] instr,
    output button_debounced
    );
    
    // Push buttons debouncers/synchronizers
    button read_uart(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(rd_uart),
        .debounced(button_debounced),
        .p_edge(rd_uart_pedge),
        .n_edge(),
        ._edge()
    );
    
    button write_uart(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(wr_uart),
        .debounced(),
        .p_edge(wr_uart_pedge),
        .n_edge(),
        ._edge()
    );
        
    // UART Driver
    wire [7:0] r_data;
    uart #(.DBIT(8), .SB_TICK(16)) uart_driver(
        .clk(clk),
        .reset_n(reset_n),
        .r_data(r_data),
        .rd_uart(rd_uart_pedge),
        .rx_empty(rx_empty),
        .rx(rx),
        .w_data(w_data),
        .wr_uart(wr_uart_pedge),
        .tx_full(tx_full),
        .tx(tx),
        .TIMER_FINAL_VALUE(11'd650) // baud rate = 9600 bps
        
    );
    
    assign instr = r_data;
    
    // Seven-Segment Driver
    sseg_driver(
        .clk(clk),
        .reset_n(reset_n),
        .I2({6'b0}),
        .I3({6'b0}),
        .I4({1'b1, display_out[3:0], 1'b0}),
        .I5({1'b1, display_out[7:4], 1'b0}),
        .I6({1'b1, display_out[11:8], 1'b0}),
        .I7({1'b1, display_out[15:12], 1'b0}),
        .I0({~rx_empty, r_data[3: 0], 1'b0}),
        .I1({~rx_empty, r_data[7: 4], 1'b0}),
        .AN(AN),
        .sseg(sseg),
        .DP(DP)
    );
    
endmodule
