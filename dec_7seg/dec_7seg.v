`timescale 1 ns / 1 ps

module dec_7seg (dec_in, dec_out);

    input wire [3:0] dec_in;
    output reg [6:0] dec_out;

    always @(*)
    begin
        case (dec_in)
            //Indices map as dec_out[g, f, e, d, c, b, a] where a is top bar and g is the middle bar, use clockwise 
            4'b0000: dec_out = 7'b0111111;

            4'b0001: dec_out = 7'b0000110;

            4'b0010: dec_out = 7'b1011011;

            4'b0011: dec_out = 7'b1001111;

            4'b0100: dec_out = 7'b1100110;

            4'b0101: dec_out = 7'b1101101;

            4'b0110: dec_out = 7'b1111101;

            4'b0111: dec_out = 7'b0000111;

            4'b1000: dec_out = 7'b1111111;

            4'b1001: dec_out = 7'b1101111;

            default: dec_out = 7'b0000000;
        endcase
    end

endmodule