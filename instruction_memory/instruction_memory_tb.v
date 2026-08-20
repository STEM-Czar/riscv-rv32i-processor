`timescale 1 ns / 1 ps

module instruction_memory_tb;

    parameter MEM_DEPTH =256;
    reg [31:0] addr;
    wire [31:0] instr;

    instruction_memory #(
        .MEM_DEPTH(MEM_DEPTH)
    ) UUT (.addr(addr), .instr(instr));

    initial
    begin 

        $dumpfile("instr_mem_wave.vcd");
        $dumpvars(0, instruction_memory_tb);

        addr = 32'h0000_0000;
        #10;

        // Display read output at address 0x0
        $display("Addr: 0x%h | Instr: 0x%h", addr, instr);

        // Advance to address 0x4
        addr = 32'h0000_0004;
        #10;
        $display("Addr: 0x%h | Instr: 0x%h", addr, instr);

        // Advance to address 0x8
        addr = 32'h0000_0008;
        #10;
        $display("Addr: 0x%h | Instr: 0x%h", addr, instr);

        // Advance to address 0xC
        addr = 32'h0000_000C;
        #10;
        $display("Addr: 0x%h | Instr: 0x%h", addr, instr);

        #10;
        $display("Test complete");
        $finish;
    end

endmodule