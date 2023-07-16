//---------------------------------------------------------------------------------------
// baud rate generator for uart
//
// this module has been changed to receive the baud rate dividing cnt from registers.
// the two registers should be calculated as follows:
// first register:
//         baud_freq_i = 16*baud_rate / gcd(global_clock_freq, 16*baud_rate)
// second register:
//         baud_limit_i = (global_clock_freq / gcd(global_clock_freq, 16*baud_rate)) - baud_freq_i
//
//---------------------------------------------------------------------------------------

module baud (
    input  wire        clk,          // global clock input
    input  wire        rst,          // global reset input

    input  wire [11:0] baud_freq_i,  // baud rate setting registers - see header description
    input  wire [15:0] baud_limit_i,
    output reg         ce16_o        // baud rate multiplyed by 16
);

    // internal registers
    reg [15:0] cnt;
    //---------------------------------------------------------------------------------------
    // module implementation
    // baud divider cnt
    always @ ( posedge clk ) begin
        if ( rst ) begin
            cnt <= 16'b0;
        end
        else if ( cnt >= baud_limit_i ) begin
            cnt <= cnt - baud_limit_i;
        end
        else begin
            cnt <= cnt + baud_freq_i;
        end
    end

    // clk divider output
    always @ ( posedge clk ) begin
        if ( rst ) begin
            ce16_o <= 1'b0;
        end
        else if ( cnt >= baud_limit_i ) begin
            ce16_o <= 1'b1;
        end
        else begin
            ce16_o <= 1'b0;
        end
    end

endmodule
