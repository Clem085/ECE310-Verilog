//`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  11/10/2024 8:27:32 PM
//// Design Name:  Serial-In Parallel-Out (SIPO) 8-Bit Register
//// Module1 Name: SIPO
//// Project Name: Lab6: Parallel-Input-Serial-Output (PISO) && Serial-Input-ParallelOutput (SIPO) 8-bit registers.
//// Description:
////  8-Bit SIPO - Serial-In Parallel-Out: SIPO
////      Inputs:
////          serial_in:        1 Bit Input, Serial Input
////          clk:              1 Bit Input, Clock Input
////          rst:              1 Bit Input, Active High Synchronous Reset
////          shift:            1 Bit Input, Active High to Shift Data
////      Outputs:
////          parallel_out:     8 Bit Output, 8-bit Parallel Output (Shifted)
///////////////////////////////////////////////////////////////////////////////////


module SIPO_8bit(
    output reg [7:0] parallel_out,   // 8-bit parallel output
    input serial_in,                 // 1-bit serial input
    input clk,                        // Clock signal
    input rst,                        // Active-high synchronous reset
    input shift                       // Shift control signal
    );

    // 8-bit shift register implemented with D flip-flops
    reg [7:0] shift_reg;

    // Always block triggered on positive edge of clock
    always @(posedge clk) begin
        if (rst) begin
            // Clear shift register on reset
            shift_reg <= 8'b00000000;
        end else if (shift) begin
            // Shift in the serial input at every clock cycle when shift is high
            shift_reg <= {shift_reg[6:0], serial_in};
        end
    end

    // Assign parallel_out to the shift register
    always @(posedge clk) begin
        if (rst)
            parallel_out <= 8'b00000000; // Reset parallel_out to 0
        else if (shift)
            parallel_out <= shift_reg;  // Update parallel_out with shifted value
    end

endmodule
