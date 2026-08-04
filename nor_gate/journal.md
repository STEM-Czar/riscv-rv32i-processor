# Journal / README

## Task
2-Input NOR Gate implementation in Verilog


## Description
For a 2-input NOR gate, the output is HIGH (`1`) only when both inputs are LOW (`0`). It is the opposite of an OR gate, meaning the output is the inverted result of the OR operation. A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

The output should only be `1` when both inputs are `0`. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the NOR gate is implemented by combining the OR operation (`|`) with the NOT operation (`~`). The output of the OR gate is inverted to produce the NOR behavior.

- I reinforced my understanding that NAND and NOR gates are inverted versions of AND and OR gates, respectively.

- I gained more practice implementing combinational logic using Verilog operators and verifying the output behavior against the expected truth table.