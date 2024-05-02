typedef struct {
    logic a;
} test_input;

typedef struct {
    logic a;
} test_output;

module automatic test;

    import "DPI-C" context function void get_input(output test_input a);
    import "DPI-C" context function void run_test(input test_output a);

    export "DPI-C" function quit;

    logic clk;

    test_input inp;
    test_output outp;
    assign outp = test_output '{ inp.a };

    initial begin
        clk = 0;
    end

    always #1 clk = ~clk;

    always @(posedge clk) begin
        get_input(inp);
        run_test(outp);
    end

    function void quit();
        $finish;
    endfunction

endmodule