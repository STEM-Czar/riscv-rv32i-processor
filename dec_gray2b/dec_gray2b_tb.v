`timescale 1 ns / 1 ps

module dec_gray2b_tb;

    parameter bit_Width = 4;

    reg [bit_Width -1 : 0] dec_In;
    wire [bit_Width -1:0] dec_Out;

    dec_gray2b #(
        .bit_width(bit_Width)
    ) DEC (.dec_out(dec_Out), .dec_in(dec_In));

    initial
    begin

        $dumpfile("dec_gray2b.vcd");
        $dumpvars(0, dec_gray2b_tb);

         $display("----------------------------------------------");    
        $display("Time(ns)\t dec_In\t dec_Out\t");
        $display("----------------------------------------------");


        dec_In = 4'b0001;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0010;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0011;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0100;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0101;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0110;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b0111;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        dec_In = 4'b1000;
        #10;
        $display("%0t ns\t %b\t %b", $time, dec_In, dec_Out);

        $display("----------------------------------------------");
        
        $display("Simulation complete.");
        $finish;
    end

endmodule