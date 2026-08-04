`timescale 1ns/1ps

module nor_gate(nor_out, nor_inA, nor_inB);

input wire nor_inA, nor_inB;
output wire nor_out;

assign nor_out = ~(nor_inA | nor_inB);

endmodule