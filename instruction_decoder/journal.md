# Journal / README

## Task

RISC V Instruction Set Architecture study and Instruction Decoder implementation in Verilog

## Description

Before implementing the **Instruction Decoder**, the instruction formats and the RISC V Instruction Set Architecture needed to be understood first.

An **Instruction Set Architecture (ISA)** is the interface between software and hardware. It defines the instructions a processor understands and how those instructions are represented.

Some broad ISA approaches include **OISC**, **MISC**, **CISC** such as x86, **RISC** such as RISC V and ARM, and **VLIW**.

The **RISC V ISA** uses fixed width 32 bit instructions in the base integer instruction set, with predictable positions for the different instruction fields.

The naming of the RISC V variants also became important.

For example:

* **RV** means RISC V
* **32** represents the 32 bit data width
* **I** represents the base Integer instruction set

RISC V is also modular, allowing additional instruction extensions to be added depending on the processor being designed.

Some of the extensions include:

* **M** for Integer Multiplication and Division
* **A** for Atomic Instructions
* **F** for Single Precision Floating Point
* **D** for Double Precision Floating Point
* **C** for Compressed Instructions
* **G** for the general purpose combination of I, M, A, F, and D

The instruction formats were also important for the decoder:

* **R type** for register to register operations
* **I type** for immediate operations and loads
* **S type** for store operations
* **B type** for conditional branches
* **U type** for upper immediate operations
* **J type** for unconditional jumps and links

With that understanding, the Instruction Decoder could be approached as a matter of separating the fields from the 32 bit instruction and reconstructing the immediate value according to its instruction format.

## Implementation

The decoder extracts the common instruction fields directly from the instruction word:

```text
opcode
rd
funct3
rs1
rs2
funct7
```

The immediate value requires more work because the bits are arranged differently depending on the instruction format.

The decoder therefore uses the `opcode` to determine which immediate format is being used.

For the **I type**, the 12 bit immediate is sign extended.

For the **S type**, the immediate is reconstructed from `instr[31:25]` and `instr[11:7]`.

For the **B type**, the immediate bits are rearranged and a `0` is appended as the least significant bit.

For the **U type**, the upper 20 bits are retained and the lower 12 bits are filled with zeros.

For the **J type**, the immediate is also reconstructed from several non contiguous instruction fields and sign extended.

## Expected Results

The decoder should correctly extract the instruction fields and reconstruct the immediate value for each supported instruction format.

The testbench covers:

| Type | Instruction       | Purpose                        |
| ---- | ----------------- | ------------------------------ |
| I    | `addi x1, x2, -5` | Sign extended immediate        |
| S    | `sw x3, 8(x4)`    | Reconstructed store immediate  |
| B    | `beq x1, x2, -8`  | Reconstructed branch immediate |
| U    | `lui x5, 0x12345` | Upper immediate                |
| J    | `jal x1, -16`     | Reconstructed jump immediate   |
| R    | `add x1, x2, x3`  | Common field extraction        |

## Verification

The testbench applies representative instructions from the different RISC V instruction formats and allows the decoder to extract their fields and reconstruct their immediate values.

A waveform is generated as `instr_dec_wave.vcd` for inspection.

The main focus of the verification was not simply whether an instruction could be decoded, but whether the different immediate layouts were reconstructed correctly.

## Lessons Learned (& Mistakes Made)

* Understanding the RISC V ISA and its instruction formats before writing the decoder made the Verilog implementation much easier to follow because each bit slice had a specific purpose.

* The instruction fields are not all arranged the same way across the different formats, so immediate values cannot simply be extracted as one continuous slice. Some formats require the bits to be rearranged before sign extension.

* The decoder does not need to perform the actual operation of an instruction. Its job at this stage is to expose the instruction fields and reconstruct the immediate so that the later processor stages can use them.

* The modular nature of RISC V became clearer during this work. The processor being built targets the **RV32I** base integer instruction set, while extensions such as M, A, F, D, and C can be added separately when needed.
