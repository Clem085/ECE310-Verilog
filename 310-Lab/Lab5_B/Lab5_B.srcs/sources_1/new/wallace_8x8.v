`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////
//// Class: ECE 310
//// School: NCSU
//// Engineer: Connor Savugot
////
//// Create Date:  11/04/2024 9:30:08 AM
//// Design Name:  Lab 5
//// Module1 Name: wallace_8x8
//// Project Name: wallace_8x8 - Lab5
//// Description:
////  8-Bit Wallace Multiplier: wallace_8x8
////      Inputs:
////          a:       8 Bit Bus Input, Binary Input #1
////          b:       8 Bit Bus Input, Binary Input #2 
////      Output:
////          prod:    16 Bit Bus Output, Binary Output #1
////
////  Full Adder: full_adder
////      Inputs:
////          A:      1 Bit Input, Binary Input #1
////          B:      1 Bit Input, Binary Input #2 
////          Cin:    1 Bit Input, Carry In Bit
////      Output:
////          S:      1 Bit Output, Binary Sum Bit
////          Cout:   1 Bit Output, Carry Out Bit
////
////  Half Adder: half_adder
////      Inputs:
////          A:      1 Bit Input, Binary Input #1
////          B:      1 Bit Input, Binary Input #2 
////      Output:
////          S:      1 Bit Output, Binary Sum Bit
////          Cout:   1 Bit Output, Carry Out Bit
////
//// Testbench: lab5_tb.v
//// Revision:
////  Revision 0.01 - File Created
////
///////////////////////////////////////////////////////////////////////////////////


module wallace_8x8(
    input [7:0] a,
    input [7:0] b,
    output [15:0] prod
    );
    // Wires
    // Partial Products
    wire 
    PP00,
    PP10, PP01,
    PP20, PP11, PP02,
    PP30, PP21, PP12, PP03,
    PP40, PP31, PP22, PP13, PP04,
    PP50, PP41, PP32, PP23, PP14, PP05,
    PP60, PP51, PP42, PP33, PP24, PP15, PP06,
    PP70, PP61, PP52, PP43, PP34, PP25, PP16, PP07,
    PP71, PP62, PP53, PP44, PP35, PP26, PP17,
    PP72, PP63, PP54, PP45, PP36, PP27,
    PP73, PP64, PP55, PP46, PP37,
    PP74, PP65, PP56, PP47,
    PP75, PP66, PP57,
    PP76, PP67,
    PP77;

    
    // Wires for Full Adder Sums (S) and Carryouts (C)
    wire FA00_S, FA00_C;
    wire FA01_S, FA01_C;
    wire FA02_S, FA02_C;
    wire FA03_S, FA03_C;
    wire FA04_S, FA04_C;
    wire FA05_S, FA05_C;
    wire FA06_S, FA06_C;
    wire FA07_S, FA07_C;
    wire FA08_S, FA08_C;
    wire FA09_S, FA09_C;
    wire FA10_S, FA10_C;
    wire FA11_S, FA11_C;
    wire FA12_S, FA12_C;
    wire FA13_S, FA13_C;
    wire FA14_S, FA14_C;
    wire FA15_S, FA15_C;
    wire FA16_S, FA16_C;
    wire FA17_S, FA17_C;
    wire FA18_S, FA18_C;
    wire FA19_S, FA19_C;
    wire FA20_S, FA20_C;
    wire FA21_S, FA21_C;
    wire FA22_S, FA22_C;
    wire FA23_S, FA23_C;
    wire FA24_S, FA24_C;
    wire FA25_S, FA25_C;
    wire FA26_S, FA26_C;
    wire FA27_S, FA27_C;
    wire FA28_S, FA28_C;
    wire FA29_S, FA29_C;
    wire FA30_S, FA30_C;
    wire FA31_S, FA31_C;
    wire FA32_S, FA32_C;
    wire FA33_S, FA33_C;
    wire FA34_S, FA34_C;
    wire FA35_S, FA35_C;
    wire FA36_S, FA36_C;
    wire FA37_S, FA37_C;
    wire FA38_S, FA38_C;
    wire FA39_S, FA39_C;
    wire FA40_S, FA40_C;
    wire FA41_S, FA41_C;
    wire FA42_S, FA42_C;
    wire FA43_S, FA43_C;
    wire FA44_S, FA44_C;
    wire FA45_S, FA45_C;
    wire FA46_S, FA46_C;
    wire FA47_S, FA47_C;
    
    // Wires for Half Adder Sums (S) and Carryouts (C)
    wire HA00_S, HA00_C;
    wire HA01_S, HA01_C;
    wire HA02_S, HA02_C;
    wire HA03_S, HA03_C;
    wire HA04_S, HA04_C;
    wire HA05_S, HA05_C;
    wire HA06_S, HA06_C;
    wire HA07_S, HA07_C;


    
    
    ///// Partial Product Values, 0:15
    // For Wallace Multiplier n x n, # AND Gates = n x n
    // 8 x 8 = 64 AND Gates
    // Level 0
    and prod0(PP00, a[0], b[0]);
    // Level 1
    and HA00_A(PP10, a[1], b[0]);
    and HA00_B(PP01, a[0], b[1]);
    // Level 2
    and FA00_A(PP20, a[2], b[0]);
    and FA00_B(PP11, a[1], b[1]);
    and HA01_A(PP02, a[0], b[2]);
    // Level 3
    and FA01_A(PP30, a[3], b[0]);
    and FA01_B(PP21, a[2], b[1]);
    and FA02_A(PP12, a[1], b[2]);
    and HA02_A(PP03, a[0], b[3]);
    // Level 4
    and FA03_A(PP40, a[4], b[0]);
    and FA03_B(PP31, a[3], b[1]);
    and FA04_A(PP22, a[2], b[2]);
    and FA05_A(PP13, a[1], b[3]);
    and FA05_B(PP04, a[0], b[4]);
    // Level 5
    and FA06_A(PP50, a[5], b[0]);
    and FA06_B(PP41, a[4], b[1]);
    and FA07_A(PP32, a[3], b[2]);
    and FA08_A(PP23, a[2], b[3]);
    and FA09_A(PP14, a[1], b[4]);
    and FA09_B(PP05, a[0], b[5]);
    // Level 6
    and FA10_A(PP60, a[6], b[0]);
    and FA10_B(PP51, a[5], b[1]);
    and FA11_A(PP42, a[4], b[2]);
    and FA12_A(PP33, a[3], b[3]);
    and FA13_A(PP24, a[2], b[4]);
    and FA14_A(PP15, a[1], b[5]);
    and FA14_B(PP06, a[0], b[6]);
    // Level 7
    and FA15_A(PP70, a[7], b[0]);
    and FA15_B(PP61, a[6], b[1]);
    and FA16_A(PP52, a[5], b[2]);
    and FA17_A(PP43, a[4], b[3]);
    and FA18_A(PP34, a[3], b[4]);
    and FA19_A(PP25, a[2], b[5]);
    and FA20_A(PP16, a[1], b[6]);
    and FA20_B(PP07, a[0], b[7]);
    // Level 8
    and HA07_A(PP71, a[7], b[1]);
    and FA21_A(PP62, a[6], b[2]);
    and FA22_A(PP53, a[5], b[3]);
    and FA23_A(PP44, a[4], b[4]);
    and FA24_A(PP35, a[3], b[5]);
    and FA25_A(PP26, a[2], b[6]);
    and FA26_A(PP17, a[1], b[7]);
    // Level 9
    and FA27_A(PP72, a[7], b[2]);
    and FA28_A(PP63, a[6], b[3]);
    and FA29_A(PP54, a[5], b[4]);
    and FA30_A(PP45, a[4], b[5]);
    and FA31_A(PP36, a[3], b[6]);
    and FA32_A(PP27, a[2], b[7]);
    // Level 10
    and FA33_A(PP73, a[7], b[3]);
    and FA34_A(PP64, a[6], b[4]);
    and FA35_A(PP55, a[5], b[5]);
    and FA36_A(PP46, a[4], b[6]);
    and FA37_A(PP37, a[3], b[7]);
    // Level 11
    and FA38_A(PP74, a[7], b[4]);
    and FA39_A(PP65, a[6], b[5]);
    and FA40_A(PP56, a[5], b[6]);
    and FA41_A(PP47, a[4], b[7]);
    // Level 12
    and FA42_A(PP75, a[7], b[5]);
    and FA43_A(PP66, a[6], b[6]);
    and FA44_A(PP57, a[5], b[7]);
    // Level 13
    and FA45_A(PP76, a[7], b[6]);
    and FA46_A(PP67, a[6], b[7]);
    // Level 14
    and FA47_A(PP77, a[7], b[7]);

    
    
    //// Bit Levels of prod, 0:15
    // Level 0
    assign prod[0] = PP00;
    // Level 1
    half_adder HA00(HA00_S, HA00_C, PP10, PP01);
    assign prod[1] = HA00_S;
    // Level 2
    full_adder FA00(FA00_S, FA00_C, PP20, PP11, HA00_C);
    half_adder HA01(HA01_S, HA01_C, PP02, FA00_S);
    assign prod[2] = HA01_S;
    // Level 3
    full_adder FA01(FA01_S, FA01_C, PP30, PP21, FA00_C);
    full_adder FA02(FA02_S, FA02_C, PP12, FA01_S, HA01_C);
    half_adder HA02(HA02_S, HA02_C, PP03, FA02_S);
    assign prod[3] = HA02_S;
    // Level 4
    full_adder FA03(FA03_S, FA03_C, PP40, PP31, FA01_C);
    full_adder FA04(FA04_S, FA04_C, PP22, FA03_S, FA02_C);
    full_adder FA05(FA05_S, FA05_C, PP13, PP04, FA04_S);
    half_adder HA03(HA03_S, HA03_C, FA05_S, HA02_C);
    assign prod[4] = HA03_S;
    // Level 5
    full_adder FA06(FA06_S, FA06_C, PP50, PP41, FA03_C);
    full_adder FA07(FA07_S, FA07_C, PP32, FA06_S, FA04_C);
    full_adder FA08(FA08_S, FA08_C, PP23, FA07_S, FA05_C);
    full_adder FA09(FA09_S, FA09_C, PP14, PP05, FA08_S);
    half_adder HA04(HA04_S, HA04_C, FA09_S, HA03_C);
    assign prod[5] = HA04_S;
    // Level 6
    full_adder FA10(FA10_S, FA10_C, PP60, PP51, FA06_C);
    full_adder FA11(FA11_S, FA11_C, PP42, FA10_S, FA07_C);
    full_adder FA12(FA12_S, FA12_C, PP33, FA11_S, FA08_C);
    full_adder FA13(FA13_S, FA13_C, PP24, FA12_S, FA09_C);
    full_adder FA14(FA14_S, FA14_C, PP15, PP06, FA13_S);
    half_adder HA05(HA05_S, HA05_C, FA14_S, HA04_C);
    assign prod[6] = HA05_S;
    // Level 7
    full_adder FA15(FA15_S, FA15_C, PP70, PP61, FA10_C);
    full_adder FA16(FA16_S, FA16_C, PP52, FA15_S, FA11_C);
    full_adder FA17(FA17_S, FA17_C, PP43, FA16_S, FA12_C);
    full_adder FA18(FA18_S, FA18_C, PP34, FA17_S, FA13_C);
    full_adder FA19(FA19_S, FA19_C, PP25, FA18_S, FA14_S);
    full_adder FA20(FA20_S, FA20_C, PP16, PP07, FA19_S);
    half_adder HA06(HA06_S, HA06_C, FA20_S, HA05_C);
    assign prod[7] = HA06_S;
    // Level 8
    half_adder HA07(HA07_S, HA07_C, PP71, FA15_C);
    full_adder FA21(FA21_S, FA21_C, PP62, HA07_S, FA16_C);
    full_adder FA22(FA22_S, FA22_C, PP53, FA21_S, FA17_C);
    full_adder FA23(FA23_S, FA23_C, PP44, FA22_S, FA18_C);
    full_adder FA24(FA24_S, FA24_C, PP35, FA23_S, FA19_C);
    full_adder FA25(FA25_S, FA25_C, PP26, FA24_S, FA20_C);
    full_adder FA26(FA26_S, FA26_C, PP17, FA25_S, HA06_C);
    assign prod[8] = FA26_S;
    // Level 9
    full_adder FA27(FA27_S, FA27_C, PP72, HA07_C, FA21_C);
    full_adder FA28(FA28_S, FA28_C, PP63, FA27_S, FA22_C);
    full_adder FA29(FA29_S, FA29_C, PP54, FA28_S, FA23_C);
    full_adder FA30(FA30_S, FA30_C, PP45, FA29_S, FA24_C);
    full_adder FA31(FA31_S, FA31_C, PP36, FA30_S, FA25_C);
    full_adder FA32(FA32_S, FA32_C, PP27, FA31_S, FA26_C);
    assign prod[9] = FA32_S;
    // Level 10
    full_adder FA33(FA33_S, FA33_C, PP73, FA27_C, FA28_C);
    full_adder FA34(FA34_S, FA34_C, PP64, FA33_S, FA29_C);
    full_adder FA35(FA35_S, FA35_C, PP55, FA34_S, FA30_C);
    full_adder FA36(FA36_S, FA36_C, PP46, FA35_S, FA31_C);
    full_adder FA37(FA37_S, FA37_C, PP37, FA36_S, FA32_C);
    assign prod[10] = FA37_S;
    // Level 11
    full_adder FA38(FA38_S, FA38_C, PP74, FA33_C, FA34_C);
    full_adder FA39(FA39_S, FA39_C, PP65, FA38_S, FA35_C);
    full_adder FA40(FA40_S, FA40_C, PP56, FA39_S, FA36_C);
    full_adder FA41(FA41_S, FA41_C, PP47, FA40_S, FA37_C);
    assign prod[11] = FA41_S;
    // Level 12
    full_adder FA42(FA42_S, FA42_C, PP75, FA38_C, FA39_C);
    full_adder FA43(FA43_S, FA43_C, PP66, FA42_S, FA40_C);
    full_adder FA44(FA44_S, FA44_C, PP57, FA43_S, FA41_C);
    assign prod[12] = FA44_S;
    // Level 13
    full_adder FA45(FA45_S, FA45_C, PP76, FA42_C, FA43_C);
    full_adder FA46(FA46_S, FA46_C, PP67, FA45_S, FA44_C);
    assign prod[13] = FA46_S;
    // Level 14
    full_adder FA47(FA47_S, FA47_C, PP77, FA45_C, FA46_C);
    assign prod[14] = FA47_S;
    // Level 15
    assign prod[15] = FA47_C;
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
    xor xor1_FA(w1,A,B);
    xor xor2_FA(S,w1,Cin);
    // AND Gates
    and and1_FA(w2,A,B);
    and and2_FA(w3,w1,Cin);
    // OR Gates
    or or1(Cout,w3,w2);
endmodule

// Half Adder - 1 Bit
module half_adder(
    output S,
    output Cout,
    input A,
    input B
    );
    xor xor1_HA(S,A,B);
    and and1_HA(Cout,A,B);
endmodule




