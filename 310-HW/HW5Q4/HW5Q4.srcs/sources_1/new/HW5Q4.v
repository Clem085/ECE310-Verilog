`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 11:15:37 PM
// Design Name: 
// Module Name: left_shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module left_shifter(
    input [7:0] in,
    input [2:0] N,
    output reg [15:0] out
    );
    
    always @(*) begin
        case (N)
            3'b000: out = {8'b0, in};                 // Shift 0 bits: 00000000 | in
            3'b001: out = {7'b0, in, 1'b0};           // Shift 1 bit:  0000000 | in | 0
            3'b010: out = {6'b0, in, 2'b00};          // Shift 2 bits: 000000 | in | 00
            3'b011: out = {5'b0, in, 3'b000};         // Shift 3 bits: 00000 | in | 000
            3'b100: out = {4'b0, in, 4'b0000};        // Shift 4 bits: 0000 | in | 0000
            3'b101: out = {3'b0, in, 5'b00000};       // Shift 5 bits: 000 | in | 00000
            3'b110: out = {2'b0, in, 6'b000000};      // Shift 6 bits: 00 | in | 000000
            3'b111: out = {1'b0, in, 7'b0000000};     // Shift 7 bits: 0 | in | 0000000
            default: out = 16'b0000000000000000;      // Default case (shouldn't occur)
        endcase
    end
endmodule



module left_shifter_tb;

    // Inputs
    reg [7:0] in;      // 8-bit input
    reg [2:0] N;       // 3-bit shift control

    // Output
    wire [15:0] out;   // 16-bit output

    // Instantiate the Unit Under Test (UUT)
    left_shifter uut (
        .in(in),
        .N(N),
        .out(out)
    );

    // Test procedure
    initial begin
        // Apply test vectors
        $display("Starting Testbench...");
        
        // Test case 1: in = 8'b1001_0011, N = 3'b101 (expected out = 16'b0001_0010_0110_0000)
        in = 8'b1001_0011; N = 3'b101;
        #10; // Wait for some time
        $display("Test case 1: in = %b, N = %b, out = %b", in, N, out);
        
        // Test case 2: in = 8'b1101_0110, N = 3'b010 (expected out = 16'b0000_0011_0101_1000)
        in = 8'b1101_0110; N = 3'b010;
        #10; 
        $display("Test case 2: in = %b, N = %b, out = %b", in, N, out);
        
        // Test case 3: in = 8'b0110_1101, N = 3'b001 (expected out = 16'b0000_1101_1010_0000)
        in = 8'b0110_1101; N = 3'b001;
        #10; 
        $display("Test case 3: in = %b, N = %b, out = %b", in, N, out);

        // Test case 4: in = 8'b1010_1010, N = 3'b111 (expected out = 16'b0101_0100_0000_0000)
        in = 8'b1010_1010; N = 3'b111;
        #10;
        $display("Test case 4: in = %b, N = %b, out = %b", in, N, out);

        // Test case 5: in = 8'b0001_1111, N = 3'b000 (expected out = 16'b0000_0000_0001_1111)
        in = 8'b0001_1111; N = 3'b000;
        #10;
        $display("Test case 5: in = %b, N = %b, out = %b", in, N, out);

        $display("Testbench finished.");
    end
endmodule

