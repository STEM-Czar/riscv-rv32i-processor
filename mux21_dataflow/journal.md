# Journal / README

## Task

2:1 Multiplexer (MUX) implementation using Dataflow Modeling in Verilog

## Description

A multiplexer (MUX) is a combinational logic circuit that selects one of several input signals and forwards the selected input to a single output. This implementation focuses on a **2:1 multiplexer**, which has two data inputs (`A` and `B`), one select line (`S`), and one output (`Y`).

Unlike the previous implementation, this design uses **dataflow modeling**. Instead of constructing the circuit with individual gate primitives, the logic is described directly using a continuous assignment (`assign`) together with Verilog's bitwise operators (`~`, `&`, and `|`). This approach expresses the Boolean equation of the multiplexer rather than its gate-by-gate implementation, resulting in a more compact and readable design.

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

* I learned that **dataflow modeling** describes a circuit by expressing its Boolean logic instead of explicitly instantiating individual gates.

* I reinforced my understanding of the `assign` keyword and how it creates a continuous assignment, allowing the output to automatically update whenever the input signals change.

* I gained more confidence using Verilog's bitwise operators (`~`, `&`, and `|`) to translate a Boolean expression directly into hardware behavior.

* Comparing this implementation with the gate-level version helped me understand that different Verilog modeling styles can describe the same hardware while producing identical simulation results.
