`timescale 1 ns / 1 ps

module Dflipflop_tb;

    reg d;
    reg clk;
    reg rst_n;
    wire q;
    wire q_bar;

    Dflipflop FlipFlop (.q(q), .q_bar(q_bar), .d(d), .clk(clk), .rst_n(rst_n));

    always #5 clk = ~clk;

    initial
    begin 
        
        $dumpfile("Dflipflop_wave.vcd");
        $dumpvars(0, Dflipflop_tb);

        clk   = 0;
        d     = 0;
        rst_n = 0;

        #12;
        rst_n = 1;
        
        #8;
        d = 1; 
        
        #10;
        d = 0;

        #10;
        d = 1;

        #5;
        rst_n = 0;

        #10;
        rst_n = 1;

        #20;
        $display("Test Complete");
        $finish;


    end

endmodule