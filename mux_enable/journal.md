# Journal / README

## Task

Generic Parameterized Multiplexer (MUX) with Enable implementation in Verilog

## Description

This implementation extends the generic parameterized multiplexer by introducing an **enable (`EN`)** signal. The module remains configurable in both the number of inputs (`n_inputs`) and the data width (`bit_width`), making it suitable for reuse throughout the RV32I processor project.

When the enable signal is asserted (`EN = 1`), the multiplexer operates normally by forwarding the selected input to the output based on the value of the select signal (`S`). When the enable signal is deasserted (`EN = 0`), the output is forced to zero regardless of the selected input.

Like the previous implementation, all inputs are packed into a single input bus, and an indexed part-select is used to extract the selected input. The enable logic simply controls whether the selected value is allowed to appear at the output.

The module was verified using **8 inputs**, a **32-bit data width**, and every possible value of the select signal with both the enabled and disabled operating modes.

## Expected Results

### Disabled State (`EN = 0`)

| EN | S | Expected mux_out |
|----|---|------------------|
| 0 | 0 | 0x00000000 |
| 0 | 1 | 0x00000000 |
| 0 | 2 | 0x00000000 |
| 0 | 3 | 0x00000000 |
| 0 | 4 | 0x00000000 |
| 0 | 5 | 0x00000000 |
| 0 | 6 | 0x00000000 |
| 0 | 7 | 0x00000000 |

The output should remain zero regardless of the selected input.

### Enabled State (`EN = 1`)

| EN | S | Selected Input | Expected mux_out |
|----|---|----------------|------------------|
| 1 | 0 | in_0 = 0x00000001 | 0x00000001 |
| 1 | 1 | in_1 = 0x00000002 | 0x00000002 |
| 1 | 2 | in_2 = 0x00000003 | 0x00000003 |
| 1 | 3 | in_3 = 0x00000004 | 0x00000004 |
| 1 | 4 | in_4 = 0x00000005 | 0x00000005 |
| 1 | 5 | in_5 = 0x00000006 | 0x00000006 |
| 1 | 6 | in_6 = 0x00000007 | 0x00000007 |
| 1 | 7 | in_7 = 0x00000008 | 0x00000008 |

The simulation was expected to confirm that the enable signal correctly controlled whether the selected input was forwarded to the output.

## Lessons Learned (& Mistakes Made)

* An enable signal adds another level of control to a module without changing its core functionality. The multiplexer still performs the same selection operation, but only when enabled.

* The enable condition has higher priority than the select logic. If the module is disabled, the output is forced to zero before any input selection takes place.

* The same generic multiplexer can scale to different numbers of inputs and data widths by changing only the parameter values, making the module suitable for reuse throughout larger hardware designs.

* A comprehensive testbench should verify every valid select value in both enabled and disabled modes to ensure that all operating conditions behave as expected.

* Using sequential input values (`1` through `8`) made it straightforward to verify that each select value corresponded to the correct input during simulation, making debugging and validation much easier.
