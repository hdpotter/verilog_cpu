

module memory(
    input [31:0] addr,
    input [31:0] value,
    input [2:0] funct3,
    input read,
    input write,
    input clk,

    output logic [31:0] data
);

parameter MEMSIZE = 64;

logic [31:0] mem [MEMSIZE-1:0];

always @(posedge clk) begin
    if(read) begin
        case(funct3)
            3'd0: data = {{24{mem[addr][7]}}, mem[addr][7:0]};
            3'd1: data = {{16{mem[addr][15]}}, mem[addr][15:0]};
            3'd2: data = mem[addr];
            3'd4: data = {24'd0, mem[addr][7:0]};
            3'd5: data = {16'd0, mem[addr][15:0]};
        endcase
    end else data = 32'd0;

    if(write) begin
        case(funct3)
            3'd0: mem[addr][7:0] = value[7:0];
            3'd1: mem[addr][15:0] = value[15:0];
            3'd2: mem[addr] = data;
        endcase
    end
end

endmodule