`timescale 1 ns / 1 ps

module dec_1hot_tb;

    parameter n_Inputs = 3;
    parameter n_Outputs = 2 ** (n_Inputs);

    reg [n_Inputs -1 :0] dec_In;
    wire [n_Outputs -1:0] dec_Out;

    dec_1hot #(
        .n_inputs(n_Inputs),
        .n_outputs(n_Outputs)
    ) DEC (.dec_out(dec_Out), .dec_in(dec_In));

    initial
    begin

        $dumpfile("dec_1hot_wave.vcd");
        $dumpvars(0, dec_1hot_tb);

        $display("------------------------------------------------");
        $display("Time\t dec_In\t dec_Out");
        $display("------------------------------------------------");

        dec_In = 3'b000;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b001;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b010;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b011;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b100;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b101;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b110;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        dec_In = 3'b111;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);
        

        $display("-------------------------------------------------");
        $display("Simulation complete");

        $finish;
    end

endmodule