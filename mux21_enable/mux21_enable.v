`timescale 1 ns / 1ps

module mux21_enable #(parameter Width = 4) (mux21_enable, mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_enable;
    input wire [Width - 1: 0] mux21_inA; 
    input wire [Width - 1: 0] mux21_inB; 
    input wire mux21_S;
    output wire [Width - 1: 0] mux21_out;

    assign mux21_out = mux21_enable ? (mux21_S ? mux21_inB : mux21_inA) : {Width{1'b0}};

endmodule