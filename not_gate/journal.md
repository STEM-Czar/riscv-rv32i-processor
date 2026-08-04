# Journal / README

## Task
NOT Gate implementation in Verilog


## Description
For a NOT gate, the output is the inverse of the input value. When the input is HIGH (`1`), the output becomes LOW (`0`), and when the input is LOW (`0`), the output becomes HIGH (`1`). A testbench was written to apply both possible input combinations (2) and verify the design through simulation on Surfer.


## Expected Results

| A | O |
|---|---|
| 0 | 1 |
| 1 | 0 |

The output should always be the opposite of the input value. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the NOT gate is implemented in Verilog using the bitwise NOT operator (`~`), which inverts each bit of the input signal.

- I reinforced my understanding that a NOT gate is a fundamental building block used to create other logic gates such as NAND and NOR by combining inversion with AND or OR operations.

- I gained more practice implementing single-input combinational logic and verifying the output behavior through simulation.