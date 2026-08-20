`timescale 1 ns / 1 ps

module  instruction_fetch_tb;

    parameter MEM_DEPTH = 256;
    reg clk;
    reg rst_n;
    reg [31:0] next_pc;
    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instr;

    instruction_fetch #(
        .MEM_DEPTH(MEM_DEPTH)
    ) IF (.clk(clk), .rst_n(rst_n), .next_pc(next_pc), .pc(pc), .pc_plus4(pc_plus4), .instr(instr));

    always #5 clk = ~clk; 

    //Direct Feedback to update next_pc with pc_plus4
    always @(*)
    begin 
        if (!rst_n)
        begin 
            next_pc = 32'h0000_0000;
        end
        else
        begin 
            next_pc = pc_plus4;
        end
    end

    initial
    begin 

        $dumpfile("instr_fetch_wave.vcd");
        $dumpvars(0, instruction_fetch_tb);

        clk = 1'b0;
        rst_n = 1'b0;

        #10;

        rst_n = 1'b1; //Reset release

        //Instruction Fetch on each rising clock edge
        $monitor("Time: %0t ns | PC: 0x%h | Next PC: 0x%h | Instruction: 0x%h", $time, pc, next_pc, instr);

        #40;

        $display("Test Complete");
        $finish;
    end
endmodule