`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Date:         11/18/2024
// Project Name: Project 2
// Description:  Createing a BCD adder and subtracter with specific 
//               patterns that must be inputed/outputed before an input/output 
//               can be read
// 
//////////////////////////////////////////////////////////////////////////////////



module combBCDadd_digit (
  input [3:0] A, B,
  input cin,
  output cout,
  output [3:0] F
);

  wire [4:0] sum_bin;      // 5-bit to accommodate carry from binary addition
  wire [4:0] corrected_sum; // 5-bit corrected sum

  assign sum_bin = A + B + cin; // Binary addition with carry-in

  // Check if correction is needed (if binary sum > 9 or if there's a carry)
  assign corrected_sum = sum_bin + 5'd6;
  assign cout = (sum_bin > 4'd9) ? 1'b1 : 1'b0; // Carry out for BCD

  // Select corrected sum if necessary, otherwise use the original binary sum
  assign F = (sum_bin > 4'd9) ? corrected_sum[3:0] : sum_bin[3:0];

endmodule


module combBCDadd_4d (
  input  [3:0] A3, A2, A1, A0,
  input  [3:0] B3, B2, B1, B0,
  output [3:0] F4, F3, F2, F1, F0
);

  wire [3:1] carry;

  combBCDadd_digit U0 ( A0, B0,     1'b0, carry[1], F0 );
  combBCDadd_digit U1 ( A1, B1, carry[1], carry[2], F1 );
  combBCDadd_digit U2 ( A2, B2, carry[2], carry[3], F2 );
  combBCDadd_digit U3 ( A3, B3, carry[3], carry_out, F3 );

  // Set F4 based on carry_out, which determines if the result is greater than 9999
  assign F4 = carry_out ? 4'b0001 : 4'b0000;
endmodule



module pattern_matcher(
    input wire clock,           // Clock signal
    input wire reset,         // Reset signal
    input wire din,           // Data input bit stream
    output reg add_sub,       // Variable to store addition/subtraction mode (1-bit)
    output reg [15:0] A,      // 16-bit variable A
    output reg [15:0] B,      // 16-bit variable B
    output reg pattern_found, // Flag to indicate if pattern has been found
    output reg valid_output,  // Flag to indicate if the output matches 8'b10010110
    output reg display_output // Flag to indicate when all output pattern bits are received
);

    // Define the start pattern (8 bits) and output pattern (8 bits)
    parameter START_PATTERN = 8'b01011010;  // Start pattern: 0x5A
    parameter OUTPUT_PATTERN = 8'b10010110; // Expected output pattern: 0x96

    // Internal registers
    reg [7:0] last_8_bits;     // To store the last 8 bits entered
    reg [5:0] bit_count;       // To track the number of bits processed
    reg [7:0] output_pattern;  // Register to store output pattern as it's generated

    // State to track if the start pattern has been matched
    reg pattern_matched;

    // Reset logic or initialization logic
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            last_8_bits <= 8'b0;
            bit_count <= 0;
            add_sub <= 0;
            A <= 16'b0;
            B <= 16'b0;
            pattern_found <= 0;
            pattern_matched <= 0;
            valid_output <= 0;
            display_output <= 0;
            output_pattern <= 8'b0;
        end else begin
            // Shift in the new input bit
            last_8_bits <= {last_8_bits[6:0], din};

            // Check for the start pattern if not already matched
            if (!pattern_matched) begin
                if (last_8_bits == START_PATTERN) begin
                    pattern_found <= 1;
                    pattern_matched <= 1;
                    bit_count <= 0;
                    add_sub <= din;

                end
            end else begin
                // After the start pattern is matched, begin processing data
                 if (bit_count <= 15) begin
                    A <= {A[14:0], din};
                    bit_count <= bit_count + 1;
                end else if (bit_count <= 31) begin
                    B <= {B[14:0], din};
                   bit_count <= bit_count + 1;
            end else if (bit_count > 31) begin
                // Check if the beginning of output_pattern matches OUTPUT_PATTERN
                if (bit_count == 32) begin
                    valid_output <= (1); // Check upper 8 bits
                    display_output <= 1; // Set display output when pattern check is complete
                    bit_count <= bit_count + 1;
                end
            

                end
            end
        end
        
        //
       
        
    end
endmodule

module Project2(
    input wire clock,                // Clock input
    input wire reset,              // Reset input
    input wire din,                // Serial data input
    output reg result              // 1-bit serial output
);

    // Internal wires and registers
    wire add_sub;                  // Add or subtract operation
    wire [15:0] A, B;              // 16-bit operands A and B
    wire pattern_found;            // Indicates if the pattern has been found
    wire valid_output;             // Indicates if the output pattern is valid
    wire display_output;           // Flag for displaying output
    reg start_val;
    integer  state;
    
    wire [3:0] F4, F3, F2, F1, F0; // BCD digits after addition/subtraction
    reg [19:0] result_pattern;      // 8-bit result pattern for parallel output
    reg [15:0] B_complement;       // BCD complement of B if subtraction is required
    reg[19:0] output_data;
    // State and counter for serial data transmission
    reg [7:0] serial_data;         // 8-bit serial data to be output
    reg [5:0] bit_counter;         // Counter to track the bit position for serial output
    reg transmitting;              // Flag to indicate if transmission is ongoing
    reg now_display_output;
    // Instantiate the pattern matcher
    pattern_matcher pm_inst (
        .clock(clock),
        .reset(reset),
        .din(din),
        .add_sub(add_sub),
        .A(A),
        .B(B),
        .pattern_found(pattern_found),
        .valid_output(valid_output),
        .display_output(display_output)
    );

    // Instantiate the 4-digit BCD adder/subtractor
    combBCDadd_4d bcd_adder (
        .A3(A[15:12]), 
        .A2(A[11:8]),
        .A1(A[7:4]),
        .A0(A[3:0]),
        .B3(!add_sub ? B[15:12] : B_complement[15:12]),
        .B2(!add_sub ? B[11:8] : B_complement[11:8]),
        .B1(!add_sub ? B[7:4] : B_complement[7:4]),
        .B0(!add_sub ? B[3:0] : B_complement[3:0]),
        .F4(F4), 
        .F3(F3),
        .F2(F2),
        .F1(F1),
        .F0(F0)
    );

   // Generate the BCD complement of B for subtraction
always @(*) begin
        // Compute 10's complement for BCD by taking the 9's complement and adding 1
        B_complement[15:12] = 4'd9 - B[15:12]; // 9's complement for most significant digit
        B_complement[11:8]  = 4'd9 - B[11:8];  // 9's complement for the next digit
        B_complement[7:4]   = 4'd9 - B[7:4];   // 9's complement for the next digit
        B_complement[3:0]   = 4'd9 - B[3:0];   // 9's complement for the least significant digit

        // Adding 1 to the 9's complement to get the 10's complement
        B_complement = B_complement + 16'h0001;

end

// State machine for parallel and serial output
always @(posedge clock or posedge reset) begin
    if (reset) 
        state <= 3'b000;
    else if (display_output && !transmitting && start_val) 
        state <= 3'b001;

    case(state)
        3'b000: begin
            result_pattern <= 20'b0;
            serial_data <= 8'b0;
            result <= 0;
            bit_counter <= 0;
            transmitting <= 0;
            start_val <= 1;
        end

        3'b001: begin
            serial_data <= 8'b10010110;
            result_pattern <= {F4[3:0], F3[3:0], F2[3:0], F1[3:0], F0[3:0]};
            result <= 0;
            start_val <= 0;
            transmitting <= 1;
            state <= 3'b010;
        end

        3'b010: begin
            result <= serial_data[7 - bit_counter];
            bit_counter <= bit_counter + 1;

            if (bit_counter == 7) begin
                transmitting <= 0;
                bit_counter <= 1;
                result <= 0;
                state <= 3'b011;
                if (add_sub) output_data <= {4'b0000, F3[3:0], F2[3:0], F1[3:0], F0[3:0]};
            if(!add_sub) output_data <= {F4[3:0], F3[3:0], F2[3:0], F1[3:0], F0[3:0]};
            
            
            end
        end

        3'b011: begin

            result <= output_data[20 - bit_counter];
            bit_counter <= bit_counter + 1;
            if(bit_counter==19) state<=3'b100;
            
            // Add state transition here if needed
        end
        3'b100: begin
         result <= 0;
        end
        
        
        default: state <= 3'b000;  // Reset to initial state for unexpected conditions
    endcase
end

endmodule