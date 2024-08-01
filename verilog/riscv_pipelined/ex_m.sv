module ex_m(
    input logic [4:0] rd_addr_in,
    input logic [31:0] rd_in,
    input logic writeback_en_in,
    input logic writeback_from_mem_in,

    output logic [4:0] rd_addr_out,
    output logic [31:0] rd_out,
    output logic writeback_en_out,
    output logic writeback_from_mem_out,

    input skip,
    input clk,
    input rst
);

always @(posedge clk) begin
    if(!rst) begin
        if(!skip) begin
            rd_addr_out <= rd_addr_in;
            rd_out <= rd_in;
            writeback_en_out <= writeback_en_in;
            writeback_from_mem_out <= writeback_from_mem_in;
        end
    end else begin
        rd_addr_out <= 5'h0;
        rd_out <= 32'h0;
        writeback_en_out <= 1;
        writeback_from_mem_out <= 0;
    end
end

endmodule