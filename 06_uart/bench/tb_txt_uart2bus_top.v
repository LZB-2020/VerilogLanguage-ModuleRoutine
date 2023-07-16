//---------------------------------------------------------------------------------------
// uart test bench
//
//---------------------------------------------------------------------------------------

`include "timescale.v"

module tb_uart_top;

    // include uart tasks
    `include "uart_tasks.v"

    // internal signal
    reg       clock;        // global clock
    reg       reset;        // global reset
    reg [6:0] counter;

    //---------------------------------------------------------------------------------------
    // test bench implementation
    // global signals generation
    initial begin
        counter = 0;
        reset   = 1;
        #40 reset   = 0;
    end

    // clock generator - 40MHz clock
    always begin
        #12 clock = 0;
        #13 clock = 1;
    end

    // test bench dump variables
    initial begin
        $dumpfile("tb_uart_top.vcd");
        //$dumpall;
        $dumpvars(0, tb_uart_top);
    end

    //------------------------------------------------------------------
    // test bench transmitter and receiver
    // uart transmit - test bench control

    initial
    begin
        // defualt value of serial output
        serial_out = 1;

        // transmit a write command to internal register file
        // command string: "w 3d 1a" + CR
        send_serial (8'h77, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // w
        #100;
        send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // space
        #100;
        send_serial (8'h64, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // 3
        #100;
        send_serial (8'h39, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // d
        #100;
        send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // space
        #100;
        send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // 1
        #100;
        send_serial (8'h61, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // a
        #100;
        send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // CR
        #100;
        // transmit a read command from register file
        // command string: "r 1a" + CR
        send_serial (8'h72, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // r
        #100;
        send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // space
        #100;
        send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // 1
        #100;
        send_serial (8'h61, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // a
        #100;
        send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); // CR
        #100;

        // delay and finish
        #900000;
        $finish;
    end

    // uart receive
    initial begin
        // default value for serial receiver and serial input
        serial_in         = 1;
        get_serial_data   = 0;        // data received from get_serial task
        get_serial_status = 0;        // status of get_serial task
    end

    // serial sniffer loop
    always begin
        // call serial sniffer
        get_serial(`BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8);

        // check serial receiver status
        // byte received OK
        if (get_serial_status & `RECEIVE_RESULT_OK) begin
            // check if not a control character (above and including space ascii code)
            if (get_serial_data >= 8'h20) begin
                $display("received byte 0x%h (\"%c\") at %t ns", get_serial_data, get_serial_data, $time);
            end
            else begin
                $display("received byte 0x%h (\"%c\") at %t ns", get_serial_data, 8'hb0, $time);
            end
        end

        // false start error
        if (get_serial_status & `RECEIVE_RESULT_FALSESTART) begin
            $display("Error (get_char): false start condition at %t", $realtime);
        end

        // bad parity error
        if (get_serial_status & `RECEIVE_RESULT_BADPARITY) begin
            $display("Error (get_char): bad parity condition at %t", $realtime);
        end

        // bad stop bits sequence
        if (get_serial_status & `RECEIVE_RESULT_BADSTOP) begin
            $display("Error (get_char): bad stop bits sequence at %t", $realtime);
        end
    end

    //------------------------------------------------------------------
    // device under test
    // DUT interface
    wire [7:0] int_address;  // address bus to register file
    wire [7:0] int_wr_data;  // write data to register file
    wire       int_write;    // write control to register file
    wire       int_read;     // read control to register file
    wire [7:0] int_rd_data;  // data read from register file
    wire       int_req;      // bus access request signal
    wire       int_gnt;      // bus access grant signal
    wire       rx;           // DUT serial input
    wire       tx;           // DUT serial output

    // DUT instance
    uart_top uart_top (
        .clk        ( clock        ),
        .rst        ( reset        ),
        .rx         ( rx           ),
        .tx         ( tx           ),
        .addr_o     ( int_address  ),
        .wen_o      ( int_write    ),
        .wdata_o    ( int_wr_data  ),
        .ren_o      ( int_read     ),
        .rdata_i    ( int_rd_data  ),
        .req_o      ( int_req      ),
        .gnt_i      ( int_gnt      )
    );
    // bus grant is always active
    assign int_gnt = 1'b1;

    // serial interface to test bench
    assign rx = serial_out;
    always @ (posedge clock) serial_in = tx;

    // register file model
    reg_file_model reg_file_model (
        .clk        ( clock        ),
        .rst        ( reset        ),
        .addr_i     ( int_address  ),
        .wdata_i    ( int_wr_data  ),
        .wen_i      ( int_write    ),
        .ren_i      ( int_read     ),
        .rdata_o    ( int_rd_data  )
    );

endmodule
