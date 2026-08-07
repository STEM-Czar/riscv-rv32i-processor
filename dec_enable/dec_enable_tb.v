`timescale 1 ns / 1 ps

module dec_enable_tb;

    parameter n_Inputs = 3;
    parameter n_Outputs = 2**(n_Inputs);

    reg [n_Inputs -1:0] dec_In;
    wire [n_Outputs -1:0] dec_Out;
    reg dec_En;

    dec_enable #(
        .n_inputs(n_Inputs),
        .n_outputs(n_Outputs)
    ) DEC (.dec_out(dec_Out), .dec_in(dec_In), .dec_en(dec_En) );

    initial
    begin

          $dumpfile("dec_enable_wave.vcd");
          $dumpvars(0, dec_enable_tb);

          $display("----------------------------------------------------");
          $display("Time\t dec_In\t dec_Out\t dec_En");
          $display("----------------------------------------------------");

          dec_In = 3'b001 ; dec_En = 1'b0;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En);

          dec_In = 3'b001 ; dec_En = 1'b1;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b011 ; dec_En = 1'b0;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b011 ; dec_En = 1'b1;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b100 ; dec_En = 1'b0;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b100 ; dec_En = 1'b1;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b101 ; dec_En = 1'b0;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b101 ; dec_En = 1'b1;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En); 

          dec_In = 3'b111 ; dec_En = 1'b0;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En);

          dec_In = 3'b111 ; dec_En = 1'b1;
          #10;
          $display("%0t ns\t %b\t %b\t %b", $time, dec_In, dec_Out, dec_En);

          $display("---------------------------------------------------------------------");
          $display("Simulation complete");

          $finish;    
    end
endmodule