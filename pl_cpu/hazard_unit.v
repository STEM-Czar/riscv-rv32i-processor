`timescale 1 ns / 1 ps

module hazard_unit (
    // Forwarding inputs
    input wire [4:0]  ex_rs1,
    input wire [4:0]  ex_rs2,
    input wire [4:0]  mem_rd,
    input wire        mem_we,
    input wire [4:0]  wb_rd,
    input wire        wb_we,
    input wire mem_mem_read,

    // Load-Use hazard inputs
    input wire [4:0]  id_rs1,
    input wire [4:0]  id_rs2,
    input wire id_uses_rs1,
    input wire id_uses_rs2,
    input wire [4:0]  ex_rd,
    input wire ex_mem_read,
    input wire ex_uses_rs1,
    input wire ex_uses_rs2,

    // Control hazard inputs
    input wire [1:0]  ex_pc_S,
    input wire        branch_taken,
    input wire ex_branch,

    // Forwarding outputs to EX stage
    output reg [1:0]  forward_A, // 00: Reg, 10: MEM stage, 01: WB stage
    output reg [1:0]  forward_B,

    // Pipeline control outputs
    output wire       stall_pc,
    output wire       stall_if_id,
    output wire       flush_if_id,
    output wire       flush_id_ex
);

    //Forwarding Logic (EX Stage)
    always @(*) begin
        // --- Forward A (RS1) ---
        if (ex_uses_rs1 && mem_we && !mem_mem_read && (mem_rd != 5'd0) && (mem_rd == ex_rs1))
        begin
            forward_A = 2'b10; // Forward from EX/MEM
        end 
        else if (ex_uses_rs1 && wb_we && (wb_rd != 5'd0) && (wb_rd == ex_rs1)) 
        begin
            forward_A = 2'b01; // Forward from MEM/WB (w_data)
        end 
        else 
        begin
            forward_A = 2'b00; // Standard register file value
        end

        // --- Forward B (RS2) ---
        if (ex_uses_rs2 && mem_we && !mem_mem_read && (mem_rd != 5'd0) && (mem_rd == ex_rs2))
        begin
            forward_B = 2'b10; // Forward from EX/MEM
        end 
        else if (ex_uses_rs2 && wb_we && (wb_rd != 5'd0) && (wb_rd == ex_rs2)) 
        begin
            forward_B = 2'b01; // Forward from MEM/WB (w_data)
        end 
        else 
        begin
            forward_B = 2'b00; // Standard register file value
        end
    end

    //Load-Use Hazard Detection
    // Stall when an instr in EX reads memory and writes to a register needed in ID
    wire load_use_hazard = ex_mem_read && (ex_rd != 5'd0) && ((id_uses_rs1 && (ex_rd == id_rs1)) || (id_uses_rs2 && (ex_rd == id_rs2)) );

    //Control Hazard Detection
    // Flush when PC is redirected by JALR (2'b10), JAL (2'b01 without branch), or Taken Branch
    wire control_flush = (ex_pc_S == 2'b10) || ((ex_pc_S == 2'b01) && ex_branch && branch_taken) || ((ex_pc_S == 2'b01) && !ex_branch);

    //Pipeline Controls
    assign stall_pc    = load_use_hazard && !control_flush;
    assign stall_if_id = load_use_hazard && !control_flush;

    assign flush_if_id = control_flush;
    assign flush_id_ex = load_use_hazard || control_flush;

endmodule