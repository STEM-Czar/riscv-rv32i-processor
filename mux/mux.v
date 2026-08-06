`timescale 1 ns / 1ps

module mux #(
    parameter n_inputs = 2,
    parameter bit_width = 32,
    parameter n_muxS = $clog2(n_inputs)
)(mux_out, mux_in, mux_S );

    input wire [(n_inputs * bit_width) - 1:0] mux_in;
    input wire [n_muxS - 1:0] mux_S;
    output reg [bit_width - 1:0] mux_out;

    always @(*)
    begin
        mux_out = mux_in[mux_S * bit_width +: bit_width];
    end

endmodule