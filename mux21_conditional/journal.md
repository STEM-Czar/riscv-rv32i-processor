# Journal / README

## Task

2:1 Multiplexer (MUX) implementation using Dataflow Modeling with Conditional Operator in Verilog

## Description

A multiplexer (MUX) is a combinational logic circuit that selects one input from multiple input signals and forwards the selected signal to a single output. This implementation focuses on a **2:1 multiplexer**, which has two data inputs (`A` and `B`), one select line (`S`), and one output (`Y`).

This design uses **dataflow modeling** by describing the relationship between inputs and output using a continuous assignment (`assign`). Instead of building the circuit using individual gates, the conditional (ternary) operator (`?:`) is used to directly express the selection behavior of the multiplexer.

The conditional expression follows the logic that when the select line (`S`) is `0`, input `A` is selected, and when `S` is `1`, input `B` is selected.

A testbench was written to apply different input combinations and verify the functionality through simulation on Surfer.

## Expected Results

| A | B | S | Y |
| - | - | - | - |
| 1 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 1 |

When the select line (`S`) is `0`, the output should follow input `A`. When the select line is `1`, the output should follow input `B`. The simulation was expected to correspond with this behavior.

## Lessons Learned (& Mistakes Made)

- Moving from gate-level modeling to dataflow modeling showed me that the same hardware can be described at different abstraction levels. Instead of manually connecting gates, the behavior can be expressed using a logical relationship between inputs and output.

- The conditional (`?:`) operator is a natural fit for multiplexers because a MUX is essentially a selection operation: choose one input based on the value of the select line.

- Using `assign` with the conditional operator made the code shorter while still representing the same hardware behavior as the gate-level implementation.

- Comparing both implementations helped me understand the tradeoff between showing the physical structure of the circuit (gate-level) and describing the intended function of the circuit (dataflow).
