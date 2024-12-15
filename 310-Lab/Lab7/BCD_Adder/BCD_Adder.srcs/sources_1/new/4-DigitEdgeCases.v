module combBCDadd_4d_tb;

  reg [15:0] A_vec;
  reg [15:0] B_vec;

  wire [19:0] F_vec;

  wire [3:0] A3, A2, A1, A0;
  wire [3:0] B3, B2, B1, B0;
  wire [3:0] F4, F3, F2, F1, F0;

  reg [3:0] i, j, k, l, m, n, p, q;

  assign A3 = A_vec[15:12];
  assign A2 = A_vec[11:8];
  assign A1 = A_vec[7:4];
  assign A0 = A_vec[3:0];

  assign B3 = B_vec[15:12];
  assign B2 = B_vec[11:8];
  assign B1 = B_vec[7:4];
  assign B0 = B_vec[3:0];

  combBCDadd_4d DUT (
    A3, A2, A1, A0,
    B3, B2, B1, B0, F4, F3, F2, F1, F0
  );

  assign F_vec[19:16] = F4;
  assign F_vec[15:12] = F3;
  assign F_vec[11:8] = F2;
  assign F_vec[7:4] = F1;
  assign F_vec[3:0] = F0;

  initial begin
    $monitor( "%1d%1d%1d%1d + %1d%1d%1d%1d = %1d%1d%1d%1d%1d",
      A3, A2, A1, A0, B3, B2, B1, B0, F4, F3, F2, F1, F0 );

    // Test all combinations of A and B (0-9 for each)
    // cin = 0
    {A_vec, B_vec} = 32'h0000_0000; #10
    {A_vec, B_vec} = 32'h0028_0017; #10
    {A_vec, B_vec} = 32'h1234_5634; #10
    {A_vec, B_vec} = 32'h0101_2020; #10
    {A_vec, B_vec} = 32'h0999_1999; #10
    {A_vec, B_vec} = 32'h9999_9999; #10
    {A_vec, B_vec} = 32'h5000_5000; #10
    {A_vec, B_vec} = 32'h0042_5550; #10

    // Test carry-in = 1
    {A_vec, B_vec} = 32'h0000_0000; #10
    {A_vec, B_vec} = 32'h0028_0017; #10
    {A_vec, B_vec} = 32'h1234_5634; #10
    {A_vec, B_vec} = 32'h0101_2020; #10
    {A_vec, B_vec} = 32'h0999_1999; #10
    {A_vec, B_vec} = 32'h9999_9999; #10
    {A_vec, B_vec} = 32'h5000_5000; #10
    {A_vec, B_vec} = 32'h0042_5550; #10

    #10 $stop;
  end
endmodule
