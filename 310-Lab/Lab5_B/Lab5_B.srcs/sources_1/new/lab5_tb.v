`timescale 1ns / 1ps

// Testbench for 8x8 Wallace Multiplier
module wallace_8x8_tb;
    // Inputs
    reg [7:0] a;
    reg [7:0] b;

    // Output
    wire [15:0] prod;

    // Instantiate the Unit Under Test (UUT)
    wallace_8x8 uut (
        .a(a), 
        .b(b), 
        .prod(prod)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;

        // Display Header
        $display("Time\t\t a\t b\t Expected prod\t Actual prod");

        // Test case 1: Both inputs are zero
        a = 8'b00000000; b = 8'b00000000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h0000, prod);

        // Test case 2: a is zero, b is maximum
        a = 8'b00000000; b = 8'b11111111;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h0000, prod);

        // Test case 3: a is maximum, b is zero
        a = 8'b11111111; b = 8'b00000000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h0000, prod);

        // Test case 4: Both inputs are maximum
        a = 8'b11111111; b = 8'b11111111;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'hFE01, prod);

        // Test case 5: Random inputs
        a = 8'b11001100; b = 8'b00110011;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h28A4, prod);     
        
        // Test case 6: a and b are both 128 (halfway point for 8-bit values)
        a = 8'b10000000; b = 8'b10000000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h4000, prod);
        
        // Test case 7: a is 127, b is 128 (testing near halfway with maximum and halfway)
        a = 8'b01111111; b = 8'b10000000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h3F80, prod);
        
        // Test case 8: a is 2, b is 4 (power of two values)
        a = 8'b00000010; b = 8'b00000100;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h0008, prod);
        
        // Test case 9: a is 16, b is 32 (higher power of two values)
        a = 8'b00010000; b = 8'b00100000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h0200, prod);
        
        // Test case 10: a is 64, b is 64 (even higher power of two values)
        a = 8'b01000000; b = 8'b01000000;        #10;
        $display("%0t\t %h\t %h\t %h\t\t %h", $time, a, b, 16'h1000, prod);
        
        // Finish simulation
        $stop;
    end

endmodule
