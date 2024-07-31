module forwarding(
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input use_rs1,
    input use_rs2,

    input prev1_write,
    input prev2_write,
    input prev3_write,

    input [4:0] prev1_write_addr,
    input [4:0] prev2_write_addr,
    input [4:0] prev3_write_addr,

    input prev1_mem, //whether we read value from memory
    input prev2_mem,
    input prev3_mem,

    output skip_instr,

    output rs1_take_mem, //take from M, not EX
    output rs1_take_prev1,
    output rs1_take_prev2,
    output rs1_take_prev3,

    output rs2_take_mem,
    output rs2_take_prev1,
    output rs2_take_prev2,
    output rs2_take_prev3
);

wire skip_instr_rs1;
wire skip_instr_rs2;
assign skip_instr = skip_instr_rs1 || skip_instr_rs2;

forwarding_single forwarding_single_rs1(
    .reg_addr(rs1_addr),
    .use_reg(use_rs1),

    .prev1_write(prev1_write),
    .prev2_write(prev2_write),
    .prev3_write(prev3_write),

    .prev1_write_addr(prev1_write_addr),
    .prev2_write_addr(prev2_write_addr),
    .prev3_write_addr(prev3_write_addr),

    .prev1_mem(prev1_mem),
    .prev2_mem(prev2_mem),
    .prev3_mem(prev3_mem),

    .skip_instr(skip_instr_rs1),
    .reg_take_mem(rs1_take_mem),
    .reg_take_prev1(rs1_take_prev1),
    .reg_take_prev2(rs1_take_prev2),
    .reg_take_prev3(rs1_take_prev3)
);

forwarding_single forwarding_single_rs2(
    .reg_addr(rs2_addr),
    .use_reg(use_rs2),

    .prev1_write(prev1_write),
    .prev2_write(prev2_write),
    .prev3_write(prev3_write),

    .prev1_write_addr(prev1_write_addr),
    .prev2_write_addr(prev2_write_addr),
    .prev3_write_addr(prev3_write_addr),

    .prev1_mem(prev1_mem),
    .prev2_mem(prev2_mem),
    .prev3_mem(prev3_mem),

    .skip_instr(skip_instr_rs2),
    .reg_take_mem(rs2_take_mem),
    .reg_take_prev1(rs2_take_prev1),
    .reg_take_prev2(rs2_take_prev2),
    .reg_take_prev3(rs2_take_prev3)
);

endmodule

module forwarding_single(
    input [4:0] reg_addr,
    input use_reg,

    input prev1_write,
    input prev2_write,
    input prev3_write,

    input [4:0] prev1_write_addr,
    input [4:0] prev2_write_addr,
    input [4:0] prev3_write_addr,

    input prev1_mem, //whether we read value from memory
    input prev2_mem,
    input prev3_mem,

    output skip_instr,

    output reg_take_mem, //take from M, not EX
    output reg_take_prev1,
    output reg_take_prev2,
    output reg_take_prev3
);

wire reg_take_prev1 = prev1_write_addr == reg_addr && prev1_write;
wire reg_take_prev2 = prev2_write_addr == reg_addr && prev2_write && !reg_take_prev1;
wire reg_take_prev3 = prev3_write_addr == reg_addr && prev3_write && !reg_take_prev2; //todo: better way to do priority?

assign skip_instr = reg_prev1_conflict && prev1_mem;

assign reg_take_mem = //todo: long combinational
    reg_take_prev1 && prev1_mem ||
    reg_take_prev2 && prev2_mem ||
    reg_take_prev3 && prev3_mem;




endmodule