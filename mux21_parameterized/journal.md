# Journal / README

## Task

Parameterized 2:1 Multiplexer (4-bit Width) implementation in Verilog

## Description

Parameterization allows a Verilog module to be reused with different configurations without modifying its internal logic. In this implementation, the 2:1 multiplexer was parameterized by making the data width configurable, with a 4-bit width used as the case study.

Unlike previous implementations, only the width of the input and output ports changes. The selection logic remains exactly the same, meaning the multiplexer still forwards one input to the output based on the value of the select line. This demonstrates that parameterization improves the flexibility and reusability of a design while keeping the hardware behavior unchanged.

A testbench was written to verify the 4-bit implementation through simulation on Surfer.

## Expected Results

| inA  | inB  | S | OUT  |
| ---- | ---- | - | ---- |
| 0001 | 0010 | 0 | 0001 |
| 0011 | 0100 | 0 | 0011 |
| 0101 | 0110 | 1 | 0110 |
| 0111 | 1000 | 1 | 1000 |

When `S = 0`, the output should match all four bits of `inA`. When `S = 1`, the output should match all four bits of `inB`. The simulation was expected to confirm that the selected 4-bit input is transferred to the output without modification.

## Lessons Learned (& Mistakes Made)

- Parameterization changes the configurability of a module rather than its functionality. In this implementation, only the width of the ports changed while the multiplexer logic remained the same.

- A fixed-width bus is simply a parameterized design with the width fixed to a specific value. Replacing the parameter with a constant changes only the port declarations, not the hardware description or functionality.

- The choice of modeling style is independent of parameterization. Whether using gate-level, dataflow, or behavioral modeling, parameterization only affects how the signals are declared, not how the hardware is described.

- Parameterized modules are more reusable because the same design can support different data widths without duplicating the implementation.

- The testbench must be updated to match the selected bus width so that the inputs, outputs, and expected results correspond to the parameterized design.
