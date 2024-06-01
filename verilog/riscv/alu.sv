module alu(
    input i_en,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] rs1,
    input [31:0] rs2,
    output logic [31:0] rd
);
    always @(*) begin
        if(!i_en) begin
            case ({funct3, funct7})
                {3'h0, 7'h0}: rd = rs1 + rs2; //add
                {3'h0, 7'h20}: rd = rs1 - rs2; //sub
                {3'h4, 7'h0}: rd = rs1 ^ rs2; //xor
                {3'h6, 7'h0}: rd = rs1 | rs2; //or
                {3'h7, 7'h0}: rd = rs1 & rs2; //and
                {3'h1, 7'h0}: rd = rs1 << rs2; //sll
                {3'h5, 7'h0}: rd = rs1 >> rs2; //srl
                {3'h5, 7'h20}: rd = $signed(rs1) >>> rs2; //sra
                {3'h2, 7'h0}: rd = $signed(rs1) < $signed(rs2) ? 32'd1 : 32'd0; //slt
                {3'h3, 7'h0}: rd = $unsigned(rs1) < $unsigned(rs2) ? 32'd1 : 32'd0; //sltu
                default: rd = {31{1'b0}};
            endcase
        end else begin
            case(funct3)
                {3'h0}: rd = rs1 + rs2; //addi
                {3'h4}: rd = rs1 ^ rs2; //xori
                {3'h6}: rd = rs1 | rs2; //ori
                {3'h7}: rd = rs1 & rs2; //addi
                {3'h1}: rd = rs1 << rs2[4:0]; //slli
                {3'h5}: rd = rs2[11:5] == 7'h0 ? rs1 >> rs2[4:0] : $signed($signed(rs1) >>> rs2[4:0]); //srli, srai
                {3'h2}: rd = $signed(rs1) < $signed(rs2) ? 32'd1 : 32'd0; //slti
                {3'h3}: rd = $unsigned(rs1) < $unsigned(rs2) ? 32'd1 : 32'd0; //sltiu
                default: rd = {31{1'b0}};
            endcase
        end
    end

endmodule