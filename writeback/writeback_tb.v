`timescale 1 ns / 1 ps

module writeback_tb;

    reg [31:0] alu_result;
    reg [31:0] r_mdata;
    reg wb_S;
    wire [31:0] w_data;

    writeback UUT (.alu_result(alu_result), .r_mdata(r_mdata), .wb_S(wb_S), .w_data(w_data));

    initial
    begin 

        $dumpfile("writeback_wave.vcd");
        $dumpvars(0, writeback_tb);

        alu_result = 32'd43;
        r_mdata = 32'd12;

        wb_S = 1'b0;
        #10;
        $display("Control = %b | InA(ALU) = %d | InB(DMEM) = %d | Result = %d", wb_S, alu_result, r_mdata, w_data);

        wb_S = 1'b1;
        #10;
        $display("Control = %b | InA(ALU) = %d | InB(DMEM) = %d | Result = %d", wb_S, alu_result, r_mdata, w_data);

        #10;
        $display("Test Complete");
        $finish;
    end

endmodule