`timescale 1 ns / 1 ps

module instruction_decode (
    input wire clk,
    input wire rst_n,
    input [31:0] instr,

    input  wire        we,
    input  wire [4:0]  w_addr,
    input  wire [31:0] w_data,

    output wire [6:0] opcode,
    output wire [4:0] rd,
    output wire [2:0] funct3,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [6:0] funct7,

    output wire [31:0] imm_out,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);

instruction_decoder ID_stage (
    .instr(instr),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),

    .imm_out(imm_out)

);

registerFile #(
    .data_width(32),
    .address_width(5)
) RegFile (.clk(clk), .rst_n(rst_n), .we(we), .w_addr(w_addr), .w_data(w_data), .r_addr1(rs1), .r_data1(rs1_data), 
    .r_addr2(rs2), .r_data2(rs2_data));

    
endmodule