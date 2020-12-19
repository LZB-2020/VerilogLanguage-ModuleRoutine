

// Module Function: Keys Debounce
 
module debounce 
#(
  parameter  N = 1;
  parameter  CNT_NUM = 240000;
  parameter  WIDTH = 18
)
//N: the number of debounce keys
//CNT_NUM: the number of clk cycles for timing,  CNT_NUM = (time of debounce) / (cycle of input clk)
//WIDTH: the width of counter for timing, WIDTH > ln(CNT_NUM) / ln2
(
  input                clk,
  input              rst_n,
  input  [N-1:0]     key_n,  //active low of keys
  output [N-1:0] key_pulse   //kry_n[x] was active, and key_pulse[x] is 1(not 0) for one clk cycle
 );

  //Debounce the falling edge of key_n
  reg [N-1:0] key_n_r;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            key_n_r <= {N{1'b1}};
        end
        else begin
            key_n_r <= key_n;
        end
    end
  wire  key_edge = key_n_r & (~key_n);

  //Timing
  reg [WIDTH-1:0] cnt;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            cnt <= 0;
        end
        else if(key_edge) begin
            cnt <= 0;
        end
		else if(cnt == CNT_NUM-1) begin
            cnt <= cnt;
        end
        else begin
            cnt <= cnt + 1;
        end
    end

  //Debounce and check the key_n again
  reg [N-1:0] key_sec, key_sec_pre;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            key_sec <= {N{1'b1}};
        end
        else if(cnt == CNT_NUM-1) begin
            key_sec <= key_n;
        end
		else begin
		    key_sec <= {N{1'b1}};
		end
    end
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            key_sec_pre <= {N{1'b1}};
        end
        else if(cnt == CNT_NUM-1) begin
            key_sec_pre <= key_sec;
        end
		else begin
		    key_sec_pre <= {N{1'b1}};
		end
	end
  assign  key_pulse = key_sec_pre & (~key_sec);

endmodule
