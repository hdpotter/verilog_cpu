module instruction_memory(
    input [31:0] addr,
    output [31:0] instr
);

parameter MEMSIZE = 64;

logic [31:0] memory [MEMSIZE-1:0];

assign instr = memory[addr / 4];

endmodule