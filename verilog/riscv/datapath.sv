module datapath(
    input clk
);

logic [31:0] pc;
wire [31:0] instr;

program_memory program_memory(
    .addr(pc),
    .instr(instr)
);

wire [2:0] funct3;
wire [6:0] funct7;
wire [11:0] imm_is;
wire [12:1] imm_b;
wire [31:12] imm_u;
wire [20:1] imm_j;
wire imm_sign;

wire r_en;
wire i_en;
wire im_en;
wire s_en;
wire b_en;
wire jal_en;
wire jalr_en;
wire lui_en;
wire auipc_en;

wire [4:0] rs1_addr;
wire [4:0] rs2_addr;
wire [4:0] rd_addr;


wire [31:0] imm;

decoder decoder(
    .instr(instr),
    
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),

    .funct3(funct3),
    .funct7(funct7),
    .imm(imm),

    .r_en(r_en),
    .i_en(i_en),
    .im_en(im_en),
    .s_en(s_en),
    .b_en(b_en),
    .jal_en(jal_en),
    .jalr_en(jalr_en),
    .lui_en(lui_en),
    .auipc_en(auipc_en)
);

wire [31:0] rs1;
wire [31:0] rs2;
wire [31:0] reg_in;

wire write_reg = r_en | i_en | jal_en | jalr_en | lui_en | auipc_en;

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),

    .rd(reg_in),
    .rs1(rs1),
    .rs2(rs2),
    
    .write(write_reg),
    .clk(clk)
);

wire [31:0] imm_shift = lui_en | auipc_en ? imm << 12 : imm;

wire [31:0] alu_in1 = b_en | jal_en | lui_en | auipc_en ? pc : rs1;
wire [31:0] alu_in2 = i_en | s_en | b_en | jal_en | jalr_en | lui_en | auipc_en ? imm_shift : rs2;

wire [31:0] alu_out;

alu alu(
    .funct3(funct3),
    .funct7(funct7),
    .rs1(alu_in1),
    .rs2(alu_in2),
    .rd(alu_out)
);

wire mem_out;

memory memory(
    .addr(alu_out),
    .value(rs2),
    .funct3(funct3),

    .read(im_en),
    .write(s_en),
    .clk(clk),

    .data(mem_out)
);

wire branch;

conditions conditions(
    .rs1(rs1),
    .rs2(rs2),
    .func3(func3),
    .branch(branch)
);

always @(posedge clk) begin
    if((b_en & branch) | jal_en | jalr_en) begin
        pc <= alu_out;
    end else begin
        pc <= pc + 4;
    end
end

assign rd =
    r_en | i_en ? alu_out :
    im_en ? mem_out :
    jal_en | jalr_en ? pc + 4 :
    lui_en ? imm_shift :
    auipc_en ? alu_out :
    0;

endmodule