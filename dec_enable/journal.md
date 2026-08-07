# Journal / README

## Task

Parameterized 1-hot Decoder with Enable implementation in Verilog

## Description

The next step was to extend the 1-hot decoder by adding an enable signal.

The basic decoder always produces a one-hot output corresponding to the binary input. Adding an enable introduces another level of control: the decoder only produces the selected one-hot output when enabled. When disabled, all output lines are forced LOW regardless of the input value.

The implementation uses an `always @(*)` block with an `if-else` statement. When `dec_en` is HIGH, the same left-shift operation used in the basic decoder generates the one-hot output. When `dec_en` is LOW, the output is assigned zero.

This provides a simple way to control when the decoder is active without changing the decoding logic itself.

## Expected Results

| `dec_In` | `dec_En` | `dec_Out`  |
| -------- | -------: | ---------- |
| `001`    |      `0` | `00000000` |
| `001`    |      `1` | `00000010` |
| `011`    |      `0` | `00000000` |
| `011`    |      `1` | `00001000` |
| `100`    |      `0` | `00000000` |
| `100`    |      `1` | `00010000` |
| `101`    |      `0` | `00000000` |
| `101`    |      `1` | `00100000` |
| `111`    |      `0` | `00000000` |
| `111`    |      `1` | `10000000` |

The simulation confirmed that the decoder produces the correct one-hot output when enabled and forces all outputs LOW when disabled.

## Lessons Learned (& Mistakes Made)

* An enable signal adds another layer of control to an existing combinational circuit without changing its core decoding operation.

* When the decoder is disabled, explicitly assigning the output to zero ensures that no output line remains active.

* The same decoding operation can be reused inside a different control structure. The left-shift operation remains responsible for selecting the output position, while the enable signal determines whether that operation is allowed to affect the output.

* Using an `always @(*)` block for the conditional output assignment keeps the implementation combinational.

* The parameterized relationship between input width and output width remains unchanged: `n_outputs = 2^n_inputs`.

* Testing the same input values with enable both LOW and HIGH makes the effect of the control signal easy to verify in both the simulation output and waveform.
