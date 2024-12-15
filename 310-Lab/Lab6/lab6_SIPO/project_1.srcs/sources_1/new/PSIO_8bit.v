`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  11/10/2024 8:24:08 PM
//// Design Name:  Parallel-Input-Serial-Output (PISO) 8-Bit Register
//// Module1 Name: PISO
//// Project Name: Lab6: Parallel-Input-Serial-Output (PISO) && Serial-Input-ParallelOutput (SIPO) 8-bit registers.
//// Description:
////  8-Bit PSIO - Parallel-Input-Serial-Output: PISO
////      Inputs:
////          parallel_in:      8 Bit Input, 8 Bit Parrallel In
////          clk:              1 Bit Input, Clock Input
////          rst:              1 Bit Input, Active High Synchronous Reset
////          load:             1 Bit Input, Active High to Load Parallel Data
////          shift:            1 Bit Input, Active High to Shift Data
////      Output:
////          serial_out:       1 Bit Output, Serial Out
///////////////////////////////////////////////////////////////////////////////////

////  8-Bit PISO
module PISO_8bit(
    output reg serial_out,   // 1-bit serial output
    input [7:0] parallel_in, // 8-bit parallel input
    input clk,               // Clock input
    input rst,               // Reset input
    input load,              // Load data signal
    input shift              // Shift data signal
    );

    reg [7:0] shift_reg; // Shift register to hold the parallel data

    // Shift register logic with load and shift capabilities
    always @(posedge clk)
    begin
        if (rst) 
            shift_reg <= 8'b00000000; // Reset shift register to 0
        else if (load) 
            shift_reg <= parallel_in; // Load parallel data into shift register
        else if (shift) 
            shift_reg <= {1'b0, shift_reg[7:1]}; // Shift data left by 1 (serialize)
    end

    // Assign the serial output to the least significant bit (LSB) of the shift register
    always @(posedge clk)
    begin
        if (rst)
            serial_out <= 1'b0;  // Reset serial output
        else if (shift)
            serial_out <= shift_reg[0]; // Output the LSB of shift register
    end
endmodule

///////////////////////////////////////////////////////////////////////////////////
////  Deprecated Code, forgot this lab may be implemented at any design level  ////
///////////////////////////////////////////////////////////////////////////////////
// D-Flip Flops
//// 1-Bit DFF
module dff_1bit(
    output reg q,
    input d,
    input rst,
    input clk
    );
    always @(posedge clk)
    begin
        if (rst)
            q <= 1'b0; // Reset output
        else
            q <= d;    // Latch input data
    end
endmodule

//// 8-Bit DFF
module dff_8bit(
    output reg [7:0] q,
    input [7:0] d,
    input rst,
    input clk
    );
    always @(posedge clk)
    begin
        if (rst)
            q <= 8'b00000000; // Reset to 0
        else
            q <= d; // Latch 8-bit input
    end
endmodule

///////////////////////////////////////////////////////////////////////////////////
// Multiplexer, MUX
//// 8-to-1 Multiplexer, MUX
module mux_8to1 (
    output [7:0] mux_out,    // 8-bit output
    input [2:0] op,          // 3-bit select input
    input [7:0] A, B, C, D, E, F, G, H  // 8-bit inputs
);
    // Assign the output based on the select input
    assign mux_out = (op == 3'b000) ? A :
                     (op == 3'b001) ? B :
                     (op == 3'b010) ? C :
                     (op == 3'b011) ? D :
                     (op == 3'b100) ? E :
                     (op == 3'b101) ? F :
                     (op == 3'b110) ? G :
                     (op == 3'b111) ? H : 8'b00000000; // Default to 0 if op is invalid
endmodule
