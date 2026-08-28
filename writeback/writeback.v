`timescale 1 ns / 1 ps

module writeback (
    input wire [31:0] alu_result,
    input wire [31:0] r_mdata,
    input wire wb_S,
    output wire [31:0] w_data
);

    mux21_parameterized #(.bit_width(32)) WB 
    (.mux21_out(w_data), .mux21_inA(alu_result), .mux21_inB(r_mdata), .mux21_S(wb_S));

endmodule