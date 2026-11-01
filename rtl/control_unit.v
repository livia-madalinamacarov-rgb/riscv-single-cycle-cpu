`timescale 1ns / 1ps


module control_unit (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg reg_write,
    output reg alu_src,
    output reg [2:0] alu_op,

    output reg mem_write,
    output reg mem_to_reg,
    
    output reg branch
);

    always @(*) begin
    
        reg_write = 0;
        alu_src = 0;
        branch = 0;
        alu_op = 3'b000;
        mem_write = 0;
        mem_to_reg = 0;

        case (opcode)

           
7'b0110011: begin
    if (funct7 == 7'b0000000) begin
        case (funct3)
            3'b000: begin
                alu_op = 3'b000; 
                reg_write = 1;
            end
            3'b111: begin
                alu_op = 3'b010;
                reg_write = 1;
            end
            3'b110: begin
                alu_op = 3'b011; 
                reg_write = 1;
            end
            3'b100: begin
                alu_op = 3'b100; 
                reg_write = 1;
            end
            3'b001: begin
                alu_op = 3'b101; 
                reg_write = 1;
            end
            3'b101: begin
                alu_op = 3'b110; 
                reg_write = 1;
            end
            3'b010: begin
                alu_op = 3'b111;
                reg_write = 1;
            end
        endcase
    end
    else if (funct7 == 7'b0100000 &&
             funct3 == 3'b000) begin
        alu_op = 3'b001; 
        reg_write = 1;
    end
end

            7'b0010011: begin
                if (funct3 == 3'b000) begin
                    alu_op = 3'b000;
                    alu_src = 1;
                    reg_write = 1;
                end
            end

        
            7'b0000011: begin
                if (funct3 == 3'b010) begin
                    alu_op = 3'b000;
                    alu_src = 1;
                    reg_write = 1;
                    mem_to_reg = 1;
                end
            end

            7'b0100011: begin
                if (funct3 == 3'b010) begin
                    alu_op = 3'b000;
                    alu_src = 1;
                    mem_write = 1;
                end
            end
            
           
            7'b1100011: begin
                if (funct3 == 3'b000) begin
                    alu_op = 3'b001; 
                    alu_src = 0;    
                    branch = 1;
                end
            end


            default: begin
               
            end
        endcase
    end

endmodule


