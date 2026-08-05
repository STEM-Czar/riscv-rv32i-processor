# Journal / README

## Task
2:1 Multiplexer (MUX) implementation using Behavioral Modeling with if-else in Verilog

## Description
A multiplexer (MUX) is a combinational logic circuit that selects one input from multiple input signals and forwards the selected signal to a single output. This implementation focuses on a 2:1 multiplexer, which has two data inputs, one select line, and one output.

This design uses behavioral modeling, where the expected behavior of the circuit is described using procedural statements inside an `always` block. Instead of describing the physical gates or directly writing the logic equation, the design describes the selection decision using an `if-else` statement.

The select line determines which input is assigned to the output. When the select line is `0`, the output receives `inA`. When the select line is `1`, the output receives `inB`.

A testbench was written to apply different input combinations and verify the functionality through simulation on Surfer.

## Expected Results

| inA | inB | S | OUT |
|-----|-----|---|-----|
|  1  |  0  | 0 |  1  |
|  0  |  1  | 0 |  0  |
|  1  |  0  | 1 |  0  |
|  0  |  1  | 1 |  1  |

When `S = 0`, `OUT` should follow `inA`. When `S = 1`, `OUT` should follow `inB`. The simulation was expected to correspond with this behavior.

## Lessons Learned (& Mistakes Made)

- Behavioral modeling allows hardware functionality to be described from the perspective of what the circuit should do rather than how the circuit is physically constructed.

- I learned that an `always` block is used to describe procedural behavior in Verilog and is commonly used when implementing combinational and sequential logic.

- I learned that blocking assignment (`=`) is appropriate for this combinational logic implementation because the statements execute immediately in the order they are written.

- Comparing the gate-level, dataflow, and behavioral implementations showed that different modeling styles can represent the same hardware functionality while providing different levels of abstraction.