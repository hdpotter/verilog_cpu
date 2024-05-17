
`define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32


`ifdef RVFI
typedef struct packed {
    // instruction metadata
    logic [`NRET        - 1 : 0] rvfi_valid;
    logic [`NRET *   64 - 1 : 0] rvfi_order;
    logic [`NRET * `ILEN - 1 : 0] rvfi_insn;
    logic [`NRET        - 1 : 0] rvfi_trap;
    logic [`NRET        - 1 : 0] rvfi_halt;
    logic [`NRET        - 1 : 0] rvfi_intr;
    logic [`NRET * 2    - 1 : 0] rvfi_mode;
    logic [`NRET * 2    - 1 : 0] rvfi_ixl;

    // integer register read/write
    logic [`NRET *    5 - 1 : 0] rvfi_rs1_addr;
    logic [`NRET *    5 - 1 : 0] rvfi_rs2_addr;
    logic [`NRET * `XLEN - 1 : 0] rvfi_rs1_rdata;
    logic [`NRET * `XLEN - 1 : 0] rvfi_rs2_rdata;
    logic [`NRET *    5 - 1 : 0] rvfi_rd_addr;
    logic [`NRET * `XLEN - 1 : 0] rvfi_rd_wdata;

    // program counter
    logic [`NRET * `XLEN - 1 : 0] rvfi_pc_rdata;
    logic [`NRET * `XLEN - 1 : 0] rvfi_pc_wdata;

    // memory access
    logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_addr;
    logic [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_rmask;
    logic [`NRET * `XLEN/8 - 1 : 0] rvfi_mem_wmask;
    logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_rdata;
    logic [`NRET * `XLEN   - 1 : 0] rvfi_mem_wdata;
} rvfi_struct;
`endif


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

rvfi_struct rvfi_all;

assign rvfi_valid = rvfi_all.rvfi_valid;
assign rvfi_order = rvfi_all.rvfi_order;
assign rvfi_insn = rvfi_all.rvfi_insn;
assign rvfi_trap = rvfi_all.rvfi_trap;
assign rvfi_halt = rvfi_all.rvfi_halt;
assign rvfi_intr = rvfi_all.rvfi_intr;
assign rvfi_mode = rvfi_all.rvfi_mode;
assign rvfi_ixl = rvfi_all.rvfi_ixl;
assign rvfi_rs1_addr = rvfi_all.rvfi_rs1_addr;
assign rvfi_rs2_addr = rvfi_all.rvfi_rs2_addr;
assign rvfi_rs1_rdata = rvfi_all.rvfi_rs1_rdata;
assign rvfi_rs2_rdata = rvfi_all.rvfi_rs2_rdata;
assign rvfi_rd_addr = rvfi_all.rvfi_rd_addr;
assign rvfi_rd_wdata = rvfi_all.rvfi_rd_wdata;
assign rvfi_pc_rdata = rvfi_all.rvfi_pc_rdata;
assign rvfi_pc_wdata = rvfi_all.rvfi_pc_wdata;
assign rvfi_mem_addr = rvfi_all.rvfi_mem_addr;
assign rvfi_mem_rmask = rvfi_all.rvfi_mem_rmask;
assign rvfi_mem_wmask = rvfi_all.rvfi_mem_wmask;
assign rvfi_mem_rdata = rvfi_all.rvfi_mem_rdata;
assign rvfi_mem_wdata = rvfi_all.rvfi_mem_wdata;

datapath ourcore(
    .rvfi_out(rvfi_all),

    .clk(clock)
);

endmodule