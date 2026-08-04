`timescale 1ns/1ps

module nand_gate(nand_out, nand_inA, nand_inB);

input wire nand_inA, nand_inB;
output wire nand_out;

assign nand_out = ~(nand_inA & nand_inB);

endmodule