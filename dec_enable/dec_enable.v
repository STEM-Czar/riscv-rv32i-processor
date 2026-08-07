`timescale 1 ns/ 1 ps

module dec_enable #(
    parameter n_inputs = 2,
    parameter n_outputs = 2 ** (n_inputs)
)(dec_out, dec_in, dec_en);

    input wire [n_inputs - 1: 0] dec_in;
    input wire dec_en;
    output reg [n_outputs -1:0] dec_out;

    always @(*)
    begin
        if (dec_en)
        begin
            dec_out = 1'b1 << dec_in;
        end
        else 
        begin
            dec_out = '0;
        end

    end

endmodule
