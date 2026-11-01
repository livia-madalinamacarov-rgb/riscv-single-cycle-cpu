`timescale 1ns / 1ps


module register_file_tb;

    reg clk = 0;
    reg reset = 0;
    reg reg_write = 0;
    reg [4:0] rs1 = 0, rs2 = 0, rd = 0;
    reg [31:0] write_data = 0;

    wire [31:0] read_data1, read_data2;

    register_file dut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin
        reset = 1;
        @(negedge clk);
        reset = 0;

        rd = 5;
        write_data = 25;
        reg_write = 1;

        @(negedge clk);
        reg_write = 0;

        rs1 = 5;
        #1;

        if (read_data1 !== 25)
            $error("FAIL: Register x5");
        else
            $display("PASS: Register x5");

        rd = 0;
        write_data = 100;
        reg_write = 1;

        @(negedge clk);
        reg_write = 0;
        rs2 = 0;
        #1;

        if (read_data2 !== 0)
            $error("FAIL: Register x0");
        else
            $display("PASS: Register x0");

        $finish;
    end

endmodule

