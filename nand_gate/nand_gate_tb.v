`timescale 1ns/1ps

module nand_gate_tb;

reg A, B;
wire Out;

nand_gate NAND1 (.nand_out(Out), .nand_inA(A), .nand_inB(B));

initial begin

    $dumpfile("nand_wave.vcd");
    $dumpvars(0, nand_gate_tb);

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