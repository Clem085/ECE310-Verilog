
//module Project2_tb;

//    // Inputs to the module under test
//    reg clock;
//    reg reset;
//    reg din;

//    // Outputs from the module under test
//    wire result;

//    // Instantiate the module under test
//    Project2 uut (
//        .clock(clock),
//        .reset(reset),
//        .din(din),
//        .result(result)
//    );

//    // Clock generation: 10 time units period
//    always #5 clock = ~clock;

//    initial begin
//        // Initialize inputs
//        clock = 0;
//        reset = 1;
//        din = 0;

//        // Hold reset for 20 time units
//        #20;
//        reset = 0;

//        // 8-bit start pattern: 01011010 (0x5A)
//        din = 1'b0; #10;
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;
//        din = 1'b0; #10;

//        // Operation bit (add_sub): 0 for addition
//        din = 1'b0; #10;

//        // BCD digits for operand A (3627)
//        // BCD digit 3 for A (3)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;
        
//        // BCD digit 6 for A (6)
//        // BCD digit 8 for B (8)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;
        
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;
        
//        // BCD digit 7 for A (7)
//        // BCD digit 8 for B (8)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;

//        // BCD digits for operand B (1287)
//        // BCD digit 1 for B (1)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;

//        // BCD digit 2 for B (2)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;

//        // BCD digit 8 for B (8)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;;

//        // BCD digit 7 for B (7)
//        din = 1'b1; #10;
//        din = 1'b0; #10;
//        din = 1'b0; #10;
//        din = 1'b1; #10;

//        // Wait for the output
//        #1000;
        
        
//        // End the simulation
//        $finish;
//    end

//endmodule


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: North Carolina State University
// Engineer: Christopher Mori
// 
// Create Date: 11/19/2024 06:32:23 PM
// Design Name: project2_tb
// Module Name: project2_tb
// Project Name: project2
// Target Devices: N/A
// Tool Versions: N/A
// Description: 
// 
// Dependencies: N/A
// 
// Revision:N/A
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module project2_tb;
    //Module connections
    reg reset_n;
    reg clock;
    reg din;
    wire result;
    
    
    //Internal signals
    reg[40:0] data_in;
    reg shift_ok;
    reg[27:0] module_result;
    reg sequence_detected;
    reg header_detected;
    reg answer_correct;
    integer timer = 0;
    
    
    //Module instantiation
    Project2 dut(
        .reset(reset_n),
        .clock(clock),
        .din(din),
        .result(result)
    );

    //Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    //Reset task
    task sys_reset;
        begin
            header_detected = 1'b0;
            answer_correct = 1'b0;
            timer = 0;
            data_in = 82'b0;
            shift_ok = 1'b0;
            sequence_detected = 1'b0;
            reset_n = 1;
            #10
            reset_n = 0;
        end
    endtask 
    
    
    //Task to wait for a whole input cycle to see if the correct answer and header are ever given (not necessarily at the same time)
    task check;
        input [19:0] correct_result; 
        begin
            timer = 0;
            header_detected = 1'b0;
            answer_correct = 1'b0;
            while(timer < 41) begin
                if(sequence_detected) begin
                    header_detected = 1'b1;
                    if(module_result[19:0] == correct_result)
                        $display("\nmodule_result: %b",module_result);
                        $display("correct_result: %b\n",correct_result);
                        answer_correct = 1'b1;
                end
                #10;
                timer = timer + 1;
            end
        end
    endtask
    
    task disp;
      if(header_detected)
            if(answer_correct)
                $display("\tTest case passed!");
            else $display("\tHeader detected, but answer incorrect!");
        else
            $display("\tdisp-No header detected, test case failed!");
    endtask
    
    //Shift data into serial port
    integer i = 0;
    initial begin
        forever
        if(shift_ok)
        begin
            for(i = 40; i >= 0; i = i - 1) 
            begin
                din = data_in[i];
                #10;
            end
        end
        else 
        begin
            din = 1'b0;
            #10;
       end 
    end
    
    //Shift result data in
    always@(posedge clock) begin
        if(reset_n) begin
            module_result = 28'b0; 
            sequence_detected = 1'b0;
        end
        else module_result = {module_result[26:0],result};        
    end
    
    

    
    
    
    
    always@(module_result)
        if(module_result[27:20] == 8'h96) begin
            sequence_detected = 1'b1;
            $display("Sequence detected: %h", module_result[27:20]); // Added this line for additional debugging
        end
        else sequence_detected = 1'b0;
   
    
    
    //Main Procedure
    initial begin
    
        /** TEST CASE 1 **/
        $display("BASIC TEST: 3627 + 1287 = 4914///////////////////////////////////////////////////////////////////////////////////////");
        sys_reset;
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};
        shift_ok = 1'b1;
        #410;
        shift_ok = 1'b0;
        check({4'h0,4'd4,4'd9,4'd1,4'd4});
        disp;
        
        /** TEMP TEST CASE 1.2 **/
        $display("TEST 1.2: 3627 + 1287 = 4914 ////////////////////////////////////////////////////////////////////////////////////////");
        sys_reset;
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};
        shift_ok = 1'b1;
        #410;
        shift_ok = 1'b0;
        check({4'h0,4'd4,4'd9,4'd1,4'd4});
        disp;

        /** TEST CASE 2 **/
        $display("CONTINUOUS STREAM TEST:  3627 + 1287 = 4914 then 3627 - 1287 = 2340 /////////////////////////////////////////////////");
        sys_reset;
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};        
        shift_ok = 1'b1;
        #410;
        data_in = {8'h5A,1'b1,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};
        check({4'h0,4'd4,4'd9,4'd1,4'd4});
        disp;
        timer = 0;
        header_detected = 1'b0;
        answer_correct = 1'b0;        
        check({4'h0,4'd2,4'd3,4'd4,4'd0});
        disp;
        
        /** TEST CASE 3 **/ 
        $display("DELAYED INPUT TEST: 3627 + 1287 = 4914 then DELAY then 3627 - 1287 = 2340");
        
        sys_reset; // Ensure sys_reset is properly defined and ends with a semicolon
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};       
        shift_ok = 1'b1;
        #410;
        shift_ok = 1'b0;      
        check({4'h0,4'd4,4'd9,4'd1,4'd4}); 
        disp;       
        timer = 0;
        header_detected = 1'b0;
        answer_correct = 1'b0;     
        #100;   
        data_in = {8'h5A,1'b1,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};       
        shift_ok = 1'b1;        
        #410;
        shift_ok = 1'b0;  
        check({4'h0,4'd2,4'd3,4'd4,4'd0}); 
        disp; 
        
        
        /** TEST CASE 4 **/
        $display("CUMULATIVE TEST: 3627 + 1287 = 4914 then 3627 - 1287 = 2340 then DELAY then 3627 - 1287 = 2340 then 3627 + 1287 = 4914");
        sys_reset;
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};        
        shift_ok = 1'b1;
        #410;
        data_in = {8'h5A,1'b1,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};
        check({4'h0,4'd4,4'd9,4'd1,4'd4});
        disp;
        timer = 0;
        header_detected = 1'b0;
        answer_correct = 1'b0;   
        shift_ok = 1'b0;          
        check({4'h0,4'd2,4'd3,4'd4,4'd0});
        disp;
        #100;
        data_in = {8'h5A,1'b1,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};        
        shift_ok = 1'b1;
        #410;
        data_in = {8'h5A,1'b0,4'd3,4'd6,4'd2,4'd7,4'd1,4'd2,4'd8,4'd7};
        check({4'h0,4'd2,4'd3,4'd4,4'd0});
        disp;
        timer = 0;
        header_detected = 1'b0;
        answer_correct = 1'b0;   
        shift_ok = 1'b0;          
        check({4'h0,4'd4,4'd9,4'd1,4'd4});
        disp;        
        $finish;
    end 
endmodule







