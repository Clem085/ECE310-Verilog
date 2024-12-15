`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
// Testbench for 8-Bit PISO (Parallel-Input-Serial-Output) Module
///////////////////////////////////////////////////////////////////////////////////
module PSIO_tb;
    // Testbench signals
    reg [7:0] parallel_in;   // 8-bit parallel input
    reg clk;                  // Clock signal
    reg rst;                  // Reset signal
    reg load;                 // Load signal
    reg shift;                // Shift signal
    wire serial_out;          // 1-bit serial output
    // Instantiate the PSIO_8bit module
    PSIO_8bit uut (
        .serial_out(serial_out),
        .parallel_in(parallel_in),
        .clk(clk),
        .rst(rst),
        .load(load),
        .shift(shift)
    );
    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate a clock with a period of 10ns
    end
    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        load = 0;
        shift = 0;
        parallel_in = 8'b10101010; // Example parallel input data

        // Apply reset
        #10;
        rst = 1;  // Assert reset
        #10;
        rst = 0;  // Deassert reset

        // Load the parallel input into the shift register
        load = 1;
        #10; // Wait for one clock cycle
        load = 0;

        // Shift the data serially
        shift = 1;
        #10; // Shift 1st bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 2nd bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 3rd bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 4th bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 5th bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 6th bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 7th bit
        shift = 0;
        #10;
        shift = 1;
        #10; // Shift 8th bit
        shift = 0;
        #10;
        // Finish simulation
        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time = %0t | parallel_in = %b | serial_out = %b", $time, parallel_in, serial_out);
    end

endmodule
