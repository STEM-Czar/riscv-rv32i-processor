`timescale 1 ns / 1 ps

module pl_cpu (
    input wire clk,
    input wire rst_n
);

    //Instruction-decode signals
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_out;


    
    //Control Signals
    wire mem_write;
    wire mem_read;
    wire alu_srcA;
    wire alu_srcB;
    wire [3:0] alu_control;
    wire we;
    wire [1:0] wb_S;
    wire [1:0] pc_S;
    wire branch;


    // Control Unit
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

    // Datapath for the 5 stages
    datapath DP (
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