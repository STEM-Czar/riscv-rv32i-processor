# Journal / README

## Task

Instruction Memory implementation in Verilog

## Description

The instruction memory stores the 32 bit instructions that the processor will execute. A parameterized memory depth of 256 words was used, giving 256 × 4 bytes = 1024 bytes (1 KB) of instruction storage.

The memory is initialized from an `instructions.hex` file using `$readmemh`. The processor provides a 32 bit byte address, while the memory uses a word index. Since each RV32I instruction is 4 bytes and must be word aligned, the two least significant address bits are ignored.

```verilog
assign instr = mem[addr[9:2]];
```

This allows addresses such as `0x00`, `0x04`, `0x08`, and `0x0C` to select consecutive instructions.

## Instructions Used

```text
00200093    // addi x1, x0, 2
00300113    // addi x2, x0, 3
002081b3    // add  x3, x1, x2
0000006f    // jal  x0, 0
```

The intended sequence is to load `2` into `x1`, load `3` into `x2`, add them into `x3`, and then enter an infinite loop with `jal x0, 0`.

## Expected Results

| Address      | Instruction  | Expected Instruction |
| ------------ | ------------ | -------------------- |
| `0x00000000` | `0x00200093` | `addi x1, x0, 2`     |
| `0x00000004` | `0x00300113` | `addi x2, x0, 3`     |
| `0x00000008` | `0x002081b3` | `add x3, x1, x2`     |
| `0x0000000C` | `0x0000006f` | `jal x0, 0`          |

The simulation should return the corresponding instruction for each address.

## Simulation Result

```text
Addr: 0x00000000 | Instr: 0x00200093
Addr: 0x00000004 | Instr: 0x00300113
Addr: 0x00000008 | Instr: 0x002081b3
Addr: 0x0000000c | Instr: 0x0000006f
Test complete
```

The instruction memory returned the expected instruction at all four tested addresses.

## Lessons Learned (& Mistakes Made)

* The lower two bits of the byte address are not needed for selecting an RV32I instruction because each instruction occupies 4 bytes and valid instruction addresses are word aligned.

* `addr[9:2]` converts the byte address into the word index needed to access a 256 word memory.

* `$readmemh` provides a simple way to load hexadecimal machine instructions into the memory during simulation, allowing the test program to be changed without modifying the Verilog module.

* The hexadecimal values in the memory file are actual encoded RISC-V instructions, so instruction memory is the point where the processor's stored program begins to connect with the instruction decoder.

* Using a small program containing `addi`, `add`, and `jal` made it possible to test the memory with instructions that will later exercise the register file, ALU, and program counter together.

* The `jal x0, 0` instruction provides an intentional infinite loop at the end of the test program, preventing execution from continuing into unused memory.

## Next Step

Connect the instruction memory to the **Program Counter** and **Instruction Decoder** so the processor can begin fetching and interpreting instructions as a sequence.
