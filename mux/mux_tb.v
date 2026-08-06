`timescale 1ns / 1ps

module mux_tb;

    parameter n_input   = 4;
    parameter bit_width = 32;
    parameter n_S       = $clog2(n_input);

    reg  [(n_input * bit_width) - 1:0] mux_in;
    reg  [n_S - 1:0]                   mux_S;
    wire [bit_width - 1:0]             mux_out;

    integer i, j;
    reg [bit_width - 1:0] temp_val;

    wire [bit_width-1:0] in_wire [0:n_input-1];

    genvar g;
    generate
        for (g = 0; g < n_input; g = g + 1) begin : UNPACK_INPUTS
            assign in_wire[g] = mux_in[g * bit_width +: bit_width];
        end
    endgenerate

    mux #(
        .n_inputs(n_input),
        .bit_width(bit_width)
    ) MUX (
        .mux_in(mux_in),
        .mux_S(mux_S),
        .mux_out(mux_out)
    );

    initial 
    begin
        $dumpfile("mux_wave.vcd");
        $dumpvars(0, mux_tb);

        for (i = 0; i < n_input; i = i + 1) 
        begin
            temp_val = i + 1;
            mux_in[i * bit_width +: bit_width] = temp_val;
        end

        $display("================================================================================");
        
        $write("S\t| ");
        for (j = 0; j < n_input; j = j + 1) begin
            $write("in_%0d\t\t| ", j);
        end
        $display("mux_out");

        $write("--------+-");
        for (j = 0; j < n_input; j = j + 1) begin
            $write("----------------+-");
        end
        $display("----------------");

        for (i = 0; i < n_input; i = i + 1) 
        begin
            mux_S = i[n_S-1:0];
            #10;

            $write("%0d\t| ", mux_S);

            for (j = 0; j < n_input; j = j + 1) begin
                $write("0x%08h\t| ", mux_in[j * bit_width +: bit_width]);
            end

            $display("0x%08h (%0d)", mux_out, mux_out);
        end

        $display("================================================================================\n");
        $finish;
    end

endmodule