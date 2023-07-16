
`timescale 1ns/1ns

module divide_tb ();

  reg     clk;
  reg   rst_n;
  wire clkout;  //kry_n[x] was active, and key_pulse[x] is 1(not 0) for one clk cycle

divide #(.N (3), .WIDTH (3)) divide
//N: Frequency division factor, N = (clk frequency) / (clkout frequency)
//WIDTH: Counter bit width, make sure: WIDTH > ln(N+1) / ln2
(
     .clk      (clk),   //input clk
     .rst_n    (rst_n),   //active low
     .clkout   (clkout)    //output clk
);
  
  initial begin
      clk = 1'b0;
  end
  always #42 clk = ~clk;
  
  initial begin
      rst_n = 1'b1; delay(4000);
	  rst_n = 1'b0; delay(40000);
	  rst_n = 1'b1; delay(250000);
	  $stop;
  end
  
endmodule
