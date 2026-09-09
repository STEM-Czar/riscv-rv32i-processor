`timescale 1 ns / 1 ps

module execute (
    
    input wire [31:0] imm_out,
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,

    input wire [31:0] pc,

    input wire alu_srcA,
    input wire alu_srcB,
    input wire [3:0] alu_control,

    output wire [31:0] alu_result,
    output wire [3:0] alu_status
);

    wire [31:0] inA;
    wire [31:0] inB;

    mux21_parameterized #(.bit_width(32)) MUXA (
        .mux21_out(inA), .mux21_inA(rs1_data), .mux21_inB(pc), .mux21_S(alu_srcA));

    mux21_parameterized #(.bit_width(32)) MUXB (
        .mux21_out(inB), .mux21_inA(rs2_data), .mux21_inB(imm_out), .mux21_S(alu_srcB));

    alu #(
        .bit_width(32),
        .control_bits(4)
    ) ALU (.alu_out(alu_result), .alu_status(alu_status), .inA(inA), .inB(inB), .alu_control(alu_control) );

endmodule