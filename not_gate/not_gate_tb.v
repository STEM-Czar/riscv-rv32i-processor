`timescale 1ns/1ps

module not_gate_tb;

reg A;
wire Out;

not_gate NOT (.not_out(Out), .not_in(A));

initial begin

    $dumpfile("not_wave.vcd");
    $dumpvars(0, not_gate_tb);

    A = 0;
    #10;

    A = 1;
    #10;

    $display("Test completed");

    $finish;

end

endmodule