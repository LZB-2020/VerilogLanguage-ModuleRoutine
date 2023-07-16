
`timescale 1ns/1ns

module debounce_tb ();

  reg              clk;
  reg            rst_n;
  reg  [3:0]     key_n;  //active low of keys
  wire [3:0] key_pulse;  //kry_n[x] was active, and key_pulse[x] is 1(not 0) for one clk cycle

debounce 
#(
  .N       (4),
  .CNT_NUM (240000),
  .WIDTH   (18)
) debounce_tb
//N: the number of debounce keys
//CNT_NUM: the number of clk cycles for timing,  CNT_NUM = (time of debounce) / (cycle of input clk)
//WIDTH: the width of counter for timing, WIDTH > ln(CNT_NUM) / ln2
(
     .clk        (clk),
     .rst_n      (rst_n),
     .key_n      (key_n),  //active low of keys
     .key_pulse  (key_pulse)   //kry_n[x] was active, and key_pulse[x] is 1(not 0) for one clk cycle
 );
  
  //clk_12MHz
  initial begin
      clk = 1'b0;
  end
  always #42 clk = ~clk;
  
  initial begin
      key_n = 4'b1111;
      rst_n = 1'b1; delay(4000);
      rst_n = 1'b0; delay(40000);
      rst_n = 1'b1; delay(4000);
	  
      key_n = 4'b1110; delay(250000);
      key_n = 4'b1111; delay(200000);
      key_n = 4'b1101; delay(10000);
      key_n = 4'b1111; delay(200000);
      key_n = 4'b1011; delay(250000);
      key_n = 4'b1111; delay(200000);
      key_n = 4'b0111; delay(250000);
      key_n = 4'b1111; delay(200000);
      key_n = 4'b1001; delay(250000);
      key_n = 4'b1000; delay(250000);
      key_n = 4'b1111; delay(200000);
	  
      $stop;
  end
  
  task delay;
    input [31:0] M;
	 begin
	     repeat(M) @(posedge clk) #1;
	 end
  endtask
  
endmodule
