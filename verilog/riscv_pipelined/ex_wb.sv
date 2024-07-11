module ex_wb(
    input [4:0] rd_addr_in,
    input [31:0] rd_in,


    output [4:0] rd_addr_out,
    output [31:0] rd_out,


    input clk
);

always @(posedge clk) begin
    rd_addr_out <= rd_addr_in;
    rd_out <= rd_in;
end

endmodule