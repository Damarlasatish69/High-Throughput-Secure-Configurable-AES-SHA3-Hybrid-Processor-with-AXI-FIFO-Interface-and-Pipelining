`timescale 1ns/1ps
module aes_core #(
    parameter KEY_SIZE = 128,   // 128, 192, 256
    parameter BLOCK_SIZE = 128
)(
    input clk, rst,
    input start,
    input [BLOCK_SIZE-1:0] data_in,
    input [KEY_SIZE-1:0] key_in,
    output reg [BLOCK_SIZE-1:0] data_out,
    output reg done
);

    wire [BLOCK_SIZE-1:0] round_data;
    wire [KEY_SIZE-1:0] round_key;
    
    // Key Scheduler instance
    aes_key_schedule #(.KEY_SIZE(KEY_SIZE)) ks(
        .clk(clk), .rst(rst),
        .key_in(key_in), .round_key(round_key)
    );

    // Pipelined AES rounds
    // ... implement round logic with LUT sharing and pipeline registers for low power

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            done <= 0;
        end else if (start) begin
            // AES encryption pipeline
            data_out <= round_data;
            done <= 1;
        end
    end
endmodule
