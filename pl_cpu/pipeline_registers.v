//Pipeline registers

//IF_ID 
module if_id_reg (
    input wire clk,
    input wire rst_n,
    input wire stall,
    input wire flush,

    input wire [31:0] if_pc,
    input wire [31:0] if_pc_plus4,
    input wire [31:0] if_instr,

    output reg [31:0] id_pc,
    output reg [31:0] id_pc_plus4,
    output reg [31:0] id_instr
);

    always @ (posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin
            id_pc <= 32'b0;
            id_pc_plus4 <= 32'b0;
            id_instr <= 32'b0;
        end
        else if (flush)
        begin 
            id_pc       <= 32'b0;
            id_pc_plus4 <= 32'b0;
            id_instr    <= 32'h00000013; //NOP
        end 
        else if (!stall)
        begin 
            id_pc <= if_pc;
            id_pc_plus4 <= if_pc_plus4;
            id_instr <= if_instr;
        end
    end

endmodule

//ID_EX
module id_ex_reg (
    input wire clk,
    input wire rst_n,
    input wire flush,
    input wire [31:0] id_pc,
    input wire [31:0] id_pc_plus4,
    input wire [4:0] id_rd,
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,
    input wire [31:0] id_rs1_data,
    input wire [31:0] id_rs2_data,
    input wire [31:0] id_imm_out,
    input wire [2:0] id_funct3,
    
    input wire id_alu_srcA,
    input wire id_alu_srcB,
    input wire [3:0] id_alu_control,
    input wire id_mem_write,
    input wire id_mem_read,
    input wire id_we,
    input wire [1:0] id_pc_S,
    input wire [1:0] id_wb_S,
    input wire id_branch,
    input wire id_uses_rs1,
    input wire id_uses_rs2,

    output reg [31:0] ex_pc,
    output reg [31:0] ex_pc_plus4,
    output reg [4:0] ex_rd,
    output reg [4:0] ex_rs1,
    output reg [4:0] ex_rs2,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [31:0] ex_imm_out,
    output reg [2:0] ex_funct3,

    output reg ex_alu_srcA,
    output reg ex_alu_srcB,
    output reg [3:0] ex_alu_control,
    output reg ex_mem_write,
    output reg ex_mem_read,
    output reg ex_we,
    output reg [1:0] ex_pc_S,
    output reg [1:0] ex_wb_S,
    output reg ex_branch,
    output reg ex_uses_rs1,
    output reg ex_uses_rs2
);

    always @ (posedge clk or negedge rst_n)
    begin 
        if (!rst_n || flush)
        begin
            ex_pc <= 32'b0;
            ex_pc_plus4 <= 32'b0;
            ex_rd <= 5'b0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_rs1_data <= 32'b0;
            ex_rs2_data <= 32'b0;
            ex_imm_out <= 32'b0;
            ex_funct3 <= 3'b0;
            ex_alu_srcA <= 1'b0;
            ex_alu_srcB <= 1'b0;
            ex_alu_control <= 4'b0;
            ex_mem_write <= 1'b0;
            ex_mem_read <= 1'b0;
            ex_we <= 1'b0;
            ex_pc_S <= 2'b0;
            ex_wb_S <= 2'b0;
            ex_branch <= 1'b0;
            ex_uses_rs1 <= 1'b0;
            ex_uses_rs2 <= 1'b0;
        end
        else
        begin 
            ex_pc <= id_pc;
            ex_pc_plus4 <= id_pc_plus4;
            ex_rd <= id_rd;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_imm_out <= id_imm_out;
            ex_funct3 <= id_funct3;
            ex_alu_srcA <= id_alu_srcA;
            ex_alu_srcB <= id_alu_srcB;
            ex_alu_control <= id_alu_control;
            ex_mem_write <= id_mem_write;
            ex_mem_read <= id_mem_read;
            ex_we <= id_we;
            ex_pc_S <= id_pc_S;
            ex_wb_S <= id_wb_S;
            ex_branch <= id_branch;
            ex_uses_rs1 <= id_uses_rs1;
            ex_uses_rs2 <= id_uses_rs2;
        end
    end
endmodule


//EX_MEM
module ex_mem_reg (
    input wire clk,
    input wire rst_n,
    input wire [31:0] ex_pc_plus4,
    input wire [4:0] ex_rd,
    input wire [31:0] ex_rs2_data,
    input wire [31:0] ex_alu_result,
    
    input wire ex_mem_write,
    input wire ex_mem_read,
    input wire ex_we,
    input wire [1:0] ex_wb_S,

    output reg [31:0] mem_pc_plus4,
    output reg [4:0] mem_rd,
    output reg [31:0] mem_rs2_data,
    output reg [31:0] mem_alu_result,
    output reg mem_mem_write,
    output reg mem_mem_read,
    output reg mem_we,
    output reg [1:0] mem_wb_S
);

    always @ (posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin
            mem_pc_plus4 <= 32'b0;
            mem_rd <= 5'b0;
            mem_rs2_data <= 32'b0;
            mem_alu_result <= 32'b0;
            mem_mem_write <= 1'b0;
            mem_mem_read <= 1'b0;
            mem_we <= 1'b0;
            mem_wb_S <= 2'b0;
        end
        else
        begin 
            mem_pc_plus4 <= ex_pc_plus4;
            mem_rd <= ex_rd;
            mem_rs2_data <= ex_rs2_data;
            mem_alu_result <= ex_alu_result;
            mem_mem_write <= ex_mem_write;
            mem_mem_read <= ex_mem_read;
            mem_we <= ex_we;
            mem_wb_S <= ex_wb_S;
        end
    end
endmodule


//MEM_WB
module mem_wb_reg (
    input wire clk,
    input wire rst_n,
    input wire [31:0] mem_pc_plus4,
    input wire [4:0] mem_rd,
    input wire [31:0] mem_r_mdata,
    input wire [31:0] mem_alu_result,
    input wire mem_we,
    input wire [1:0] mem_wb_S,

    output reg [31:0] wb_pc_plus4,
    output reg [4:0] wb_rd,
    output reg [31:0] wb_r_mdata,
    output reg [31:0] wb_alu_result,

    output reg wb_we,
    output reg [1:0] wb_wb_S 
);

    always @ (posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin
            wb_pc_plus4 <= 32'b0;
            wb_rd <= 5'b0;
            wb_r_mdata <= 32'b0;
            wb_alu_result <= 32'b0;
            wb_we <= 1'b0;
            wb_wb_S <= 2'b0; 
        end
        else
        begin 
            wb_pc_plus4 <= mem_pc_plus4;
            wb_rd <= mem_rd;
            wb_r_mdata <= mem_r_mdata;
            wb_alu_result <= mem_alu_result;
            wb_we <= mem_we;
            wb_wb_S <= mem_wb_S;
        end
    end

endmodule
