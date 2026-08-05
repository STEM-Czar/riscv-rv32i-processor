# Journal / README

## Task

2:1 Multiplexer (MUX) with Enable implementation in Verilog

## Description

An enable signal provides control over whether a digital circuit is active. In this implementation, an enable (`EN`) input was added to the parameterized 2:1 multiplexer.

When the enable signal is asserted (`EN = 1`), the multiplexer operates normally by selecting either `inA` or `inB` based on the value of the select line (`S`). When the enable signal is deasserted (`EN = 0`), the output is forced to `0000`, effectively disabling the multiplexer regardless of the values of the inputs or select line.

Adding an enable input is a common design technique because it allows a circuit to be controlled externally without modifying its internal selection logic.

A testbench was written to verify both the enabled and disabled operating conditions through simulation on Surfer.

## Expected Results

|  EN | inA  | inB  |  S  | OUT  |
| :-: | ---- | ---- | :-: | ---- |
|  0  | 0001 | 0010 |  0  | 0000 |
|  1  | 0011 | 0100 |  0  | 0011 |
|  0  | 0101 | 0110 |  1  | 0000 |
|  1  | 0111 | 1000 |  1  | 1000 |

When `EN = 0`, the output should remain `0000` regardless of the input values or the select line.

When `EN = 1`, the multiplexer should operate normally by forwarding `inA` when `S = 0` and `inB` when `S = 1`.

The simulation was expected to confirm both operating modes.

## Lessons Learned (& Mistakes Made)

* An enable signal controls whether a circuit is active or inactive without changing its underlying functionality.

* The enable condition takes priority over the selection logic. When the multiplexer is disabled, the output is forced to a known value before the select line is considered.

* Adding an enable input extends the functionality of a module while preserving its original behavior whenever the circuit is enabled.

* The testbench should verify both enabled and disabled conditions to ensure the additional control logic behaves as intended.
