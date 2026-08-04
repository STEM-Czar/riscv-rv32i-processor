# Journal / README

## Task
2-Input OR Gate implementation in Verilog


## Description
For a 2-input OR gate, the output is HIGH (`1`) when at least one of the inputs is HIGH (`1`). A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

The output should be `1` when either input or both inputs are `1`. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the OR gate is implemented in Verilog using the bitwise OR operator (`|`), which directly represents the hardware logic operation.

- I reinforced my understanding of how truth tables translate into Verilog logic expressions and how each possible input combination must be verified through simulation.

- I gained more confidence in writing Verilog modules and testbenches by applying the same simulation workflow used for the AND gate implementation.