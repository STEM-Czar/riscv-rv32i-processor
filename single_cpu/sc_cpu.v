`timescale 1 ns / 1 ps

module sc_cpu (
    input wire clk,
    input wire rst_n
);

    wire we;
    wire alu_srcA;
    wire alu_srcB;
    wire [3:0] alu_control;
    wire mem_write;
    wire mem_read;
    wire [1:0] wb_S;
    wire [1:0] pc_S;
    wire branch;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_out;


    cu CU (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .imm_out(imm_out),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .alu_control(alu_control),
        .we(we),
        .wb_S(wb_S),
        .pc_S(pc_S),
        .branch(branch)
    );

    datapath DATAPATH(
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .alu_control(alu_control),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .wb_S(wb_S),
        .pc_S(pc_S),
        .branch(branch),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .imm_out(imm_out)
    );


endmodule