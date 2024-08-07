// interface alu_op_onehot;
//     add_en;
//     sub_en;
//     xor_en;
//     or_en;
//     and_en;
// endinterface

module alu(
    // input alu_op_onehot op,
    input add_en,
    input sub_en,
    input xor_en,
    input or_en,
    input and_en,
    input eq_en,

    input [31:0] arg1,
    input [31:0] arg2,

    output logic [31:0] result
);
    always @(*) begin
        // todo: should be unique if
        if(add_en) result = arg1 + arg2; //todo: look into mux optimizations
        else if(sub_en) result = arg1 - arg2;
        else if(xor_en) result = arg1 ^ arg2;
        else if(or_en) result = arg1 | arg2;
        else if(and_en) result = arg1 & arg2;
        else if (eq_en) result = arg1 == arg2;
        else result = 32'b0;
    end

endmodule