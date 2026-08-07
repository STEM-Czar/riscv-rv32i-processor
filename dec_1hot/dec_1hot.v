`timescale 1 ns / 1 ps

module dec_1hot #(
    parameter n_inputs = 4,
    parameter n_outputs = 2** (n_inputs)
) (dec_out, dec_in);

    input wire [n_inputs - 1:0] dec_in;
    output wire [n_outputs -1:0] dec_out;

    assign dec_out = 1'b1 << dec_in;


endmodule