# Journal / README

## Task

2:1 Multiplexer (MUX) implementation using Gate-Level Modeling in Verilog

## Description

A multiplexer (MUX) is a combinational logic circuit that selects one of several input signals and forwards it to a single output. It can be thought of as a digitally controlled switch where the selection lines determine which input reaches the output.

This implementation focuses on the simplest multiplexer, the **2:1 MUX**, which has two data inputs (`A` and `B`), one select line (`S`), and one output (`Y`). Since there are two possible inputs to choose from, only one select line is required because (2^1 = 2).

The multiplexer was implemented using **gate-level modeling**, where the circuit was constructed by instantiating Verilog's built-in `not`, `and`, and `or` gate primitives. This approach closely resembles the actual logic diagram of the hardware, making it easier to understand how the selection process is physically realized.

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

* I learned that a multiplexer functions as a digital selector, forwarding one of several inputs to a single output based on the value of the select line.

* I understood why a 2:1 multiplexer requires only one select line and how the relationship between the number of inputs and select lines follows the expression **Select Lines = log₂(Number of Inputs)**.

* I learned that gate-level modeling builds hardware by instantiating logic gate primitives (`not`, `and`, and `or`) rather than describing the logic with operators or behavioral statements.

* I reinforced my understanding of how individual logic gates can be connected together using intermediate wires to create more complex combinational circuits.

* The simulation results matched the expected behavior of a 2:1 multiplexer, confirming that the gate-level implementation was correct.
