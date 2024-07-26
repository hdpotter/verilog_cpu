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

    output writeback_en,

    // data hazard resolution
    input [4:0] prev_rd_addr,
    input prev_writeback,

    input [4:0] prev2_rd_addr,
    input prev2_writeback,

    input [4:0] prev3_rd_addr,
    input prev3_writeback,

    output rs1_alu_loopback,
    output rs2_alu_loopback,

    output rs1_take_prev2,
    output rs2_take_prev2,
    output rs1_take_prev3,
    output rs2_take_prev3
);

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr = instr[11:7];

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign alu_rs2_reg = opcode[5];

assign add_en = funct3 == 3'h0 && !sub_en; //todo: how to handle this
assign sub_en = funct3 == 3'h0 && funct7 == 7'h20;
assign xor_en = funct3 == 3'h4;
assign or_en = funct3 == 3'h6;
assign and_en = funct3 == 3'h7;

assign writeback_en =  //todo: find more efficient solution
    opcode == 7'b0110011 || //add etc.
    opcode == 7'b0010011 || //addi etc.
    opcode == 7'b0000011 || //lb etc.
    opcode == 7'b1101111 || //jal
    opcode == 7'b1100111 || //jalr
    opcode == 7'b0110111 || //lui
    opcode == 7'b0010111;   //auipc

assign imm = {20'b0, instr[31:20]};

// data hazard resolution
assign rs1_alu_loopback = prev_writeback && prev_rd_addr == rs1_addr;
assign rs2_alu_loopback = prev_writeback && prev_rd_addr == rs2_addr;

assign rs1_take_prev2 = prev2_writeback && prev2_rd_addr == rs1_addr;
assign rs2_take_prev2 = prev2_writeback && prev2_rd_addr == rs2_addr;

assign rs1_take_prev3 = prev3_writeback && !rs1_take_prev2 == rs1_addr;
assign rs2_take_prev3 = prev3_writeback && !rs2_take_prev2 == rs2_addr;





endmodule