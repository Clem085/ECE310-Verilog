`timescale 1ns / 1ps
module project1_tb;
    reg reset_n;
    reg clock;
    reg [7:0] d_in;
    reg [1:0] op;
    reg capture;

    wire [8:0] result;
    wire valid;
    
    wire [7:0] demux_A_out, demux_B_out, demux_C_out, demux_D_out;
    wire [7:0] mux_A_out, mux_B_out, mux_C_out, mux_D_out;
    wire [7:0] dff_A_out, dff_B_out, dff_C_out, dff_D_out;
    wire [8:0] AplusB_out, CplusD_out;
    wire AplusB_Cout, CplusD_Cout, final_Cout;
    wire [8:0] AplusB_9bit, CplusD_9bit;
    wire [1:0] prev_op;
    wire [2:0] counter;

    Project1 dut (
        .reset_n(reset_n), 
        .clock(clock), 
        .d_in(d_in), 
        .op(op), 
        .capture(capture), 
        .result(result), 
        .valid(valid),
        
        // Additional Outputs, for detailed module testing
        .demux_A_out(demux_A_out), 
        .demux_B_out(demux_B_out), 
        .demux_C_out(demux_C_out), 
        .demux_D_out(demux_D_out),
        .mux_A_out(mux_A_out), 
        .mux_B_out(mux_B_out), 
        .mux_C_out(mux_C_out), 
        .mux_D_out(mux_D_out),
        .dff_A_out(dff_A_out), 
        .dff_B_out(dff_B_out), 
        .dff_C_out(dff_C_out), 
        .dff_D_out(dff_D_out),
        .AplusB_out(AplusB_out), 
        .CplusD_out(CplusD_out), 
        .AplusB_Cout(AplusB_Cout), 
        .CplusD_Cout(CplusD_Cout), 
        .final_Cout(final_Cout),
        .AplusB_9bit(AplusB_9bit), 
        .CplusD_9bit(CplusD_9bit),
        .prev_op(prev_op),
        .counter(counter)
    );

// Clock generation with controlled stopping condition
    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
            if (valid == 1'b1) begin
                // Ensures valid is only high 1 clock cycle
                $display("Time: %t | d_in: %b, op: %b, capture: %b, result: %b", $time, d_in, op, capture, result);
                $finish;                        // End simulation
            end
        end
    end

    // Test procedure
    initial begin
        // Initialize inputs
//        counter = 1'b000;    // Initialize counter to low
        reset_n = 1'b1;    // Start with reset_n high
        capture = 1'b0;    // Initialize capture to low
        d_in = 8'b0;
        op = 2'b00;
        
        // Apply reset
        #10;
        reset_n = 1'b0;    // Set reset low
        #10;
        reset_n = 1'b1;    // Set reset high
        
        // Input values for A, B, C, and D
        #10;
        d_in = 8'b00001010;   // Example value for B //b00001010
        capture = 1'b1;        // Set capture high
        op = 2'b01;            // Select op for B
        #10;
        capture = 1'b0;        // Set capture low

        #10;
        d_in = 8'b00000011;   // Example value for C
        capture = 1'b1;        // Set capture high
        op = 2'b10;            // Select op for C
        #10;
        capture = 1'b0;        // Set capture low
        
        #10;
        d_in = 8'b00000101;   // Example value for A
        capture = 1'b1;        // Set capture high
        op = 2'b00;            // Select op for A
        #10;
        capture = 1'b0;        // Set capture low
        
        #10;
        d_in = 8'b00000101;   // Example value for D
        capture = 1'b1;        // Set capture high
        op = 2'b11;            // Select op for D
        #10;
        capture = 1'b0;        // Set capture low
        #10;
        #10;
    end

endmodule



