# 32-bit RISC-V Single-Cycle CPU

A 32-bit single-cycle RISC-V processor implemented in Verilog and simulated using Vivado 2025.2.

The project focuses on the basic architecture of a CPU, including instruction decoding, arithmetic and logic operations, register access, memory operations and branch instructions.

## Features

- 32-bit single-cycle architecture
- 12 supported RISC-V instructions
- 32 general-purpose registers
- Register x0 always remains zero
- Separate instruction and data memories
- Modular Verilog implementation

## Supported Instructions

The processor supports the following instructions:

- Arithmetic: ADD, SUB, ADDI
- Logic: AND, OR, XOR
- Shifts: SLL, SRL
- Comparison: SLT
- Memory: LW, SW
- Branch: BEQ

Only a subset of the RV32I instruction set is implemented.

## Architecture

The processor is divided into separate Verilog modules:

- `cpu_top.v` - Connects all CPU components
- `program_counter.v` - Updates the program counter
- `instruction_memory.v` - Stores and provides instructions
- `instruction_decoder.v` - Extracts instruction fields and immediate values
- `control_unit.v` - Generates control signals
- `register_file.v` - Contains the 32 registers
- `alu.v` - Performs arithmetic and logic operations
- `data_memory.v` - Handles load and store operations

Each supported instruction is executed in a single clock cycle.

## Project Structure

- `rtl/` - CPU Verilog modules
- `tb/` - Verilog testbenches
- `programs/` - Test programs in `.mem` format

## Verification

The design was tested using individual module testbenches and an integrated CPU testbench.

Eight instruction programs were used to verify:

- Arithmetic and logic operations
- Shift operations and signed comparisons
- Load and store instructions
- Taken and not-taken branches
- Register x0 behavior
- Negative numbers
- Backward branches

The integrated testbench uses a `check` task to compare actual results with expected values and report passed or failed checks.

### Simulation Results

```text
RISC-V CPU TEST SUMMARY
Passed: 26
Failed: 0
ALL TESTS PASSED
```

All 26 checks passed in Vivado behavioral simulation.

## How to Run

1. Create a new RTL project in Vivado.
2. Add the Verilog files from `rtl/` as design sources.
3. Add `cpu_top_tb.v` and the `.mem` files from `programs/` as simulation sources.
4. Set `cpu_top_tb` as the simulation top module.
5. Run Behavioral Simulation.

The `.mem` files must be available in the simulation working directory because the testbench loads them using `$readmemh`.

## Tools Used

- Verilog HDL
- Vivado 2025.2
- XSim

## Limitations

The processor implements only a subset of RV32I. It uses simplified memory models and does not support pipelining, caches, exception handling or misaligned memory accesses.

The project was developed to practice CPU architecture, RTL design and functional verification.
