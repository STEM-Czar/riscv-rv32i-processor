`timescale 1 ns / 1 ps

module writeback (
    input wire [31:0] alu_result,
    input wire [31:0] r_mdata,
    input wire [31:0] pc_plus4,
    input wire [1:0] wb_S,
    output reg [31:0] w_data
);

    always @(*)
    begin
        case (wb_S)
            2'b00: w_data = alu_result;
            2'b01: w_data = r_mdata;
            2'b10: w_data = pc_plus4;
            default: w_data = alu_result;
        endcase
    end

endmodule