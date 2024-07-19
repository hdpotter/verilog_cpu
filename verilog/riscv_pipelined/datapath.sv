module datapath (
    input rst,
    input clk
);


logic [31:0] pc;
logic broken;



// ################################################################
// begin instruction fetch
// ################################################################

logic [31:0] instr_if;

instruction_memory instruction_memory(
    .addr(pc),
    .instr(instr_if),
    .broken(broken)
);

always @(posedge clk) begin
    if(rst) begin
        pc <= 0;
        broken <= 0;
    end else begin
        pc <= pc + 4;
        broken <= broken || instr_if == 32'h00100073;
    end
end

// ################################################################
// end instruction fetch

logic [31:0] instr_id;

if_id if_id(
    .instr_in(instr_if),
    .instr_out(instr_id),
    .clk(clk)
);

// begin instruction decode
// ################################################################


logic [4:0] rd_addr_id;
logic [4:0] rs1_addr;
logic [4:0] rs2_addr;

logic alu_rs1_reg_id;
logic add_en_id;
logic sub_en_id;
logic xor_en_id;
logic or_en_id;
logic and_en_id;
logic [31:0] imm_id;

logic writeback_en_id;

decoder decoder(
    .instr(instr_id),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr_id),
    .alu_rs2_reg(alu_rs2_reg_id),

    .add_en(add_en_id),
    .sub_en(sub_en_id),
    .xor_en(xor_en_id),
    .or_en(or_en_id),
    .and_en(and_en_id),

    .imm(imm_id),
    .writeback_en(writeback_en_id)
);

logic [31:0] rs1_id;
logic [31:0] rs2_id;

wire [4:0] reg_write_addr; // separate names because we need to propagate through pipeline
wire [31:0] reg_write_val;
wire reg_write_en;

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),

    .rs1(rs1_id),
    .rs2(rs2_id),

    .rd_addr(reg_write_addr),
    .rd(reg_write_val),
    .write(reg_write_en),

    .clk(clk)
);

// ################################################################
// end instruction decode

logic [4:0] rd_addr_ex;
logic [31:0] rs1_ex;
logic [31:0] rs2_ex;
logic alu_rs2_reg_ex;
logic [31:0] imm_ex;
logic add_en_ex;
logic sub_en_ex;
logic xor_en_ex;
logic or_en_ex;
logic and_en_ex;

id_ex id_ex(
    .rd_addr_in(rd_addr_id),
    .rs1_in(rs1_id),
    .rs2_in(rs2_id),
    .alu_rs2_reg_in(alu_rs2_reg_id),
    .imm_in(imm_id),
    .add_en_in(add_en_id),
    .sub_en_in(sub_en_id),
    .xor_en_in(xor_en_id),
    .or_en_in(xor_en_id),
    .and_en_in(and_en_id),

    .rd_addr_out(rd_addr_ex),
    .rs1_out(rs1_ex),
    .rs2_out(rs2_ex),
    .alu_rs2_reg_out(alu_rs2_reg_ex),
    .imm_out(imm_ex),
    .add_en_out(add_en_ex),
    .sub_en_out(sub_en_ex),
    .xor_en_out(xor_en_ex),
    .or_en_out(or_en_ex),
    .and_en_out(and_en_ex),

    .clk(clk)
);

// begin execute
// ################################################################

logic [31:0] alu_out;

wire[31:0] alu_in_2 = alu_rs2_reg_ex ? rs2_ex : imm_ex;

alu alu(
    .add_en(add_en_ex),
    .sub_en(sub_en_ex),
    .xor_en(xor_en_ex),
    .or_en(or_en_ex),
    .and_en(and_en_ex),

    .arg1(rs1_ex),
    .arg2(alu_in_2),
    .out(alu_out)
);

// ################################################################
// end execute

logic [4:0] rd_addr_m;
logic [31:0] rd_m;

ex_m ex_m(
    .rd_addr_in(rd_addr_ex),
    .rd_in(alu_out),
    .rd_addr_out(rd_addr_m),
    .rd_out(rd_m),

    .clk(clk)
);

// begin memory
// ################################################################


memory memory(
);



// ################################################################
// end memory

logic [4:0] rd_addr_wb;
logic [31:0] rd_wb;

m_wb m_wb(
    .rd_addr_in(rd_addr_m),
    .rd_in(rd_m),
    .rd_addr_out(rd_addr_wb),
    .rd_out(rd_wb),

    .clk(clk)
);


// begin writeback
// ################################################################

assign reg_write_addr = rd_addr_wb;
assign reg_write_val = rd_wb;
assign reg_write_en = 1;


endmodule