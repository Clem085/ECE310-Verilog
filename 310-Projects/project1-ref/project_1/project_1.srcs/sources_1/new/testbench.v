module project1_tb;
    reg reset_n;
    reg clock;
    reg [7:0] d_in;
    reg [1:0] op;
    reg capture;

    wire [8:0] result;
    wire valid;

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
        .CplusD_9bit(CplusD_9bit)
    );

//    // Clock generation
//    initial begin
//        clock = 0;
//        forever #5 clock = ~clock; // Toggle clock every 5 time units
//    end

//    // Test procedure
//    initial begin
//        // Initialize inputs
//        reset_n = 1'b1;    
//        capture = 1'b0;    
//        d_in = 8'b0;
//        op = 2'b00;

//        // Apply reset
//        #10;
//        reset_n = 1'b0;    
//        #10;
//        reset_n = 1'b1; // Release reset

//        // Test different inputs
//        for (integer i = 0; i < 16; i = i + 1) begin
//            d_in = i; // Test different d_in values
//            op = i[1:0]; // Change op for every input
//            capture = 1'b1; // Capture the value
//            #10; // Wait for a clock cycle
//            capture = 1'b0; // Release capture
//            #10; // Wait for a clock cycle to stabilize outputs
//            $display("Time: %t | d_in: %b, op: %b, capture: %b, result: %b, valid: %b", 
//                     $time, d_in, op, capture, result, valid);
//        end
//        $finish; // End simulation
//    end

// Clock generation with controlled stopping condition
    initial begin
        clock = 0;
        forever begin
            #5 clock = ~clock;
            if (valid == 1'b1) begin
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
        d_in = 8'b00000101;   // Example value for A
        #10;
        capture = 1'b1;        // Set capture high
        #10;
        op = 2'b00;            // Select op for A
        #10;
        capture = 1'b0;        // Set capture low

        #10;
        d_in = 8'b00001010;   // Example value for B //b00001010
        #10;
        capture = 1'b1;        // Set capture high
        #10;
        op = 2'b01;            // Select op for B
        #10;
        capture = 1'b0;        // Set capture low

        #10;
        d_in = 8'b00000011;   // Example value for C
        #10;
        capture = 1'b1;        // Set capture high
        #10;
        op = 2'b10;            // Select op for C
        #10;
        capture = 1'b0;        // Set capture low

        #10;
        d_in = 8'b00000101;   // Example value for D
        #10;
        capture = 1'b1;        // Set capture high
        #10;
        op = 2'b11;            // Select op for D
        #10;
        capture = 1'b0;        // Set capture low
        
    end

endmodule



