`timescale 1ns/1ps
module control_unit(
    input clk, rst, start,
    input [1:0] mode_select, // 00=AES, 01=SHA3, 10=Hybrid
    output reg aes_start, sha_start, done
);
    // FSM to control AES/SHA3 start, pipelining, and done signals
endmodule
