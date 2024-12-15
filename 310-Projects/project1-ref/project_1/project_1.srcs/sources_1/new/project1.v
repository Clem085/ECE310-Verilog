`timescale 1ns / 1ps


module full_adder (
    input A,   
    input B,   
    input Cin,  // carry-in 
    output S,   // sum output
    output Cout // carry-out output
);
    // Intermediate signals
    wire X1;  // XOR 
    wire C1;  // AND (2)
    wire C2;  // AND(4)

    // Gate 1- XOR 
    xor (X1, A, B);  
    
    // Gate 2- AND
    and (C1, A, B);  
    
    // Gate 3- XOR 
    xor (S, Cin, X1); 
    
    // Gate 4- AND
    and (C2, X1, Cin); 
    
    // Gate 5: OR 
    or (Cout, C1, C2); 
endmodule

module RCA_8bit (
    input [7:0] A,  // 8-bit input A
    input [7:0] B,  // 8-bit input B
    input Cin,      // Carry-in for the least significant bit
    output [8:0] S  // 9-bit output for sum (8 bits + 1 carry)
);
    wire C1, C2, C3, C4, C5, C6, C7, C8; // carry wires

    // Instantiate all 8 full adders for the RCA
    full_adder FA0 (
        .A(A[0]), 
        .B(B[0]), 
        .Cin(Cin), 
        .S(S[0]), 
        .Cout(C1)
    );

    full_adder FA1 (
        .A(A[1]), 
        .B(B[1]), 
        .Cin(C1), 
        .S(S[1]), 
        .Cout(C2)
    );

    full_adder FA2 (
        .A(A[2]), 
        .B(B[2]), 
        .Cin(C2), 
        .S(S[2]), 
        .Cout(C3)
    );

    full_adder FA3 (
        .A(A[3]), 
        .B(B[3]), 
        .Cin(C3), 
        .S(S[3]), 
        .Cout(C4)
    );

    full_adder FA4 (
        .A(A[4]), 
        .B(B[4]), 
        .Cin(C4), 
        .S(S[4]), 
        .Cout(C5)
    );

    full_adder FA5 (
        .A(A[5]), 
        .B(B[5]), 
        .Cin(C5), 
        .S(S[5]), 
        .Cout(C6)
    );

    full_adder FA6 (
        .A(A[6]), 
        .B(B[6]), 
        .Cin(C6), 
        .S(S[6]), 
        .Cout(C7)
    );

    full_adder FA7 (
        .A(A[7]), 
        .B(B[7]), 
        .Cin(C7), 
        .S(S[7]), 
        .Cout(C8)
    );

    // The last carry-out becomes the most significant bit of the result
    assign S[8] = C8;

endmodule


module RCA_9bit (
    input [8:0] A,  // 8-bit input A
    input [8:0] B,  // 8-bit input B
    input Cin,      // Carry-in for the least significant bit
    output [8:0] S  // 9-bit output for sum (8 bits + 1 carry)
);
    wire C1, C2, C3, C4, C5, C6, C7, C8, C9; // carry wires

    // Instantiate all 8 full adders for the RCA
    full_adder FA0 (
        .A(A[0]), 
        .B(B[0]), 
        .Cin(Cin), 
        .S(S[0]), 
        .Cout(C1)
    );

    full_adder FA1 (
        .A(A[1]), 
        .B(B[1]), 
        .Cin(C1), 
        .S(S[1]), 
        .Cout(C2)
    );

    full_adder FA2 (
        .A(A[2]), 
        .B(B[2]), 
        .Cin(C2), 
        .S(S[2]), 
        .Cout(C3)
    );

    full_adder FA3 (
        .A(A[3]), 
        .B(B[3]), 
        .Cin(C3), 
        .S(S[3]), 
        .Cout(C4)
    );

    full_adder FA4 (
        .A(A[4]), 
        .B(B[4]), 
        .Cin(C4), 
        .S(S[4]), 
        .Cout(C5)
    );

    full_adder FA5 (
        .A(A[5]), 
        .B(B[5]), 
        .Cin(C5), 
        .S(S[5]), 
        .Cout(C6)
    );

    full_adder FA6 (
        .A(A[6]), 
        .B(B[6]), 
        .Cin(C6), 
        .S(S[6]), 
        .Cout(C7)
    );

    full_adder FA7 (
        .A(A[7]), 
        .B(B[7]), 
        .Cin(C7), 
        .S(S[7]), 
        .Cout(C8)
    );
    full_adder FA8 (
        .A(A[8]), 
        .B(B[8]), 
        .Cin(C8), 
        .S(S[8]), 
        .Cout(C9)
    );
endmodule


module muxA (
    input wire op1not, op0not, capture, 
    output wire muxA_output
);
    assign muxA_output = (op1not&&op0not&&capture) ? 1'b1 : 1'b0; // If sel is 1, output 1; else output current 0
endmodule

module muxB (

    input wire op1not, sel0, capture,
    output wire muxB_output  // Output which can also serve as feedback
);
    assign muxB_output = (op1not && sel0&&capture) ? 1'b1 : 1'b0; // If sel is 1, output 1; else output current 0

endmodule
module muxC (

    input wire sel1,op0not, capture,
    output wire muxC_output  // Output which can also serve as feedback
);

    assign muxC_output = (op0not && sel1&&capture) ? 1'b1 : 1'b0; // If sel is 1, output 1; else output current 0

endmodule
module muxD (
    input wire sel1, sel0, capture,
        output wire muxD_output  // Output which can also serve as feedback
);
    assign muxD_output = (sel1 && sel0 && capture) ? 1'b1 : 1'b0; // If sel is 1, output 1; else output current 0

endmodule


module Project1 (
//once they are all high, then turn valid to 1 and clear all enable bits in reset
    input reset_n,
    input clock,
    input [7:0] d_in,
    input  [1:0] op,
    input capture,
    input muxA_output, muxB_output, muxC_output, muxD_output,
    output wire [8:0] result,  
    output wire valid
);
    wire A_enabled, B_enabled, C_enabled, D_enabled;
    wire op1not, op0not, sel0, sel1;
    
    reg [7:0] A, B, C, D;
    wire [8:0] sum_AB, sum_CD, neg_sum_CD;
    wire [8:0] final_result;
    
    not (op1not, op[1]);
    not (op0not, op[0]);

    //sign extend valid by 9 bits and and it with the result
   and (valid, A_enabled, B_enabled, C_enabled, D_enabled,  muxD_output);

    wire [8:0] valid_extended; // 8-bit sign-extended output
    assign valid_extended = { {8{valid}}, valid };
    
    
    
    
    
    //wire [1:0] data_to_dff; // This should be the data you want to latch
    //assign data_to_dff = (valid) ? 2'b00 : op[1:0]; // Adjust accordingly
    //two_bit_dff ops(.Q(op[1:0]), .D(data_to_dff), .clock(clock), .reset_n(reset_n), .enable(valid) );
   
   
    muxA muxA_inst (.op1not(op1not), .op0not(op0not),.capture(capture), .muxA_output(muxA_output));
    dff dff_muxA(.Q(A_enabled), .D(1'b1), .clock(clock), .reset_n(reset_n), .enable(muxA_output));

    muxB muxB_inst (.op1not(op1not), .sel0(op[0]),.capture(capture), .muxB_output(muxB_output));
    dff dff_muxB(.Q(B_enabled), .D(1'b1), .clock(clock), .reset_n(reset_n), .enable(muxB_output));

    muxC muxC_inst (.sel1(op[1]), .op0not(op0not),.capture(capture), .muxC_output(muxC_output));
    dff dff_muxC(.Q(C_enabled), .D(1'b1), .clock(clock), .reset_n(reset_n), .enable(muxC_output));

    muxD muxD_inst (.sel1(op[1]), .sel0(op[0]), .capture(capture), .muxD_output(muxD_output));
    dff dff_muxD(.Q(D_enabled), .D(1'b1), .clock(clock), .reset_n(reset_n), .enable(muxD_output));


    RCA_8bit adder_AB ( .A(A_out), .B(B_out), .Cin(1'b0), .S(sum_AB) );
    RCA_8bit adder_CD (.A(C_out), .B(D_out), .Cin(1'b0),.S(sum_CD) );
    RCA_9bit negator_CD (.A({~sum_CD[8:0]}), .B(9'b000000001), .Cin(1'b0), .S(neg_sum_CD));
    RCA_9bit subtractor ( .A(sum_AB), .B(neg_sum_CD), .Cin(1'b0), .S(final_result));

 // 8-bit D flip-flops for storing A, B, C, D values
    wire [7:0] A_out, B_out, C_out, D_out;
    eight_bit_dff A_ff (.Q(A_out), .D(d_in), .clock(clock), .reset_n(reset_n), .enable(capture && muxA_output));
    eight_bit_dff B_ff (.Q(B_out), .D(d_in), .clock(clock), .reset_n(reset_n), .enable(capture && muxB_output));
    eight_bit_dff C_ff (.Q(C_out), .D(d_in), .clock(clock), .reset_n(reset_n), .enable(capture && muxC_output));
    eight_bit_dff D_ff (.Q(D_out), .D(d_in), .clock(clock), .reset_n(reset_n), .enable(capture && muxD_output));

    assign result = (valid) ? final_result : 9'b0; // If sel is 1, output b; else output current A_enabled


endmodule
//NEED TO FIGURE OUT HOW TO CLEAR OP AT THE END OF EACH CLOCK CYCLE
module dff(output reg Q, input D, clock, reset_n, enable, output reg [1:0] op);
    always @(posedge clock)
       if (!reset_n) begin
       Q = 1'b0; // Reset Q to 0
       //op[1:0] =2'bzz;
       end
       else if(enable)Q<=D;
    endmodule
module two_bit_dff(
    output [1:0] Q,     // 2-bit output
    input [1:0] D,      // 2-bit input
    input clock,
    input reset_n,
    input enable
);
    // Instantiate 8 individual D flip-flops
    dff dff0(Q[0], D[0], clock, reset_n, enable);
    dff dff1(Q[1], D[1], clock, reset_n, enable);
    endmodule

    
module eight_bit_dff(
    output [7:0] Q,     // 8-bit output
    input [7:0] D,      // 8-bit input
    input clock,
    input reset_n,
    input enable
);
    // Instantiate 8 individual D flip-flops
    dff dff0(Q[0], D[0], clock, reset_n, enable);
    dff dff1(Q[1], D[1], clock, reset_n, enable);
    dff dff2(Q[2], D[2], clock, reset_n, enable);
    dff dff3(Q[3], D[3], clock, reset_n, enable);
    dff dff4(Q[4], D[4], clock, reset_n, enable);
    dff dff5(Q[5], D[5], clock, reset_n, enable);
    dff dff6(Q[6], D[6], clock, reset_n, enable);
    dff dff7(Q[7], D[7], clock, reset_n, enable);
endmodule
