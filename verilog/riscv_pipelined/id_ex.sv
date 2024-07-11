module id_x(
    input logic [31:0] rd_addr_in,
    input logic [31:0] rs1_in,
    input logic [31:0] rs2_in,

    input logic alu_rs2_reg_in,
    input alu_op_onehot alu_op_in,
    input logic [31:0] imm_in,


    output logic [31:0] rd_addr_out,
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,

    output logic alu_rs2_reg_out,
    output alu_op_onehot alu_op_out,
    output logic [31:0] imm_out,


    input clk
);

always @(posedge clk) begin
    rd_addr_out <= rd_addr_in;
    rs1_out <= rs1_in;
    rs2_out <= rs2_in;

    alu_rs2_reg_out <= alu_rs2_reg_in;
    alu_op_in <= alu_op_out;

    imm_in <= imm_out;
end

endmodule