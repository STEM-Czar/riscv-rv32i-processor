`timescale 1 ns / 1 ps

module pl_cpu_tb;

    reg clk;
    reg rst_n;

    pl_cpu DUT (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;

        #20;
        rst_n = 1'b1;

        #1000;

        $finish;
    end

    initial begin
        $dumpfile("pl_cpu.vcd");
        $dumpvars(0, pl_cpu_tb);
    end

    initial 
    begin
    $monitor(
        "T=%0t PC=%h INSTR=%h | x1=%h x2=%h x3=%h x4=%h x5=%h x6=%h x7=%h x8=%h x9=%h x10=%h x11=%h x12=%h x13=%h x14=%h x19=%h x20=%h x21=%h x22=%h | stall=%b flushIF=%b flushEX=%b",
        $time,
        DUT.DP.pc,
        DUT.DP.instr,
        DUT.DP.ID.RegFile.registers[1],
        DUT.DP.ID.RegFile.registers[2],
        DUT.DP.ID.RegFile.registers[3],
        DUT.DP.ID.RegFile.registers[4],
        DUT.DP.ID.RegFile.registers[5],
        DUT.DP.ID.RegFile.registers[6],
        DUT.DP.ID.RegFile.registers[7],
        DUT.DP.ID.RegFile.registers[8],
        DUT.DP.ID.RegFile.registers[9],
        DUT.DP.ID.RegFile.registers[10],
        DUT.DP.ID.RegFile.registers[11],
        DUT.DP.ID.RegFile.registers[12],
        DUT.DP.ID.RegFile.registers[13],
        DUT.DP.ID.RegFile.registers[14],
        DUT.DP.ID.RegFile.registers[19],
        DUT.DP.ID.RegFile.registers[20],
        DUT.DP.ID.RegFile.registers[21],
        DUT.DP.ID.RegFile.registers[22],
        DUT.DP.stall_pc,
        DUT.DP.flush_if_id,
        DUT.DP.flush_id_ex
    );
end

endmodule