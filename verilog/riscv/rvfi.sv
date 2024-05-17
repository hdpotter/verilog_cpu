
`define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32


module rvfi_wrapper(
    // instruction metadata
    output [`NRET        - 1 : 0] rvfi_valid,
    output [`NRET *   64 - 1 : 0] rvfi_order,
    output [`NRET * `ILEN - 1 : 0] rvfi_insn,
    output [`NRET        - 1 : 0] rvfi_trap,
    output [`NRET        - 1 : 0] rvfi_halt,
    output [`NRET        - 1 : 0] rvfi_intr,
    output [`NRET * 2    - 1 : 0] rvfi_mode,
    output [`NRET * 2    - 1 : 0] rvfi_ixl,

    // integer register read/write
    output [`NRET *    5 - 1 : 0] rvfi_rs1_addr,
    output [`NRET *    5 - 1 : 0] rvfi_rs2_addr,
    output [`NRET * `XLEN - 1 : 0] rvfi_rs1_rdata,
    output [`NRET * `XLEN - 1 : 0] rvfi_rs2_rdata,
    output [`NRET *    5 - 1 : 0] rvfi_rd_addr,
    output [`NRET * `XLEN - 1 : 0] rvfi_rd_wdata,

    // program counter
    output [`NRET * `XLEN - 1 : 0] rvfi_pc_rdata,
    output [`NRET * `XLEN - 1 : 0] rvfi_pc_wdata,

    // memory access
    output [`NRET * `XLEN   - 1 : 0] rvfi_mem_addr,
    output [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_rmask,
    output [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_wmask,
    output [`NRET * `XLEN   - 1 : 0] rvfi_mem_rdata,
    output [`NRET * `XLEN   - 1 : 0] rvfi_mem_wdata,

    // inputs
    input clock,
    input reset
);


datapath ourcore(
    .rvfi_valid(rvfi_valid),
    .rvfi_order(rvfi_order),
    .rvfi_insn(rvfi_insn),
    .rvfi_trap(rvfi_trap),
    .rvfi_halt(rvfi_halt),
    .rvfi_intr(rvfi_intr),
    .rvfi_mode(rvfi_mode),
    .rvfi_ixl(rvfi_ixl),
    .rvfi_rs1_addr(rvfi_rs1_addr),
    .rvfi_rs2_addr(rvfi_rs2_addr),
    .rvfi_rs1_rdata(rvfi_rs1_rdata),
    .rvfi_rs2_rdata(rvfi_rs2_rdata),
    .rvfi_rd_addr(rvfi_rd_addr),
    .rvfi_rd_wdata(rvfi_rd_wdata),
    .rvfi_pc_rdata(rvfi_pc_rdata),
    .rvfi_pc_wdata(rvfi_pc_wdata),
    .rvfi_mem_addr(rvfi_mem_addr),
    .rvfi_mem_rmask(rvfi_mem_rmask),
    .rvfi_mem_wmask(rvfi_mem_wmask),
    .rvfi_mem_rdata(rvfi_mem_rdata),
    .rvfi_mem_wdata(rvfi_mem_wdata),

    .clk(clock)
);

endmodule