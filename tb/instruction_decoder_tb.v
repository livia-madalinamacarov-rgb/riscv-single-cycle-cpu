`timescale 1ns / 1ps

module instruction_decoder_tb;

    reg [31:0] instruction;

    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [31:0] imm_i;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_i(imm_i)
    );

    initial begin
        instruction = 32'h10C00393;
        #10;

        if (opcode !== 7'b0010011 ||
            rd !== 5'd7 ||
            rs1 !== 5'd0 ||
            funct3 !== 3'b000 ||
            imm_i !== 32'd268)
            $error("FAIL: ADDI decoding");
        else
            $display("PASS: ADDI decoding");

        instruction = 32'h007302B3;
        #10;

        if (opcode !== 7'b0110011 ||
            rd !== 5'd5 ||
            rs1 !== 5'd6 ||
            rs2 !== 5'd7 ||
            funct3 !== 3'b000 ||
            funct7 !== 7'b0000000)
            $error("FAIL: ADD decoding");
        else
            $display("PASS: ADD decoding");

        $finish;
    end

endmodule

