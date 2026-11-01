`timescale 1ns / 1ps


module control_unit_tb;

    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire reg_write;
    wire alu_src;
    wire [2:0] alu_op;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op)
    );

    initial begin
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (reg_write !== 1 || alu_src !== 0 ||
            alu_op !== 3'b000)
            $error("FAIL: ADD control");
        else
            $display("PASS: ADD control");

        funct7 = 7'b0100000;
        #10;
        if (reg_write !== 1 || alu_src !== 0 ||
            alu_op !== 3'b001)
            $error("FAIL: SUB control");
        else
            $display("PASS: SUB control");

        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        if (reg_write !== 1 || alu_src !== 1 ||
            alu_op !== 3'b000)
            $error("FAIL: ADDI control");
        else
            $display("PASS: ADDI control");

        opcode = 7'b1111111;
        #10;
        if (reg_write !== 0)
            $error("FAIL: Invalid opcode");
        else
            $display("PASS: Invalid opcode");

        $finish;
    end

endmodule

