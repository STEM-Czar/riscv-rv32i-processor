`timescale 1 ns / 1ps

module enc_parity #(
    parameter n_inputs = 2,
    parameter n_outputs = $clog2(n_inputs)
    ) (enc_out, enc_in, parity);

    input wire [n_inputs - 1:0 ] enc_in;
    output reg [n_outputs - 1:0] enc_out;
    output wire parity;

    assign parity = ^enc_in;

    integer i;

    always @(*) 
    begin
        enc_out = '0;
        
        for (i = 0; i < n_inputs; i = i + 1) 
        begin
            if (enc_in[i]) 
            begin
                enc_out = i[n_outputs-1:0];
            end
        end
    end

endmodule
