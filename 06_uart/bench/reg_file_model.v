//---------------------------------------------------------------------------------------
// register file model as a simple memory
//
//---------------------------------------------------------------------------------------

`include "timescale.v"

module reg_file_model (
    input  wire       clk,      // global clock input
    input  wire       rst,      // global reset input
    input  wire [7:0] addr_i,   // address bus to register file
    input  wire [7:0] wdata_i,  // write data to register file
    input  wire       wen_i,    // write control to register file
    input  wire       ren_i,    // read control to register file
    output reg  [7:0] rdata_o   // data read from register file
);

    // internal signal
    reg [7:0] reg_file [0:255];   // 256 of 8 bit registers

    //---------------------------------------------------------------------------------------
    // internal tasks
    // clear memory
    task clear_reg_file;
        reg [8:0] addr;
        begin
            for (addr = 9'h0; addr <= 9'h0FF; addr = addr + 1) begin
                reg_file[addr] = 0;
            end
        end
    endtask

    //---------------------------------------------------------------------------------------
    // module implementation
    // register file write
    always @ ( posedge clk ) begin
        if ( rst )
            clear_reg_file;
        else if ( wen_i )
            reg_file[addr_i] <= wdata_i;
    end

    // register file read
    always @ ( posedge clk ) begin
        if ( rst )
            rdata_o <= 8'h0;
        else if ( ren_i )
            rdata_o <= reg_file[addr_i];
    end

endmodule
