`timescale 1ns/1ps

module buffer_tb;

reg A;
wire Out;

buff_gate BUFFER (.buff_out(Out), .buff_in(A));

initial begin

    $dumpfile("buffer_wave.vcd");
    $dumpvars(0, buffer_tb);

    A = 0;
    #10;

    A = 1;
    #10;

    $display("Test completed");

    $finish;

end

endmodule