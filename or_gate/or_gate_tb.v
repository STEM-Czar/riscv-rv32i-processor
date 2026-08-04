`timescale 1ns/1ps

module or_gate_tb;

reg A, B;
wire Out;

or_gate OR1 (.or_out(Out), .or_inA(A), .or_inB(B));

initial begin

    $dumpfile("or_wave.vcd");
    $dumpvars(0, or_gate_tb);

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