`timescale 1 ns / 1ps

module dec_gray2b #(
    parameter bit_width = 4
)(dec_out, dec_in);

    input wire [bit_width -1:0] dec_in;
    output reg [bit_width -1:0] dec_out;

    integer i;

    always @(*)
    begin
     
     dec_out[bit_width -1] = dec_in[bit_width -1];

     for (i = bit_width - 2; i >= 0 ; i = i - 1)
     begin
        dec_out[i] = dec_out[i+1] ^ dec_in[i];
     end
 

    end

endmodule