`timescale 1ns/1ps

module and_gate_tb;

reg A, B;
wire Out;

and_gate AND1 (.and_out(Out), .and_inA(A), .and_inB(B));

initial begin

    $dumpfile("and_wave.vcd");
    $dumpvars(0, and_gate_tb);

    A = 0; B = 0;
    #10;

    A = 0; B = 1;
    #10;

    A = 1; B = 0;
    #10;

    A = 1; B = 1;
    #10;

    $display("Test completed");

    $finish;

end

endmodule