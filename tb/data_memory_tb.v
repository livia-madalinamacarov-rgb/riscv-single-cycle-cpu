`timescale 1ns / 1ps


module data_memory_tb;

    reg clk = 0;
    reg mem_write = 0;
    reg [31:0] address = 0;
    reg [31:0] write_data = 0;
    wire [31:0] read_data;

    data_memory dut (
        .clk(clk),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        address = 100;
        write_data = 25;
        mem_write = 1;

        @(negedge clk);
        mem_write = 0;
        #1;

        if (read_data !== 32'd25)
            $error("FAIL: Memory write/read");
        else
            $display("PASS: Memory write/read");

        write_data = 42;
        mem_write = 1;

        @(negedge clk);
        mem_write = 0;
        #1;

        if (read_data !== 32'd42)
            $error("FAIL: Memory overwrite");
        else
            $display("PASS: Memory overwrite");

        $finish;
    end

endmodule

