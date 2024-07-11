interface alu_op_onehot;
    add_en;
    sub_en;
    xor_en;
    or_en;
    and_en;
endinterface

module alu(
    input alu_op_onehot op,

    input arg1,
    input arg2,

    output logic [31:0] out
);
    always @(*) begin
        unique if(op.add_en) out = arg1 + arg2; //todo: look into mux optimizations
        else if(op.sub_en) out = arg1 - arg2;
        else if(op.xor_en) out = arg1 ^ arg2;
        else if(op.or_en) out = arg1 | arg2;
        else if(op.and_en) out = arg1 & arg2;
        else out = 32'b0;
    end

endmodule