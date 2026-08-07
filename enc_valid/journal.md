# Journal / README

## Task

Parameterized Encoder with Valid Detection implementation in Verilog

## Description

A basic encoder converts a one-hot input into the binary index of the active input. This implementation extends the encoder by adding a validity output to indicate whether any input is active.

The valid signal is generated using a reduction OR operation:

`assign enc_valid = |enc_in;`

If any input bit is HIGH, `enc_valid` becomes `1`. If all inputs are LOW, `enc_valid` becomes `0`.

The design was also tested with multiple active inputs to observe priority behavior. Since the encoder loop continues through all input positions and updates the output whenever an active bit is detected, the highest active input takes priority. This effectively demonstrates MSB priority encoder behavior.

The testbench verified normal one-hot inputs, an empty input condition, and multiple active input conditions.

## Expected Results

| `enc_In`   | `enc_Out` | `enc_Valid` |
| ---------- | --------- | ----------- |
| `00000001` | `000`     | `1`         |
| `00000010` | `001`     | `1`         |
| `00000100` | `010`     | `1`         |
| `00001000` | `011`     | `1`         |
| `00010000` | `100`     | `1`         |
| `00100000` | `101`     | `1`         |
| `01000000` | `110`     | `1`         |
| `10000000` | `111`     | `1`         |
| `00000000` | `000`     | `0`         |
| `00001001` | `011`     | `1`         |
| `10010010` | `111`     | `1`         |

The simulation confirmed correct encoding, validity detection, and priority behavior.

## Lessons Learned (& Mistakes Made)

* A reduction OR operator (`|signal`) provides a simple way to check whether any bit in a vector is active.

* A validity output is useful in practical hardware designs because it separates the encoded value from whether the input contains meaningful data.

* Testing multiple active inputs revealed that the current loop structure creates MSB priority behavior. Later active bits overwrite earlier assignments, causing the highest active bit to determine the output.

* Priority behavior can be changed by modifying the search direction or stopping the search after the first detected active input. For example, LSB priority can be achieved by checking from the highest index downward or exiting after the first match.

* A basic encoder assumes one active input, while a priority encoder handles cases where multiple inputs are active by defining which input takes precedence.

* Extending existing modules with additional outputs is a useful approach for exploring hardware functionality without creating unnecessary separate designs.
