///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  11/17/2024 3:04:21 PM
//// Design Name:  Project 2
//// Module Name:  Project2
//// Project Name: BCD Serial In Serial Out ALU
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

module Project2 (
    input wire reset,        // Active-high synchronous reset
    input wire clock,        // Free-running clock
    input wire din,          // Serial data input
    output reg result       // Serial result output
);
    // Internal Registers
//    reg [40:0] dinParallel; // din converted to Parallel by SIPO
    wire [40:0] dinParallel_w; // din converted to Parallel by SIPO
    reg [40:0] dinParallel_reg; // Unmodified by SIPO Instantiation (hopefully)
    wire SIPO_done;
    wire PISO_done;
    reg shift_SIPO;
    reg shift_PISO;
    reg load;
    reg operation;            // Operation type: addition or subtraction
    reg [15:0] operand_a;     // First operand (4 digits BCD)
    reg [15:0] operand_b;     // Second operand (4 digits BCD)
    wire [3:0] FA0, FA1, FA2, FA3, FA4; // Wire to hold current BCD Addition results for each digit
    wire [3:0] FS0, FS1, FS2, FS3, FS4; // Wire to hold current BCD Subtraction results for each digit
    reg [19:0] result_bcd;    // Result in BCD (up to 5 digits)
    reg [7:0] state;          // State for FSM
    reg [27:0] resultParallel;// result in Parallel
    reg [7:0] endPacket; 
    wire result_wire;
    wire PISO_out_wire;
    reg firstTest;
    
    // Module Instantiations (outside the always block)
    SIPO_41bit sipo_inst(.parallel_out(dinParallel_w), .done(SIPO_done), .serial_in(din), .clk(clock), .rst(reset), .shift(shift_SIPO));
    PISO_28bit piso_inst(.serial_out(result_wire), .done(PISO_done), .parallel_in(resultParallel), .clk(clock), .rst(reset), .load(load), .shift(shift_PISO));
//    PISO_8bit piso(.serial_out(PISO_out_wire), .done(done), .parallel_in(endPacket), .clk(clk), .rst(rst), .load(load), .shift(shift_PISO));
    // Instantiate the BCD adder for each digit
    combBCDadd_4d adder_0 (
        .A3(operand_a[15:12]), .A2(operand_a[11:8]), .A1(operand_a[7:4]), .A0(operand_a[3:0]),
        .B3(operand_b[15:12]), .B2(operand_b[11:8]), .B1(operand_b[7:4]), .B0(operand_b[3:0]),
        .F4(FA4), .F3(FA3), .F2(FA2), .F1(FA1), .F0(FA0)
    );
    combBCDadd_4d subtractor_0 (
        .A3(operand_a[15:12]), .A2(operand_a[11:8]), .A1(operand_a[7:4]), .A0(operand_a[3:0]),
        .B3(operand_b[15:12]), .B2(operand_b[11:8]), .B1(operand_b[7:4]), .B0(operand_b[3:0]),
        .F4(FS4), .F3(FS3), .F2(FS2), .F1(FS1), .F0(FS0)
    );
    // State Machine Parameters
    localparam IDLE =    8'b00000001;
    localparam RST =     8'b00000010;
    localparam SIPO =    8'b00000100;
    localparam LOAD_OP = 8'b00001000;
    localparam COMPUTE = 8'b00010000;
    localparam OUTPUT =  8'b00100000;
    localparam PISO =    8'b01000000;
    localparam OUTPACK = 8'b10000000;   
    // Initializations
    initial begin
        firstTest = 1;
    end
    // Synchronous Reset and FSM Logic
    always @(posedge clock) begin
        if (reset) begin
//            $display("\t\t shift_SIPO = %b", shift_SIPO);
//            $display("Reset Active: Initializing FSM at time %t", $time);
            state = RST;
        end else begin
            case (state)
                IDLE: begin
                    // Wait for input to start
//                    $display("\t --- STUCK --- IN --- IDLE --- FOREVER ---");
                    //// //// 
                    state <= SIPO;
                    dinParallel_reg <= 0;
                    result <= 0;
                    load <= 0;
                    shift_PISO <= 0;
                    // Add resets for any other signal used in the module:
                    operand_a <= 0;
                    operand_b <= 0;
                    result_bcd <= 0;
                    resultParallel <= 0;
                    endPacket <= 0;
                    // Reset FSM-specific signals
                    operation <= 0;
                end
                RST: begin
//                    $display("\tSTATE==RST");
                    state <= SIPO;
                    dinParallel_reg <= 0;
                    result <= 0;
                    load <= 0;
                    if(firstTest) begin   
                        shift_SIPO <= 0;
                        firstTest = 0;
                    end
                    else begin
                        shift_SIPO <= 1;
                    end
                    // Reset System
//                    rst_SIPO <= 1;
//                    rst_PISO <= 1;
//                    shift_SIPO <= 0;
                    
//                    $strobe("System Reset");
                    
                    shift_PISO <= 0;
                    // Add resets for any other signal used in the module:
                    operand_a <= 0;
                    operand_b <= 0;
                    result_bcd <= 0;
                    resultParallel <= 0;
                    endPacket <= 0;
                    // Reset FSM-specific signals
                    operation <= 0;
                end
                SIPO: begin
                    // 41 Bit SIPO
                    shift_SIPO <= 1;
                    if (SIPO_done) begin
//                        $display("\n\t STATE==SIPO");
//                        $display("\t\t dinParallel_w = %h", dinParallel_w);
//                        $display("\t\t dinParallel_w[40:33] = %h", dinParallel_w[40:33]);
                        
//                        $display("\n\n\ndinParallel_w[42] = %h", dinParallel_w[42]);
//                        $display("dinParallel_w[41] = %h", dinParallel_w[41]);
//                        $display("dinParallel_w[40:33] = %b", dinParallel_w[40:33]);
                        
                        shift_SIPO <= 0;
                        if (dinParallel_w[40:33] == 8'h5A) begin
                            dinParallel_reg <= dinParallel_w;// The first one magically gets modified by the SIPO module, hopefully this one won't
                            state <= LOAD_OP;   // All serial input has been loaded in parallel, and control pattern is valid
                        end
                    end
                    
                end
                LOAD_OP: begin
                    // Load operands and operation
//                    $display("\n\t STATE==LOAD_OP");
//                    $display("\t\t ControlPattern: %h",dinParallel_w[40:33]);
//                    $display("\t\t Operation: %b",dinParallel_w[32]);
//                    $display("\t\t Operand A: %h",dinParallel_w[31:16]);
//                    $display("\t\t Operand B: %h",dinParallel_w[15:0]);
                    operation <= dinParallel_w[32];
                    operand_a <= dinParallel_w[31:16];
                    operand_b <= dinParallel_w[15:0];
                    state <= COMPUTE;
//                    $display("\tSTATE->COMPUTE");
                end
                COMPUTE: begin
//                    $display("\n\t STATE==COMPUTE");
                    // Perform operation
                    if (operation == 1'b0) begin
                        result_bcd <= {FA4, FA3, FA2, FA1, FA0}; // Concatenate F4 to F0
//                        $strobe("\t\t Operation: Addition");
//                        $strobe("\t\t Sum: %h, %h, %h, %h, %h", FA4, FA3, FA2, FA1, FA0);
                    end else if (operation == 1'b1) begin
                        result_bcd <= {FS4, FS3, FS2, FS1, FS0}; // Perform subtraction
//                        $strobe("\t\t Operation: Subtraction");
//                        $strobe("\t\t Difference: %h, %h, %h, %h, %h", FS4, FS3, FS2, FS1, FS0);
                    end                    
                    state <= OUTPUT;
//                    $display("\t STATE->OUTPUT");
                    
                end
                OUTPUT: begin
//                    $display("\n\t STATE==OUTPUT");
                    // Concatenate all Outputs into Parallel Output packet
                    resultParallel[27:20] <= 8'h96;
                    resultParallel[19:0] <= result_bcd;
                    state <= PISO;
                    shift_PISO <= 0;
                    load <= 0;
//                    $display("\tSTATE->PISO");
//                    $display("\t STATE==PISO");
                end
                PISO: begin
                    // Load resultParallel into PISO shift register
                    if (!load && !shift_PISO) begin
                        load <= 1;            // Enable the load signal for PISO
                        shift_PISO <= 0;      // Disable shifting initially
                    end
                
                    // After loading, start shifting
                    if (load) begin
//                        $display("\t PISO result_wire: %b",result_wire);
                        load <= 0;            // Disable load signal after one clock cycle
                        shift_PISO <= 1;      // Enable shift signal to start serializing
                    end
                    
                    if(shift_PISO) begin
                       if(result_wire !== 1'bx) begin
                           result <= result_wire;
//                           $display("\t PROJECT2 result = %b",result_wire);
                       end else begin
//                           $display("\t X? result_wire = %b",result_wire);
                       end
                    end 
                
                    // Wait for PISO to finish shifting the data
                    if (PISO_done) begin
//                        $strobe("\n PISO_Complete");
//                        $strobe("\t Final result_wire: %b",result_wire);
                        result <= result_wire;  // Capture the final serialized result from PISO
                        shift_PISO <= 0; 
                        shift_SIPO <= 1'bx;
                        
                        state <= IDLE; // TEMP change to IDLE, originally was RST
                    end
                end                
                default: begin
                    state <= IDLE;
//                $display("\tSTATE=XXXX");
                end
            endcase 
        end
    end
endmodule


////  28-Bit PISO
module PISO_28bit(
    output reg serial_out,    // 1-bit serial output
    output reg done,          // Signal to indicate shift completion
    input [27:0] parallel_in, // 28-bit parallel input
    input clk,                // Clock input
    input rst,                // Reset input
    input load,               // Load data signal
    input shift              // Shift data signal
);
    reg [27:0] shift_reg; // 28-bit shift register
    reg [4:0] shift_count; // Counter for 28 cycles
    always @(posedge clk) begin
        if (rst) begin
//            $display("\t\t PISO RESET");
            shift_reg <= 28'b0;  // Reset shift register
            shift_count <= 5'b0; // Reset shift counter
            done <= 0;
            serial_out <= 1'bx;
        end else if (load) begin
//            $display("\t\t PISO LOAD");
            shift_reg <= parallel_in; // Load parallel data
            shift_count <= 5'b0;     // Reset counter for new operation
            done <= 0;
        end else if (shift) begin
//            shift_reg <= {1'b0, shift_reg[27:1]}; // Shift left by 1 (serialize)
            shift_reg <= {shift_reg[26:0],1'b0}; 
            shift_count <= shift_count + 1;      // Increment shift count
//            $display("\t\t PISO SHIFT");
            
            if (shift_count == 5'd27) begin
                done <= 1; // Assert done on the last shift cycle
                // Hopefully this will reset it for next test case
//                shift_reg <= 28'b0;  // Reset shift register
//                shift_count <= 5'b0; // Reset shift counter
//                serial_out <= 1'bx;
            end else begin
                done <= 0;
            end
        end
    end
    // Assign the serial output to the LSB of the shift register
    always @(posedge clk) begin
        if (rst) begin
            serial_out <= 1'bx;
            shift_reg <= 28'b0;  // Reset shift register
            shift_count <= 5'b0; // Reset shift counter
        end else if (shift) begin
//            serial_out <= shift_reg[0];
            serial_out <= shift_reg[27];
//            $display("\t\t\t serial_out: %b",shift_reg[0]);
        end
    end
endmodule


// 41-Bit SIPO
module SIPO_41bit(
    output reg [40:0] parallel_out,   // 41-bit parallel output
    output reg done,                 // Indicator when all 41 bits have been shifted
    input serial_in,                 // 1-bit serial input
    input clk,                       // Clock signal
    input rst,                       // Active-high synchronous reset
    input shift                     // Shift control signal
);
    // 41-bit shift register
    reg [40:0] shift_reg;
    reg [5:0] bit_counter;           // 6-bit counter to count up to 41
    reg serial_in_reg;
    always @(posedge rst) begin
        // serial_in_reg is used just incase serial_in changes values before reset is complete. Should prevent bit loss
        serial_in_reg = serial_in;
        parallel_out = 40'b0;
        done = 1'b0;
        parallel_out = {parallel_out[39:0],serial_in_reg};
//        $strobe("SIPO RST \n\t parallel_out = %h", parallel_out);
        // Remember to Disable shift Externally
    end    
    always @(posedge clk) begin
        if(parallel_out[40:33] == 8'h5A) begin
            done <= 1'b1;
//            $strobe("CTRL PTRN\n\t parallel_out[40:33] = %h", parallel_out[40:33]);
            // Remember to Disable shift Externally
        end else if(shift) begin
            parallel_out <= {parallel_out[39:0],serial_in};
//            $strobe("SIPO SHIFT \n\t parallel_out = %h", parallel_out);
        end
    end
endmodule


// BCD Add Single Digit
module combBCDadd_digit (
	input [3:0] A, B,
	input cin,
	output cout,
	output [3:0] F );
	// Inputs Consist of 4 Bits: 2^4 = 16
	wire [4:0] binary_sum;
	wire [4:0] corrected_sum;
	assign binary_sum = A + B + cin;
	assign corrected_sum = binary_sum + 5'd6;

	assign cout = (binary_sum > 9) ? corrected_sum[4] : binary_sum[4]; 
	assign F = (binary_sum > 9) ? corrected_sum[3:0] : binary_sum[3:0];
endmodule


// BCD Adder 4 Digits
module combBCDadd_4d (
  input  [3:0] A3, A2, A1, A0,
  input  [3:0] B3, B2, B1, B0,
  output [3:0] F4, F3, F2, F1, F0
);
  wire [3:1] carry;
  combBCDadd_digit U0 ( A0, B0,     1'b0, carry[1], F0 );
  combBCDadd_digit U1 ( A1, B1, carry[1], carry[2], F1 );
  combBCDadd_digit U2 ( A2, B2, carry[2], carry[3], F2 );
  combBCDadd_digit U3 ( A3, B3, carry[3],    F4[0], F3 );
  // carry will never fill 3 MSb of F4
  assign F4[3:1] = 3'b000;
endmodule


// BCD Subtract Single Digit
module combBCDsub_digit (
    input [3:0] A, B,    // A - Minuend, B - Subtrahend
    input bin,           // Borrow-in
    output bout,         // Borrow-out
    output [3:0] F       // Result digit
);
    wire [4:0] binary_diff;
    wire [4:0] corrected_diff;
    wire borrow_condition;

    // Calculate raw difference: 10's complement by adding (9 - B), bin, and A
    assign binary_diff = A + (~B + 4'b1001) + bin;
    
    // Check for BCD overflow condition and correct it
    assign corrected_diff = binary_diff + 5'd6;
    assign borrow_condition = (binary_diff < 10);

    // Assign final outputs
    assign bout = borrow_condition ? corrected_diff[4] : binary_diff[4];
    assign F = borrow_condition ? corrected_diff[3:0] : binary_diff[3:0];
endmodule


// BCD Subtract 4 Digits
module combBCDsub_4d (
    input  [3:0] A3, A2, A1, A0,   // Minuend digits
    input  [3:0] B3, B2, B1, B0,   // Subtrahend digits
    output [3:0] F4, F3, F2, F1, F0 // Result digits
);
    wire [3:1] borrow;

    // Subtract each digit using the combBCDsub_digit module
    combBCDsub_digit U0 (A0, B0,     1'b0, borrow[1], F0);
    combBCDsub_digit U1 (A1, B1, borrow[1], borrow[2], F1);
    combBCDsub_digit U2 (A2, B2, borrow[2], borrow[3], F2);
    combBCDsub_digit U3 (A3, B3, borrow[3],    F4[0], F3);

    // Carry will never fill 3 MSB of F4
    assign F4[3:1] = 3'b000;
endmodule

