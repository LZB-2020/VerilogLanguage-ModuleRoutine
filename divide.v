

// Module Function: divide clk in any integer(even or odd)
 
module divide #(parameter  N = 5, parameter  WIDTH = 3)
//N: Frequency division factor
//WIDTH: Counter bit width, make sure "WIDTH > ln(N+1) / ln2"
(
  input       clk,   //input clk
  input     rst_n,   //active low
  output   clkout    //output clk
);      
 
  reg [WIDTH-1:0] cnt_p, cnt_n;  //cnt_p to count the posedge clk, cnt_n to count the negedge clk
  reg             clk_p, clk_n;  //clk_p is divided clock of posedge clk, clk_n is divided clock of negedge clk
 
  //create cnt_p: Mode N
  always @ (posedge clk or negedge rst_n ) 
    begin
        if(!rst_n)
	    cnt_p <= 0;
        else if (cnt_p == (N-1))
            cnt_p <= 0;
	else cnt_p <= cnt_p + 1;   
    end
  
  //create clk_p: if N even, the duty of clk_p is 50%
  always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            clk_p <= 0;
        else if (cnt_p < (N >> 1)) 
            clk_p <= 0;
        else 
            clk_p <= 1;
    end
 
  //create cnt_n: Mode N   	
  always @ (negedge clk or negedge rst_n)
    begin
        if(!rst_n)
            cnt_n <= 0;
        else if (cnt_n == (N-1))
            cnt_n <= 0;
        else cnt_n <= cnt_n + 1;
    end
 
  //create cnt_n: half a clock cycle is difference from cnt_p; 
  //              the positive cycle of cnt_n is one clk clock more than the negative cycle of cnt_n
  always @ (negedge clk)
    begin
        if(!rst_n)
            clk_n <= 0;
        else if (cnt_n < (N >> 1))  
            clk_n <= 0;
        else 
            clk_n <= 1;  
    end
 
  //N=1, clkout = clk;
  //N=even, clkout = clk_p;
  //N=odd, clkout = clk_p & clk_n;
  assign clkout = (N==1) ? clk : 
                  (N[0]) ? (clk_p & clk_n) : clk_p; 
  
endmodule   
