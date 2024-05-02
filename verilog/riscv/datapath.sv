module datapath(
    input clk
);

wire instr;


wire [2:0] funct3;
wire [6:0] funct7;
wire [11:0] imm_is;
wire [12:1] imm_b;
wire [31:12] imm_u;
wire [20:1] imm_j;
wire imm_sign;

wire r_en;
wire i_en;
wire s_en;
wire b_en;
wire j_en;
wire lui_en;
wire auipc_en;

wire [4:0] rs1_addr;
wire [4:0] rs2_addr;
wire [4:0] rd_addr;

wire [31:0] pc;

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
    .s_en(s_en),
    .b_en(b_en),
    .j_en(j_en),
    .lui_en(lui_en),
    .auipc_en(auipc_en)
);

wire [31:0] rs1;
wire [31:0] rs2;
wire [31:0] reg_in;

wire write_reg = r_en | i_en | j_en | lui_en | auipc_en;

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

wire [31:0] alu_in1 = b_en | j_en | lui_en | auipc_en ? pc : rs1;
wire [31:0] alu_in2 = i_en | s_en | b_en | j_en | lui_en | auipc_en ? imm_shift : rs2;

wire [31:0] alu_out;

alu alu(
    .funct3(funct3),
    .funct7(funct7),
    .rs1(alu_in1),
    .rs2(alu_in2),
    .rd(alu_out)
);

wire mem_read;
wire mem_write;

wire mem_out;

memory memory(
    .addr(alu_out),
    .pc(pc),
    .value(rs2),
    .funct3(funct3),

    .read(mem_read),
    .write(mem_write),
    .clk(clk),

    .data(mem_out),
    .instr(instr)
);

endmodule