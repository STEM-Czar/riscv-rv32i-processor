`timescale 1ns/1ps

module or_gate(or_out, or_inA, or_inB);

input wire or_inA, or_inB;
output wire or_out;

assign or_out = or_inA | or_inB;

endmodule