`include "define.v"

module uart_top (
    // global signals
    input  wire          clk,       // global clock input
    input  wire          rst,       // global reset input
    // uart serial signals
    input  wire          rx,        // serial data input
    output wire          tx,        // serial data output
    // internal bus to register file
    output wire [ 7:0]   addr_o,    // address bus to register file
    output wire          wen_o,     // write control to register file
    output wire [ 7:0]   wdata_o,   // write data to register file
    output wire          ren_o,     // read control to register file
    input  wire [ 7:0]   rdata_i,   // data read from register file
    output wire          req_o,     // bus access request signal
    input  wire          gnt_i      // bus access grant signal
);

    // internal wires
    wire [ 7:0] data2tx;        // data byte to transmit
    wire        next2tx;    // asserted to indicate that there is a new data byte for transmission
    wire        tx_busy;        // signs that transmitter is busy
    wire [ 7:0] rx2data;        // data byte received
    wire        rx2next;    // signs that a new byte was received
    wire [11:0] baud_freq;
    wire [15:0] baud_limit;
    wire        baud_clk;

    // uart top module instance
    uart_core top_core (
        .clk            ( clk           ),
        .rst            ( rst           ),
        .rx_i           ( rx            ),
        .tx_o           ( tx            ),
        .data2tx_i      ( data2tx       ),
        .next2tx_i      ( next2tx       ),
        .tx_busy_o      ( tx_busy       ),
        .rx2data_o      ( rx2data       ),
        .rx2next_o      ( rx2next       ),
        .baud_freq_i    ( `D_BAUD_FREQ  ),
        .baud_limit_i   ( `D_BAUD_LIMIT ),
        .baud_clk       ( baud_clk      )
    );

    // uart parser instance
    parser top_parser (
        .clk          ( clk       ),
        .rst          ( rst       ),
        .data2tx_o    ( data2tx   ),
        .next2tx_o    ( next2tx   ),
        .tx_busy_i    ( tx_busy   ),
        .rx2data_i    ( rx2data   ),
        .rx2next_i    ( rx2next   ),
        .addr_o       ( addr_o    ),
        .wdata_o      ( wdata_o   ),
        .wen_o        ( wen_o     ),
        .rdata_i      ( rdata_i   ),
        .ren_o        ( ren_o     ),
        .req_o        ( req_o     ),
        .gnt_i        ( gnt_i     )
    );

endmodule
