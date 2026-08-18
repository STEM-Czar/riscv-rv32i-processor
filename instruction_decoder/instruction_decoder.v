`timescale 1 ns / 1 ps

module instruction_decoder (
    input wire [31:0] instr,
    output wire [6:0] opcode,
    output wire [4:0] rd,
    output wire [2:0] funct3,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [6:0] funct7,

    output reg [31:0] imm_out

);

    assign opcode = instr[6:0];
    assign rd = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign funct7 = instr[31:25];

    always @(*)
    begin 
        case(opcode) 
            //I type
            7'b0010011,  //immediate arithmetic and logical ops
            7'b0000011, //memory loads
            7'b1100111, //jalr
            7'b1110011: //env or sys
            imm_out =  {{20{instr[31]}}, instr[31:20]}; //sign-extended

            // S type
            7'b0100011:
            imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            //B type
            7'b1100011:
            imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

            //U type
            7'b0110111, //lui
            7'b0010111: //auipc
            imm_out = {instr[31:12], {12{1'b0}}};

            //J type
            7'b1101111:
            imm_out = {{11{instr[31]}} , instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};

            default: imm_out = 32'b0;

        endcase
    end

endmodule