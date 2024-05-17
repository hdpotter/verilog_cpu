
`define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32

module registers(
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [4:0] rd_addr,
    input [31:0] rd,

    output [31:0] rs1,
    output [31:0] rs2,

`ifdef RVFI
    output logic [31:0] rd_out,
`endif

    input write,
    input clk
);

logic [31:0] mem [31:0];

assign rs1 = rs1_addr == 0 ? 0 : mem[rs1_addr];
assign rs2 = rs2_addr == 0 ? 0 : mem[rs2_addr];

always @(posedge clk) begin
    if(write) begin
        mem[rd_addr] <= rd;
`ifdef RVFI
        rd_out <= rd; //todo: get this to actually read memory
`endif
    end
`ifdef RVFI
    else begin
        rd_out <= 32'd0;
    end
`endif


end

endmodule