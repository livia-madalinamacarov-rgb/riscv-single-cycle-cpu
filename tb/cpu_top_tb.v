`timescale 1ns / 1ps

module cpu_top_tb;

    reg clk = 0;
    reg reset = 1;

    wire [31:0] pc;
    wire [31:0] instruction;

    integer passed = 0;
    integer failed = 0;
    
    cpu_top dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk;
    
    
task check;
    input [8*40-1:0] test_name;
    input [31:0] actual;
    input [31:0] expected;

    begin
        if (actual === expected) begin
            $display("PASS: %0s", test_name);
            passed = passed + 1;
        end
        else begin
            $display("FAIL: %0s", test_name);
            $display("Expected: %h", expected);
            $display("Actual: %h", actual);
            failed = failed + 1;
        end
    end
endtask


    
initial begin
    reset = 1;

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("arithmetic.mem", dut.imem.memory);

    @(negedge clk);
    reset = 0;

    repeat (4) @(posedge clk);
    #1;
    
    
    check("ADD", dut.rf.registers[3], 32'd15);
    check("SUB", dut.rf.registers[4], 32'd5);

    @(negedge clk);
    reset = 1;

    @(posedge clk);
    #1;
    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("mem.mem", dut.imem.memory);

    reset = 0;

    repeat (8) @(posedge clk);
    #1;
    
    check("AND", dut.rf.registers[3], 32'd8);
    check("OR",  dut.rf.registers[4], 32'd14);
    check("XOR", dut.rf.registers[5], 32'd6);
    check("SLL", dut.rf.registers[6], 32'd12288);
    check("SRL", dut.rf.registers[7], 32'd0);
    check("SLT", dut.rf.registers[8], 32'd0);


   
    $display("=== TEST 3: LW / SW ===");

    @(negedge clk);
    reset = 1;

    @(posedge clk);
    #1;

    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("load_store.mem", dut.imem.memory);
    reset = 0;

    repeat (4) @(posedge clk);
    #1;

    check("ADDI x1", dut.rf.registers[1], 32'd100);
    check("ADDI x2", dut.rf.registers[2], 32'd25);
    check("SW", dut.dmem.memory[25], 32'd25);
    check("LW", dut.rf.registers[3], 32'd25);


     $display("=== TEST 4: BEQ TAKEN ===");

    @(negedge clk);
    reset = 1;
    @(posedge clk);
    #1;
    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("beq_taken.mem", dut.imem.memory);
    reset = 0;

    repeat (4) @(posedge clk);
    #1;
    
    
    check("BEQ taken", dut.rf.registers[3], 32'd42);
    check("BEQ taken PC", pc, 32'd20);

    
    $display("=== TEST 5: BEQ NOT TAKEN ===");

    @(negedge clk);
    reset = 1;
    @(posedge clk);
    #1;
    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("beq_not_taken.mem", dut.imem.memory);
    reset = 0;

    repeat (5) @(posedge clk);
    #1;
    
    
    check("BEQ not taken", dut.rf.registers[3], 32'd99);
    check("BEQ not taken x4", dut.rf.registers[4], 32'd42);
    check("BEQ not taken PC", pc, 32'd20);


        $display("=== TEST 6: REGISTER x0 ===");

    @(negedge clk);
    reset = 1;

    @(posedge clk);
    #1;

    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("x0_test.mem", dut.imem.memory);

    reset = 0;

    repeat (4) @(posedge clk);
    #1;

    check("x0 remains zero", dut.rf.registers[0], 32'd0);
    check("x0 read by ADDI", dut.rf.registers[2], 32'd0);
    check("x0 read by ADD", dut.rf.registers[3], 32'd5);


    
    $display("=== TEST 7: NEGATIVE NUMBERS ===");

    @(negedge clk);
    reset = 1;

    @(posedge clk);
    #1;

    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("negative__test.mem", dut.imem.memory);

    reset = 0;

    repeat (5) @(posedge clk);
    #1;

    check("ADDI negative", dut.rf.registers[1], 32'hFFFFFFFB);
    check("SUB negative", dut.rf.registers[3], 32'hFFFFFFF8);
    check("SLT negative true", dut.rf.registers[4], 32'd1);
    check("SLT negative false", dut.rf.registers[5], 32'd0);
    
        $display("=== TEST 8: BACKWARD BRANCH ===");

    @(negedge clk);
    reset = 1;

    @(posedge clk);
    #1;

    @(negedge clk);

    for (integer i = 0; i < 256; i = i + 1)
        dut.imem.memory[i] = 32'h00000013;

    $readmemh("backward_branch.mem", dut.imem.memory);

    reset = 0;
    repeat (8) @(posedge clk);
    #1;

    check("BEQ backward x3", dut.rf.registers[3], 32'd3);
    check("BEQ backward PC", pc, 32'd8);



    $display("==========================");
    $display("RISC-V CPU TEST SUMMARY");
    $display("==========================");
    $display("Passed: %0d", passed);
    $display("Failed: %0d", failed);

    if (failed == 0 && passed == 26)
        $display("ALL TESTS PASSED");
    else
        $display("VERIFICATION FAILED");

    $finish;
end
endmodule

