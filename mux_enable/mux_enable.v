`timescale 1 ns / 1ps

module mux_enable #(
    parameter n_inputs = 16,
    parameter bit_width = 32,
    parameter n_muxS = $clog2(n_inputs)
)(mux_out, mux_in, mux_S, mux_en );

    input wire [(n_inputs * bit_width) - 1:0] mux_in;
    input wire [n_muxS - 1:0] mux_S;
    input wire mux_en;
    output reg [bit_width - 1:0] mux_out;

    always @(*)
    begin
        if (mux_en)
            begin
                mux_out = mux_in[mux_S * bit_width +: bit_width];
            end

        else
            begin
                mux_out = {bit_width{1'b0}};
            end
        
    end

endmodule