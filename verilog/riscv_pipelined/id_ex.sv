module id_x(
    input logic [31:0] rd_addr_in,
    input logic [31:0] rs1_in,
    input logic [31:0] rs2_in,

    input logic [2:0] funct3_in,
    input logic [6:0] funct7_in,

    input logic [31:0] imm_in,

    output logic [31:0] rd_addr_out,
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,

    output logic [2:0] funct3_out,
    output logic [6:0] funct7_out,

    output logic [31:0] imm_out,

    input clk
);

always @(posedge clk) begin
    rd_addr_out <= rd_addr_in;
    rs1_out <= rs1_in;
    rs2_out <= rs2_in;

    funct3_in <= funct3_out;
    funct7_in <= funct7_out;
    imm_in <= imm_out;
end

endmodule