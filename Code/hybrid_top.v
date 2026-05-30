/*`timescale 1ns/1ps
module hybrid_top(
    input clk, rst, start,
    input [1:0] mode_select,
    input [255:0] key_in,
    input [127:0] data_in,
    output [127:0] data_out,
    output [511:0] hash_out,
    output done
);
    wire aes_done, sha_done;
    wire [127:0] aes_out;
    wire [511:0] sha_out;

    aes_core #(.KEY_SIZE(256)) aes_inst(
        .clk(clk), .rst(rst), .start(start),
        .data_in(data_in), .key_in(key_in[255:0]),
        .data_out(aes_out), .done(aes_done)
    );

    sha3_core #(.HASH_SIZE(512)) sha_inst(
        .clk(clk), .rst(rst), .start(aes_done),
        .data_in(aes_out), .hash_out(sha_out), .done(sha_done)
    );

    assign data_out = aes_out;
    assign hash_out = sha_out;
    assign done = sha_done;
endmodule*/


/*`timescale 1ns/1ps
module hybrid_top(
    input clk, rst, start,
    input [1:0] mode_select,     // 00=AES, 01=SHA3, 10=Hybrid
    input [255:0] key_in,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done
);

    reg [127:0] aes_out;
    reg [511:0] sha_out;
    reg aes_done, sha_done;

    // ----------------------------
    // Dummy AES: XOR input with key
    // ----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            aes_out <= 0;
            aes_done <= 0;
        end else if (start) begin
            aes_out <= data_in ^ key_in[127:0]; // Dummy AES logic
            aes_done <= 1;
        end else begin
            aes_done <= 0;
        end
    end

    // ----------------------------
    // Dummy SHA3: XOR AES output with constant
    // ----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sha_out <= 0;
            sha_done <= 0;
        end else if (aes_done) begin
            sha_out <= {aes_out, aes_out, aes_out, aes_out}; // Dummy SHA3
            sha_done <= 1;
        end else begin
            sha_done <= 0;
        end
    end

    // Assign outputs
    always @(*) begin
        data_out = aes_out;
        hash_out = sha_out;
        done = sha_done;
    end

endmodule*/

/*`timescale 1ns/1ps
module hybrid_top(
    input clk, rst,
    input start,
    input [1:0] mode_select,
    input [255:0] key_in,
    input [127:0] data_in,
    input valid_in,            // Indicates input data is valid
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done,
    output reg ready_out       // Ready for next input
);

    reg [127:0] aes_out;
    reg [511:0] sha_out;
    reg aes_done, sha_done;
    reg processing;

    // Latch inputs
    reg [127:0] data_reg;
    reg [255:0] key_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            aes_out <= 0; sha_out <= 0; data_out <= 0; hash_out <= 0;
            aes_done <= 0; sha_done <= 0; done <= 0; processing <= 0;
            ready_out <= 1;
        end else if (valid_in && ready_out) begin
            // Latch input for processing
            processing <= 1;
            data_reg <= data_in;
            key_reg <= key_in;
            ready_out <= 0; // Not ready until processing done
        end else if (processing) begin
            // Dummy AES: XOR input with lower 128-bit key
            aes_out <= data_reg ^ key_reg[127:0];
            aes_done <= 1;

            // Dummy SHA3: replicate AES output
            sha_out <= {aes_out, aes_out, aes_out, aes_out};
            sha_done <= 1;

            // Update outputs
            data_out <= aes_out;
            hash_out <= sha_out;
            done <= 1;

            processing <= 0;
        end else begin
            done <= 0;
            ready_out <= 1; // Ready for next input
        end
    end

endmodule*/

/*`timescale 1ns/1ps
module hybrid_top(
    input clk, rst,
    input start,
    input valid_in,
    input [1:0] mode_select,
    input [255:0] key_in,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done,
    output reg ready_out
);

    // Internal registers
    reg [127:0] data_reg;
    reg [255:0] key_reg;
    reg processing;

    reg [127:0] aes_out;
    reg [511:0] sha_out;

    // Initialize
    initial begin
        done = 0;
        ready_out = 1;
        processing = 0;
        data_out = 0;
        hash_out = 0;
        aes_out = 0;
        sha_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            processing <= 0;
            done <= 0;
            ready_out <= 1;
            aes_out <= 0;
            sha_out <= 0;
            data_out <= 0;
            hash_out <= 0;
        end else begin
            done <= 0; // clear done each cycle

            if (valid_in && ready_out) begin
                // Latch inputs
                data_reg <= data_in;
                key_reg <= key_in;
                processing <= 1;
                ready_out <= 0;
            end

            if (processing) begin
                // Dummy AES: XOR input with lower 128-bit key
                aes_out <= data_reg ^ key_reg[127:0];

                // Dummy SHA3: replicate AES output
                sha_out <= {aes_out, aes_out, aes_out, aes_out};

                // Update outputs
                data_out <= aes_out;
                hash_out <= sha_out;

                done <= 1;
                processing <= 0;
                ready_out <= 1;
            end
        end
    end

endmodule*/

/*`timescale 1ns/1ps
module hybrid_top(
    input clk,
    input rst,
    input valid_in,
    input [255:0] key_in,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done,
    output reg ready_out
);

    // Internal registers
    reg [127:0] data_reg;
    reg [255:0] key_reg;
    reg [127:0] aes_stage;      // AES output register
    reg processing;

    // Initialize outputs
    initial begin
        data_out = 0;
        hash_out = 0;
        done = 0;
        ready_out = 1;
        processing = 0;
        aes_stage = 0;
        data_reg = 0;
        key_reg = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 0;
            key_reg <= 0;
            aes_stage <= 0;
            data_out <= 0;
            hash_out <= 0;
            processing <= 0;
            done <= 0;
            ready_out <= 1;
        end else begin
            done <= 0; // default

            // Latch inputs if ready
            if (valid_in && ready_out) begin
                data_reg <= data_in;
                key_reg <= key_in;
                processing <= 1;
                ready_out <= 0;
            end

            // Compute AES
            if (processing) begin
                aes_stage <= data_reg ^ key_reg[127:0]; // Dummy AES
                processing <= 0;
                done <= 1;
                ready_out <= 1;
            end

            // Update outputs
            data_out <= aes_stage;
            hash_out <= {aes_stage, aes_stage, aes_stage, aes_stage}; // Dummy SHA3
        end
    end
endmodule*/
/*`timescale 1ns/1ps
module hybrid_top(
    input clk,
    input rst,
    input valid_in,
    input [255:0] key_in,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done,
    output reg ready_out
);

    // Parameters
    localparam AES_STAGES = 4;  // number of pipeline stages

    // Pipeline registers
    reg [127:0] aes_pipe [0:AES_STAGES-1];
    reg [127:0] data_pipe [0:AES_STAGES-1];
    reg [255:0] key_pipe [0:AES_STAGES-1];
    reg [AES_STAGES-1:0] valid_pipe;

    integer i;

    // Initialize
    initial begin
        data_out = 0;
        hash_out = 0;
        done = 0;
        ready_out = 1;
        for (i=0; i<AES_STAGES; i=i+1) begin
            aes_pipe[i] = 0;
            data_pipe[i] = 0;
            key_pipe[i] = 0;
            valid_pipe[i] = 0;
        end
    end

    // Pipeline logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            ready_out <= 1;
            data_out <= 0;
            hash_out <= 0;
            for (i=0; i<AES_STAGES; i=i+1) begin
                aes_pipe[i] <= 0;
                data_pipe[i] <= 0;
                key_pipe[i] <= 0;
                valid_pipe[i] <= 0;
            end
        end else begin
            done <= 0;

            // Shift pipeline
            for (i=AES_STAGES-1; i>0; i=i-1) begin
                aes_pipe[i] <= aes_pipe[i-1];
                data_pipe[i] <= data_pipe[i-1];
                key_pipe[i] <= key_pipe[i-1];
                valid_pipe[i] <= valid_pipe[i-1];
            end

            // Insert new input at stage 0
            if (valid_in && ready_out) begin
                data_pipe[0] <= data_in;
                key_pipe[0] <= key_in;
                aes_pipe[0] <= data_in ^ key_in[127:0]; // dummy AES
                valid_pipe[0] <= 1;
                ready_out <= 0;
            end else begin
                valid_pipe[0] <= 0;
            end

            // Update output when last stage is valid
            if (valid_pipe[AES_STAGES-1]) begin
                data_out <= aes_pipe[AES_STAGES-1];
                hash_out <= {aes_pipe[AES_STAGES-1], aes_pipe[AES_STAGES-1],
                             aes_pipe[AES_STAGES-1], aes_pipe[AES_STAGES-1]}; // dummy SHA3
                done <= 1;
                ready_out <= 1;
            end
        end
    end///////////////////////////////////////
endmodule*/


`timescale 1ns/1ps
module hybrid_top(
    input clk,
    input rst,
    input valid_in,
    input [255:0] key_in,
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [511:0] hash_out,
    output reg done,
    output reg ready_out
);

    // Internal signals
    reg aes_start, sha_start;
    wire [127:0] aes_out;
    wire [511:0] sha_out;
    wire aes_done, sha_done;
    reg processing;

    // Clock enable signals for low-power
    reg aes_ce, sha_ce;

    // Instantiate AES and SHA3 cores with enable
    aes256_core aes_inst (
        .clk(clk),
        .rst(rst),
        .start(aes_start),
        .key(key_in),
        .din(data_in),
        .dout(aes_out),
        .done(aes_done)
    );

    sha3_512_core sha_inst (
        .clk(clk),
        .rst(rst),
        .start(sha_start),
        .din(aes_out),
        .dout(sha_out),
        .done(sha_done)
    );

    // Control logic with low-power enable
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            aes_start <= 0;
            sha_start <= 0;
            processing <= 0;
            data_out <= 0;
            hash_out <= 0;
            done <= 0;
            ready_out <= 1;
            aes_ce <= 0;
            sha_ce <= 0;
        end else begin
            done <= 0;

            // Start AES only when valid input and ready
            if (valid_in && ready_out) begin
                aes_start <= 1;
                aes_ce <= 1;
                processing <= 1;
                ready_out <= 0;
            end else begin
                aes_start <= 0;
                aes_ce <= 0;
            end

            // Start SHA3 only after AES is done
            if (processing) begin
                if (aes_done) begin
                    sha_start <= 1;
                    sha_ce <= 1;
                end else begin
                    sha_start <= 0;
                    sha_ce <= 0;
                end

                // Once SHA3 is done, update outputs
                if (sha_done) begin
                    data_out <= aes_out;
                    hash_out <= sha_out;
                    done <= 1;
                    processing <= 0;
                    ready_out <= 1;
                    sha_ce <= 0;
                end
            end
        end
    end

endmodule
