# Journal / README

## Task

Instruction Fetch (IF) Stage implementation in Verilog

## Description

The Instruction Fetch stage brings together the **Program Counter** and **Instruction Memory** so the processor can retrieve instructions sequentially.

The Program Counter stores the current instruction address, while the Instruction Memory uses that address to return the corresponding 32 bit instruction. The `pc_plus4` output provides the address of the next sequential instruction.

For this implementation, `pc_plus4` was fed directly back into `next_pc` in the testbench. This allows the processor to move through the instruction memory one instruction at a time.

The Instruction Fetch module was built by instantiating the previously implemented **Program Counter** and **Instruction Memory** modules.

## Expected Results

The PC should advance by 4 on each rising clock edge, and the instruction memory should return the instruction stored at the corresponding address.

| PC | Expected Instruction |
| --- | --- |
| `0x00000000` | `0x00200093` |
| `0x00000004` | `0x00300113` |
| `0x00000008` | `0x002081B3` |
| `0x0000000C` | `0x0000006F` |
| `0x00000010` | `0x00000000` |

The simulation produced the expected instruction sequence.

## Lessons Learned (& Mistakes Made)

- The Instruction Fetch stage is mainly about connecting existing pieces together. The Program Counter provides the address, and the Instruction Memory uses that address to provide the instruction.

- Feeding `pc_plus4` directly back into `next_pc` creates a simple sequential instruction flow where the PC advances by 4 bytes after each instruction.

- The simulation made the relationship between the PC and instruction memory much clearer. `0x00`, `0x04`, `0x08`, and `0x0C` select consecutive 32 bit instructions.

- The `jal x0, 0` instruction was successfully fetched at `PC = 0x0C`, but it did not cause a jump. The Instruction Fetch stage is not responsible for interpreting the instruction. The decoder and control logic have not been connected yet, so `next_pc` is still being supplied directly by `pc_plus4`.

- This separates **fetching an instruction** from **deciding what the instruction does**. The Instruction Fetch stage can retrieve a `jal` instruction correctly even before the rest of the processor knows that it is a jump.

- The testbench confirmed that the Program Counter, Instruction Memory, and sequential `PC + 4` path are working together as expected.

## Verification

The testbench was simulated and monitored using the waveform and console output.

The resulting sequence was:

```text
PC 0x00000000 → Instruction 0x00200093
PC 0x00000004 → Instruction 0x00300113
PC 0x00000008 → Instruction 0x002081B3
PC 0x0000000C → Instruction 0x0000006F
PC 0x00000010 → Instruction 0x00000000