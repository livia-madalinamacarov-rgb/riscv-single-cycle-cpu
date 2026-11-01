`timescale 1ns / 1ps

module instruction_memory_tb;

    reg [31:0] address;
    wire [31:0] instruction;

    instruction_memory dut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        address = 0;
        #10;
        if (instruction !== 32'h00A00093)
            $error("FAIL: Instruction 1");
        else
            $display("PASS: Instruction 1");

        address = 4;
        #10;
        if (instruction !== 32'h00500113)
            $error("FAIL: Instruction 2");
        else
            $display("PASS: Instruction 2");

        address = 8;
        #10;
        if (instruction !== 32'h002081B3)
            $error("FAIL: Instruction 3");
        else
            $display("PASS: Instruction 3");

        address = 12;
        #10;
        if (instruction !== 32'h40208233)
            $error("FAIL: Instruction 4");
        else
            $display("PASS: Instruction 4");

        $finish;
    end

endmodule

