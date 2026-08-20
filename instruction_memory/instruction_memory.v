`timescale 1 ns / 1 ps

module instruction_memory #(
    parameter MEM_DEPTH = 256 // 256 x 4 bytes (32 bits) = 1024 bytes ( 1 KB)
) (
    input  wire [31:0] addr,
    output wire [31:0] instr
);

    
    reg [31:0] mem [0:MEM_DEPTH-1];

    
    initial 
    begin
        $readmemh("instructions.hex", mem);
    end

    assign instr = mem[addr[9:2]]; //256 so 8 bits needed for addressing, but the first 2 bits are dropped for word alignment

endmodule