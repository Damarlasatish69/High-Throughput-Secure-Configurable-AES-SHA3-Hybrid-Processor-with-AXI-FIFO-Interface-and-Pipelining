`timescale 1ns/1ps
module utils;

    // 1. Multiplexer (parameterized)
    function [WIDTH-1:0] mux2;
        parameter WIDTH=128;
        input [WIDTH-1:0] a, b;
        input sel;
        begin
            mux2 = sel ? b : a;
        end
    endfunction

    // 2. XOR Mask Generator for side-channel attack resistance
    function [WIDTH-1:0] random_mask;
        parameter WIDTH=128;
        input [31:0] seed;
        integer i;
        reg [WIDTH-1:0] mask;
        begin
            for(i=0;i<WIDTH;i=i+1)
                mask[i] = $urandom(seed) % 2;
            random_mask = mask;
        end
    endfunction

    // 3. Parameterized register bank
    module reg_bank #(parameter WIDTH=128, DEPTH=4)(
        input clk, rst,
        input [WIDTH-1:0] data_in,
        output [WIDTH-1:0] data_out
    );
        reg [WIDTH-1:0] regs[0:DEPTH-1];
        integer i;
        always @(posedge clk or posedge rst) begin
            if(rst) for(i=0;i<DEPTH;i=i+1) regs[i]<=0;
            else begin
                regs[0]<=data_in;
                for(i=1;i<DEPTH;i=i+1) regs[i]<=regs[i-1];
            end
        end
        assign data_out=regs[DEPTH-1];
    endmodule

endmodule
