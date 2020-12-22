
// Module Function: 4*4 Array_KeyBoard, active low

module Array_KeyBoard
#(
  parameter  CNT_200HZ = 60000,
  parameter  WIDTH = 16
)
//CNT_200HZ: Frequency division factor
//WIDTH: make sure: WIDTH > (ln(CNT_200HZ) / ln2) - 1
(
  input               clk,
  input             rst_n,
  input  [ 3:0]       col,  // get column data
  output [ 3:0]       row,  // scan row/line
  output [15:0]   key_out,  // output Key number
  output [15:0] key_pulse   // output Key pulse, last one clk cycle
);

  localparam  STATE0 = 2'b00;
  localparam  STATE1 = 2'b01;
  localparam  STATE2 = 2'b10;
  localparam  STATE3 = 2'b11;

  /*
    因使用4x4矩阵按键，通过扫描方法实现，所以这里使用状态机实现，共分为4种状态
    在其中的某一状态时间里，对应的4个按键相当于独立按键，可按独立按键的周期采样法采样
    周期采样时每隔20ms采样一次，对应这里状态机每隔20ms循环一次，每个状态对应5ms时间
    对矩阵按键实现原理不明白的，请去了解矩阵按键实现原理
  */

  //create clk_200hz: cycle 5ms
  reg [WIDTH-1:0] cnt;
  reg  clk_200hz;
  always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            cnt <= 0;
            clk_200hz <= 1'b0;
        end
        else begin
            if(cnt >= ((CNT_200HZ >> 1) - 1)) begin
                cnt <= 0;
                clk_200hz <= ~clk_200hz;
            end
            else begin
                cnt <= cnt + 1;
                clk_200hz <= clk_200hz;
            end
        end
    end

  //Scan line every 5ms
  reg[1:0]c_state;
  reg[3:0]row_r;
  always@(posedge clk_200hz or negedge rst_n)
    begin
        if(!rst_n) begin
            c_state <= STATE0;
            row_r <= 4'b1110;
        end
        else begin
            case(c_state)
                STATE0: begin c_state <= STATE1; row_r <= 4'b1101; end
                STATE1: begin c_state <= STATE2; row_r <= 4'b1011; end
                STATE2: begin c_state <= STATE3; row_r <= 4'b0111; end
                STATE3: begin c_state <= STATE0; row_r <= 4'b1110; end
                default:begin c_state <= STATE0; row_r <= 4'b1110; end
            endcase
        end
    end
  assign row = row_r;

  //Read column
  reg[15:0]key,key_r;
  reg[15:0]key_out_r;
  always@(negedge clk_200hz or negedge rst_n)
    begin
        if(!rst_n) begin
            key_out_r <= 16'hffff;
			key_r <= 16'hffff;
			key <= 16'hffff;
        end
        else begin
            case(c_state)
                //Debounce: two consecutive samples of low level are judged as button press
                STATE0: begin key_out_r[ 3: 0] <= key_r[ 3: 0]|key[ 3: 0]; key_r[ 3: 0] <= key[ 3: 0]; key[ 3: 0] <= col; end
                STATE1: begin key_out_r[ 7: 4] <= key_r[ 7: 4]|key[ 7: 4]; key_r[ 7: 4] <= key[ 7: 4]; key[ 7: 4] <= col; end
                STATE2: begin key_out_r[11: 8] <= key_r[11: 8]|key[11: 8]; key_r[11: 8] <= key[11: 8]; key[11: 8] <= col; end
                STATE3: begin key_out_r[15:12] <= key_r[15:12]|key[15:12]; key_r[15:12] <= key[15:12]; key[15:12] <= col; end
                default:begin key_out_r <= 16'hffff; key_r <= 16'hffff; key <= 16'hffff; end
            endcase
        end
    end
  assign key_out = key_out_r;

  //Register low_sw_r, lock low_sw to next clk
  reg[15:0]key_out_r1;
  always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) begin
            key_out_r1 <= 16'hffff;
        end
        else begin
            key_out_r1 <= key_out_r;
        end
    end
  //Detect the negedge of low_sw, generate pulse
  assign key_pulse= key_out_r1 & ( ~key_out_r);

endmodule
