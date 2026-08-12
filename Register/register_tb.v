`timescale 1 ns / 1 ps

module register_tb;
    
    parameter bit_width = 32;
    reg clk;
    reg we;
    reg rst_n;
    reg [bit_width -1:0] d_in;
    wire [bit_width -1:0] q_out;

    register #(
        .bit_width(bit_width)
    ) REG (.clk(clk), .we(we), .rst_n(rst_n), .d_in(d_in), .q_out(q_out));

    always #5 clk = ~clk;

    initial
    begin 
        
        $dumpfile("register_wave.vcd");
        $dumpvars(0, register_tb);
        
        clk   = 0;
        we    = 0;
        rst_n = 0;
        d_in  = {bit_width{1'b0}};

        #12;
        rst_n = 1;

        #8;
        d_in = {bit_width{1'b1}};
        we   = 0; //q_out = 0

        #10;
        we = 1;  // q_out = d_in = {bit_width{1'b1}} = 1111111...


        #10;
        d_in = {bit_width/2{2'b10}}; // q_out = {bit_width/2{2'b10}} = 101010...;

        #10;
        we = 0;
        d_in = {bit_width/2{2'b01}}; //q_out shout not change

        #7;
        rst_n = 0; //q_out = 0000...

        #10;
        rst_n = 1;

        #20;


        $display("Test Complete");
        $finish;

    end 

endmodule