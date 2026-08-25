`timescale 1 ns / 1 ps

module instruction_decode_tb;

    reg clk;
    reg rst_n;
    reg [31:0] instr;

    reg we;
    reg [4:0]  w_addr;
    reg [31:0] w_data;

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;

    wire [31:0] imm_out;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    instruction_decode DUT (
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

    always #5 clk = ~clk;

    initial
    begin 

        $dumpfile("instr_decode_wave.vcd");
        $dumpvars(0, instruction_decode_tb);

        clk = 0;
        rst_n = 0;
        instr = 32'b0;

        we     = 0;
        w_addr = 0;
        w_data = 0;

        #12;
        rst_n = 1;

        // Write x1 = 10
        @(negedge clk);
        we     = 1;
        w_addr = 5'd1;
        w_data = 32'd10;

        // Write x2 = 20
        @(negedge clk);
        w_addr = 5'd2;
        w_data = 32'd20;

        // Write x4 = 40
        @(negedge clk);
        w_addr = 5'd4;
        w_data = 32'd40;

        
        @(negedge clk);
        we = 0;

        $display("REGISTER CHECK: x1=%d | x2=%d | x4=%d",
         DUT.RegFile.registers[1],
         DUT.RegFile.registers[2],
         DUT.RegFile.registers[4]);

        // 1. I-Type: addi x1, x0, 2
        instr = 32'h00200093;
        #10;

        $display("opcode=%h | rd=%d | rs1=%d | imm=%h | rs1_data=%d | rs2_data=%d", opcode, rd, rs1, imm_out, rs1_data, rs2_data);


        // 2. I-Type: addi x2, x0, 3
        instr = 32'h00300113;
        #10;

       $display("opcode=%h | rd=%d | rs1=%d | imm=%h | rs1_data=%d | rs2_data=%d", opcode, rd, rs1, imm_out, rs1_data, rs2_data);


        // 3. R-Type: add x3, x1, x2
        instr = 32'h002081B3;
        #10;

        $display("opcode=%h | rd=%d | rs1=%d | rs2=%d | funct3=%h | funct7=%h | rs1_data=%d | rs2_data=%d", opcode, rd, rs1, rs2, funct3, funct7, rs1_data, rs2_data);


        // 4. S-Type: sw x3, 8(x4)
        instr = 32'h00322423;
        #10;

        $display("opcode=%h | rs1=%d | rs2=%d | imm=%h | rs1_data=%d | rs2_data=%d", opcode, rs1, rs2, imm_out, rs1_data, rs2_data);


        // 5. B-Type: beq x1, x2, -8
        instr = 32'hFE208CE3;
        #10;

        $display("opcode=%h | rs1=%d | rs2=%d | imm=%h | rs1_data=%d | rs2_data=%d", opcode, rs1, rs2, imm_out, rs1_data, rs2_data);


        // 6. U-Type: lui x5, 0x12345
        instr = 32'h123452B7;
        #10;

        $display("opcode=%h | rd=%d | imm=%h", opcode, rd, imm_out);


        // 7. J-Type: jal x1, -16
        instr = 32'hFF1FF0EF;
        #10;

        $display("opcode=%h | rd=%d | imm=%h", opcode, rd, imm_out);


        $display("Test complete");
        $finish;


    end

endmodule