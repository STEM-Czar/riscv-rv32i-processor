`timescale 1 ns / 1ps

module mux21_ifelse (mux21_out, mux21_inA, mux21_inB, mux21_S);

    input wire mux21_inA, mux21_inB, mux21_S;
    output reg mux21_out;

    always @(*) 
    begin
        if (mux21_S)
            begin
                mux21_out = mux21_inB;
            end
        else
            begin
                mux21_out = mux21_inA;
            end
    end

endmodule 