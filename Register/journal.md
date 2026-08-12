# Journal / README

## Task

Parameterized Register Implementation in Verilog

## Description

A register was implemented as a group of D flip flops that stores a multi-bit value. The `bit_width` parameter determines the number of bits in the register, allowing the same module to be used for different data widths.

The register uses a clock, active-low reset, write enable, data input, and data output.

On the rising edge of the clock, the register captures `d_in` when `we` is HIGH. When `we` is LOW, the stored value remains unchanged. The active-low reset clears the register to zero.

This provides the basic storage element needed for larger structures such as a register file in the RISC-V processor.

## Expected Results

| Condition | Expected `q_out` |
| - | - |
| `rst_n = 0` | All `0`s |
| `rst_n = 1`, `we = 0` | Previous stored value |
| `rst_n = 1`, `we = 1` | Captures `d_in` on rising clock edge |

The simulation should confirm that data is only captured when write enable is active, that the stored value is retained when write enable is disabled, and that reset clears the register.

## Test Results

A 32-bit register was used for testing.

The testbench verified:

- Resetting the register to zero.
- Keeping the register unchanged while `we = 0`.
- Loading all `1`s while `we = 1`.
- Loading an alternating `1010...` pattern.
- Changing `d_in` while `we = 0` to confirm that the stored value does not change.
- Resetting the register again after storing data.

A VCD waveform was generated and inspected using Surfer.

## Lessons Learned (& Mistakes Made)

- A register is a group of D flip flops working together, with each flip flop storing one bit of the larger value.

- The write enable controls whether new data is loaded or the previous value is retained.

- Parameterizing the register with `bit_width` makes the same design reusable for different data widths instead of creating separate modules for each width.

- Replication such as `{bit_width{1'b0}}` keeps reset values independent of a fixed register size.

- The internal `q_reg` holds the stored state while `q_out` provides access to that state.

- The register provides the basic storage element that can be replicated and combined to form a register file for the processor.

## Result

The parameterized register was successfully implemented and verified through simulation. The tests confirmed correct reset, write, data capture, and data retention behavior.