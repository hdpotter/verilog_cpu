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

assign add_en = funct3 == 3'h0 && !sub_en; //todo: how to handle this
assign sub_en = funct3 == 3'h0 && funct7 == 7'h20;
assign xor_en = funct3 == 3'h4;
assign or_en = funct3 == 3'h6;
assign and_en = funct3 == 3'h7;

assign imm = {20'b0, instr[31:20]};

always_comb begin
    case(opcode)
        7'b0110011: begin //add etc.
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 1;
        end
        7'b0010011: begin //addi etc.
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 0;
        end
        7'b0000011: begin //lb etc.
            writeback_en = 1;
            writeback_from_mem = 1;
            use_rs1 = 1;
            use_rs2 = 0;
        end
        7'b0100011: begin //sb etc.
            writeback_en = 0;
            writeback_from_mem = 0; //todo: investigate whether don't cares work here
            use_rs1 = 1;
            use_rs2 = 1;
        end
        7'b1100011: begin //beq etc.
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 1;
        end
        7'b1101111: begin //jal
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;
        end
        7'b1100111: begin //jalr
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 1;
            use_rs2 = 0;
        end
        7'b0110111: begin //lui
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;
        end
        7'b0010111: begin //auipc
            writeback_en = 1;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;
        end
        7'b1110011: begin //ecall, ebreak
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;
        end
        default: begin //instruction error
            writeback_en = 0;
            writeback_from_mem = 0;
            use_rs1 = 0;
            use_rs2 = 0;
        end
    endcase
end




endmodule