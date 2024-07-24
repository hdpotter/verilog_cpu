module m_wb(
    input [4:0] rd_addr_in,
    input [31:0] rd_in,


    output logic [4:0] rd_addr_out,
    output logic [31:0] rd_out,


    input clk,
    input rst
);

always @(posedge clk) begin
    if(!rst) begin
        rd_addr_out <= rd_addr_in;
        rd_out <= rd_in;
    end else begin
        rd_addr_out <= 5'h0;
        rd_out <= 32'h0;
    end
end

endmodule