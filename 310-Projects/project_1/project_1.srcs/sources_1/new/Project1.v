`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  10/20/2024 9:30:08 AM
//// Design Name:  Project 1
//// Module1 Name: Project1
//// Project Name: Project1
//// Description:
////  Full Adder: full_adder_struct
////      Inputs:
////          A:      1 Bit Input, Binary Input #1
////          B:      1 Bit Input, Binary Input #2 
////          Cin:    1 Bit Input, Carry In Bit
////      Output:
////          S:      1 Bit Output, Binary Sum Bit
////          Cout:   1 Bit Output, Carry Out Bit
////
////  8-Bit RCA - Ripple Carry Adder: rca_8bit
////      Inputs:
////          A:      8 Bit Bus Input, Binary Input #1
////          B:      8 Bit Bus Input, Binary Input #2 
////          Cin:    8 Bit Bus Input, Carry In Bit
////      Output:
////          S:      8 Bit But Output, Binary Sum
////          Cout:   1 Bit Output, Carry Out Bit
////
////  Project 1 Module: Project1
////      Inputs:
////          reset_n:  1 Bit Input, Active-low synchronous reset
////          clock:    1 Bit Input, Free-running clock
////          d_in:     8 Bit Input, 8-bit unsigned input
////          op:       2 Bit Input, 2-bit operand selector
////          capture:  1 Bit Input, 1-bit capture indicator
////      Outputs:
////          result:   9 Bit Output, 9-bit unsigned result as output
////          valid:    1 Bit Output, 1-bit valid indicator
////
//// Testbench: project1_tb.v
//// Revision:
////  Revision 0.01 - File Created
////
///////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
// Project 1 Module
module Project1(
    input reset_n,
    input clock,
    input [7:0] d_in,
    input [1:0] op,
    input capture,
    output [8:0] result,
    output valid,
    
    output [1:0] prev_op,
    output [2:0] counter,
    
    // Additional Outputs, for detailed module testing
    output [7:0] demux_A_out, demux_B_out, demux_C_out, demux_D_out,
    output [7:0] mux_A_out, mux_B_out, mux_C_out, mux_D_out,
    output [7:0] dff_A_out, dff_B_out, dff_C_out, dff_D_out,
    output [8:0] AplusB_out, CplusD_out,
    output AplusB_Cout, CplusD_Cout, final_Cout,
    output [8:0] AplusB_9bit, CplusD_9bit
    );
    // Instantiation
    demux_1to4 input_op(.A_out(demux_A_out), .B_out(demux_B_out), .C_out(demux_C_out), .D_out(demux_D_out), .in(d_in), .op(op), .capture(capture));
    
    mux_2to1 mux_A(.mux_out(mux_A_out), .sel((capture && op == 2'b00)), .old_val(dff_A_out), .new_val(demux_A_out));
    mux_2to1 mux_B(.mux_out(mux_B_out), .sel((capture && op == 2'b01)), .old_val(dff_B_out), .new_val(demux_B_out));
    mux_2to1 mux_C(.mux_out(mux_C_out), .sel((capture && op == 2'b10)), .old_val(dff_C_out), .new_val(demux_C_out));
    mux_2to1 mux_D(.mux_out(mux_D_out), .sel((capture && op == 2'b11)), .old_val(dff_D_out), .new_val(demux_D_out));
    
    
    
    dff_8bit dff_A(.Q(dff_A_out), .D(mux_A_out), .reset_n(reset_n), .clock(clock));
    dff_8bit dff_B(.Q(dff_B_out), .D(mux_B_out), .reset_n(reset_n), .clock(clock));
    dff_8bit dff_C(.Q(dff_C_out), .D(mux_C_out), .reset_n(reset_n), .clock(clock));
    dff_8bit dff_D(.Q(dff_D_out), .D(mux_D_out), .reset_n(reset_n), .clock(clock));
    
    rca_9bit AplusB(.S(AplusB_out), .Cout(AplusB_Cout), .A({1'b0,dff_A_out}), .B({1'b0,dff_B_out}), .Cin(1'b0));
    rca_9bit CplusD(.S(CplusD_out), .Cout(CplusD_Cout), .A({1'b0,dff_C_out}), .B({1'b0,dff_D_out}), .Cin(1'b0));
    
    assign AplusB_9bit = {AplusB_Cout,AplusB_out};
    assign CplusD_9bit = {CplusD_Cout,CplusD_out};
    
    // 2's Compliment
    wire [8:0] CplusD_9bit_complement;  // Temporary variable to hold the two's complement
    assign CplusD_9bit_complement = ~CplusD_9bit + 9'b000000001;  // Negate and add 1
    
    rca_9bit final(.S(result), .Cout(final_Cout), .A(AplusB_9bit), .B(CplusD_9bit_complement), .Cin(1'b0));
    
//    control_counter cc (.counter(counter), .valid(valid), .clock(clock), .reset_n(reset_n), .op(op), .prev_op(prev_op));
    assign valid = (result !== 9'bxxxxxxxxx) ? 1'b1 : 1'b0;
endmodule

// Controller
//module control_counter (
//    output valid,              // Valid output
//v    input clock,               // Clock
//    input reset_n,             // reset
//    input [1:0] op,            // Current operand input
    
//    output [1:0] prev_op,        // Previous operand input
//    output [2:0] counter
//);
////    assign counter = (counter == 3'bxxx) ? 3'b000 : counter + 3'b001;
////    dff_2bit dff_op(.Q(prev_op), .D(op), .reset_n(reset_n), .clock(clock));
//    //dff_3bit dff_counter(.Q(counter), .D(counter), .reset_n(reset_n), .clock(clock));
////    assign valid = (counter > 4) ? 1'b1 : 1'b0;
//    assign valid = (dff_A_out != 8'bzzzzzzzz);
//endmodule


// D-Flip Flop
module dff_8bit(
    output reg [7:0] Q,
    input [7:0] D,
    input reset_n,
    input clock
    );
    always @(posedge clock)
    begin
        if(!reset_n) Q <= 8'bzzzzzzzz;
        else Q <= D; 
    end
endmodule

module dff_3bit(
    output reg [2:0] Q,
    input [2:0] D,
    input reset_n,
    input clock
    );
    always @(posedge clock)
    begin
        if(!reset_n) Q <= 3'b000;
        else Q <= D; 
    end
endmodule

module dff_2bit(
    output reg [1:0] Q,
    input [1:0] D,
    input reset_n,
    input clock
    );
    always @(posedge clock)
    begin
        if(!reset_n) Q <= 2'bzz;
        else Q <= D; 
    end
endmodule



// Multiplexer, MUX
// 4-to-1 Multiplexer, MUX
module mux_4to1 (
    output [7:0] mux_out,   // 8-bit output
    input [1:0] op,         // 2-bit select input
    input [7:0] A, B, C, D   // 8-bit inputs
);
    // Assign the output based on the select input
    assign mux_out = (op == 2'b00) ? A :
                     (op == 2'b01) ? B :
                     (op == 2'b10) ? C :
                     (op == 2'b11) ? D : 8'b00000000; // Default to 0 if op is invalid
endmodule

// 2-to-1 Multiplexer, MUX
module mux_2to1 (
    output [7:0] mux_out,   // 8-bit output
    input sel,              // 1-bit select input
    input [7:0] old_val, new_val // 8-bit inputs
);
    // Assign the output based on the select input
    assign mux_out = sel ? new_val : old_val; // If sel is high, output new_val; otherwise, output old_val
endmodule



// Inverse Multiplexer, DEMUX
module demux_1to4 (
    output [7:0] A_out, // Output A
    output [7:0] B_out, // Output B
    output [7:0] C_out, // Output C
    output [7:0] D_out, // Output D
    input [7:0] in,     // 8-bit input
    input [1:0] op,     // 2-bit selector
    input capture       // 1-bit Capture
    );
    // Assign the input to the correct output based on the selector using AND gates
    assign A_out = (op == 2'b00 && capture == 1'b1) ? in : 8'b00000000;
    assign B_out = (op == 2'b01 && capture == 1'b1) ? in : 8'b00000000;
    assign C_out = (op == 2'b10 && capture == 1'b1) ? in : 8'b00000000;
    assign D_out = (op == 2'b11 && capture == 1'b1) ? in : 8'b00000000;
endmodule



// Adder Modules
// Full Adder - 1 Bit
module full_adder(
    output S,
    output Cout,
    input A,
    input B,
    input Cin
    );
// Wires
wire w1; // A^B Out
wire w2; // A & B Out
wire w3; // (A^B) & Cin Out
// XOR Gates
xor xor1(w1,A,B);
xor xor2(S,w1,Cin);
// AND Gates
and and1(w2,A,B);
and and2(w3,w1,Cin);
// OR Gates
or or1(Cout,w3,w2);
endmodule

// RCA Adder - 9 Bit
module rca_9bit(
    output [8:0] S,
    output Cout,
    input [8:0] A,
    input [8:0] B,
    input Cin
    );
wire Cin1,Cin2,Cin3,Cin4,Cin5,Cin6,Cin7,Cin8;
full_adder fa0 (.A(A[0]), .B(B[0]), .Cin(Cin),  .S(S[0]), .Cout(Cin1));
full_adder fa1 (.A(A[1]), .B(B[1]), .Cin(Cin1), .S(S[1]), .Cout(Cin2));
full_adder fa2 (.A(A[2]), .B(B[2]), .Cin(Cin2), .S(S[2]), .Cout(Cin3));
full_adder fa3 (.A(A[3]), .B(B[3]), .Cin(Cin3), .S(S[3]), .Cout(Cin4));
full_adder fa4 (.A(A[4]), .B(B[4]), .Cin(Cin4), .S(S[4]), .Cout(Cin5));
full_adder fa5 (.A(A[5]), .B(B[5]), .Cin(Cin5), .S(S[5]), .Cout(Cin6));
full_adder fa6 (.A(A[6]), .B(B[6]), .Cin(Cin6), .S(S[6]), .Cout(Cin7));
full_adder fa7 (.A(A[7]), .B(B[7]), .Cin(Cin7), .S(S[7]), .Cout(Cin8));
full_adder fa8 (.A(A[8]), .B(B[8]), .Cin(Cin8), .S(S[8]), .Cout(Cout));
endmodule




