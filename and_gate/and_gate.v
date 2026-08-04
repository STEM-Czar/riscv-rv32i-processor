`timescale 1ns/1ps

module and_gate(and_out, and_inA, and_inB);

input wire and_inA, and_inB;
output wire and_out;

assign and_out = and_inA & and_inB;

endmodule