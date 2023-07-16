
// Module Function: the driver of independent digital of common anode

module segment_anode (
  input         seg_DIG,  // Position selection, active high
  input          seg_DP,  // Decimal point, active low
  input  [3:0] seg_data,  // 0~F to be displayed
  output [8:0]  seg_led   // nine signals: MSB~LSB = DIG、DP、G、F、E、D、C、B、A
);

  // MSB~LSB = G、F、E、D、C、B、A
  reg [6:0] seg [15:0];
  initial
    begin
        seg[0]  = 7'h40;  // 0
        seg[1]  = 7'h79;  // 1
        seg[2]  = 7'h24;  // 2
        seg[3]  = 7'h30;  // 3
        seg[4]  = 7'h19;  // 4
        seg[5]  = 7'h12;  // 5
        seg[6]  = 7'h02;  // 6
        seg[7]  = 7'h78;  // 7
        seg[8]  = 7'h00;  // 8
        seg[9]  = 7'h10;  // 9
        seg[10] = 7'h08;  // A
        seg[11] = 7'h03;  // b
        seg[12] = 7'h46;  // C
        seg[13] = 7'h21;  // d
        seg[14] = 7'h06;  // E
        seg[15] = 7'h0e;  // F
    end

  //DIG: position selection(1'b1 = Light, 1'b0 = OFF)
  //DP: decimal point(1'b0 = Light, 1'b1 = OFF)
  assign seg_led = {seg_DIG, seg_DP, seg[seg_data]};

endmodule
