`timescale 1ns/1ps

module xnor_gate_tb;

reg A, B;
wire Out;

xnor_gate XNOR1 (.xnor_out(Out), .xnor_inA(A), .xnor_inB(B));

initial begin

    $dumpfile("xnor_wave.vcd");
    $dumpvars(0, xnor_gate_tb);

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