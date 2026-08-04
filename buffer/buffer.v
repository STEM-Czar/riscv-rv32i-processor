`timescale 1ns/1ps

module buff_gate(buff_out, buff_in);

input wire buff_in;
output wire buff_out;

assign buff_out = buff_in;

endmodule