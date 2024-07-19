module id_ex(
    input logic [4:0] rd_addr_in,
    input logic [31:0] rs1_in,
    input logic [31:0] rs2_in,

    input logic alu_rs2_reg_in,
    input logic [31:0] imm_in,

    input logic add_en_in,
    input logic sub_en_in,
    input logic xor_en_in,
    input logic or_en_in,
    input logic and_en_in,

    input logic rs1_alu_loopback_in,
    input logic rs2_alu_loopback_in,


    output logic [4:0] rd_addr_out,
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,

    output logic alu_rs2_reg_out,
    output logic [31:0] imm_out,

    output logic add_en_out,
    output logic sub_en_out,
    output logic xor_en_out,
    output logic or_en_out,
    output logic and_en_out,

    output logic rs1_alu_loopback_out,
    output logic rs2_alu_loopback_out,

    input clk,
    input rst
);

always @(posedge clk) begin
    rd_addr_out <= rd_addr_in;
    rs1_out <= rs1_in;
    rs2_out <= rs2_in;

    alu_rs2_reg_out <= alu_rs2_reg_in;
    
    add_en_out <= add_en_in;
    sub_en_out <= sub_en_in;
    xor_en_out <= xor_en_in;
    or_en_out <= or_en_in;
    and_en_out <= and_en_in;

    imm_out <= imm_in;


end

endmodule