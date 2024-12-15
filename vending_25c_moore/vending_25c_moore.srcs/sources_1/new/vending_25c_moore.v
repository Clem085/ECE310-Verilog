`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2024 10:56:03 PM
// Design Name: 
// Module Name: vending_25c_moore
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

module candy_vending_machine(
    input wire [1:0] coin_input, // 2-bit input vector (D, Q)
    input wire clk, // Clock signal
    input wire reset, // Reset signal
    output reg [1:0] output_signal // 2-bit output vector (P, C)
);

// State encoding
reg [2:0] state, next_state;  // Updated to 3 bits to account for additional state
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b111; 

// State transition
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= S0;
    else
        state <= next_state;
end

// Next state logic and output logic
always @(*) begin
    // Default outputs
    output_signal = 2'b00; // Default output (P=0, C=0)
    case (state)
        S0: begin
            output_signal = 2'b00; // Default output (P=0, C=0)
            if (coin_input == 2'b10) next_state = S1; // 10 cents
            else if (coin_input == 2'b01) next_state = S3; // 25 cents, product dispensed, no change
            else next_state = S0;
        end
        S1: begin
            output_signal = 2'b00; // Default output (P=0, C=0)
            if (coin_input == 2'b10) next_state = S2; // 20 cents
            else if (coin_input == 2'b10) next_state = S4; // 25+ cents, product dispensed, change dispensed
            else next_state = S1;
        end
        S2: begin
            output_signal = 2'b00; // Default output (P=0, C=0)
            if (coin_input == 2'b01 || coin_input == 2'b10) next_state = S4; // 25+ cents, product dispensed, change dispensed
            else next_state = S2;
        end
        S3: begin
            output_signal = 2'b10; // Default output (P=1, C=0)
            if (coin_input == 2'b01 || coin_input == 2'b10) next_state = S0;  // Return to initial state
            else next_state = S3; // (!D && !Q) || (D && Q)
        end
        S4: begin
            output_signal = 2'b11; // Default output (P=1, C=1)
            if (coin_input == 2'b01 || coin_input == 2'b10) next_state = S0;  // Return to initial state
            else next_state = S4; // (!D && !Q) || (D && Q)
        end
        S5: begin
            output_signal = 2'b00; // Default output (P=0, C=0)
            next_state = S5; // Do Not change State
        end
        S6: begin
            output_signal = 2'b00; // Default output (P=0, C=0)
            next_state = S6; // Do Not change State
        end
        default: next_state = S0;
    endcase
end
endmodule







module tb_candy_vending_machine;

// Testbench signals
reg [1:0] coin_input;     // 2-bit input vector
reg clk;                  // Clock signal
reg reset;                // Reset signal
wire [1:0] output_signal; // 2-bit output vector (P, C)

// Instantiate the candy vending machine module
candy_vending_machine uut (
    .coin_input(coin_input),
    .clk(clk),
    .reset(reset),
    .output_signal(output_signal)
);

// Generate clock
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

// Test procedure
initial begin
    // Initialize signals
    reset = 1;          // Assert reset
    coin_input = 2'b00; // No coins
    #10;                // Wait for a while
    reset = 0;         // Deassert reset
    
    // Test Case 1: Insert a quarter (25 cents)
    coin_input = 2'b01; // Coin input: Quarter
    #10;                // Wait for one clock cycle
    coin_input = 2'b00; // No coins
    #10;                // Wait for one clock cycle
    
    // Check output for Test Case 1
    if (output_signal == 2'b10) begin
        $display("Test Case 1 Passed: Product dispensed with no change (Output: %b)", output_signal);
    end else begin
        $display("Test Case 1 Failed: Expected Output: 10, Got: %b", output_signal);
    end

    // Reset the machine for the next test case
    reset = 1;
    #10;
    reset = 0;

    // Test Case 2: Insert two dimes (20 cents) then a quarter (25 cents)
    coin_input = 2'b10; // Insert Dime
    #10;                // Wait for one clock cycle
    coin_input = 2'b10; // Insert another Dime
    #10;                // Wait for one clock cycle
    coin_input = 2'b01; // Insert Quarter
    #10;                // Wait for one clock cycle
    coin_input = 2'b00; // No coins
    #10;                // Wait for one clock cycle
    
    // Check output for Test Case 2
    if (output_signal == 2'b11) begin
        $display("Test Case 2 Passed: Product dispensed with change (Output: %b)", output_signal);
    end else begin
        $display("Test Case 2 Failed: Expected Output: 11, Got: %b", output_signal);
    end
    
    // Finish simulation
    $finish;
end

endmodule
