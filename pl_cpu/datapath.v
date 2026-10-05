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

    wire [31:0] w_data;
    
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;    
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    wire [3:0] alu_status;

    reg branch_taken;

    wire [31:0] id_rs1_data_mux = (opcode == 7'b0110111) ? 32'b0 : rs1_data;
    wire [4:0] id_rs1_final = (opcode == 7'b0110111) ? 5'b00000 : rs1;

    wire stall_pc;
    wire stall_if_id;
    wire flush_if_id;
    wire flush_id_ex;
    wire [1:0] forward_A;
    wire [1:0] forward_B;


    instruction_fetch #(
        .MEM_DEPTH (256) // 256 x 4 bytes (32 bits) = 1024 bytes ( 1 KB)
    ) IF (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_pc),
        .next_pc(next_pc),

        .pc(pc),
        .pc_plus4(pc_plus4),
        .instr(instr)
    );

    wire [31:0] id_pc;
    wire [31:0] id_pc_plus4;
    wire [31:0] id_instr;

    if_id_reg IF_ID (
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall_if_id),
        .flush(flush_if_id),
        .if_pc(pc),
        .if_pc_plus4(pc_plus4),
        .if_instr(instr),
        .id_pc(id_pc),
        .id_pc_plus4(id_pc_plus4),
        .id_instr(id_instr)
    );

    wire wb_we;
    wire [4:0] wb_rd;


    
    instruction_decode ID (
        .clk(clk),
        .rst_n(rst_n),
        .instr(id_instr),
        .we(wb_we),
        .w_addr(wb_rd),
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

    wire [31:0] ex_pc;
    wire [31:0] ex_pc_plus4;
    wire [4:0] ex_rd;
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_alu_result;
    wire [31:0] ex_imm_out;
    wire [2:0] ex_funct3;
    wire ex_alu_srcA;
    wire ex_alu_srcB;
    wire [3:0] ex_alu_control;
    wire ex_mem_write;
    wire ex_mem_read;
    wire ex_we;
    wire [1:0] ex_pc_S;
    wire [1:0] ex_wb_S;
    wire ex_branch;
    wire ex_uses_rs1;
    wire ex_uses_rs2;

    id_ex_reg ID_EX (
        .clk(clk),
        .rst_n(rst_n),
        .flush(flush_id_ex),
        .id_pc(id_pc),
        .id_pc_plus4(id_pc_plus4),
        .id_rd(rd),
        .id_rs1(id_rs1_final),
        .id_rs2(rs2),
        .id_rs1_data(id_rs1_data_mux),
        .id_rs2_data(rs2_data),
        .id_imm_out(imm_out),
        .id_funct3(funct3),
        .id_alu_srcA(alu_srcA),
        .id_alu_srcB(alu_srcB),
        .id_alu_control(alu_control),
        .id_mem_write(mem_write),
        .id_mem_read(mem_read),
        .id_we(we),
        .id_pc_S(pc_S),
        .id_wb_S(wb_S),
        .id_branch(branch),
        .id_uses_rs1(id_uses_rs1),
        .id_uses_rs2(id_uses_rs2),

        .ex_pc(ex_pc),
        .ex_pc_plus4(ex_pc_plus4),
        .ex_rd(ex_rd),
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_imm_out(ex_imm_out),
        .ex_funct3(ex_funct3),
        .ex_alu_srcA(ex_alu_srcA),
        .ex_alu_srcB(ex_alu_srcB),
        .ex_alu_control(ex_alu_control),
        .ex_mem_write(ex_mem_write),
        .ex_mem_read(ex_mem_read),
        .ex_we(ex_we),
        .ex_pc_S(ex_pc_S),
        .ex_wb_S(ex_wb_S),
        .ex_branch(ex_branch),
        .ex_uses_rs1(ex_uses_rs1),
        .ex_uses_rs2(ex_uses_rs2)
    );

    reg [31:0] ex_rs1_forwarded;
    reg [31:0] ex_rs2_forwarded;

    always @(*) begin
        case (forward_A)
            2'b00:   ex_rs1_forwarded = ex_rs1_data;
            2'b10:   ex_rs1_forwarded = mem_forward_data; // Forwarded from EX/MEM
            2'b01:   ex_rs1_forwarded = w_data;         // Forwarded from MEM/WB
            default: ex_rs1_forwarded = ex_rs1_data;
        endcase
    end

    always @(*) begin
        case (forward_B)
            2'b00:   ex_rs2_forwarded = ex_rs2_data;
            2'b10:   ex_rs2_forwarded = mem_forward_data; // Forwarded from EX/MEM
            2'b01:   ex_rs2_forwarded = w_data;         // Forwarded from MEM/WB
            default: ex_rs2_forwarded = ex_rs2_data;
        endcase
    end

    wire [31:0] ex_jalr_target = ex_rs1_forwarded + ex_imm_out;

    execute EX (
        .imm_out(ex_imm_out),
        .rs1_data(ex_rs1_forwarded),
        .rs2_data(ex_rs2_forwarded),
        .pc(ex_pc),
        .alu_srcA(ex_alu_srcA),
        .alu_srcB(ex_alu_srcB),
        .alu_control(ex_alu_control),

        .alu_result(ex_alu_result),
        .alu_status(alu_status)
    );

    wire [31:0] mem_pc_plus4;
    wire [4:0] mem_rd;
    wire [31:0] mem_rs2_data;
    wire [31:0] mem_alu_result;
    wire mem_mem_write;
    wire mem_mem_read;
    wire mem_we;
    wire [1:0] mem_wb_S;

    ex_mem_reg EX_MEM (
        .clk(clk),
        .rst_n(rst_n),
        .ex_pc_plus4(ex_pc_plus4),
        .ex_rd(ex_rd),
        .ex_rs2_data(ex_rs2_forwarded),
        .ex_alu_result(ex_alu_result),
        .ex_mem_write(ex_mem_write),
        .ex_mem_read(ex_mem_read),
        .ex_we(ex_we),
        .ex_wb_S(ex_wb_S),
        .mem_pc_plus4(mem_pc_plus4),
        .mem_rd(mem_rd),
        .mem_rs2_data(mem_rs2_data),
        .mem_alu_result(mem_alu_result),
        .mem_mem_write(mem_mem_write),
        .mem_mem_read(mem_mem_read),
        .mem_we(mem_we),
        .mem_wb_S(mem_wb_S) 
    );
    wire [31:0] mem_forward_data;
    wire [31:0] mem_r_mdata;
    wire [31:0] mem_w_data_final = mem_rs2_data;
    assign mem_forward_data = (mem_wb_S == 2'b10) ? mem_pc_plus4 : mem_alu_result;
    
    data_memory DMEM (
        .clk(clk),
        .rst_n(rst_n),
        .m_addr(mem_alu_result),
        .w_mdata(mem_w_data_final),
        .mem_write(mem_mem_write),
        .mem_read(mem_mem_read),
    
        .r_mdata(mem_r_mdata)
    );

    wire [31:0] wb_pc_plus4;
    wire [31:0] wb_r_mdata;
    wire [31:0] wb_alu_result;
    wire [1:0] wb_wb_S;

    mem_wb_reg MEM_WB (
        .clk(clk),
        .rst_n(rst_n),
        .mem_pc_plus4(mem_pc_plus4),
        .mem_rd(mem_rd),
        .mem_r_mdata(mem_r_mdata),
        .mem_alu_result(mem_alu_result),
        .mem_we(mem_we),
        .mem_wb_S(mem_wb_S),

        .wb_pc_plus4(wb_pc_plus4),
        .wb_rd(wb_rd),
        .wb_r_mdata(wb_r_mdata),
        .wb_alu_result(wb_alu_result),
        .wb_we(wb_we),
        .wb_wb_S(wb_wb_S) 
    );

    writeback WB (
        .alu_result(wb_alu_result),
        .r_mdata(wb_r_mdata),
        .pc_plus4(wb_pc_plus4),
        .wb_S(wb_wb_S),
        .w_data(w_data)
    );

    wire id_uses_rs1;
    wire id_uses_rs2;

    assign id_uses_rs1 =
                        (opcode == 7'b0110011) || // R-type
                        (opcode == 7'b0010011) || // I-type ALU
                        (opcode == 7'b0000011) || // LW
                        (opcode == 7'b0100011) || // SW
                        (opcode == 7'b1100011) || // Branch
                        (opcode == 7'b1100111);   // JALR

assign id_uses_rs2 =
                        (opcode == 7'b0110011) || // R-type
                        (opcode == 7'b0100011) || // SW
                        (opcode == 7'b1100011);   // Branch

    hazard_unit HU (
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .mem_rd(mem_rd),
        .mem_we(mem_we),
        .mem_mem_read(mem_mem_read),
        .wb_rd(wb_rd),
        .wb_we(wb_we),

        .id_rs1(id_rs1_final),
        .id_rs2(rs2),
        .id_uses_rs1(id_uses_rs1),
        .id_uses_rs2(id_uses_rs2),
        .ex_rd(ex_rd),
        .ex_mem_read(ex_mem_read),
        .ex_uses_rs1(ex_uses_rs1),
        .ex_uses_rs2(ex_uses_rs2),

        .ex_pc_S(ex_pc_S),
        .ex_branch(ex_branch),
        .branch_taken(branch_taken),

        .forward_A(forward_A),
        .forward_B(forward_B),

        .stall_pc(stall_pc),
        .stall_if_id(stall_if_id),
        .flush_if_id(flush_if_id),
        .flush_id_ex(flush_id_ex)
    );

    always @(*) 
    begin
        branch_taken = 1'b0;

        if (ex_branch) 
        begin
            case (ex_funct3)
                3'b000: branch_taken = (ex_rs1_forwarded == ex_rs2_forwarded); // BEQ
                3'b001: branch_taken = (ex_rs1_forwarded != ex_rs2_forwarded); // BNE
                3'b100: branch_taken = ($signed(ex_rs1_forwarded) < $signed(ex_rs2_forwarded));  // BLT
                3'b101: branch_taken = ($signed(ex_rs1_forwarded) >= $signed(ex_rs2_forwarded)); // BGE
                3'b110: branch_taken = ($unsigned(ex_rs1_forwarded) < $unsigned(ex_rs2_forwarded)); // BLTU
                3'b111: branch_taken = ($unsigned(ex_rs1_forwarded) >= $unsigned(ex_rs2_forwarded)); // BGEU
                default: branch_taken = 1'b0;
            endcase
        end
    end


    always @(*) 
    begin
        case (ex_pc_S)
            2'b01: 
            begin
                if (ex_branch && branch_taken)
                    next_pc = ex_pc + ex_imm_out; //Branch taken target 
                else if (!ex_branch) 
                    next_pc = ex_pc + ex_imm_out; //JAL target
                else
                    next_pc = pc_plus4;
            end
            2'b10: next_pc = {ex_jalr_target[31:1], 1'b0};
            default: next_pc = pc_plus4;
        endcase
    end


endmodule