
// `define RVFI

`define NRET 1
`define ILEN 32
`define XLEN 32

module memory(
    input [31:0] addr,
    input [11:0] offset,
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

wire [31:0] full_addr = $signed(addr) + $signed(offset); //todo: errors on top half of 32-bit memory space

parameter MEMSIZE = 64;

logic [7:0] mem [MEMSIZE-1:0];

always @(posedge clk) begin
    if(read) begin
        case(funct3)
            3'h0: begin
                data <= {{24{mem[full_addr][7]}}, mem[full_addr]};
`ifdef RVFI
                rmask <= 4'b0001;
`endif
            end
            3'h1: begin
                data <= {{16{mem[full_addr+1][7]}}, mem[full_addr+1], mem[full_addr]};
`ifdef RVFI
                rmask <= 4'b0011;
`endif
            end
            3'h2: begin
                data <= {mem[full_addr+3], mem[full_addr+2], mem[full_addr+1], mem[full_addr]};
`ifdef RVFI
                rmask <= 4'b1111;
`endif
            end
            3'h4: begin
                data <= {24'd0, mem[full_addr]};
`ifdef RVFI
                rmask <= 4'b0001;
`endif
            end
            3'h5: begin
                data <= {16'd0, mem[full_addr+1], mem[full_addr]};
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
                mem[full_addr] = value[7:0];
`ifdef RVFI
                wmask <= 4'b0001;
`endif
            end
            3'h1: begin
                {mem[full_addr+1], mem[full_addr]} = value[15:0];
`ifdef RVFI
                wmask <= 4'b0011;
`endif
            end
            3'h2: begin
                {mem[full_addr+3], mem[full_addr+2], mem[full_addr+1], mem[full_addr]} = value;
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