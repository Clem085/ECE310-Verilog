///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  11/27/2024 3:04:21 PM
//// Design Name:  Project 2
//// Module Name:  project2
//// Project Name: Project2
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
////  8-Bit PSIO - Parallel-Input-Serial-Output: PISO
////      Inputs:
////          parallel_in:      8 Bit Input, 8 Bit Parrallel In
////          clk:              1 Bit Input, Clock Input
////          rst:              1 Bit Input, Active High Synchronous Reset
////          load:             1 Bit Input, Active High to Load Parallel Data
////          shift:            1 Bit Input, Active High to Shift Data
////      Output:
////          serial_out:       1 Bit Output, Serial Out
////
////  8-Bit SIPO - Serial-In Parallel-Out: SIPO
////      Inputs:
////          serial_in:        1 Bit Input, Serial Input
////          clk:              1 Bit Input, Clock Input
////          rst:              1 Bit Input, Active High Synchronous Reset
////          shift:            1 Bit Input, Active High to Shift Data
////      Outputs:
////          parallel_out:     8 Bit Output, 8-bit Parallel Output (Shifted)
////
//// Testbench: project2_tb.v
//// Revision:
////  Revision 0.01 - File Created
////
///////////////////////////////////////////////////////////////////////////////////


































module BCD (
    input [3:0] bin,      // 4-bit binary input
    output reg [3:0] bcd  // 4-bit BCD output
);
    always @(*) begin
        case(bin)
            4'd0: bcd = 4'b0000;
            4'd1: bcd = 4'b0001;
            4'd2: bcd = 4'b0010;
            4'd3: bcd = 4'b0011;
            4'd4: bcd = 4'b0100;
            4'd5: bcd = 4'b0101;
            4'd6: bcd = 4'b0110;
            4'd7: bcd = 4'b0111;
            4'd8: bcd = 4'b1000;
            4'd9: bcd = 4'b1001;
            default: bcd = 4'b0000;  // Invalid BCD
        endcase
    end
endmodule



module BCD_addition (
    input [3:0] A, B,    // BCD inputs
    input cin,           // Carry-in from previous addition
    output cout,         // Carry-out for next addition
    output [3:0] F       // Sum in BCD format
);
    wire [4:0] binary_sum;
    wire [4:0] corrected_sum;
    
    // Perform binary sum
    assign binary_sum = A + B + cin;
    
    // If the sum exceeds 9, apply correction (BCD adjustment)
    assign corrected_sum = binary_sum + 5'd6;
    assign cout = (binary_sum > 9) ? corrected_sum[4] : binary_sum[4];
    assign F = (binary_sum > 9) ? corrected_sum[3:0] : binary_sum[3:0];
endmodule



module BCD_addition_4d (
    input [3:0] A3, A2, A1, A0,  // 4-digit BCD A input
    input [3:0] B3, B2, B1, B0,  // 4-digit BCD B input
    output [3:0] F4, F3, F2, F1, F0  // Sum in 4-digit BCD result
);
    wire [3:1] carry;

    // Perform the 4-digit BCD addition
    BCD_addition U0 (A0, B0, 1'b0, carry[1], F0);
    BCD_addition U1 (A1, B1, carry[1], carry[2], F1);
    BCD_addition U2 (A2, B2, carry[2], carry[3], F2);
    BCD_addition U3 (A3, B3, carry[3], F4[0], F3);
    
    // The MSB of F4 will stay 0 as there is no carry beyond this bit.
    assign F4[3:1] = 3'b000;
endmodule

module BCD_subtraction (
    input [3:0] A, B,    // BCD inputs: A is the minuend, B is the subtrahend
    input bin,            // Borrow-in from previous subtraction
    output bout,          // Borrow-out for next subtraction
    output [3:0] D       // Difference in BCD format
);
    wire [3:0] bcd_complement;
    wire [3:0] bin_bcd;
    
    // Calculate 10's complement of B (invert B and add 1)
    assign bcd_complement = ~B;  // 1's complement (invert B)
    assign bin_bcd = bcd_complement + 4'd1;  // Add 1 to form the 10's complement
    
    // Perform BCD addition with the 10's complement of B
    BCD_addition U0 (
        .A(A), 
        .B(bin_bcd), 
        .cin(bin), 
        .cout(bout), 
        .F(D)
    );
endmodule

module BCD_subtraction_4d (
    input [3:0] A3, A2, A1, A0,  // Minuend BCD digits
    input [3:0] B3, B2, B1, B0,  // Subtrahend BCD digits
    input bin,                    // Borrow-in from previous subtraction
    output bout,                  // Borrow-out for next subtraction
    output [3:0] D4, D3, D2, D1, D0 // Difference in BCD digits
);
    wire [3:0] bcd_complement3, bcd_complement2, bcd_complement1, bcd_complement0;
    wire [3:0] bin_bcd3, bin_bcd2, bin_bcd1, bin_bcd0;
    
    // Calculate the 10's complement (subtract from 9) of each BCD digit
    assign bcd_complement3 = 4'd9 - B3;
    assign bcd_complement2 = 4'd9 - B2;
    assign bcd_complement1 = 4'd9 - B1;
    assign bcd_complement0 = 4'd9 - B0;
    
    // Add 1 to form the 10's complement for each digit
    assign bin_bcd3 = bcd_complement3 + 4'd1;
    assign bin_bcd2 = bcd_complement2 + 4'd1;
    assign bin_bcd1 = bcd_complement1 + 4'd1;
    assign bin_bcd0 = bcd_complement0 + 4'd1;
    
    // Perform BCD addition with the 10's complement of each digit
    BCD_addition U0 (
        .A(A0), 
        .B(bin_bcd0), 
        .cin(bin), 
        .cout(bout), 
        .F(D0)
    );
    
    BCD_addition U1 (
        .A(A1), 
        .B(bin_bcd1), 
        .cin(bout), 
        .cout(), 
        .F(D1)
    );
    
    BCD_addition U2 (
        .A(A2), 
        .B(bin_bcd2), 
        .cin(bout), 
        .cout(), 
        .F(D2)
    );
    
    BCD_addition U3 (
        .A(A3), 
        .B(bin_bcd3), 
        .cin(bout), 
        .cout(), 
        .F(D3)
    );

    // MSB of D4 will remain zero since carry never fills 3 MSB of D4
    assign D4 = 4'b0000; // No borrow beyond the most significant digit
endmodule

////  16-Bit PISO
module PISO_16bit(
    output reg serial_out,      // 1-bit serial output
    input [15:0] parallel_in,   // 16-bit parallel input
    input clk,                  // Clock input
    input rst,                  // Reset input
    input load,                 // Load data signal
    input shift                 // Shift data signal
    );
    reg [15:0] shift_reg;       // 16-bit shift register to hold the parallel data

    // Shift register logic with load and shift capabilities
    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 16'b0000000000000000;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= parallel_in;  // Load the parallel input into the shift register
        end else if (shift) begin
            serial_out <= shift_reg[0]; // Output the LSB (first bit of the shift register)
            shift_reg <= {1'b0, shift_reg[15:1]}; // Shift data left by one bit (MSB becomes 0)
        end
    end
endmodule


//// 16-Bit SIPO
module SIPO_16bit(
    output reg [15:0] parallel_out,   // 16-bit parallel output
    input serial_in,                   // 1-bit serial input
    input clk,                          // Clock signal
    input rst,                          // Active-high synchronous reset
    input shift                         // Shift control signal
    );    // 16-bit shift register implemented with D flip-flops
    reg [15:0] shift_reg;              // 16-bit shift register
    // Always block triggered on positive edge of clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear shift register on reset
            shift_reg <= 16'b0000000000000000;
        end else if (shift) begin
            // Shift in the serial input at every clock cycle when shift is high
            shift_reg <= {shift_reg[14:0], serial_in};
        end
    end

    // Assign parallel_out to the shift register
    always @(posedge clk or posedge rst) begin
        if (rst)
            parallel_out <= 16'b0000000000000000;  // Reset parallel_out to 0
        else
            parallel_out <= shift_reg;  // Update parallel_out with shifted value
    end
endmodule




//module combBCDadd_digit (
//  input [3:0] A, B,
//  input cin,
//  output cout,
//  output [3:0] F
//);
//  wire [4:0] binary_sum;
//  wire [4:0] corrected_sum;
  
//  // Perform the binary sum
//  assign binary_sum = A + B + cin;
  
//  // Adjust for BCD if the sum is greater than 9
//  assign corrected_sum = binary_sum + 5'd6;
//  assign cout = (binary_sum > 9) ? corrected_sum[4] : binary_sum[4];
//  assign F = (binary_sum > 9) ? corrected_sum[3:0] : binary_sum[3:0];
//endmodule

//module combBCDadd_4d (
//  input [3:0] A3, A2, A1, A0,
//  input [3:0] B3, B2, B1, B0,
//  output [3:0] F4, F3, F2, F1, F0
//);
//  wire [3:1] carry;
  
//  combBCDadd_digit U0 ( A0, B0, 1'b0, carry[1], F0 );
//  combBCDadd_digit U1 ( A1, B1, carry[1], carry[2], F1 );
//  combBCDadd_digit U2 ( A2, B2, carry[2], carry[3], F2 );
//  combBCDadd_digit U3 ( A3, B3, carry[3], F4[0], F3 );
  
//  // MSB of F4 will remain zero since carry never fills 3 MSB of F4
//  assign F4[3:1] = 3'b000;
//endmodule














////module Project2 (
////    input wire reset,        // Active-high synchronous reset
////    input wire clock,        // Free-running clock
////    input wire din,          // Serial data input
////    output wire result       // Serial result output
////);
////    // Internal Registers
////    reg [3:0] operation;     // Operation type: addition or subtraction
////    reg [15:0] operand_a;    // First operand (4 digits BCD)
////    reg [15:0] operand_b;    // Second operand (4 digits BCD)
////    reg [19:0] result_bcd;   // Result in BCD (up to 5 digits)
////    reg [7:0] state;         // State for FSM
////    reg result_reg;          // Register to hold the output value

////    // Assign the internal result register to the output
////    assign result = result_reg;

////    // State Machine Parameters
////    localparam IDLE = 8'b00000001;
////    localparam LOAD_OP = 8'b00000010;
////    localparam COMPUTE = 8'b00000100;
////    localparam OUTPUT = 8'b00001000;

////    // Synchronous Reset and FSM Logic
////    always @(posedge clock) begin
////        if (reset) begin
////            // Reset the system
////            state <= IDLE;
////            operand_a <= 16'b0;
////            operand_b <= 16'b0;
////            operation <= 4'b0;
////            result_bcd <= 20'b0;
////            result_reg <= 0;
////        end else begin
////            case (state)
////                IDLE: begin
////                    // Wait for input to start
////                    if (din == 1) begin
////                        state <= LOAD_OP;
////                    end
////                end
////                LOAD_OP: begin
////                    // Load operands and operation (example logic)
////                    operand_a <= 16'h3627; // Hardcoded for example; replace with shift register logic
////                    operand_b <= 16'h1287;
////                    operation <= 4'b0001; // Example operation (add)
////                    state <= COMPUTE;
////                end
////                COMPUTE: begin
////                    // Perform operation
////                    if (operation == 4'b0001) begin
////                        result_bcd <= operand_a + operand_b; // Perform addition
////                    end else if (operation == 4'b0010) begin
////                        result_bcd <= operand_a - operand_b; // Perform subtraction
////                    end
////                    state <= OUTPUT;
////                end
////                OUTPUT: begin
////                    // Output result serially
////                    result_reg <= result_bcd[19]; // Output MSB of result
////                    result_bcd <= {result_bcd[18:0], 1'b0}; // Shift result
////                    if (result_bcd == 20'b0) begin
////                        state <= IDLE; // Return to IDLE when done
////                    end
////                end
////                default: state <= IDLE;
////            endcase
////        end
////    end

////endmodule



//module Project2 (
//    input wire reset,         // Active-high synchronous reset
//    input wire clock,         // Free-running clock
//    input wire din,           // Serial data input
//    output wire result        // Serial result output
//);
//    // Internal Registers
//    reg [3:0] operation;      // Operation type: addition or subtraction
//    reg [15:0] operand_a;     // First operand (4 digits BCD)
//    reg [15:0] operand_b;     // Second operand (4 digits BCD)
//    reg [19:0] result_bcd;    // Result in BCD (up to 5 digits)
//    reg [7:0] state;          // State for FSM
//    reg result_reg;           // Register to hold the output value
//    reg [4:0] shift_count;    // Counter for serial result shifting
//    reg header_detected_reg;  // Register to hold the header detection signal

//    // Assign the internal result register to the output
//    assign result = result_reg;
    
//    // Signal for header detection to the testbench
//    assign header_detected = header_detected_reg;

//    // State Machine Parameters
//    localparam IDLE     = 8'b00000001;
//    localparam LOAD_OP  = 8'b00000010;
//    localparam COMPUTE  = 8'b00000100;
//    localparam OUTPUT   = 8'b00001000;

//    // Synchronous Reset and FSM Logic
//    always @(posedge clock) begin
//        if (reset) begin
//            // Reset the system
//            state <= IDLE;
//            operand_a <= 16'b0;
//            operand_b <= 16'b0;
//            operation <= 4'b0;
//            result_bcd <= 20'b0;
//            result_reg <= 1'b0;
//            shift_count <= 5'd0;
//            header_detected_reg <= 1'b0;  // Reset header detection
//        end else begin
//            case (state)
//                IDLE: begin
//                    // Wait for input to start
//                    if (din) begin
//                        state <= LOAD_OP;
//                    end
//                end
//                LOAD_OP: begin
//                    // Load operands and operation (use shift register logic for serial input)
//                    // Check for header (8'h5A)
//                    if (din == 1'b1) begin
//                        header_detected_reg <= 1'b1;  // Set the header detected flag
//                    end
//                    // This should be replaced by serial logic (e.g., SIPO module)
//                    operand_a <= 16'h3627;
//                    operand_b <= 16'h1287;
//                    operation <= 4'b0001; // Example operation (add)
//                    state <= COMPUTE;
//                end
//                COMPUTE: begin
//                    // Perform operation
//                    if (operation == 4'b0001) begin
//                        result_bcd <= operand_a + operand_b; // Perform addition
//                    end else if (operation == 4'b0010) begin
//                        result_bcd <= operand_a - operand_b; // Perform subtraction
//                    end
//                    shift_count <= 5'd20; // Initialize shift count
//                    state <= OUTPUT;
//                end
//                OUTPUT: begin
//                    // Output result serially
//                    if (shift_count > 0) begin
//                        result_reg <= result_bcd[19];           // Output MSB of result
//                        result_bcd <= {result_bcd[18:0], 1'b0}; // Shift result left
//                        shift_count <= shift_count - 1;         // Decrement shift counter
//                    end else begin
//                        state <= IDLE; // Return to IDLE when done
//                    end
//                end
//                default: state <= IDLE;
//            endcase
//        end
//    end
//endmodule



//////  16-Bit PISO
//module PISO_16bit(
//    output reg serial_out,      // 1-bit serial output
//    input [15:0] parallel_in,   // 16-bit parallel input
//    input clk,                  // Clock input
//    input rst,                  // Reset input
//    input load,                 // Load data signal
//    input shift                 // Shift data signal
//    );
//    reg [15:0] shift_reg;       // 16-bit shift register to hold the parallel data

//    // Shift register logic with load and shift capabilities
//    always @(posedge clk) begin
//        if (rst) begin
//            shift_reg <= 16'b0000000000000000;
//            serial_out <= 1'b0;
//        end else if (load) begin
//            shift_reg <= parallel_in;  // Load the parallel input into the shift register
//        end else if (shift) begin
//            serial_out <= shift_reg[0]; // Output the LSB (first bit of the shift register)
//            shift_reg <= {1'b0, shift_reg[15:1]}; // Shift data left by one bit (MSB becomes 0)
//        end
//    end
//endmodule



//module SIPO_16bit(
//    output reg [15:0] parallel_out,   // 16-bit parallel output
//    input serial_in,                   // 1-bit serial input
//    input clk,                          // Clock signal
//    input rst,                          // Active-high synchronous reset
//    input shift                         // Shift control signal
//    );    // 16-bit shift register implemented with D flip-flops
//    reg [15:0] shift_reg;              // 16-bit shift register
//    // Always block triggered on positive edge of clock
//    always @(posedge clk or posedge rst) begin
//        if (rst) begin
//            // Clear shift register on reset
//            shift_reg <= 16'b0000000000000000;
//        end else if (shift) begin
//            // Shift in the serial input at every clock cycle when shift is high
//            shift_reg <= {shift_reg[14:0], serial_in};
//        end
//    end

//    // Assign parallel_out to the shift register
//    always @(posedge clk or posedge rst) begin
//        if (rst)
//            parallel_out <= 16'b0000000000000000;  // Reset parallel_out to 0
//        else
//            parallel_out <= shift_reg;  // Update parallel_out with shifted value
//    end
//endmodule




//module combBCDadd_digit (
//	input [3:0] A, B,
//	input cin,
//	output cout,
//	output [3:0] F );
//	// Inputs Consist of 4 Bits: 2^4 = 16
//	wire [4:0] binary_sum;
//	wire [4:0] corrected_sum;
//	assign binary_sum = A + B + cin;
//	assign corrected_sum = binary_sum + 5'd6;
//	assign cout = (binary_sum > 9) ? corrected_sum[4] : binary_sum[4]; 
//	assign F = (binary_sum > 9) ? corrected_sum[3:0] : binary_sum[3:0];
//endmodule



//module combBCDadd_4d (
//  input  [3:0] A3, A2, A1, A0,
//  input  [3:0] B3, B2, B1, B0,
//  output [3:0] F4, F3, F2, F1, F0
//);
//  wire [3:1] carry;
//  combBCDadd_digit U0 ( A0, B0,     1'b0, carry[1], F0 );
//  combBCDadd_digit U1 ( A1, B1, carry[1], carry[2], F1 );
//  combBCDadd_digit U2 ( A2, B2, carry[2], carry[3], F2 );
//  combBCDadd_digit U3 ( A3, B3, carry[3],    F4[0], F3 );
//  // carry will never fill 3 MSb of F4
//  assign F4[3:1] = 3'b000;
//endmodule
