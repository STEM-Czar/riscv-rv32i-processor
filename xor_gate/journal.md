# Journal / README

## Task
2-Input XOR Gate implementation in Verilog


## Description
For a 2-input XOR gate, the output is HIGH (`1`) only when the two inputs are different. When both inputs are the same, the output is LOW (`0`). A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

The output should be `1` only when one input is `1` and the other input is `0`. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the XOR gate is implemented in Verilog using the bitwise XOR operator (`^`), which produces a HIGH output only when the input values are different.

- I reinforced my understanding that digital logic behavior can be represented directly using Verilog operators and verified by comparing simulation results with the expected truth table.

- I gained more practice creating simple combinational logic modules and verifying their behavior using a testbench and waveform simulation.