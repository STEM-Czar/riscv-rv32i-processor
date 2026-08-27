`timescale 1 ns / 1 ps

module data_memory_tb;

    reg clk;
    reg rst_n;
    reg [31:0] addr;
    reg [31:0] w_mdata;
    reg mem_write;
    reg mem_read;
    wire [31:0] r_mdata;

    data_memory DMEM (.clk(clk), .rst_n(rst_n), .addr(addr), .w_mdata(w_mdata), .mem_write(mem_write), .mem_read(mem_read), .r_mdata(r_mdata));

    always #5 clk = ~clk;

    initial
    begin 

        $dumpfile("data_memory_wave.vcd");
        $dumpvars(0, data_memory_tb);

        clk = 1'b0; rst_n = 1'b0; mem_write = 1'b0; mem_read = 1'b0;
        addr = 32'b0000_0000; w_mdata = 32'b0000_0000;

        

        //writing while reset is on
        mem_write = 1'b1;
        addr = 32'd3;
        w_mdata = 32'd67;
        
        #10;
        $display("Rst = %b  | mem_write = %b | mem_read = %b | addr = %d | write_data = %d | read_data = %d", rst_n, mem_write, mem_read, addr, w_mdata, r_mdata);

        rst_n = 1'b1;
        mem_write = 1'b1;
        addr = 32'd3;
        w_mdata = 32'd67;

        #10;
        $display("Rst = %b  | mem_write = %b | mem_read = %b | addr = %d | write_data = %d | read_data = %d", rst_n, mem_write, mem_read, addr, w_mdata, r_mdata);

        mem_write = 1'b0;
        mem_read = 1'b1;
        #10;
        $display("Rst = %b  | mem_write = %b | mem_read = %b | addr = %d | write_data = %d | read_data = %d", rst_n, mem_write, mem_read, addr, w_mdata, r_mdata);


        $display("Test Complete");
        $finish;

    end
endmodule