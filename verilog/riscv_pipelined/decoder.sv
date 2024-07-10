module decoder (
    input [31:0] instr,

    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [4:0] rd_addr,

    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,

    output logic [31:0] imm
);

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr = instr[11:7];

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];


endmodule