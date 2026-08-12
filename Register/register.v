`timescale 1 ns / 1 ps

module register #(
    parameter bit_width = 32
) (clk, rst_n, we, d_in, q_out);

    input wire clk;
    input wire rst_n;
    input wire we;
    input wire [bit_width -1:0] d_in;
    output wire [bit_width -1:0] q_out;

    reg [bit_width -1 : 0] q_reg; //internal state register (parallel D flipflops)

    assign q_out = q_reg;

    always @(posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin 
            q_reg <= {bit_width{1'b0}};
        end
        else
        if (we)
        begin 
            q_reg <= d_in;
        end
    end

endmodule