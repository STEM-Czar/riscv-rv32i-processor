# Journal / README

## Task
2:1 Multiplexer (MUX) implementation using Behavioral Modeling with case Statement in Verilog


## Description
A multiplexer (MUX) is a combinational logic circuit that selects one input from multiple input signals and forwards the selected input to a single output.

This implementation focuses on a 2:1 multiplexer, which has two data inputs (`inA` and `inB`), one select line (`S`), and one output (`OUT`). Since there are two possible inputs to select from, only one select line is required.

The design was implemented using behavioral modeling with a `case` statement inside an `always` block. Instead of describing the circuit using individual gates or a direct logic expression, the behavior of the multiplexer is described by defining the output value for each possible state of the select line.

When `S = 0`, `OUT` is assigned `inA`.  
When `S = 1`, `OUT` is assigned `inB`.

A testbench was written to apply different input combinations and verify the design through simulation on Surfer.


## Expected Results

| inA | inB | S | OUT |
|-----|-----|---|-----|
|  1  |  0  | 0 |  1  |
|  0  |  1  | 0 |  0  |
|  1  |  0  | 1 |  0  |
|  0  |  1  | 1 |  1  |

The output should follow `inA` when `S` is `0` and follow `inB` when `S` is `1`. The simulation results were expected to match this behavior.


## Lessons Learned (& Mistakes Made)

- The `case` statement provides a clear way to describe multiple possible conditions and is suitable for implementing selection-based combinational circuits such as multiplexers.

- A `case` statement must be closed using `endcase`. The `case`, `begin`, and `end` keywords do not require semicolons after them.

- Adding a `default` condition is good practice because it defines a response for any unexpected or unhandled condition.

- Behavioral modeling provides multiple ways to describe the same hardware functionality. A 2:1 MUX can be represented using `if-else`, `case`, or a conditional operator while producing the same output behavior.

- For combinational logic, the output assignment must cover all possible input conditions to avoid unintended hardware behavior.