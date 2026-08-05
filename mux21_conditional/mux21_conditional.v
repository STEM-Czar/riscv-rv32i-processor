`timescale 1 ns / 1ps

module mux21_conditional (mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_inA, mux21_inB, mux21_S;
    output wire mux21_out;

    assign mux21_out = mux21_S ? mux21_inB : mux21_inA;

endmodule 