`timescale 1 ns / 1 ps

module sc_cpu_tb;

    reg clk;
    reg rst_n;

    sc_cpu CPU (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;


    initial 
    begin 

        $dumpfile("sc_cpu_tb_wave.vcd");
        $dumpvars(0, Sc_cpu_tb);

        clk = 1'b0; rst_n = 1'b0;

        $monitor("Time=%0t | next_pc=%h | pc=%h | instr=%h | alu_control=%b | alu_result=%h | w_data=%h | r_data=%h",
            $time, CPU.DATAPATH.next_pc, CPU.DATAPATH.pc, CPU.DATAPATH.instr, CPU.CU.alu_control, CPU.DATAPATH.alu_result, CPU.DATAPATH.w_data, CPU.DATAPATH.r_mdata
        );
/*
        $monitor("Time=%0t | pc=%h | instr=%h | alu_srcA=%b | alu_srcB=%b | alu_rs1_data=%h | inA=%h | inB=%h | alu_result=%h | w_data=%h",
            $time,
            CPU.DATAPATH.pc,
            CPU.DATAPATH.instr,
            CPU.CU.alu_srcA,
            CPU.CU.alu_srcB,
            CPU.DATAPATH.alu_rs1_data,
            CPU.DATAPATH.EX.inA,
            CPU.DATAPATH.EX.inB,
            CPU.DATAPATH.alu_result,
            CPU.DATAPATH.w_data
        ); */
        
        #20;
        rst_n = 1'b1;

        #1000;
        $display("\nTest is complete.");
        $finish;

    end
    
endmodule