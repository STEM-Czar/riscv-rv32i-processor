## Instruction Decode

After completing the Instruction Fetch stage, I moved to the **Instruction Decode (ID)** stage.

The purpose of the decode stage is to take the 32 bit instruction coming from Instruction Fetch and expose the information needed by the rest of the processor. I already had an `instruction_decoder` module from the earlier work, so the goal here was to build the ID stage around it rather than simply test the decoder by itself.

I started by connecting the instruction decoder outputs:

```text
opcode
rd
funct3
rs1
rs2
funct7
imm_out
```

These fields would eventually be passed forward to the execution and control logic.

The immediate also needed to remain available to the next stage. Since the different RISC V instruction formats arrange their immediate bits differently, the decoder reconstructs and sign extends the immediate according to the instruction type.

I then connected the **Register File** to the decode stage.

The `rs1` and `rs2` fields extracted from the instruction became the two read addresses of the Register File. This allowed the ID stage to produce:

```text
rs1_data
rs2_data
```

alongside the decoded instruction fields and immediate.

At first, I tried to initialize some register values directly inside the testbench by accessing the Register File's internal register array. That worked as a temporary way to establish known values, but it did not represent how the processor would actually use the Register File.

I therefore changed the test to use the Register File's real write interface:

```text
we
w_addr
w_data
```

This is the same interface that will eventually be driven by the Writeback stage.

The first attempt still returned zeros. The Register File itself looked correct, so I traced the testbench timing. The problem was that I had not released `rst_n` before attempting to write the temporary register values. Since the Register File uses an active low reset, it was still being held in reset.

After releasing reset first and then performing the writes, the Register File correctly contained:

```text
x1 = 10
x2 = 20
x4 = 40
```

The read ports then returned the expected values when the instruction selected those registers.

I tested the decode stage using several actual RV32I instructions:

```text
addi x1, x0, 2
addi x2, x0, 3
add  x3, x1, x2
sw   x3, 8(x4)
beq  x1, x2, -8
lui  x5, 0x12345
jal  x1, -16
```

This allowed me to verify the different instruction formats rather than testing only one type.

The R type instruction confirmed that `rs1` and `rs2` were being extracted correctly and that their corresponding Register File values were available:

```text
rs1 = 1
rs2 = 2
rs1_data = 10
rs2_data = 20
```

The S and B type instructions also confirmed that the two source registers and their reconstructed immediates were available.

The J type test initially appeared to reveal another decoder problem. The output showed:

```text
rd = 0
imm = FFFFFFF4
```

when I expected `jal x1, -16`.

After checking the J type immediate extraction, the decoder logic was actually correct. The problem was the machine code used in the testbench. I had encoded the test instruction incorrectly. After replacing it with the correct encoding for `jal x1, -16`, the decoder produced:

```text
opcode = 6F
rd     = 1
imm    = FFFFFFF0
```

This was a useful debugging lesson because the failure was not in the RTL. The test itself was wrong.

One other result was intentionally left at zero. The `add` instruction references `x1` and `x2`, which were initialized, but `x3` had not actually been produced by an execution stage yet. At this point I am only testing the decode stage, so the processor has not executed the instruction and written the result back into `x3`.

The final test confirmed that the ID stage can now provide:

```text
Instruction
    │
    ▼
Instruction Decoder
    │
    ├── opcode
    ├── rd
    ├── funct3
    ├── rs1
    ├── rs2
    ├── funct7
    └── immediate
             │
             ▼
        Register File
          │       │
          ▼       ▼
      rs1_data  rs2_data
```

The important part of this stage was not simply extracting bits from an instruction. It was establishing the interface between the instruction and the data the execution stage will need.

**Instruction Fetch gets the instruction. Instruction Decode determines what information is inside it and obtains the source register values needed to work with it.**

With the Instruction Fetch and Instruction Decode stages now working independently, the processor has the beginning of its instruction path.

Next, I can move into the execution side and start giving these decoded values somewhere to go.
