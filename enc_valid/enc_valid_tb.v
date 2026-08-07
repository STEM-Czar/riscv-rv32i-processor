`timescale 1 ns / 1 ps

module enc_valid_tb;

    parameter n_Inputs = 8;
    parameter n_Outputs = $clog2(n_Inputs);

    reg [n_Inputs - 1:0] enc_In;
    wire [n_Outputs - 1:0] enc_Out;
    wire enc_Valid;

    enc_valid #(
        .n_inputs(n_Inputs),
        .n_outputs(n_Outputs)
    ) ENC (.enc_out(enc_Out), .enc_in(enc_In), .enc_valid(enc_Valid));

    integer t;

    initial
    begin

        $dumpfile("enc_valid_wave.vcd");
        $dumpvars(0, enc_valid_tb);


        $display("----------------------------------------------");    
        $display("Time(ns)\t enc_In\t enc_Out\t enc_Valid");
        $display("----------------------------------------------");

        for (t = 0; t < n_Inputs; t = t + 1) begin
            enc_In = (1 << t);
            #10;
            
            $display("%0t ns\t %b\t %b\t %b ", $time, enc_In, enc_Out, enc_Valid);
        end

        enc_In = 8'b0;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, enc_Valid);

        enc_In = 8'b00001001;
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, enc_Valid);

        enc_In = 8'b10010010; 
        #10;
        $display("%0t ns\t %b\t %b\t %b", $time, enc_In, enc_Out, enc_Valid);

        $display("----------------------------------------------");
        
        $display("Simulation complete.");
        $finish;
    end

endmodule