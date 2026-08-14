`timescale 1 ns / 1 ps

module registerFile #(
    parameter data_width = 32,
    parameter address_width = 5
)(clk, rst_n, we, w_addr, w_data, r_addr1, r_data1, r_addr2, r_data2);

    input wire clk;
    input wire rst_n;
    input wire we;
    input wire [address_width -1 :0] w_addr;
    input wire [data_width -1 :0] w_data;
    input wire [address_width -1 :0] r_addr1;
    input wire [address_width -1 :0] r_addr2;

    output wire [data_width-1 :0] r_data1;
    output wire [data_width-1 :0] r_data2;

    localparam n_regs = 2 ** (address_width);

    reg [data_width-1:0] registers [0:n_regs-1];

    integer i;

    always @(posedge clk or negedge rst_n)
    begin 
        if (!rst_n)
        begin 
            for (i = 0; i < n_regs; i=i+1)
            begin 
                registers[i] <= {data_width{1'b0}};
            end
        end
        else 
            if (we && (w_addr != 0))
            begin 
                registers[w_addr] <= w_data;
            end
    end

    assign r_data1 = (r_addr1 == 0) ? {data_width{1'b0}} : registers[r_addr1];
    assign r_data2 = (r_addr2 == 0) ? {data_width{1'b0}} : registers[r_addr2];

endmodule