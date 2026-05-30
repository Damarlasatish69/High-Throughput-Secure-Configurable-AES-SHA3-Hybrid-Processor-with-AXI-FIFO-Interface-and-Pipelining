`timescale 1ns/1ps
module pipeliner #(parameter WIDTH=128, DEPTH=4)(
    input clk, rst,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out
);
    reg [WIDTH-1:0] pipeline_reg[0:DEPTH-1];
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) for (i=0;i<DEPTH;i=i+1) pipeline_reg[i]<=0;
        else begin
            pipeline_reg[0]<=data_in;
            for(i=1;i<DEPTH;i=i+1) pipeline_reg[i]<=pipeline_reg[i-1];
        end
    end
    assign data_out=pipeline_reg[DEPTH-1];
endmodule
