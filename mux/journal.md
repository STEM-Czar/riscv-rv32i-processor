# Journal / README

## Task

Generic Parameterized Multiplexer (MUX) implementation in Verilog

## Description

This implementation extends the previous multiplexer designs into a reusable hardware module that can be instantiated throughout the project. Instead of creating separate 2:1, 4:1, 8:1, or 16:1 multiplexers, a single parameterized module was developed that supports different numbers of inputs and data widths.

The module is parameterized by the number of inputs (`n_inputs`) and the width of each input (`bit_width`). The required number of select lines is automatically calculated using the `$clog2()` system function, eliminating the need to manually determine the select bus width.

All input signals are packed into a single input bus, and an indexed part-select is used to extract the selected input based on the value of the select line. This makes the implementation compact, scalable, and suitable for reuse throughout the RV32I processor project.

The module was verified using a **4-input, 32-bit** configuration. Each input was assigned a unique value, and the select line was cycled through all possible values to confirm that the correct input was forwarded to the output.

## Expected Results

| S | in_3       | in_2       | in_1       | in_0       | mux_out    |
| - | ---------- | ---------- | ---------- | ---------- | ---------- |
| 0 | 0x00000004 | 0x00000003 | 0x00000002 | 0x00000001 | 0x00000001 |
| 1 | 0x00000004 | 0x00000003 | 0x00000002 | 0x00000001 | 0x00000002 |
| 2 | 0x00000004 | 0x00000003 | 0x00000002 | 0x00000001 | 0x00000003 |
| 3 | 0x00000004 | 0x00000003 | 0x00000002 | 0x00000001 | 0x00000004 |

The output was expected to correspond to the selected input for every value of the select line. The simulation confirmed that the correct 32-bit input was forwarded to the output in each case.

## Lessons Learned (& Mistakes Made)

* Parameterization makes a hardware module reusable by allowing the number of inputs and data width to be configured without changing the implementation.

* A fixed-width multiplexer is simply a parameterized multiplexer with constant values assigned to its parameters. The hardware description remains unchanged.

* The `$clog2()` system function automatically determines the number of select bits required from the number of inputs, reducing manual calculations and improving scalability.

* Indexed part-select (`base +: width`) provides an efficient way to select a variable slice of a packed bus, making it well suited for generic multiplexers.

* Parameterizing a design also requires parameterizing the testbench. Signal declarations, stimulus generation, and result formatting should all adapt to the selected parameter values.

* Assigning an `integer` expression directly to a smaller vector produced a width truncation warning. Using an intermediate register with the correct width resolved the issue.

* Verilog does not allow part-selecting an arithmetic expression directly. Assigning the expression to an intermediate variable before using it eliminated the syntax error.

* Dynamic display formatting made the simulation output easier to read and allowed the same testbench to present results consistently for different parameter configurations.
