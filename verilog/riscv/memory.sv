
// `define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32

module memory(
    input [31:0] addr,
    input [31:0] value,
    input [2:0] funct3,
    input read,
    input write,
    input clk,

`ifdef RVFI
    output logic [3:0] rmask,
    output logic [3:0] wmask,
`endif

    output logic [31:0] data
);

parameter MEMSIZE = 64;

logic [7:0] mem [MEMSIZE-1:0];

always @(posedge clk) begin
    if(read) begin
        case(funct3)
            3'h0: begin
                data <= {{24{mem[addr][7]}}, mem[addr]};
`ifdef RVFI
                rmask <= 4'b0001;
`endif
            end
            3'h1: begin
                data <= {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};
`ifdef RVFI
                rmask <= 4'b0011;
`endif
            end
            3'h2: begin
                data <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
`ifdef RVFI
                rmask <= 4'b1111;
`endif
            end
            3'h4: begin
                data <= {24'd0, mem[addr]};
`ifdef RVFI
                rmask <= 4'b0001;
`endif
            end
            3'h5: begin
                data <= {16'd0, mem[addr+1], mem[addr]};
`ifdef RVFI
                rmask <= 4'b0011;
`endif
            end
            default: begin
                data <= 32'd0;
`ifdef RVFI
                rmask <= 4'b0000;
`endif
            end
        endcase
    end else begin
        data <= 32'd0;
`ifdef RVFI
        rmask <= 4'b0000;
`endif
    end

    if(write) begin
        case(funct3)
            3'h0: begin
                mem[addr] = value[7:0];
`ifdef RVFI
                wmask <= 4'b0001;
`endif
            end
            3'h1: begin
                {mem[addr+1], mem[addr]} = value[15:0];
`ifdef RVFI
                wmask <= 4'b0011;
`endif
            end
            3'h2: begin
                {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = data;
`ifdef RVFI
                wmask <= 4'b1111;
`endif
            end
`ifdef RVFI
            default: begin
                wmask <= 4'b0000;
            end
`endif
        endcase
    end 
`ifdef RVFI
    else begin
        wmask <= 4'b0000;
    end
`endif
end

endmodule