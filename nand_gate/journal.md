# Journal / README

## Task
2-Input NAND Gate implementation in Verilog


## Description
For a 2-input NAND gate, the output is LOW (`0`) only when both inputs are HIGH (`1`). It is the opposite of an AND gate, meaning the output is the inverted result of the AND operation. A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

The output should only be `0` when both inputs are `1`. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the NAND gate is implemented by combining the AND operation (`&`) with the NOT operation (`~`). The output of the AND gate is inverted to produce the NAND behavior.

- I reinforced my understanding that basic logic gates can be combined to create more complex digital circuits.

- I gained more confidence in translating logic expressions into Verilog and verifying the expected behavior through simulation.