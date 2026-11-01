`timescale 1ns / 1ps


module cpu_top (
    input wire clk,
    input wire reset,

    output wire [31:0] pc,
    output wire [31:0] instruction
);

    
    wire [31:0] next_pc;
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_b, alu_result;
    wire [31:0] imm_i, imm_s;
    wire [31:0] immediate;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;

    wire [6:0] opcode, funct7;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [2:0] alu_op;

    wire reg_write;
    wire alu_src;
    wire zero;
    wire mem_write;
    wire mem_to_reg;
    
    wire [31:0] imm_b;
    wire branch;

    assign next_pc = (branch && zero)
               ? pc + imm_b
               : pc + 32'd4;

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .pc_write(1'b1),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );

  
    instruction_decoder decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_i(imm_i),
        .imm_s(imm_s),
        .imm_b(imm_b)
    );


    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch)
        
    );

    register_file rf (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    assign immediate = (opcode == 7'b0100011)
                       ? imm_s : imm_i;

    assign alu_b = alu_src ? immediate : read_data2;

    alu alu_unit (
        .a(read_data1),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(zero)
    );

    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write && !reset),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(mem_read_data)
    );

    assign write_back_data = mem_to_reg
                             ? mem_read_data
                             : alu_result;

endmodule
