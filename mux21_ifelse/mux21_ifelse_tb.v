`timescale 1 ns/ 1ps

module mux21_ifelse_tb;

    reg inA; reg inB; reg S; wire OUT;

    mux21_ifelse MUX21 (.mux21_out(OUT), .mux21_inA(inA), .mux21_inB(inB), .mux21_S(S));

    initial begin

        $dumpfile("mux21_ifelse_wave.vcd");
        $dumpvars(0, mux21_ifelse_tb);
        
        $display("------------------------------");
        $display("Time\t inA  inB  S   |  OUT");
        $display("------------------------------");

        $monitor("%0d ns\t  %b  %b  %b  |  %b", $time, inA, inB, S, OUT);
        
        inA = 1'b1; inB = 1'b0; S = 1'b0;
        #10

        inA = 1'b0; inB = 1'b1; S = 1'b0;
        #10

        inA = 1'b1; inB = 1'b0; S = 1'b1;
        #10

        inA = 1'b0; inB = 1'b1; S = 1'b1;
        #10
        
        $display ("Simulation Completed");
        
        $finish;

    end

endmodule; 