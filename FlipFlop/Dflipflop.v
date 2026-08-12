`timescale 1 ns / 1ps

module Dflipflop (q, q_bar, d, rst_n, clk);

    input wire d;
    input wire clk;
    input wire rst_n;
    output reg q;
    output wire q_bar;

    assign q_bar = ~q;

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            q <= 1'b0;
        end
        else
        begin
            q <= d;
        end

    end

endmodule