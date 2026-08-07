# Journal / README

## Task

Parameterized Binary to 1-hot Decoder implementation in Verilog

## Description

A decoder performs the reverse operation of the 1-hot encoder. Instead of taking one active input from several lines and representing its position with a smaller binary value, a decoder takes a binary value and activates the corresponding output line.

For `n` input bits, there are `2^n` possible binary combinations, so a decoder can produce `2^n` output lines.

This implementation uses a 3-bit input and an 8-bit output. Each possible input value activates exactly one corresponding output bit.

The one-hot output is generated using a left shift:

`assign dec_out = 1'b1 << dec_in;`

Starting with a single HIGH bit and shifting it by the value of `dec_in` places the HIGH bit at the corresponding output position.

The design is parameterized so that the number of output lines automatically grows with the input width.

## Expected Results

| `dec_In` | `dec_Out`  |
| -------- | ---------- |
| `000`    | `00000001` |
| `001`    | `00000010` |
| `010`    | `00000100` |
| `011`    | `00001000` |
| `100`    | `00010000` |
| `101`    | `00100000` |
| `110`    | `01000000` |
| `111`    | `10000000` |

The simulation confirmed that each binary input activates the corresponding one-hot output position.

## Lessons Learned (& Mistakes Made)

* A decoder can be viewed as the reverse operation of a one-hot encoder: binary position in, one active output line out.

* The relationship between input and output width follows `2^n`. Three input bits provide eight possible combinations, requiring eight output lines for a complete 1-hot decoder.

* A left shift provides a simple way to implement the decoder. Starting with `1'b1` and shifting by the binary input moves the active bit to the required output position.

* Parameterization makes the decoder scalable. Increasing the input width automatically increases the number of possible output lines.

* The direction of bit movement matters. The left shift moves the single HIGH bit toward higher output positions as the binary input increases.

* The encoder and decoder demonstrate complementary operations: the encoder compresses the position of an active line into a binary representation, while the decoder expands a binary representation back into a single active line.
