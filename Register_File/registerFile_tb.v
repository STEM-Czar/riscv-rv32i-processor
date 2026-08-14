`timescale 1 ns / 1 ps

module registerFile_tb;

    parameter data_width = 32;
    parameter address_width = 5;

    reg clk;
    reg rst_n;
    reg we;
    reg [address_width-1:0] w_addr;
    reg [data_width-1:0] w_data;
    reg [address_width-1:0] r_addr1; 
    wire [data_width-1:0] r_data1; 
    reg [address_width-1:0] r_addr2; 
    wire [data_width-1:0] r_data2;

    registerFile #(
    .data_width(data_width),
    .address_width(address_width)
    ) RegFile (.clk(clk), .rst_n(rst_n), .we(we), .w_addr(w_addr), .w_data(w_data), .r_addr1(r_addr1), .r_data1(r_data1), .r_addr2(r_addr2), .r_data2(r_data2));

    always #5 clk = ~clk;

    initial
    begin 

        $dumpfile("regFile_wave.vcd");
        $dumpvars(0, registerFile_tb);

        clk     = 0;
        rst_n   = 0;
        we      = 0;
        w_addr  = 0;
        w_data  = {data_width{1'b0}};
        r_addr1 = 5'd1; 
        r_addr2 = 5'd2;

        #12;
        rst_n = 1; // outputs should stay 0

        #8;
        we     = 1;
        w_addr = 5'd0;
        w_data = 32'hDEAD_BEEF;

        #10;
        we     = 0;
        r_addr1 = 5'd0; // output should be 0, blocking the write

        #10;
        we     = 1;
        w_addr = 5'd1;
        w_data = 32'hAAAA_AAAA;

        #10;
        w_addr = 5'd2;
        w_data = 32'hBBBB_BBBB;

        #10;
        we      = 0; // Disable write
        r_addr1 = 5'd1; // Reads 0xAAAAAAAA
        r_addr2 = 5'd2; // Reads 0xBBBBBBBB simultaneously

        #10;
        we     = 0;
        w_addr = 5'd1;
        w_data = 32'hFFFF_FFFF; // Attempt overwrite while we=0 (should fail)

        #7;
        rst_n = 0; // Clears all registers immediately

        #10;
        rst_n = 1;

        #20;
        $display("Test complete");
        $finish;
    end

endmodule