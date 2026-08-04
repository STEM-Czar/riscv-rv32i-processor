`timescale 1ns/1ps

module nor_gate_tb;

reg A, B;
wire Out;

nor_gate NOR1 (.nor_out(Out), .nor_inA(A), .nor_inB(B));

initial begin

    $dumpfile("nor_wave.vcd");
    $dumpvars(0, nor_gate_tb);

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