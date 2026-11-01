`timescale 1ns / 1ps


module alu_tb;

    reg [31:0] a, b;
    reg [2:0] alu_op;
    wire [31:0] result;
    wire zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    initial begin
        a = 10; b = 5; alu_op = 3'b000;
        #10;
        if (result !== 15 || zero !== 0)
            $display("FAIL: ADD");
        else
            $display("PASS: ADD");

        alu_op = 3'b001;
        #10;
        if (result !== 5 || zero !== 0)
            $display("FAIL: SUB");
        else
            $display("PASS: SUB");

        a = 5; b = 5;
        #10;
        if (result !== 0 || zero !== 1)
            $display("FAIL: ZERO");
        else
            $display("PASS: ZERO");
            
            
        a = 3; b = 2; alu_op = 3'b101;
        #10;
        if (result !== 12)
            $error("FAIL: SLL");
        else
            $display("PASS: SLL");

        a = 16; b = 2; alu_op = 3'b110;
        #10;
        if (result !== 4)
            $error("FAIL: SRL");
        else
            $display("PASS: SRL");

        a = 32'hFFFFFFFF; b = 2;
        alu_op = 3'b111;
        #10;
        if (result !== 1)
            $error("FAIL: SLT");
        else
            $display("PASS: SLT");


        $finish;
    end

endmodule

