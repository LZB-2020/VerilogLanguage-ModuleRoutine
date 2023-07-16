
module uart_core (
    // global signals
    input  wire        clk,           // global clock input
    input  wire        rst,           // global reset input
    // uart serial signals
    input  wire        rx_i,          // serial data input
    output wire        tx_o,          // serial data output
    // transmit and receive internal interface signals
    input  wire [ 7:0] data2tx_i,     // data byte to transmit
    input  wire        next2tx_i,     // asserted to indicate that there is a new data byte for transmission
    output wire        tx_busy_o,     // signs that transmitter is busy
    output wire [ 7:0] rx2data_o,     // data byte received
    output wire        rx2next_o,     // signs that a new byte was received
    // baud rate configuration register - see baud_gen.v for details
    input  wire [11:0] baud_freq_i,  // baud rate setting registers - see header description
    input  wire [15:0] baud_limit_i,
    output wire        baud_clk
);

    // clk enable at bit rate
    wire ce16;
    assign baud_clk = ce16;

    //---------------------------------------------------------------------------------------
    // module implementation
    // baud rate generator module
    baud core_baud (
        .clk            ( clk          ),
        .rst            ( rst          ),
        .baud_freq_i    ( baud_freq_i  ),
        .baud_limit_i   ( baud_limit_i ),
        .ce16_o         ( ce16         )
    );

    // uart receiver
    rx core_rx (
        .clk            ( clk       ),
        .rst            ( rst       ),
        .ce16_i         ( ce16      ),
        .rx_i           ( rx_i      ),
        .data_o         ( rx2data_o ),
        .next_o         ( rx2next_o )
    );

    // uart transmitter
    tx core_tx (
        .clk            ( clk       ),
        .rst            ( rst       ),
        .ce16_i         ( ce16      ),
        .data_i         ( data2tx_i ),
        .next_i         ( next2tx_i ),
        .tx_o           ( tx_o      ),
        .tx_busy_o      ( tx_busy_o )
    );

endmodule
