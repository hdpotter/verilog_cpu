module registers(
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,

    output [31:0] rs1,
    output [31:0] rs2,


    input [4:0] rd_addr,
    input [31:0] rd,
    input write,


    input clk
);

logic [31:0] mem [31:0];

assign rs1 = rs1_addr == 0 ? 0 : mem[rs1_addr];
assign rs2 = rs2_addr == 0 ? 0 : mem[rs2_addr];

always @(posedge clk) begin
    if(write && rd_addr != 5'h0 ) begin
        mem[rd_addr] <= rd;
    end
end

endmodule