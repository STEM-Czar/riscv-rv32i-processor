`timescale 1 ns / 1 ps

module dec_7seg_tb;

    reg [3:0] dec_In;

    wire [6:0] dec_Out;

    dec_7seg Seg7 (.dec_out(dec_Out), .dec_in(dec_In));

    integer k;
    
    initial
    begin

        $dumpfile("dec_7seg_wave.vd");
        $dumpvars(0, dec_7seg_tb);

        for (k = 0; k < 11; k = k+1)
        begin
            dec_In = k[3:0];
            #10;

            $display("\nInput: %d (4'b%b) | Output: 7'b%b", dec_In, dec_In, dec_Out);
            
            // dec_Out bits: [6]=g, [5]=f, [4]=e, [3]=d, [2]=c, [1]=b, [0]=a
            
            //Top Line
            $display(" %s ", dec_Out[0] ? "_" : " ");
            
            //Middle Line 
            $display("%s%s%s", dec_Out[5] ? "|" : " ", 
                               dec_Out[6] ? "_" : " ", 
                               dec_Out[1] ? "|" : " ");
                               
            // Bottom Line
            $display("%s%s%s", dec_Out[4] ? "|" : " ", 
                               dec_Out[3] ? "_" : " ", 
                               dec_Out[2] ? "|" : " ");

        end

    end

endmodule