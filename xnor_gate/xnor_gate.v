`timescale 1ns/1ps

module xnor_gate(xnor_out, xnor_inA, xnor_inB);

input wire xnor_inA, xnor_inB;
output wire xnor_out;

assign xnor_out = ~(xnor_inA ^ xnor_inB);

endmodule