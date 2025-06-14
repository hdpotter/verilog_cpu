module conditions(
    input [31:0] rs1,
    input [31:0] rs2,
    input [2:0] funct3,
    output logic branch
);

always @(*) begin
    case (funct3)
        3'd0: branch = $signed(rs1) == $signed(rs2); // beq
        3'd1: branch = $signed(rs1) != $signed(rs2); // bne
        3'd4: branch = $signed(rs1) < $signed(rs2); // blt
        3'd5: branch = $signed(rs1) >= $signed(rs2); // bge
        3'd6: branch = $unsigned(rs1) < $unsigned(rs2); // bltu
        3'd7: branch = $unsigned(rs1) >= $unsigned(rs2); // bgeu
        default: branch = 0;
    endcase
end


endmodule