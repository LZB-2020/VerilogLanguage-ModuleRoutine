!(https://github.com/HITlvzhenbin2020/VerilogLanguage-ModuleRoutine/blob/main/image/2020-06-05-211745.jpg)
## 欢迎来到HIT吕振斌的个人博客——VerilogLanguage-ModuleRoutine版块

该网站用于收集一些基于verilog语言的通用module（包含对应的testbench文件）。

目的在于：在保证正确率的前期下，缩短FPGA项目产品的开发周期。

### 目录

在此列出截止到当前已收集的module名称，并显示出模块头以供读者概览输入输出端口，若查看详细代码，则请进入Github（单击【View on GitHub】）查看下载。

当然，此处作者会根据自己的情况，不定期进行更新。

**1. divide.v（时钟分频）**
```verilog
  module divide #(parameter  N = 5, parameter  WIDTH = 3)
  //N: Frequency division factor, N = (clk frequency) / (clkout frequency)
  //WIDTH: Counter bit width, make sure: WIDTH > ln(N+1) / ln2
  (
    input       clk,   //input clk
    input     rst_n,   //active low
    output   clkout    //output clk
  ); 
```

**2. debounce.v（独立按键消抖）**
```verilog
  module debounce 
  #(
    parameter  N = 1,
    parameter  CNT_NUM = 240000,
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
```

**3. Array_KeyBoard.v（4×4矩阵键盘扫描）**
```verilog
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
```

**4. pwm.v（PWM生成）**
```verilog
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
```

**5. segment_anode.v（共阳极八段数码管）**
```verilog
  module segment_anode (
    input         seg_DIG,  // Position selection, active high
    input          seg_DP,  // Decimal point, active low
    input  [3:0] seg_data,  // 0~F to be displayed
    output [8:0]  seg_led   // nine signals: MSB~LSB = DIG、DP、G、F、E、D、C、B、A
  );
```

**6. segment_cathode.v（共阴极八段数码管）**
```verilog
  module segment_cathode (
    input         seg_DIG,  // Position selection, active low
    input          seg_DP,  // Decimal point, active high
    input  [3:0] seg_data,  // 0~F to be displayed
    output [8:0]  seg_led   // nine signals: MSB~LSB = DIG、DP、G、F、E、D、C、B、A
  );
```

更多Markdown语法细节详见 [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/HITlvzhenbin2020/VerilogLanguage-ModuleRoutine/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.
