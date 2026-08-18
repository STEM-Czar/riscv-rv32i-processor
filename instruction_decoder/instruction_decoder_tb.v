`timescale 1 ns / 1 ps

module instruction_decoder_tb;

    reg [31:0] instr;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;

    wire [31:0] imm_out;

    instruction_decoder DUT (.instr(instr), .opcode(opcode), .rd(rd), .funct3(funct3), .rs1(rs1), .rs2(rs2), .funct7(funct7), .imm_out(imm_out));

    initial
    begin

        $dumpfile("instr_dec_wave.vcd");
        $dumpvars(0, instruction_decoder_tb);

        instr = 32'b0;
        #10;

        // 1. I-Type: addi x1, x2, -5
        // imm[11:0] = 12'hFFB (-5), rs1 = 2, funct3 = 0, rd = 1, opcode = 7'b0010011 (hex 13)
        instr = 32'hFFB10093;
        #10;

        // 2. S-Type: sw x3, 8(x4)
        // imm[11:5] = 7'b0000000, rs2 = 3, rs1 = 4, funct3 = 2, imm[4:0] = 5'b01000, opcode = 7'b0100011 (hex 23)
        instr = 32'h00322423;
        #10;

        // 3. B-Type: beq x1, x2, -8
        // imm[12|10:5] = 7'b1111111, rs2 = 2, rs1 = 1, funct3 = 0, imm[4:1|11] = 5'b11001, opcode = 7'b1100011 (hex 63)
        instr = 32'hFE208CE3;
        #10;

        // 4. U-Type: lui x5, 0x12345
        // imm[31:12] = 20'h12345, rd = 5, opcode = 7'b0110111 (hex 37)
        instr = 32'h123452B7;
        #10;

        // 5. J-Type: jal x1, -16
        // imm[20|10:1|11|19:12] reconstructed for offset -16, rd = 1, opcode = 7'b1101111 (hex 6F)
        instr = 32'hFF5FF06F;
        #10;

        // 6. R-Type (Default Case): add x1, x2, x3
        // funct7 = 0, rs2 = 3, rs1 = 2, funct3 = 0, rd = 1, opcode = 7'b0110011 (hex 33)
        instr = 32'h003100B3;
        #10;

        $display("Test complete");
        $finish;
    end

endmodule