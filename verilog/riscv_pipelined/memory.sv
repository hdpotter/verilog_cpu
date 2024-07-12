
module memory(
    input [31:0] addr,
    input [11:0] offset,
    input [31:0] value,
    input [2:0] funct3,
    input read,
    input write,
    input clk,

    output logic [31:0] data
);

wire [31:0] full_addr = $signed(addr) + $signed(offset); //todo: errors on top half of 32-bit memory space

parameter MEMSIZE = 64;

logic [7:0] mem [MEMSIZE-1:0];

always @(*) begin
    if(read) begin
        case(funct3)
            3'h0: begin
                data <= {{24{mem[full_addr][7]}}, mem[full_addr]};
            end
            3'h1: begin
                data <= {{16{mem[full_addr+1][7]}}, mem[full_addr+1], mem[full_addr]};
            end
            3'h2: begin
                data <= {mem[full_addr+3], mem[full_addr+2], mem[full_addr+1], mem[full_addr]};
            end
            3'h4: begin
                data <= {24'd0, mem[full_addr]};
            end
            3'h5: begin
                data <= {16'd0, mem[full_addr+1], mem[full_addr]};
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
                mem[full_addr] = value[7:0];
            end
            3'h1: begin
                {mem[full_addr+1], mem[full_addr]} = value[15:0];
            end
            3'h2: begin
                {mem[full_addr+3], mem[full_addr+2], mem[full_addr+1], mem[full_addr]} = value;
            end
        endcase
    end 
end

endmodule