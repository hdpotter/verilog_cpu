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

wire [31:0] pc_imm = pc_ex + imm_ex;
wire jump = jump_always_ex | (jump_on_alu_true_ex & alu_result_ex[0]); //todo: verify understanding of boolean output to 32-bit type

always @(posedge clk) begin
    if(rst) begin
        pc <= 0;
        broken <= 0;
    end else begin
        if(jump) pc <= pc_imm; //todo: better mux
        else if (!skip_instr_id) pc <= pc + 4;

        broken <= broken || instr_if == 32'h00100073;
    end
end

// ################################################################
// end instruction fetch

logic [31:0] instr_id;
logic [31:0] pc_id;

if_id if_id(
    .instr_in(instr_if),
    .pc_in(pc),

    .instr_out(instr_id),
    .pc_out(pc_id),

    .clk(clk),
    .rst(rst | jump)
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
logic eq_en_id;
logic [31:0] imm_id;

logic writeback_en_id;
wire writeback_from_mem_id;
wire use_rs1;
wire use_rs2;

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
    .eq_en(eq_en_id),

    .jump_on_alu_true(jump_on_alu_true_id),
    .jump_always(jump_always_id),

    .imm(imm_id),

    .writeback_en(writeback_en_id),
    .writeback_from_mem(writeback_from_mem_id),
    .use_rs1(use_rs1),
    .use_rs2(use_rs2)
);

logic [31:0] rs1_reg;
logic [31:0] rs2_reg;

wire [4:0] reg_write_addr; // separate names because we need to propagate through pipeline
wire [31:0] reg_write_val;
wire reg_write_en;

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),

    .rs1(rs1_reg),
    .rs2(rs2_reg),

    .rd_addr(reg_write_addr),
    .rd(reg_write_val),
    .write(reg_write_en),

    .clk(clk)
);

wire skip_instr_id;

wire rs1_take_mem;
wire rs1_take_prev1_id; // needs to be passed to ex
wire rs1_take_prev2;
wire rs1_take_prev3;

wire rs2_take_mem;
wire rs2_take_prev1_id;
wire rs2_take_prev2;
wire rs2_take_prev3;

wire [31:0] rs1_id = rs1_take_prev2 ? rd_m : (rs1_take_prev3 ? rd_wb : rs1_reg); //todo: more idiomatic way of doing 3-way priority?
wire [31:0] rs2_id = rs2_take_prev2 ? rd_m : (rs2_take_prev3 ? rd_wb : rs2_reg); //todo: priority delay stacks with reg read delay; figure out if it should be here or in alu


forwarding forwarding(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .use_rs1(use_rs1),
    .use_rs2(use_rs2),

    .prev1_write(writeback_en_ex),
    .prev2_write(writeback_en_m),
    .prev3_write(writeback_en_wb),

    .prev1_write_addr(rd_addr_ex),
    .prev2_write_addr(rd_addr_m),
    .prev3_write_addr(rd_addr_wb),

    .prev1_mem(writeback_from_mem_ex),
    .prev2_mem(writeback_from_mem_m),
    .prev3_mem(writeback_from_mem_wb),

    .skip_instr(skip_instr_id),

    .rs1_take_mem(rs1_take_mem),
    .rs1_take_prev1(rs1_take_prev1_id),
    .rs1_take_prev2(rs1_take_prev2),
    .rs1_take_prev3(rs1_take_prev3),

    .rs2_take_mem(rs2_take_mem),
    .rs2_take_prev1(rs2_take_prev1_id),
    .rs2_take_prev2(rs2_take_prev2),
    .rs2_take_prev3(rs2_take_prev3)
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
logic eq_en_ex;

logic skip_instr_ex;

logic writeback_en_ex;
logic writeback_from_mem_ex;

logic [31:0] pc_ex;

logic rs1_take_prev1_ex;
logic rs2_take_prev1_ex;

logic jump_on_alu_true_ex;
logic jump_always_ex;

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
    .eq_en_in(eq_en_id),
    .skip_instr_in(skip_instr_id),
    .rs1_take_prev1_in(rs1_take_prev1_id),
    .rs2_take_prev1_in(rs2_take_prev1_id),
    .writeback_en_in(writeback_en_id),
    .writeback_from_mem_in(writeback_from_mem_id),
    .jump_on_alu_true_in(jump_on_alu_true_id),
    .jump_always_in(jump_always_id),
    .pc_in(pc_id),

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
    .eq_en_out(eq_en_ex),
    .skip_instr_out(skip_instr_ex),
    .rs1_take_prev1_out(rs1_take_prev1_ex),
    .rs2_take_prev1_out(rs2_take_prev1_ex),
    .writeback_en_out(writeback_en_ex),
    .writeback_from_mem_out(writeback_from_mem_ex),
    .jump_on_alu_true_out(jump_on_alu_true_ex),
    .jump_always_out(jump_always_ex),
    .pc_out(pc_ex),

    .skip(skip_instr_ex),
    .clk(clk),
    .rst(rst | jump)
);

// begin execute
// ################################################################

logic [31:0] alu_result_ex;

wire[31:0] alu_in_1 = rs1_take_prev1_ex ? rd_m : rs1_ex;

wire[31:0] alu_in_2_maybe_loopback = rs2_take_prev1_ex ? rd_m : rs2_ex;
wire[31:0] alu_in_2 = alu_rs2_reg_ex ? alu_in_2_maybe_loopback : imm_ex; 

alu alu(
    .add_en(add_en_ex),
    .sub_en(sub_en_ex),
    .xor_en(xor_en_ex),
    .or_en(or_en_ex),
    .and_en(and_en_ex),
    .eq_en(eq_en_ex),

    .arg1(alu_in_1),
    .arg2(alu_in_2),
    .result(alu_result_ex)
);

// ################################################################
// end execute

logic [4:0] rd_addr_m;
logic [31:0] alu_result_m;
logic writeback_en_m;
logic writeback_from_mem_m;

ex_m ex_m(
    .rd_addr_in(rd_addr_ex),
    .alu_result_in(alu_result_ex),
    .writeback_en_in(writeback_en_ex),
    .writeback_from_mem_in(writeback_from_mem_ex),

    .rd_addr_out(rd_addr_m),
    .alu_result_out(alu_result_m),
    .writeback_en_out(writeback_en_m),
    .writeback_from_mem_out(writeback_from_mem_m),

    .skip(skip_instr_ex),
    .clk(clk),
    .rst(rst)
);

// begin memory
// ################################################################

wire [31:0] mem_out;

memory memory(
    .addr(alu_result_m),
    .value(32'h0),
    .funct3(3'd2), //lw

    .read(writeback_from_mem_m),
    .write(1'b0),

    .data(mem_out),

    .clk(clk)
);

wire [31:0] rd_m = writeback_from_mem_m ? mem_out : alu_result_m;



// ################################################################
// end memory

logic [4:0] rd_addr_wb;
logic [31:0] rd_wb;
logic writeback_en_wb;
logic writeback_from_mem_wb;

m_wb m_wb(
    .rd_addr_in(rd_addr_m),
    .rd_in(rd_m),
    .writeback_en_in(writeback_en_m),
    .writeback_from_mem_in(writeback_from_mem_m),

    .rd_addr_out(rd_addr_wb),
    .rd_out(rd_wb),
    .writeback_en_out(writeback_en_wb),
    .writeback_from_mem_out(writeback_from_mem_wb),

    .skip(skip_instr_ex),
    .clk(clk),
    .rst(rst)
);


// begin writeback
// ################################################################

// todo: these shouldn't be an issue on skip_instr because m_wb won't update; verify this   
assign reg_write_addr = rd_addr_wb;
assign reg_write_val = rd_wb;
assign reg_write_en = 1;



endmodule