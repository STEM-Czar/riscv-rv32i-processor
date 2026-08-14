`timescale 1 ns / 1 ps

module program_counter #(
    parameter data_width = 32 
) (clk, rst_n, next_pc, pc, pc_plus4);

    input wire clk;
    input wire rst_n;
    input wire [data_width-1:0] next_pc;
    output reg [data_width-1:0] pc;
    output wire [data_width-1:0] pc_plus4;

    always @(posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin 
            pc <= {data_width{1'b0}}; 
        end
        else
        begin 
            pc <= next_pc;
        end
    end

    assign pc_plus4 = pc + 4;


endmodule