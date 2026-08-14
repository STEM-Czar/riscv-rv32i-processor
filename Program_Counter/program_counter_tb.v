`timescale 1 ns / 1 ps

module program_counter_tb;

    parameter data_width = 32;

    reg clk;
    reg rst_n;
    reg [data_width-1:0] next_pc;
    wire [data_width-1:0] pc;
    wire [data_width-1:0] pc_plus4;


    program_counter #(
        .data_width(data_width) 
    ) PC (.clk(clk), .rst_n(rst_n), .next_pc(next_pc), .pc(pc), .pc_plus4(pc_plus4));


    always #5 clk = ~clk;

    initial
    begin 

        $dumpfile("program_counter_wave.vcd");
        $dumpvars(0, program_counter_tb);

        clk = 0; rst_n = 0;
        next_pc = 32'h0000_0000;

        #12;
        rst_n  = 1;

        repeat (4) //sequential execution
        begin 
            @(negedge clk);
            next_pc = pc_plus4;
        end

        @(negedge clk); 
        next_pc = 32'h0000_0080; //Jump or Branch Test

        @(negedge clk);
        next_pc = pc_plus4;

        #20;
        $display("Test Complete");
        $finish;


    end

endmodule