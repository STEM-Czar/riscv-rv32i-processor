`timescale 1 ns / 1ps

module mux21_parameterized #(parameter bit_width = 4) (mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire [bit_width - 1: 0] mux21_inA; 
    input wire [bit_width - 1: 0] mux21_inB; 
    input wire mux21_S;
    output wire [bit_width - 1: 0] mux21_out;

    assign mux21_out = mux21_S ? mux21_inB : mux21_inA;

endmodule