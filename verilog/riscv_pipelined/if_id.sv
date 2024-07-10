module if_id(
    input logic [31:0] instr_in,
    output logic [31:0] instr_out,

    input clk
);

always @(posedge clk) begin
    instr_out <= instr_in;
end

endmodule