`timescale 1ns/1ps
module hmac_sha3 #(parameter HASH_SIZE=512)(
    input clk, rst,
    input start,
    input [127:0] data_in,
    input [127:0] key,
    output reg [HASH_SIZE-1:0] hmac_out,
    output reg done
);
    // HMAC = SHA3(key XOR opad || SHA3(key XOR ipad || message))
endmodule
