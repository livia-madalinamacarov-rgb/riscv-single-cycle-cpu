`timescale 1ns / 1ps


module program_counter_tb;

    reg clk = 0;
    reg reset = 0;
    reg pc_write = 0;
    reg [31:0] next_pc = 0;
    wire [31:0] pc;

    program_counter dut (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        reset = 1;
        @(negedge clk);
        #1;
        if (pc !== 0)
            $error("FAIL: PC Reset");
        else
            $display("PASS: PC Reset");

        // PC = 4
        reset = 0;
        pc_write = 1;
        next_pc = 4;
        @(negedge clk);
        #1;
        if (pc !== 4)
            $error("FAIL: PC Update");
        else
            $display("PASS: PC Update");

        pc_write = 0;
        next_pc = 8;
        @(negedge clk);
        #1;
        if (pc !== 4)
            $error("FAIL: PC Hold");
        else
            $display("PASS: PC Hold");

        pc_write = 1;
        next_pc = 100;
        @(negedge clk);
        #1;
        if (pc !== 100)
            $error("FAIL: PC Branch");
        else
            $display("PASS: PC Branch");

        $finish;
    end

endmodule

