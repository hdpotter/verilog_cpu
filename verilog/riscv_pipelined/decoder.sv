module decoder (
    input [31:0] instr,

    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [4:0] rd_addr,

    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,

    output alu_rs2_reg,
    output logic [31:0] imm,

    output add_en,
    output sub_en,
    output xor_en,
    output or_en,
    output and_en,
    output eq_en,

    output jump_on_alu_true,
    output jump_always,

    output logic writeback_en,
    output logic writeback_from_mem,
    output logic use_rs1,
    output logic use_rs2
);

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr = instr[11:7];

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

assign alu_rs2_reg = opcode[5];

logic arith_en;
logic cond_en;

assign add_en = arith_en && funct3 == 3'h0 && !sub_en; //todo: how to handle this
assign sub_en = arith_en && funct3 == 3'h0 && funct7 == 7'h20;
assign xor_en = arith_en && funct3 == 3'h4;
assign or_en = arith_en && funct3 == 3'h6;
assign and_en = arith_en && funct3 == 3'h7;

assign eq_en = cond_en && funct3 == 3'h0;

assign jump_on_alu_true = opcode == 7'b1100011;
assign jump_always = opcode == 7'b1101111 || opcode == 7'b1100111;

always @(*) begin //can't be always_comb because icarus doesn't support bit array indexing in that context
    case(opcode)
        7'b0110011: begin //add etc.
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 1;

            arith_en = 1;
            cond_en = 0;

            imm = 32'h0;
        end
        7'b0010011: begin //addi etc.
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 0;

            arith_en = 1;
            cond_en = 0;

            imm = {20'b0, instr[31:20]};
        end
        7'b0000011: begin //lb etc.
            writeback_en = 1;
            writeback_from_mem = 1;
            use_rs1 = 1;
            use_rs2 = 0;

            arith_en = 1;
            cond_en = 0;

            imm = {20'b0, instr[31:20]};
        end
        7'b0100011: begin //sb etc.
            writeback_en = 0;
            writeback_from_mem = 0; //todo: investigate whether don't cares work here
            use_rs1 = 1;
            use_rs2 = 1;

            arith_en = 1;
            cond_en = 0;

            imm = {20'b0, instr[31:25], instr[11:7]};
        end
        7'b1100011: begin //beq etc.
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 1;

            arith_en = 0;
            cond_en = 1;

            imm = {19'b0, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        end
        7'b1101111: begin //jal
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;

            arith_en = 1;
            cond_en = 0;

            imm = {12'b0, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        7'b1100111: begin //jalr
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 0;

            arith_en = 1;
            cond_en = 0;

            imm = {20'b0, instr[31:20]};
        end
        7'b0110111: begin //lui
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;

            arith_en = 0;
            cond_en = 0;

            imm = {instr[31:12], 12'b0};
        end
        7'b0010111: begin //auipc
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;

            arith_en = 1;
            cond_en = 0;

            imm = {instr[31:12], 12'b0};
        end
        7'b1110011: begin //ecall, ebreak
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;

            arith_en = 0;
            cond_en = 0;

            imm = {20'b0, instr[31:20]};
        end
        default: begin //instruction error
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;

            arith_en = 0;
            cond_en = 0;

            imm = {32'b0};
        end
    endcase
end




endmodule