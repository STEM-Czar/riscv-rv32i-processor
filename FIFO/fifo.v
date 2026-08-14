`timescale 1 ns / 1 ps

module fifo #(
    parameter data_width = 32,
    parameter fifo_depth = 16
) (r_data, full, empty, clk, rst_n, w_en, r_en, w_data);

    input wire clk;
    input wire rst_n;
    input wire w_en;
    input wire r_en;
    input wire [data_width-1:0] w_data;
    output reg [data_width-1:0] r_data;
    output wire full;
    output wire empty;

    reg [data_width-1:0] mem [0:fifo_depth-1];
    reg [($clog2(fifo_depth))-1:0] w_ptr;
    reg [($clog2(fifo_depth))-1:0] r_ptr;
    reg [($clog2(fifo_depth)):0] count;

    assign full = (count == fifo_depth);
    assign empty = (count == 0);

    always @(posedge clk or negedge rst_n)
    begin 
        if(!rst_n)
        begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
            r_data <= 0;   

        end
        else 
        begin 
            if (w_en && !full)
            begin 
               mem[w_ptr] <= w_data;
               w_ptr <= w_ptr + 1'b1;
     
            end

            if (r_en && !empty)
            begin 
                r_data <= mem[r_ptr];
                r_ptr <= r_ptr + 1'b1;
            end

            case ({w_en && !full, r_en && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;

                default: count <= count;
            endcase
        end
    end

endmodule