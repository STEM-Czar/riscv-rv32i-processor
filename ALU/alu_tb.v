`timescale 1 ns / 1 ps

module alu_tb;

    parameter bit_width   = 8;
    parameter opcode_bits = 4;

    reg  [bit_width - 1 : 0]   inA;
    reg  [bit_width - 1 : 0]   inB;
    reg  [opcode_bits - 1 : 0] alu_control;
    wire [bit_width - 1 : 0]   alu_out;
    wire [3:0]                 alu_status;

    alu #(
        .bit_width(bit_width),
        .opcode_bits(opcode_bits)
    ) uut (
        .alu_out(alu_out),
        .alu_status(alu_status),
        .inA(inA),
        .inB(inB),
        .alu_control(alu_control)
    );

    // Human-readable decimal checker task
    task check_dec(
        input signed [bit_width - 1 : 0] exp_out,
        input [3:0]                      exp_status,
        input string                     op_name
    );
        begin
            #5;
            if (alu_out !== exp_out || alu_status !== exp_status) begin
                $display("[FAIL] %-25s | A=%0d, B=%0d | Expected: Out=%0d [Status=%b] | Got: Out=%0d [Status=%b]",
                         op_name, $signed(inA), $signed(inB), exp_out, exp_status, $signed(alu_out), alu_status);
            end else begin
                $display("[PASS] %-25s | A=%0d, B=%0d => Out=%0d | Status[V C N Z]=%b", 
                         op_name, $signed(inA), $signed(inB), $signed(alu_out), alu_status);
            end
        end
    endtask

    // Hex/Binary checker task for logical operations
    task check_hex(
        input [bit_width - 1 : 0] exp_out,
        input [3:0]               exp_status,
        input string              op_name
    );
        begin
            #5;
            if (alu_out !== exp_out || alu_status !== exp_status) begin
                $display("[FAIL] %-25s | A=%b, B=%b | Expected: Out=%b [Status=%b] | Got: Out=%b [Status=%b]",
                         op_name, inA, inB, exp_out, exp_status, alu_out, alu_status);
            end else begin
                $display("[PASS] %-25s | A=%b, B=%b => Out=%b | Status[V C N Z]=%b", 
                         op_name, inA, inB, alu_out, alu_status);
            end
        end
    endtask

    initial begin
        
        $dumpfile("alu_wave.vcd");
        $dumpvars(0, alu_tb);


        $display("==================================================================================\n");

        // --- ARITHMETIC TESTS (DECIMAL DISPLAY) ---
        $display("--- 1. ADDITION TESTS ---");
        inA = 8'd10; inB = 8'd20; alu_control = 4'b0000;
        check_dec(8'd30, 4'b0000, "10 + 20");

        inA = 8'd0; inB = 8'd0; alu_control = 4'b0000;
        check_dec(8'd0, 4'b0001, "0 + 0 (Zero Flag)");

        inA = 8'd255; inB = 8'd1; alu_control = 4'b0000;
        check_dec(8'd0, 4'b0101, "255 + 1 (Unsigned Overflow)");

        inA = 8'd127; inB = 8'd1; alu_control = 4'b0000;
        check_dec(-8'd128, 4'b1010, "127 + 1 (Signed Overflow)");

        inA = -8'd128; inB = -8'd1; alu_control = 4'b0000;
        check_dec(8'd127, 4'b1100, "-128 + -1 (Signed Overflow)");


        $display("\n--- 2. SUBTRACTION TESTS ---");
        inA = 8'd30; inB = 8'd10; alu_control = 4'b0001;
        check_dec(8'd20, 4'b0000, "30 - 10");

        inA = 8'd15; inB = 8'd15; alu_control = 4'b0001;
        check_dec(8'd0, 4'b0001, "15 - 15 (Zero Flag)");

        inA = 8'd5; inB = 8'd10; alu_control = 4'b0001;
        check_dec(-8'd5, 4'b0110, "5 - 10 (Underflow/Borrow)");

        inA = 8'd127; inB = -8'd1; alu_control = 4'b0001;
        check_dec(-8'd128, 4'b1010, "127 - (-1) (Signed Overflow)");


        // --- SHIFT TESTS (DECIMAL & BINARY MIX) ---
        $display("\n--- 3. SHIFT TESTS ---");
        inA = 8'd12; inB = 8'd2; alu_control = 4'b0010;
        check_dec(8'd48, 4'b0000, "Logical Shift Left (12 << 2)");

        inA = 8'd48; inB = 8'd2; alu_control = 4'b0011;
        check_dec(8'd12, 4'b0000, "Logical Shift Right (48 >> 2)");

        inA = -8'd16; inB = 8'd2; alu_control = 4'b0101;
        check_dec(-8'd4, 4'b0010, "Arith Shift Right (-16 >>> 2)");

        inA = 8'b10000001; inB = 8'd2; alu_control = 4'b0110;
        check_hex(8'b00000110, 4'b0000, "Rotate Left");

        inA = 8'b10000001; inB = 8'd2; alu_control = 4'b0111;
        check_hex(8'b01100000, 4'b0000, "Rotate Right");


        // --- BITWISE LOGIC TESTS (BINARY DISPLAY) ---
        $display("\n--- 4. BITWISE LOGICAL TESTS ---");
        inA = 8'b11001100; inB = 8'b10101010; alu_control = 4'b1000;
        check_hex(8'b10001000, 4'b0010, "Bitwise AND");

        inA = 8'b11001100; inB = 8'b10101010; alu_control = 4'b1001;
        check_hex(8'b11101110, 4'b0010, "Bitwise OR");

        inA = 8'b11001100; inB = 8'b10101010; alu_control = 4'b1010;
        check_hex(8'b01100110, 4'b0000, "Bitwise XOR");

        inA = 8'b11001100; inB = 8'b10101010; alu_control = 4'b1011;
        check_hex(8'b01110111, 4'b0000, "Bitwise NAND");


        // --- COMPARISONS ---
        $display("\n--- 5. COMPARISON TESTS ---");
        inA = 8'd42; inB = 8'd42; alu_control = 4'b1110;
        check_dec(8'd1, 4'b0000, "Equal (42 == 42)");

        inA = 8'd42; inB = 8'd99; alu_control = 4'b1110;
        check_dec(8'd0, 4'b0001, "Equal (42 == 99)");

        inA = 8'd100; inB = 8'd50; alu_control = 4'b1111;
        check_dec(8'd1, 4'b0000, "Greater (100 > 50)");

        inA = 8'd50; inB = 8'd100; alu_control = 4'b1111;
        check_dec(8'd0, 4'b0001, "Greater (50 > 100)");

        $display("\n==================================================================================");
        $display("                            Test Complete                                ");
        $display("==================================================================================\n");
        $finish;
    end

endmodule