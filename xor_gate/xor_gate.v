`timescale 1ns/1ps

module xor_gate(xor_out, xor_inA, xor_inB);

input wire xor_inA, xor_inB;
output wire xor_out;

assign xor_out = xor_inA ^ xor_inB;

endmodule