module decoder(
    input [31:0] instr,

    output [4:0] rd_addr,
    output [2:0] funct3,
    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [6:0] funct7,

    output logic [31:0] imm,

    output r_en,
    output i_en,
    output im_en, // memory section of i-type instruction space
    output s_en,
    output b_en,
    output jal_en,
    output jalr_en,

    output lui_en,
    output auipc_en
);

assign r_en = instr[6:0] == 7'b0110011;
assign i_en = instr[6:0] == 7'b0010011;
assign im_en = instr[6:0] == 7'b0000011;
assign s_en = instr[6:0] == 7'b0100011;
assign b_en = instr[6:0] == 7'b1100011;

assign jal_en = instr[6:0] == 7'b1101111;
assign jalr_en = instr[6:0] == 7'b1100111;

assign lui_en = instr[6:0] == 7'b0110111;
assign auipc_en = instr[6:0] == 7'b0010111;

assign rd_addr = instr[11:7];
assign funct3 = instr[14:12];
assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign funct7 = instr[31:25];


wire imm_sign = instr[31];

wire [11:0] imm_is = i_en ? instr[31:25] : {instr[31:25], instr[11:7]};
wire [12:1] imm_b = {instr[31], instr[7], instr[30:25], instr[11:8]};
wire [31:12] imm_u = instr[31:12];
wire [20:1] imm_j = {instr[31], instr[19:12], instr[20], instr[30:21]};

always @(*) begin
    if(i_en | s_en) imm = {{20{imm_sign}}, imm_is};
    else if(b_en) imm = {{19{imm_sign}}, imm_b, 1'd0};
    else if(lui_en | auipc_en) imm = {imm_u, 20'd0};
    else if(jal_en) imm = {{20{imm_sign}}, imm_j};
    else imm = 32'd0;
end




endmodule