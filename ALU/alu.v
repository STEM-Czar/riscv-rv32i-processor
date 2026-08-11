`timescale 1 ns / 1 ps

module alu #(
    parameter bit_width = 8,
    parameter opcode_bits = 4
) (alu_out, alu_status, inA, inB, alu_control );

    input wire [bit_width -1 : 0] inA;
    input wire [bit_width - 1 : 0] inB;
    input wire [opcode_bits - 1 : 0] alu_control;
    output reg [bit_width - 1 : 0] alu_out;
    output reg [3:0] alu_status;

    reg Z_flag; //Zero = [0]
    reg N_flag; //Negative = [1]
    reg C_flag; //Carry = [2]
    reg V_flag; //Overflow = [3]

    reg[bit_width:0] temp;


    always @(*)
    begin
        
        temp       = {(bit_width + 1){1'b0}};
        alu_out    = {bit_width{1'b0}};
        alu_status = 4'b0000;
        C_flag = 1'b0;
        V_flag = 1'b0;
        Z_flag     = 1'b0;
        N_flag     = 1'b0;

        case (alu_control)
            
            //Add            
            4'b0000:
            begin
                    temp = {1'b0, inA} + {1'b0, inB};
                    alu_out = temp[bit_width -1:0];
                    C_flag = temp[bit_width];
                    V_flag = (inA[bit_width -1] == inB[bit_width-1]) && (alu_out[bit_width-1] != inA[bit_width -1]);

            end

            //Subtract            
            4'b0001:
            begin
                    temp = {1'b0, inA} - {1'b0, inB};
                    alu_out = temp[bit_width -1:0];
                    C_flag = ~temp[bit_width];
                    V_flag = (inA[bit_width -1] != inB[bit_width-1]) && (alu_out[bit_width-1] != inA[bit_width -1]);
            end

            //Logical Shift Left            
            4'b0010:
                    alu_out = inA << inB;

            //Logical Shift Right            
            4'b0011:
                    alu_out = inA >> inB;

            //Arithmetic Shift Left            
            4'b0100:
                    alu_out = $signed(inA) <<< inB;

            //Arithmetic Shift Right            
            4'b0101:
                    alu_out = $unsigned($signed(inA) >>> inB);

            //Circular Shift Left            
            4'b0110:
                    alu_out = (inA << inB) | (inA >> (bit_width - inB));

            //Circular Shift Right            
            4'b0111:
                    alu_out = (inA >> inB) | (inA << (bit_width - inB));

            //Logical AND            
            4'b1000:
                    alu_out = inA & inB;

            //Logical OR            
            4'b1001:
                    alu_out = inA | inB;

            //Logical XOR            
            4'b1010:
                    alu_out = inA ^ inB;

            //Logical NAND            
            4'b1011:
                    alu_out = ~(inA & inB);

            //Logical NOR            
            4'b1100:
                    alu_out = ~(inA | inB);

            //Logical XNOR            
            4'b1101:
                    alu_out = ~(inA ^ inB);

            //Equal Comparison            
            4'b1110:
                    alu_out = (inA == inB) ? {{bit_width -1{1'b0}}, 1'b1} : {bit_width{1'b0}};

            //Greater Comparison            
            4'b1111:
                    alu_out = (inA > inB) ? {{bit_width -1{1'b0}}, 1'b1} : {bit_width{1'b0}};

            default: alu_out = {bit_width{1'b0}};

        endcase

        Z_flag = (alu_out == {bit_width{1'b0}});
        N_flag = alu_out[bit_width - 1];

        alu_status = {V_flag, C_flag, N_flag, Z_flag};

    end

endmodule