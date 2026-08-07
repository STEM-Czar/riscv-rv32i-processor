# Journal / README

## Task

Parameterized 1-hot Encoder implementation in Verilog

## Description

An encoder converts one active input among several inputs into a binary code representing the position of that input.

This implementation uses a one-hot input, meaning only one input bit is HIGH at a time. The position of that HIGH bit is converted into its corresponding binary value at the output.

The number of output bits is determined using `$clog2(n_inputs)`. For 8 inputs, 3 output bits are required because `2^3 = 8`.

The encoder uses an `always @(*)` block with a `for` loop to check the input vector. The output is initialized to zero before the loop, then updated with the index of the active input.

The testbench dynamically generated all 8 one-hot input patterns using bit shifting and verified each input position.

## Expected Results

| Active Input | `enc_In`   | `enc_Out` |
| ------------ | ---------- | --------- |
| 0            | `00000001` | `000`     |
| 1            | `00000010` | `001`     |
| 2            | `00000100` | `010`     |
| 3            | `00001000` | `011`     |
| 4            | `00010000` | `100`     |
| 5            | `00100000` | `101`     |
| 6            | `01000000` | `110`     |
| 7            | `10000000` | `111`     |

The output should represent the binary index of the active input. The simulation confirmed the expected encoding for all 8 input positions.

## Lessons Learned (& Mistakes Made)

* An extra closing parenthesis in the `if` condition caused a syntax error.

* The integer loop index is wider than the encoder output. Limiting the assigned value to `n_outputs` bits prevents width mismatch warnings.

* Initializing `enc_out` to zero at the beginning of the `always @(*)` block provides a default value for the combinational logic and prevents unintended latches.

* An `else` assignment inside the loop would be incorrect because a later inactive input could overwrite a valid match. The default assignment belongs before the loop.

* Verilog vector indexing starts at bit `0` at the LSB and increases toward the MSB. For example, `4'b0100` has bit `2` active and produces binary `2`.

* `$clog2(n_inputs)` provides a convenient way to determine the required output width. With 8 inputs, `$clog2(8)` gives 3 output bits.

* Bit shifting provides a simple way to generate one-hot test patterns dynamically instead of hardcoding every case.

* `$display` automatically adds a newline, while `$write` does not.

* Parameterized designs require consistent parameter names, signal names, port connections, and capitalization between the module and testbench.

* When multiple inputs are HIGH, the current implementation gives MSB priority because the loop continues through all inputs and later matches overwrite earlier matches. LSB priority can be achieved by stopping at the first active input with a `break;` inside the `if` statement.

* A one-hot encoder normally expects only one active input. Allowing multiple active inputs introduces priority encoder behavior.
