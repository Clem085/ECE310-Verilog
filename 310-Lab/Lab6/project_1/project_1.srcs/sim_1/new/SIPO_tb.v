`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
// Testbench for SIPO_8bit Module (Serial-In Parallel-Out)
///////////////////////////////////////////////////////////////////////////////////

module SIPO_tb;
    // Testbench signals
    reg serial_in;              // 1-bit serial input
    reg clk;                     // Clock signal
    reg rst;                     // Reset signal
    reg shift;                   // Shift control signal
    wire [7:0] parallel_out;     // 8-bit parallel output

    // Instantiate the SIPO_8bit module
    SIPO_8bit uut (
        .parallel_out(parallel_out),
        .serial_in(serial_in),
        .clk(clk),
        .rst(rst),
        .shift(shift)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate clock with a period of 10ns
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        shift = 0;
        serial_in = 0;

        // Apply reset
        #10;
        rst = 1;  // Assert reset
        #10;
        rst = 0;  // Deassert reset

        // Input 8 bits serially
        #10;
        serial_in = 1; shift = 1;  // Load bit 1
        #10; serial_in = 0; shift = 1;  // Load bit 2
        #10; serial_in = 1; shift = 1;  // Load bit 3
        #10; serial_in = 0; shift = 1;  // Load bit 4
        #10; serial_in = 1; shift = 1;  // Load bit 5
        #10; serial_in = 0; shift = 1;  // Load bit 6
        #10; serial_in = 1; shift = 1;  // Load bit 7
        #10; serial_in = 0; shift = 1;  // Load bit 8

        // Finish simulation after 8 bits have been loaded
        #10;
        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time = %0t | serial_in = %b | parallel_out = %b", $time, serial_in, parallel_out);
    end

endmodule




