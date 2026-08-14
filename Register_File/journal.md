# Journal / README

## Task

32-Register RISC-V Register File implementation in Verilog

## Description

The register file is the collection of registers used by the processor to store data and operands. For a 32-bit RISC-V processor, the register file contains 32 registers, each 32 bits wide.

The register file was implemented as a parameterized array of registers. The `data_width` parameter controls the width of each register, while `address_width` determines the number of registers through `2 ** address_width`.

The design supports:

* One write port
* Two independent read ports
* Write enable
* Active-low asynchronous reset
* Register `x0` permanently reading as zero

Writing occurs on the rising edge of the clock when `we` is HIGH. Writes to address `0` are blocked so that `x0` remains zero.

The two read ports are combinational, allowing two registers to be read simultaneously without waiting for a clock edge. When either read address is `0`, the corresponding output is forced to zero.

## Expected Results

| Operation              | Expected Behavior                                               |
| ---------------------- | --------------------------------------------------------------- |
| Reset                  | All registers are cleared to `0`                                |
| Write with `we = 0`    | Register contents remain unchanged                              |
| Write with `we = 1`    | Data is stored at the selected address on the rising clock edge |
| Write to address `0`   | Write is blocked                                                |
| Read address `0`       | Output is always `0`                                            |
| Read valid address     | Corresponding register value is returned                        |
| Two read addresses     | Both values are available simultaneously                        |
| Reset during operation | All registers immediately clear to `0`                          |

The testbench verifies reset, write enable, blocked writes to `x0`, normal writes, simultaneous reads, disabled writes, and reset during operation.

## Lessons Learned (& Mistakes Made)

* A register file can be implemented efficiently as an array of registers instead of instantiating each register individually, making the design much easier to scale.

* The relationship between `address_width` and the number of registers became clearer. With a 5-bit address, `2 ** 5` gives 32 registers, matching the RISC-V register file.

* The write operation is clocked, while the read ports can be implemented as combinational logic, allowing two register values to be read at the same time.

* RISC-V register `x0` must always return zero, so writes to address `0` are blocked and reads from address `0` are forced to zero.

* Parameterizing both the data width and address width makes the register file reusable instead of tying it specifically to a 32-bit, 32-register implementation.

* The testbench showed why write enable must be checked before changing a register. When `we` was disabled, changing the write address and data had no effect on the stored values.

* The register file brings together concepts from the previous register work. Individual storage elements can now be organized into the structure needed by the processor's datapath.
