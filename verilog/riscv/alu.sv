module alu(
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] rs1,
    input [31:0] rs2,
    output logic [31:0] rd
);
    always @(*) begin
        case ({funct3, funct7})
            {3'd0, 10'd0}: rd = rs1 + rs2; //add
            {3'd0, 10'd20}: rd = rs1 - rs2; //sub
            {3'd4, 10'd0}: rd = rs1 ^ rs2; //xor
            {3'd6, 10'd0}: rd = rs1 | rs2; //or
            {3'd7, 10'd0}: rd = rs1 & rs2; //and
            {3'd1, 10'd0}: rd = rs1 << rs2; //sll
            {3'd5, 10'd0}: rd = rs1 >> rs2; //srl
            {3'd5, 10'd20}: rd = rs1 >>> rs2; //sra
            {3'd2, 10'd0}: rd = $signed(rs1) < $signed(rs2) ? 32'd1 : 32'd0; //slt
            {3'd3, 10'd0}: rd = $unsigned(rs1) < $unsigned(rs2) ? 32'd1 : 32'd0; //sltu
            default: rd = {31{1'b0}};
        endcase
    end

endmodule