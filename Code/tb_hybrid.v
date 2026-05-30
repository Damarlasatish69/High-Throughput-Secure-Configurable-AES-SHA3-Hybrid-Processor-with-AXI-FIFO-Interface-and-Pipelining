/*`timescale 1ns/1ps
module tb_hybrid;
    reg clk,rst,start;
    reg [255:0] key_in;
    reg [127:0] data_in;
    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;

    hybrid_top dut(
        .clk(clk), .rst(rst), .start(start),
        .mode_select(2'b10),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done)
    );

    initial begin
        clk=0; forever #5 clk=~clk;
    end

    initial begin
        rst=1; start=0; key_in=256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        data_in=128'h0123456789abcdef0123456789abcdef;
        #20 rst=0;
        #10 start=1;
        #10 start=0;
        #1000 $finish;
    end
endmodule*/

/*`timescale 1ns/1ps
module tb_hybrid;

    reg clk, rst, start;
    reg [1:0] mode_select;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;

    integer i;

    // Instantiate top module
    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode_select(mode_select),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done)
    );

    // ----------------------------
    // Clock generation
    // ----------------------------
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns period

    // ----------------------------
    // Test stimulus
    // ----------------------------
    initial begin
        rst = 1; start = 0; mode_select = 2'b10;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        data_in = 128'h0123456789abcdef0123456789abcdef;

        #20 rst = 0;
        #10 start = 1;
        #10 start = 0;

        // Wait until done
        wait(done == 1);

        // Print outputs in decimal to TCL console
        $display("----- AES + SHA3 Simulation Result -----");
        $display("Data Out (AES ciphertext in decimal) = %0d", data_out);
        // Print hash in decimal in 128-bit chunks for readability
        for(i=0; i<4; i=i+1) begin
            $display("Hash Chunk %0d (SHA3 in decimal) = %0d", i, hash_out[(i+1)*128-1 -:128]);
        end

        #10 $finish;
    end

endmodule*/
/*`timescale 1ns/1ps
module tb_hybrid;

    reg clk, rst, start, valid_in;
    reg [1:0] mode_select;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;
    wire ready_out;

    integer i;

    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .mode_select(mode_select),
        .key_in(key_in),
        .data_in(data_in),
        .valid_in(valid_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done),
        .ready_out(ready_out)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        rst = 1; start = 0; valid_in = 0; mode_select = 2'b10;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        #20 rst = 0;
        #10 start = 1;

        // Feed 5 data blocks
        for (i = 0; i < 5; i = i+1) begin
            @(posedge clk);
            if (ready_out) begin
                data_in = 128'h11111111111111110000000000000000 + i;
                valid_in = 1;
            end
            @(posedge clk);
            valid_in = 0;

            // Wait for done signal
            wait(done == 1);
            #1; // small delay

            // Print outputs in decimal
            $display("Block %0d:", i);
            $display("Data Out (AES decimal) = %0d", data_out);
            $display("SHA3 Hash Chunks (decimal):");
            $display("Chunk 0: %0d", hash_out[127:0]);
            $display("Chunk 1: %0d", hash_out[255:128]);
            $display("Chunk 2: %0d", hash_out[383:256]);
            $display("Chunk 3: %0d", hash_out[511:384]);
            $display("------------------------------");
        end

        #10 $finish;
    end
endmodule*/

/*`timescale 1ns/1ps
module tb_hybrid;

    reg clk, rst, start, valid_in;
    reg [1:0] mode_select;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;
    wire ready_out;

    integer i;

    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .valid_in(valid_in),
        .mode_select(mode_select),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done),
        .ready_out(ready_out)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1; start = 0; valid_in = 0; mode_select = 2'b10;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;

        #20 rst = 0;
        #10 start = 1;

        // Feed 5 data blocks
        for (i=0; i<5; i=i+1) begin
            @(posedge clk);
            if (ready_out) begin
                data_in = 128'h11111111111111110000000000000000 + i;
                valid_in = 1;
            end
            @(posedge clk);
            valid_in = 0;

            // Wait until done pulses
            wait(done == 1);
            @(posedge clk); // move to next cycle

            // Print decimal outputs
            $display("Block %0d:", i);
            $display("Data Out (AES decimal) = %0d", data_out);
            $display("SHA3 Hash Chunks (decimal):");
            $display("Chunk 0: %0d", hash_out[127:0]);
            $display("Chunk 1: %0d", hash_out[255:128]);
            $display("Chunk 2: %0d", hash_out[383:256]);
            $display("Chunk 3: %0d", hash_out[511:384]);
            $display("------------------------------");
        end

        #10 $finish;
    end
endmodule*/

/*`timescale 1ns/1ps
module tb_hybrid;

    reg clk, rst, valid_in;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;
    wire ready_out;

    integer i;
    integer block_count; // Tracks processed blocks

    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done),
        .ready_out(ready_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;
        valid_in = 0;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        data_in = 0;
        block_count = 0;

        #20 rst = 0;

        // Feed 5 data blocks
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            if (ready_out) begin
                data_in = 128'h11111111111111110000000000000000 + i;
                valid_in = 1;
            end
            @(posedge clk);
            valid_in = 0;
        end
    end

    // Monitor processed blocks and display outputs
    always @(posedge clk) begin
        if (done) begin
            $display("Block %0d:", block_count);
            $display("Data Out (AES decimal) = %0d", data_out);
            $display("SHA3 Hash Chunks (decimal):");
            $display("Chunk 0: %0d", hash_out[127:0]);
            $display("Chunk 1: %0d", hash_out[255:128]);
            $display("Chunk 2: %0d", hash_out[383:256]);
            $display("Chunk 3: %0d", hash_out[511:384]);
            $display("------------------------------");
            block_count = block_count + 1;
        end
    end

    // Finish simulation after all blocks processed
    initial begin
        #200 $finish;
    end
endmodule*/

/*`timescale 1ns/1ps
module tb_hybrid;////////////////////////////

    reg clk, rst, valid_in;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;
    wire ready_out;

    integer i;

    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done),
        .ready_out(ready_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        rst = 1;
        valid_in = 0;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        data_in = 0;

        #20 rst = 0;

        // Feed 5 data blocks
        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            if (ready_out) begin
                data_in = 128'h11111111111111110000000000000000 + i;
                valid_in = 1;
            end
            @(posedge clk);
            valid_in = 0;

            // Wait until done pulses
            wait(done == 1);
            @(posedge clk);

            // Display outputs
            $display("Block %0d:", i);
            $display("Data Out (AES decimal) = %0d", data_out);
            $display("SHA3 Hash Chunks (decimal):");
            $display("Chunk 0: %0d", hash_out[127:0]);
            $display("Chunk 1: %0d", hash_out[255:128]);
            $display("Chunk 2: %0d", hash_out[383:256]);
            $display("Chunk 3: %0d", hash_out[511:384]);
            $display("------------------------------");
        end

        #10 $finish;
    end//////////////////////////
endmodule*/


`timescale 1ns/1ps
module tb_hybrid;

    reg clk, rst, valid_in;
    reg [255:0] key_in;
    reg [127:0] data_in;

    wire [127:0] data_out;
    wire [511:0] hash_out;
    wire done;
    wire ready_out;

    integer i;

    hybrid_top dut(
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .key_in(key_in),
        .data_in(data_in),
        .data_out(data_out),
        .hash_out(hash_out),
        .done(done),
        .ready_out(ready_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        rst = 1; valid_in = 0;
        key_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
        data_in = 128'h0;

        #20 rst = 0;

        for (i = 0; i < 5; i = i + 1) begin
            @(posedge clk);
            if (ready_out) begin
                data_in = 128'h11111111111111110000000000000000 + i;
                valid_in = 1;
            end
            @(posedge clk);
            valid_in = 0;

            wait(done == 1);
            @(posedge clk);

            $display("Block %0d:", i);
            $display("Data Out (AES decimal) = %0d", data_out);
            $display("SHA3 Hash Chunks (decimal):");
            $display("Chunk 0: %0d", hash_out[127:0]);
            $display("Chunk 1: %0d", hash_out[255:128]);
            $display("Chunk 2: %0d", hash_out[383:256]);
            $display("Chunk 3: %0d", hash_out[511:384]);
            $display("------------------------------");
        end

        #10 $finish;
    end
endmodule
