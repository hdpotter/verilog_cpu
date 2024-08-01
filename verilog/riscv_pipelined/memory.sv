
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

logic [7:0] mem [MEMSIZE-1:0];

always @(*) begin
    if(read) begin
        case(funct3)
            3'h0: begin
                data <= {{24{mem[addr][7]}}, mem[addr]};
            end
            3'h1: begin
                data <= {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};
            end
            3'h2: begin
                data <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
            end
            3'h4: begin
                data <= {24'd0, mem[addr]};
            end
            3'h5: begin
                data <= {16'd0, mem[addr+1], mem[addr]};
            end
            default: begin
                data <= 32'd0;
            end
        endcase
    end else begin
        data <= 32'd0;
    end

    if(write) begin
        case(funct3)
            3'h0: begin
                mem[addr] = value[7:0];
            end
            3'h1: begin
                {mem[addr+1], mem[addr]} = value[15:0];
            end
            3'h2: begin
                {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = value;
            end
        endcase
    end 
end

endmodule