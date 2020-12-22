
`timescale 1ns/1ns

module Array_KeyBoard_tb ();

  reg               clk;
  reg             rst_n;
  reg  [ 3:0]       col;  // get column data
  wire [ 3:0]       row;  // scan row/line
  wire [15:0]   key_out;  // output Key number
  wire [15:0] key_pulse;  // output Key pulse, last one clk cycle

Array_KeyBoard
#(
  .CNT_200HZ (60000),
  .WIDTH (16)
) Array_KeyBoard
//CNT_200HZ: Frequency division factor
//WIDTH: make sure: WIDTH > (ln(CNT_200HZ) / ln2) - 1
(
      .clk       (clk),
      .rst_n     (rst_n),
      .col       (col),  // get column data
      .row       (row),  // scan row/line
      .key_out   (key_out),  // output Key number
      .key_pulse (key_pulse)   // output Key pulse, last one clk cycle
);
  
  initial begin
      clk = 1'b0;
  end
  always #42 clk = ~clk;
  
  initial begin
        col = 4'b1111;
        rst_n = 1'b1; delay(4000);
	rst_n = 1'b0; delay(40000);
	rst_n = 1'b1; delay(200000);
	
	col = 4'b1110; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b1101; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b1011; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b0111; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b1100; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b1100; delay(50000); //null
	col = 4'b1111; delay(250000);
		
	col = 4'b1001; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b0011; delay(300000);
	col = 4'b1111; delay(250000);
	
	col = 4'b0100; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b0010; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b0000; delay(300000);
	col = 4'b1111; delay(250000);
		
	col = 4'b1111; delay(250000);
		
	$stop;
  end
  
  
  task delay;
    input [31:0] M;
	 begin
	     repeat(M) @(posedge clk) #1;
	 end
  endtask
  
endmodule
