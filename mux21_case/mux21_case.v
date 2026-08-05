`timescale 1 ns / 1ps

module mux21_case (mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_inA, mux21_inB, mux21_S;
    output reg mux21_out;

    always @(*) 
    begin
        case (mux21_S)
            1'b0: mux21_out = mux21_inA;
            1'b1: mux21_out = mux21_inB;
            
            default: mux21_out = 1'bx;
        endcase
    end

endmodule 