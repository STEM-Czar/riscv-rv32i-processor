`timescale 1ns/1ps

module not_gate(not_out, not_in);

input wire not_in;
output wire not_out;

assign not_out = ~not_in;

endmodule