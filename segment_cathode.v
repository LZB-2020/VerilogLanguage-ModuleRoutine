
// Module Function: the driver of independent digital of common cathode

module segment_cathode (
  input         seg_DIG,  // Position selection, active low
  input          seg_DP,  // Decimal point, active high
  input  [3:0] seg_data,  // 0~F to be displayed
  output [8:0]  seg_led   // nine signals: MSB~LSB = DIG、DP、G、F、E、D、C、B、A
);

  // MSB~LSB = G、F、E、D、C、B、A
  reg [6:0] seg [15:0];
  initial
    begin
        seg[0]  = 7'h3f;  // 0
        seg[1]  = 7'h06;  // 1
        seg[2]  = 7'h5b;  // 2
        seg[3]  = 7'h4f;  // 3
        seg[4]  = 7'h66;  // 4
        seg[5]  = 7'h6d;  // 5
        seg[6]  = 7'h7d;  // 6
        seg[7]  = 7'h07;  // 7
        seg[8]  = 7'h7f;  // 8
        seg[9]  = 7'h6f;  // 9
        seg[10] = 7'h77;  // A
        seg[11] = 7'h7c;  // b
        seg[12] = 7'h39;  // C
        seg[13] = 7'h5e;  // d
        seg[14] = 7'h79;  // E
        seg[15] = 7'h71;  // F
    end

  //DIG: position selection(1'b0 = Light, 1'b1 = OFF)
  //DP: decimal point(1'b1 = Light, 1'b0 = OFF)
  assign seg_led = {seg_DIG, seg_DP, seg[seg_data]};

endmodule
