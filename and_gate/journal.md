# Journal / README

## Task
2-Input AND Gate implementation in Verilog


## Description
For a 2-input AND gate, the output is HIGH (`1`) only when both inputs are HIGH (`1`). A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

The output should only be `1` when both inputs are `1`. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I initially omitted the `` `timescale `` compiler directive from the main Verilog module because I thought it was only needed in the testbench. I learned that every Verilog module should include it to ensure consistent simulation timing.

- I mistakenly used a single quote (`'`) instead of the required backtick (`` ` ``) for the compiler directive. I learned that the backtick is on the same key as `~`, above the **Tab** key on a US keyboard.

- It is easier to forget to add a semicolon (`;`) after system tasks such as `$finish` because of how it is positioned in the testbench module.

- I learned that the bitwise operators `&`, `|`, `~`, and `^` are the fundamental operators used to implement basic digital logic building blocks.

- I understood that the `assign` keyword is used for continuous assignments, meaning the output updates automatically whenever the input changes.