`timescale 1ns/1ps

module xor_gate_tb;

reg A, B;
wire Out;

xor_gate XOR1 (.xor_out(Out), .xor_inA(A), .xor_inB(B));

initial begin

    $dumpfile("xor_wave.vcd");
    $dumpvars(0, xor_gate_tb);

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