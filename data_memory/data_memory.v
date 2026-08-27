`timescale 1 ns / 1 ps

module data_memory (
    input wire clk,
    input wire rst_n,
    input wire [31:0] addr,
    input wire [31:0] w_mdata,

    input wire mem_write,
    input wire mem_read,
    
    output wire [31:0] r_mdata
);

    reg [31:0] memory [0:1023];
    integer i;
    
    always @(posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin 
            for (i = 0; i < 1024; i = i+1)
            begin 
                memory[i] <= 32'b0;
            end
        end
        else if (mem_write)
            begin 
                memory[addr] <= w_mdata;
            end
    end

    assign r_mdata = mem_read ? memory[addr] : 32'b0;

endmodule