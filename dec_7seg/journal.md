# Journal / README

## Task

4-bit to 7-segment Display Decoder implementation in Verilog

## Description

A decoder does not always have to produce a one-hot output. Its outputs can also be arranged to control a specific device or display.

This implementation takes a 4-bit binary input and converts it into the seven control signals required to display decimal digits on a 7-segment display.

The seven output bits represent the segments `g, f, e, d, c, b, a`, with `a` being the top segment and `g` the middle segment. Each input value from `0` to `9` is mapped to the corresponding segment pattern using a `case` statement.

For example, an input of `4'b0000` activates the segments required to display `0`, while `4'b0001` produces the pattern for `1`.

Since a 4-bit input can represent values from `0` to `15`, inputs `10` through `15` are also possible. These values are not assigned digit patterns in this implementation, so the `default` case turns all segments off.

## Expected Results

| Input  | Decimal | `dec_Out` |
| ------ | ------: | --------- |
| `0000` |       0 | `0111111` |
| `0001` |       1 | `0000110` |
| `0010` |       2 | `1011011` |
| `0011` |       3 | `1001111` |
| `0100` |       4 | `1100110` |
| `0101` |       5 | `1101101` |
| `0110` |       6 | `1111101` |
| `0111` |       7 | `0000111` |
| `1000` |       8 | `1111111` |
| `1001` |       9 | `1101111` |
| `1010` |      10 | `0000000` |

The simulation confirmed the expected 7-segment patterns for digits `0` through `9`. The input `10` also confirmed the default behavior, with all segments turned off.

## Lessons Learned (& Mistakes Made)

* A decoder can be designed for a specific output device rather than simply producing a one-hot output. In this case, the outputs directly represent the segments needed to display a digit.

* The meaning of each output bit depends on the chosen segment mapping. Here, the output is arranged as `[g, f, e, d, c, b, a]`, so the bit patterns must be written according to that order.

* A `case` statement provides a clear way to map discrete input values to specific hardware output patterns.

* A `default` case is useful when the input has possible values that do not have a defined output pattern. Here, inputs `10` through `15` turn all segments off.

* The 4-bit input provides 16 possible combinations, while the decoder only assigns patterns to the 10 decimal digits. This leaves six combinations available for other symbols or for the default condition.

* The 7-segment decoder shows how combinational logic can translate binary information into a form that can directly control a physical interface.
