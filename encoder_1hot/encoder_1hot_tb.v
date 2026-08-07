`timescale 1 ns / 1 ps

module encoder_1hot_tb;

    parameter n_Inputs = 8;
    parameter n_Outputs = $clog2(n_Inputs);

    reg [n_Inputs - 1:0] enc_In;
    wire [n_Outputs - 1:0] enc_Out;

    encoder_1hot #(
        .n_inputs(n_Inputs),
        .n_outputs(n_Outputs)
    ) ENC (.enc_out(enc_Out), .enc_in(enc_In));

    integer t;

    initial
    begin

        $dumpfile("encoder_1hot_wave.vcd");
        $dumpvars(0, encoder_1hot_tb);


        $display("----------------------------------------------");    
        $display("Time(ns)\t enc_In\t enc_Out");
        $display("----------------------------------------------");

        for (t = 0; t < n_Inputs; t = t + 1) begin
            enc_In = (1 << t);
            #10;
            
            $display("%0t ns\t\t %b\t\t %b", $time, enc_In, enc_Out);
        end

        $display("----------------------------------------------");
        
        $display("Simulation complete.");
        $finish;
    end

endmodule