`timescale 1 ns / 1 ps

module datapath (
    input wire clk,
    input wire rst_n,
    input wire we,
    input wire alu_srcA,
    input wire alu_srcB,
    input wire [3:0] alu_control,
    input wire mem_write,
    input wire mem_read,
    input wire [1:0] wb_S,
    input wire [1:0] pc_S,
    input wire branch,

    output wire [6:0] opcode,
    output wire [2:0] funct3,
    output wire [6:0] funct7,
    output wire [31:0] imm_out
);

    reg [31:0] next_pc;
    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instr;

    wire [4:0] w_addr;
    wire [31:0] w_data;
    
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;    
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    wire [31:0] alu_result;
    wire [3:0] alu_status;

    wire [31:0] r_mdata;

    reg branch_taken;
    wire [31:0] jalr_target;

    wire [31:0] alu_rs1_data;

    assign w_addr = rd;
    assign jalr_target = rs1_data + imm_out;

    assign alu_rs1_data = (opcode == 7'b0110111) ? 32'b0 : rs1_data;




    instruction_fetch #(
        .MEM_DEPTH (256) // 256 x 4 bytes (32 bits) = 1024 bytes ( 1 KB)
    ) IF (
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),

        .pc(pc),
        .pc_plus4(pc_plus4),
        .instr(instr)
    );

    instruction_decode ID (
        .clk(clk),
        .rst_n(rst_n),
        .instr(instr),
        .we(we),
        .w_addr(w_addr),
        .w_data(w_data),

        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_out(imm_out),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    execute EX (
        .imm_out(imm_out),
        .rs1_data(alu_rs1_data),
        .rs2_data(rs2_data),
        .pc(pc),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .alu_control(alu_control),

        .alu_result(alu_result),
        .alu_status(alu_status)
    );

    data_memory DMEM (
        .clk(clk),
        .rst_n(rst_n),
        .m_addr(alu_result),
        .w_mdata(rs2_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
    
        .r_mdata(r_mdata)
    );

    writeback WB (
        .alu_result(alu_result),
        .r_mdata(r_mdata),
        .pc_plus4(pc_plus4),
        .wb_S(wb_S),
        .w_data(w_data)
    );

    always @(*) 
    begin
        branch_taken = 1'b0;

        if (branch) 
        begin
            case (funct3)
                3'b000: branch_taken = (alu_result == 32'b0); // BEQ
                3'b001: branch_taken = (alu_result != 32'b0); // BNE
                3'b100: branch_taken = (alu_result == 32'b1); // BLT
                3'b101: branch_taken = (alu_result == 32'b0); // BGE
                3'b110: branch_taken = (alu_result == 32'b1); // BLTU
                3'b111: branch_taken = (alu_result == 32'b0); // BGEU
                default: branch_taken = 1'b0;
            endcase
        end
    end


    always @(*) 
    begin
        case (pc_S)
            2'b00: next_pc = pc_plus4;
            2'b01: next_pc = branch ? (branch_taken ? pc + imm_out : pc_plus4) : (pc + imm_out);
            2'b10: next_pc = {jalr_target[31:1], 1'b0};
            default: next_pc = pc_plus4;
        endcase
    end


endmodule