`timescale 1ns/1ps
module axi_fifo_interface #(parameter WIDTH=128)(
    input clk, rst,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    input valid_in,
    output reg ready_out
);
    // Simple AXI4/FIFO handshake logic
    // Low-power: enable only when valid_in is high
endmodule
