That is a good point to include in the journal because the `+4` is not just an arbitrary operation. It comes directly from how RV32I instructions are stored in memory.

### Journal / README

## Task

Parameterized Program Counter implementation in Verilog

## Description

The Program Counter (PC) keeps track of the address of the current instruction. On each clock edge, it updates to the value of `next_pc`.

For the RV32I processor, the PC also needs to provide the address of the next sequential instruction. This is done through `pc_plus4`.

While learning about the Program Counter, I came across the fact that `4` needs to be added to the PC output to get the address of the next sequential instruction. That made me ask why it was specifically `4`.

The answer comes from how memory is addressed. RISC-V uses **byte-addressed memory**, meaning each memory address refers to one byte. A standard RV32I instruction is **32 bits**, which is 4 bytes.

So if one instruction starts at address `0x00000000`, the next instruction starts at:

```text
0x00000000 + 4 = 0x00000004
```

Then:

```text
0x00000004 + 4 = 0x00000008
```

and so on.

This is why the Program Counter needs `pc + 4` for normal sequential instruction execution.

## Expected Results

After reset, the PC should be `0`.

For sequential execution, `next_pc` should receive `pc_plus4`, causing the PC to advance by 4 bytes on each clock cycle.

The design should also allow `next_pc` to receive another address for situations such as a jump or branch.

## Verification

The testbench first held the Program Counter in reset and then released reset.

Sequential execution was tested by repeatedly assigning `pc_plus4` to `next_pc`. The PC should advance by 4 on each clock cycle.

A jump or branch scenario was then tested by loading `0x00000080` into `next_pc`. After that, `pc_plus4` was used again to continue sequential execution from the new address.

The waveform was generated as `program_counter_wave.vcd` for inspection.


## Lessons Learned (& Mistakes Made)

* The `+4` in the Program Counter comes from RV32I instructions being 32 bits, or 4 bytes, while RISC-V uses byte-addressed memory.

* The Program Counter does not always have to advance sequentially. `next_pc` allows another address to be supplied for jumps and branches.

* Keeping `pc_plus4` as a separate output makes the sequential address available to the rest of the processor while `pc` stores the current instruction address.

* Parameterizing `data_width` keeps the Program Counter reusable for different datapath widths instead of hardcoding a 32-bit implementation.

