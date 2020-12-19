
// Module Function: PWM

module pwm #(parameter WIDTH = 32)
//the width of counter, make sure: WIDTH > ln(cycle) / ln2
(
  input               clk,
  input             rst_n,
  input                en,
  input [WIDTH-1:0] cycle,	// time of pwm cycle = cycle * (time of clk cycle)
  input [WIDTH-1:0]  duty,	// duty < cycle
  output          pwm_out
);

  //counter for cycle
  reg [WIDTH-1:0] cnt;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            cnt <= 1'b1;
        end
        else if(cnt >= cycle) begin
            cnt <= 1'b1;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end

  //pulse with duty
  reg pwm_out_r;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            pwm_out_r <= 1'b1;
        end
        else if(cnt < duty) begin
            pwm_out_r <= 1'b1;
        end
        else begin
            pwm_out_r <= 1'b0;
        end
    end

  assign pwm_out = en ? pwm_out_r : 1'bz;

endmodule
