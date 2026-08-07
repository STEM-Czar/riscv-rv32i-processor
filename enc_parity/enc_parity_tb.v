`timescale 1 ns / 1 ps

module enc_parity_tb;

    parameter n_Inputs = 8;
    parameter n_Outputs = $clog2(n_Inputs);

    reg [n_Inputs - 1:0] enc_In;
    wire [n_Outputs - 1:0] enc_Out;
    wire Parity;

    enc_parity #(
        .n_inputs(n_Inputs),
        .n_outputs(n_Outputs)
    ) ENC (.enc_out(enc_Out), .enc_in(enc_In), .parity(Parity));


    initial
    begin

        $dumpfile("enc_parity_wave.vcd");
        $dumpvars(0, enc_parity_tb);


        $display("----------------------------------------------");    
        $display("Time(ns)\t enc_In\t enc_Out\t Parity");
        $display("----------------------------------------------");


        enc_In = 8'b00000001;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000010;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000011;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000100;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000101;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000110;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00000111;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        enc_In = 8'b00001000;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, Parity);

        $display("----------------------------------------------");
        
        $display("Simulation complete.");
        $finish;
    end

endmodule