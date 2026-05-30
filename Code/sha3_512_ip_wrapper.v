module sha3_512_core (
    input clk,
    input rst,
    input start,
    input [127:0] din,
    output reg [511:0] dout,
    output reg done
);
    // Dummy SHA3 for demonstration: replicate input
    reg [511:0] sha_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sha_reg <= 0;
            dout <= 0;
            done <= 0;
        end else if (start) begin
            sha_reg <= {din, din, din, din}; // replicate input
            dout <= sha_reg;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
