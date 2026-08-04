# Journal / README

## Task
2-Input XNOR Gate implementation in Verilog


## Description
For a 2-input XNOR gate, the output is HIGH (`1`) when both inputs are the same. It is the opposite of an XOR gate, meaning the output is the inverted result of the XOR operation. A testbench was written to apply all possible input combinations (4) and verify the design through simulation on Surfer.


## Expected Results

| A | B | O |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

The output should be `1` when both inputs have the same value and `0` when the inputs are different. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that the XNOR gate is implemented by inverting the XOR operation using the NOT operator (`~`). The output of the XOR gate is complemented to produce the XNOR behavior.

- I reinforced my understanding that XOR and XNOR gates are complementary logic operations, where XOR detects differences between inputs and XNOR detects matching inputs.

- I gained more practice implementing combinational logic by combining basic operators and verifying the expected output using truth tables and simulation waveforms.