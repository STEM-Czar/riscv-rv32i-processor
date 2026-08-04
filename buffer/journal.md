# Journal / README

## Task
Buffer Gate implementation in Verilog


## Description
For a buffer gate, the output follows the input directly without any inversion or modification. When the input is HIGH (`1`), the output is HIGH (`1`), and when the input is LOW (`0`), the output is LOW (`0`). A testbench was written to apply both possible input combinations (2) and verify the design through simulation on Surfer.


## Expected Results

| A | Y |
|---|---|
| 0 | 0 |
| 1 | 1 |

The output should always match the input value. The simulation was expected to correspond with this truth table.


## Lessons Learned (& Mistakes Made)

- I learned that a buffer gate is implemented in Verilog by directly connecting the input to the output, allowing the signal value to pass through unchanged.

- I reinforced my understanding that not all logic gates modify the input signal. A buffer is useful for signal isolation, driving higher loads, and maintaining signal integrity in digital circuits.

- I gained more confidence in implementing simple combinational logic circuits and verifying their behavior using truth tables and simulation waveforms.