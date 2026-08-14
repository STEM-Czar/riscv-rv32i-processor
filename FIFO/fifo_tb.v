`timescale 1 ns / 1 ps

module fifo_tb;

    parameter data_width = 32;
    parameter fifo_depth = 16;

    reg clk;
    reg rst_n;
    reg w_en;
    reg r_en;
    reg [data_width-1:0] w_data;
    wire [data_width-1:0] r_data;
    wire full;
    wire empty;

    
    fifo #(
        .data_width(data_width),
        .fifo_depth(fifo_depth)
    ) FIFO (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .r_en(r_en),
        .w_data(w_data),
        .r_data(r_data),
        .full(full),
        .empty(empty)
    );

    
    always #5 clk = ~clk;

    initial begin
        $dumpfile("fifo_wave.vcd");
        $dumpvars(0, fifo_tb);

        
        clk    = 0;
        rst_n  = 0;
        w_en   = 0;
        r_en   = 0;
        w_data = 0;

        #12 rst_n = 1; // Release reset

        // Fill the FIFO (16 Writes)
        repeat (fifo_depth) begin
            @(negedge clk);
            w_en   = 1;
            w_data = w_data + 32'h10; // Write incrementing values
        end

        // Try writing 1 extra word to check full flag protection
        @(negedge clk);
        w_data = 32'hDEADBEEF;

        @(negedge clk);
        w_en = 0;

        // Empty the FIFO (16 Reads)
        repeat (fifo_depth) begin
            @(negedge clk);
            r_en = 1;
        end

        @(negedge clk);
        r_en = 0;

        #20;
        $display("Test Complete!");
        $finish;
    end

endmodule