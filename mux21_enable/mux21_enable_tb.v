`timescale 1 ns/ 1ps

module mux21_enable_tb;

    parameter Width_tb = 4;

    reg enable; reg [Width_tb - 1:0] inA; reg [Width_tb - 1:0] inB; reg S; wire [Width_tb - 1:0] OUT;

    mux21_enable MUX21 (.mux21_enable(enable), .mux21_out(OUT), .mux21_inA(inA), .mux21_inB(inB), .mux21_S(S));

    initial begin

        $dumpfile("mux21_enable_wave.vcd");
        $dumpvars(0, mux21_enable_tb);
        
        $display("------------------------------");
        $display("Time\t EN  inA  inB  S   |  OUT");
        $display("------------------------------");

        $monitor("%0d ns\t  %b  %b  %b  %b  |  %b", $time, enable, inA, inB, S, OUT);
        
        enable = 1'b0; inA = 4'b0001; inB = 4'b0010; S = 1'b0;
        #10

        enable = 1'b1; inA = 4'b0011; inB = 4'b0100; S = 1'b0;
        #10

        enable = 1'b0; inA = 4'b0101; inB = 4'b0110; S = 1'b1;
        #10

        enable = 1'b1; inA = 4'b0111; inB = 4'b1000; S = 1'b1;
        #10
        
        $display ("Simulation Completed");
        
        $finish;

    end

endmodule; 