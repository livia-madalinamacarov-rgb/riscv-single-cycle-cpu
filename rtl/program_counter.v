`timescale 1ns / 1ps


module program_counter (
    input wire clk,
    input wire reset,
    input wire pc_write,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else if (pc_write)
            pc <= next_pc;
    end

endmodule

