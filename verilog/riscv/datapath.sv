
// `define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32

module datapath (

`ifdef RVFI
    // instruction metadata
    output logic [`NRET        - 1 : 0] rvfi_valid,
    output logic [`NRET *   64 - 1 : 0] rvfi_order,
    output logic [`NRET * `ILEN - 1 : 0] rvfi_insn,
    output logic [`NRET        - 1 : 0] rvfi_trap,
    output logic [`NRET        - 1 : 0] rvfi_halt,
    output logic [`NRET        - 1 : 0] rvfi_intr,
    output logic [`NRET * 2    - 1 : 0] rvfi_mode,
    output logic [`NRET * 2    - 1 : 0] rvfi_ixl,

    // integer register read/write
    output logic [`NRET *    5 - 1 : 0] rvfi_rs1_addr,
    output logic [`NRET *    5 - 1 : 0] rvfi_rs2_addr,
    output logic [`NRET * `XLEN - 1 : 0] rvfi_rs1_rdata,
    output logic [`NRET * `XLEN - 1 : 0] rvfi_rs2_rdata,
    output logic [`NRET *    5 - 1 : 0] rvfi_rd_addr,
    output logic [`NRET * `XLEN - 1 : 0] rvfi_rd_wdata,

    // program counter
    output logic [`NRET * `XLEN - 1 : 0] rvfi_pc_rdata,
    output logic [`NRET * `XLEN - 1 : 0] rvfi_pc_wdata,

    // memory access
    output logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_addr,
    output logic [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_rmask,
    output logic [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_wmask,
    output logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_rdata,
    output logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_wdata,
`endif

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

`ifdef RVFI
logic [31:0] rd_out;
`endif

registers registers(
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),

    .rd(reg_in),
    .rs1(rs1),
    .rs2(rs2),
`ifdef RVFI
    .rd_out(rd_out),
`endif
    
    .write(write_reg),
    .clk(clk)
);

wire [31:0] imm_shift = lui_en | auipc_en ? imm << 12 : imm;

wire [31:0] alu_in1 = b_en | jal_en | lui_en | auipc_en ? pc : rs1;
wire [31:0] alu_in2 = i_en | s_en | b_en | jal_en | jalr_en | lui_en | auipc_en ? imm_shift : rs2;

wire [31:0] alu_out;

alu alu(
    .i_en(i_en),
    .funct3(funct3),
    .funct7(funct7),
    .rs1(alu_in1),
    .rs2(alu_in2),
    .rd(alu_out)
);

wire [31:0] mem_out;

`ifdef RVFI
logic rmask;
logic wmask;
`endif

memory memory(
    .addr(rs1),
    .offset(imm),
    .value(rs2),
    .funct3(funct3),

    .read(im_en),
    .write(s_en),
    .clk(clk),

`ifdef RVSI
    .rmask(rmask),
    .wmask(wmask),
`endif

    .data(mem_out)
);

wire branch;

conditions conditions(
    .rs1(rs1),
    .rs2(rs2),
    .funct3(funct3),
    .branch(branch)
);

always @(posedge clk) begin
    if((b_en & branch) | jal_en | jalr_en) begin
        pc <= alu_out;
`ifdef RVFI
        rvfi_pc_wdata <= alu_out;
`endif
    end else begin
        pc <= pc + 4;
`ifdef RVFI
        rvfi_pc_wdata <= pc + 4;
`endif
    end
end

assign reg_in =
    r_en | i_en ? alu_out :
    im_en ? mem_out :
    jal_en | jalr_en ? pc + 4 :
    lui_en ? imm_shift :
    auipc_en ? alu_out :
    0;

`ifdef RVFI
always @(posedge clk) begin
    rvfi_valid <= 1;
    rvfi_order <= rvfi_order + 1;
    rvfi_insn <= instr;
    rvfi_trap <= 0; //todo: traps
    rvfi_halt <= 0; //todo: halt
    rvfi_intr <= 0; //todo: traps
    rvfi_mode <= 0;
    rvfi_ixl <= 2'd1;

    rvfi_rs1_addr <= rs1_addr;
    rvfi_rs2_addr <= rs2_addr;
    rvfi_rs1_rdata <= rs1;
    rvfi_rs2_rdata <= rs2;
    rvfi_rd_addr <= rd_addr;
    rvfi_rd_wdata <= rd_out;

    rvfi_pc_rdata <= pc;
    // rvfi_pc_wdata written in pc always block

    rvfi_mem_addr <= alu_out;
    rvfi_mem_rmask <= rmask;
    rvfi_mem_wmask <= wmask;
    rvfi_mem_rdata <= mem_out;
    rvfi_mem_wdata <= rs2;

end
`endif


endmodule
