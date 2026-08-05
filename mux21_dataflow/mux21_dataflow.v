`timescale 1 ns / 1 ps

module mux21_dataflow (mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_inA, mux21_inB, mux21_S;
    output wire mux21_out;

    assign mux21_out = (mux21_inA & ~mux21_S) | (mux21_S & mux21_inB);

endmodule