
`timescale 1ns/1ns

module pwm_tb ();

  reg          clk;
  reg        rst_n;
  reg           en;
  reg [31:0] cycle;	// time of pwm cycle = cycle * (time of clk cycle)
  reg [31:0]  duty;	// duty < cycle
  wire     pwm_out;

pwm #(.WIDTH (32)) pwm
//the width of counter, make sure: WIDTH > ln(cycle) / ln2
(
      .clk     (clk),
      .rst_n   (rst_n),
      .en      (en),
      .cycle   (cycle),	// time of pwm cycle = cycle * (time of clk cycle)
      .duty    (duty),	// duty < cycle
      .pwm_out (pwm_out)
);
  
  initial begin
      clk = 1'b0;
  end
  always #42 clk = ~clk;
  
  initial begin
    cycle = 0; duty = 0;
    en = 1'b0; delay(4000);
	en = 1'b1; delay(4000);
	
    rst_n = 1'b1; delay(4000);
	rst_n = 1'b0; delay(40000);
	rst_n = 1'b1; delay(250000);
		
	cycle = 10;
	duty = 5;
	delay(250000);
	en = 1'b0; delay(4000);
	en = 1'b1; delay(4000);
		
	cycle = 10;
	duty = 8;
	delay(250000);
	en = 1'b0; delay(4000);
	en = 1'b1; delay(4000);
		
	cycle = 10;
	duty = 2;
	delay(250000);
	en = 1'b0; delay(4000);
	en = 1'b1; delay(4000);
	$stop;
  end
  
  
  task delay;
    input [31:0] M;
	 begin
	     repeat(M) @(posedge clk) #1;
	 end
  endtask
  
endmodule
