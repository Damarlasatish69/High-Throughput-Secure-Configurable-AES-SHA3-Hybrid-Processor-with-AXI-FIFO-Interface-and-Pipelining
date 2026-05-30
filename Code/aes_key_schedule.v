`timescale 1ns/1ps
module aes_key_schedule #(parameter KEY_SIZE=128)(
    input clk, rst,
    input [KEY_SIZE-1:0] key_in,
    output reg [KEY_SIZE-1:0] round_key
);
    // Implement key expansion FSM
    // Optimize LUT/FF by sharing S-box logic
endmodule
