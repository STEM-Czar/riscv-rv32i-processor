`timescale 1 ns / 1 ps

module cu (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [31:0] imm_out,

    output reg mem_write,
    output reg mem_read,
    output reg alu_srcA,
    output reg alu_srcB,
    output reg [3:0] alu_control,
    output reg we,
    output reg [1:0] wb_S,
    output reg [1:0] pc_S,
    output reg branch
);

    always @(*)
    begin 

        alu_control = 4'b0;
        alu_srcA = 1'b0;
        alu_srcB = 1'b0;
        mem_write = 1'b0;
        mem_read = 1'b0;
        we = 1'b0;
        wb_S = 2'b0;
        pc_S = 2'b0;
        branch = 1'b0;

        case(opcode) 

        //R-type
            7'b0110011:
            begin
                we = 1'b1;

                case(funct3) 
                    3'b000: 
                        case(funct7) 
                            7'b0000000: //ADD
                                alu_control = 4'b0000; 

                            7'b0100000: //SUB
                                alu_control = 4'b0001; 
                            default: ;
                        endcase

                    3'b001: //SLL 
                                alu_control = 4'b0010;

                    3'b010: //SLT 
                                alu_control = 4'b0100;

                    3'b011: //SLTU
                                alu_control = 4'b1111;

                    3'b100: //XOR
                                alu_control = 4'b1010;

                    3'b101:
                        case(funct7) 
                            7'b0000000: //SRL
                                alu_control = 4'b0011;

                            7'b0100000: //SRA
                                alu_control = 4'b0101;
                            default: ;
                        endcase

                    3'b110: //OR
                                alu_control = 4'b1001;

                    3'b111: //AND
                                alu_control = 4'b1000;
                    default: ;
                endcase
            end

            
        

        //I-type

            7'b0010011:
            begin
                we = 1'b1;

                case(funct3) 
                    3'b000: //ADDI
                    begin
                        alu_control = 4'b0000; alu_srcB = 1; 
                    end

                    3'b001: //SLLI
                    begin 
                        alu_control = 4'b0010; alu_srcB = 1;
                    end

                    3'b010: //SLTI
                    begin 
                        alu_control = 4'b0100; alu_srcB = 1;
                    end

                    3'b011: //SLTIU
                    begin
                        alu_control = 4'b1111; alu_srcB = 1;
                    end

                    3'b100: //XORI
                    begin
                        alu_control = 4'b1010; alu_srcB = 1;
                    end

                    3'b101:
                        case(imm_out[11:5]) 
                            7'b0000000: //SRLI
                            begin
                                alu_control = 4'b0011; alu_srcB = 1;
                            end

                            7'b0100000: //SRAI
                            begin
                                alu_control = 4'b0101; alu_srcB = 1;
                            end
                            default: ;
                        endcase

                    3'b110: //ORI
                    begin
                        alu_control = 4'b1001; alu_srcB = 1;
                    end

                    3'b111: //ANDI
                    begin
                        alu_control = 4'b1000; alu_srcB = 1;
                    end
                    default: ;
                endcase
            end         

        //S-type
            7'b0100011:
            begin
                we = 1'b0; 
                case(funct3) 
                    3'b010: //sw
                    begin
                        mem_write = 1'b1; alu_srcB = 1; alu_control = 4'b0000;  
                    end
                    default: ;
                endcase
            end

        //B-type
            7'b1100011:
            begin
                branch = 1'b1;
                pc_S = 2'b01;
                we = 1'b0; 

                case(funct3)
                    3'b000: alu_control = 4'b0001; // BEQ
                    3'b001: alu_control = 4'b0001; // BNE
                    3'b100: alu_control = 4'b0100; // BLT
                    3'b101: alu_control = 4'b0100; // BGE
                    3'b110: alu_control = 4'b1111; // BLTU
                    3'b111: alu_control = 4'b1111; // BGEU
                    default: alu_control = 4'b0000;
                endcase
            end

        //U-type
            //lui
            7'b0110111:
            begin
                we = 1'b1; 
                alu_srcB = 1'b1;
            end

            //auipc
            7'b0010111:
            begin
                we = 1'b1; 
                alu_srcA = 1'b1; alu_srcB = 1'b1; alu_control = 4'b0000;
            end

        //J-type
            
            7'b1101111: //JAL
            begin
                we = 1'b1; wb_S = 2'b10;
                alu_srcA = 1'b1; alu_srcB = 1'b1; alu_control = 4'b0000; pc_S = 2'b01;
            end

            7'b1100111: //JALR
            begin
                we = 1'b1; wb_S = 2'b10;
                alu_srcB = 1'b1; alu_control = 4'b0000; pc_S = 2'b10;
            end


        //Memory
            7'b0000011: //lw
            begin
                we = 1'b1; wb_S = 2'b01;
                mem_read = 1'b1; alu_srcB = 1'b1; alu_control = 4'b0000;
            end

        default:
        begin 
            //
        end 
  
        endcase


    end

endmodule