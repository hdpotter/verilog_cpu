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

decoder decoder(
    .instr(instr_id),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr_id)
);

logic [31:0] rs1_id;
logic [31:0] rs2_id;

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),

    .rs1(rs1_id),
    .rs2(rs2_id)
);

// ################################################################
// end instruction decode

logic [31:0] rd_addr_ex;
logic [31:0] rs1_ex;
logic [31:0] rs2_ex;

id_ex id_ex(
    .rd_addr_in(rd_addr_id),
    .rs1_in(rs1_id),
    .rs2_in(rs2_id),

    .rd_addr_out(rd_adder_ex),
    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex)
);

// begin execute
// ################################################################


endmodule