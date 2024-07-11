module datapath (
    input clk
);

// ################################################################
// begin instruction fetch
// ################################################################

logic [31:0] pc;
logic [31:0] instr_if;

instruction_memory instruction_memory(
    .addr(pc),
    .instr(instr_if)
);


// ################################################################
// end instruction fetch

logic [31:0] instr_id;

if_id if_id(
    .instr_in(instr),
    .instr_out(instr_id),
    .clk(clk)
);

// begin instruction decode
// ################################################################


logic [4:0] rd_addr_id;
logic [4:0] rs1_addr;
logic [4:0] rs2_addr;

logic alu_rs1_reg_id;
alu_op_onehot alu_op_id;
logic [31:0] imm_id;

logic writeback_en_id;

decoder decoder(
    .instr(instr_id),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr_id),
    .alu_rs2_reg(alu_rs2_reg_id),
    .alu_op(alu_op_id),
    .imm(imm_id),
    .writeback_en(writeback_en_id)
);

logic [31:0] rs1_id;
logic [31:0] rs2_id;

logic [4:0] reg_write_addr; // separate names because we need to propagate through pipeline
logic [31:0] reg_write_val;
logic reg_write_en;

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),

    .rs1(rs1_id),
    .rs2(rs2_id),

    .rd_addr(reg_write_addr),
    .rd(reg_write_val),
    .write(reg_write_en)
);

// ################################################################
// end instruction decode

logic [31:0] rd_addr_ex;
logic [31:0] rs1_ex;
logic [31:0] rs2_ex;
logic alu_rs2_reg_ex;
alu_op_onehot alu_op_ex;
logic [31:0] imm_ex;

id_ex id_ex(
    .rd_addr_in(rd_addr_id),
    .rs1_in(rs1_id),
    .rs2_in(rs2_id),
    .alu_rs2_reg_in(alu_rs2_reg_id),
    .alu_op_in(alu_op_id),
    .imm_in(imm_id),

    .rd_addr_out(rd_adder_ex),
    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex),
    .alu_rs2_reg_out(alu_rs2_reg_ex),
    .alu_op_out(alu_op_ex),
    .imm_out(imm_ex)
);

// begin execute
// ################################################################

logic [31:0] alu_out;

logic alu_in_2 = alu_rs2_reg_ex ? rs2_ex : imm_ex;

alu alu(
    .op(alu_op_ex),
    .arg1(rs1_ex),
    .arg2(rs2_ex),
    .out(alu_out)
);

// ################################################################
// end execute

logic [4:0] rd_addr_wb;
logic [31:0] rd_wb;

ex_wb ex_wb(
    .rd_addr_in(rd_addr_ex),
    .rd_in(alu_out),
    .rd_addr_out(rd_addr_wb),
    .rd_out(rd_wb)
);

// begin writeback
// ################################################################

assign reg_write_addr = rd_addr_wb;
assign reg_write_val = rd_wb;


endmodule