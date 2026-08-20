`timescale 1 ns / 1ps

module instruction_fetch #(
    parameter MEM_DEPTH = 256 // 256 x 4 bytes (32 bits) = 1024 bytes ( 1 KB)
) (
    input wire clk,
    input wire rst_n,
    input wire [31:0] next_pc,
    output wire [31:0] pc,
    output wire [31:0] pc_plus4,
    
    output wire [31:0] instr
);
    
    //Program Counter instance
    program_counter #(
        .data_width(32)
    )
    PC_inst (.clk(clk), .rst_n(rst_n), .next_pc(next_pc), .pc(pc), .pc_plus4(pc_plus4));

    //Instruction Memory instance
    instruction_memory #(
        .MEM_DEPTH(MEM_DEPTH)
    ) instr_mem_inst (.addr(pc), .instr(instr));



endmodule