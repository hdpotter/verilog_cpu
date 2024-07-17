module decoder (
    input [31:0] instr,

    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [4:0] rd_addr,

    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,

    output alu_rs2_reg,
    output logic [31:0] imm,

    output add_en,
    output sub_en,
    output xor_en,
    output or_en,
    output and_en,

    output writeback_en
);

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr = instr[11:7];

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign alu_rs2_reg = opcode[5];

assign add_en = {funct3, funct7} == {3'h0, 7'h0};
assign sub_en = {funct3, funct7} == {3'h0, 7'h20};
assign xor_en = {funct3, funct7} == {3'h4, 7'h0};
assign or_en = {funct3, funct7} == {3'h6, 7'h0};
assign and_en = {funct3, funct7} == {3'h7, 7'h0};

assign writeback_en = 1;

assign imm = {20'b0, instr[31:20]};

endmodule