module if_id(
    input logic [31:0] instr_in,
    input logic [31:0] pc_in,

    output logic [31:0] instr_out,
    output logic [31:0] pc_out,

    input clk,
    input rst
);

always @(posedge clk) begin
    if(!rst) begin
        instr_out <= instr_in;
        pc_out <= pc_in;
    end else begin
        instr_out <= 32'h00000013; //nop on reset
        pc_out <= 0; //todo: better way?
    end
end

endmodule