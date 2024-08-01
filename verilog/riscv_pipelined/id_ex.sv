module id_ex(
    input logic [4:0] rd_addr_in,
    input logic [31:0] rs1_in,
    input logic [31:0] rs2_in,
    input logic writeback_en_in,
    input logic writeback_from_mem_in,

    input logic alu_rs2_reg_in,
    input logic [31:0] imm_in,

    input logic add_en_in,
    input logic sub_en_in,
    input logic xor_en_in,
    input logic or_en_in,
    input logic and_en_in,

    input logic skip_instr_in,
    input logic rs1_take_prev1_in,
    input logic rs2_take_prev1_in,


    output logic [4:0] rd_addr_out,
    output logic [31:0] rs1_out,
    output logic [31:0] rs2_out,
    output logic writeback_en_out,
    output logic writeback_from_mem_out,

    output logic alu_rs2_reg_out,
    output logic [31:0] imm_out,

    output logic add_en_out,
    output logic sub_en_out,
    output logic xor_en_out,
    output logic or_en_out,
    output logic and_en_out,

    output logic skip_instr_out,
    output logic rs1_take_prev1_out,
    output logic rs2_take_prev1_out,

    input clk,
    input rst
);

always @(posedge clk) begin
    if(!rst) begin
        rd_addr_out <= rd_addr_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        writeback_en_out <= writeback_en_in;
        writeback_from_mem_out <= writeback_from_mem_in;

        alu_rs2_reg_out <= alu_rs2_reg_in;

        skip_instr_out <= skip_instr_in;
        rs1_take_prev1_out <= rs1_take_prev1_in;
        rs2_take_prev1_out <= rs2_take_prev1_in;

        add_en_out <= add_en_in;
        sub_en_out <= sub_en_in;
        xor_en_out <= xor_en_in;
        or_en_out <= or_en_in;
        and_en_out <= and_en_in;

        imm_out <= imm_in;
        
    end else begin
        rd_addr_out <= 5'd0;
        rs1_out <= 32'h0;
        rs2_out <= 32'h0;
        writeback_en_out <= 1;
        writeback_from_mem_out <= 0;

        alu_rs2_reg_out <= 0;

        skip_instr_out <= 0;
        rs1_take_prev1_out <= 0;
        rs2_take_prev1_out <= 0;

        add_en_out <= 1;
        sub_en_out <= 0;
        xor_en_out <= 0;
        or_en_out <= 0;
        and_en_out <= 0;

        imm_out <= 32'h0;
    end
end

endmodule