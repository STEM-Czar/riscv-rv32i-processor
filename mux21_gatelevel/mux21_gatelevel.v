`timescale 1ns/1ps

module mux21_gatelevel(mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_inA, mux21_inB, mux21_S;
    output wire mux21_out;

    wire Sn; wire and1_out; wire and2_out;

    not NOT (Sn, mux21_S);
    and AND1 (and1_out, mux21_inA, Sn);
    and AND2 (and2_out, mux21_inB, mux21_S);
    or OUT (mux21_out, and1_out, and2_out);

endmodule


