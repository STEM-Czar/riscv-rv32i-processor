# RV32I Single Cycle Processor

## Engineering Journal

This journal documents my hands on development of a single cycle RV32I RISC V processor using Verilog.

The goal of this project was not simply to write Verilog that compiles. The goal was to understand how a processor actually moves data, makes decisions, executes instructions, and changes the program counter.

I built the processor from smaller hardware blocks and gradually connected them into a working CPU.

---

# Phase 1: Building the Datapath

The datapath was the first major step toward turning the individual hardware blocks into a processor.

The basic idea was simple:

> The Control Unit decides what should happen. The Datapath makes it happen.

The datapath needed to connect the major parts of the processor:

```text
Instruction Fetch
       ↓
Instruction Decode
       ↓
Execute
       ↓
Data Memory
       ↓
Writeback
```

At the same time, it needed to provide the paths required for different instruction types.

The PC needed to move to the next instruction.

Register values needed to reach the ALU.

Immediate values needed to reach the ALU.

ALU results needed to reach the register file.

Memory data needed to reach writeback.

Branches and jumps needed alternative paths for the PC.

This was where the processor started to feel like an actual CPU rather than a collection of unrelated Verilog modules.

---

# Phase 2: Connecting the Execute Stage

The Execute stage already contained the ALU and two input multiplexers.

The first MUX selects the ALU A input:

```text
alu_srcA = 0 → rs1_data
alu_srcA = 1 → PC
```

The second MUX selects the ALU B input:

```text
alu_srcB = 0 → rs2_data
alu_srcB = 1 → immediate
```

This turned out to be important because different instructions need different combinations.

For example:

```text
ADD
A = rs1
B = rs2

ADDI
A = rs1
B = immediate

AUIPC
A = PC
B = immediate

JAL
A = PC
B = immediate
```

The same ALU could therefore perform many different operations simply by changing the control signals and the data selected by the MUXes.

That was one of the first major lessons from the project:

**The hardware does not need a separate ALU for every instruction. Control signals determine how the existing hardware is used.**

---

# Phase 3: Building the PC Selection Logic

The normal flow of the processor is:

```text
PC → PC + 4
```

But branches and jumps require different destinations.

I therefore added PC selection logic with three main possibilities:

```text
00 → PC + 4
01 → Branch target / JAL target
10 → JALR target
```

The branch logic also needed to determine whether a conditional branch was actually taken.

This introduced a new relationship between the ALU and the PC:

```text
ALU comparison
      ↓
branch decision
      ↓
PC selection
```

This was an important point in the project because the ALU was no longer only producing arithmetic results. Its comparison result was being used to control the future flow of the processor.

---

# Phase 4: Adding Data Memory

The next step was connecting the data memory to the datapath.

For a store instruction:

```text
rs2_data → Data Memory
```

The ALU calculates the memory address:

```text
rs1 + immediate → memory address
```

For a load instruction:

```text
rs1 + immediate → memory address
Data Memory → read data → Writeback
```

The memory initially used 1024 words of 32 bits.

One issue appeared during simulation:

```text
%Warning-WIDTHTRUNC
```

The memory array had 1024 locations, so the address used to index the array needed 10 bits.

The original indexing was too wide.

The correction was:

```verilog
memory[m_addr[11:2]]
```

This was a useful reminder that Verilog will not automatically make every width choice meaningful just because the code compiles.

The warning was not ignored. The hardware structure was checked and the indexing was corrected.

---

# Phase 5: Expanding Writeback

The original writeback path only needed two sources:

```text
ALU result
Memory data
```

But jumps introduced another requirement.

JAL and JALR must write:

```text
PC + 4
```

into the destination register.

The writeback MUX was therefore expanded to three sources:

```text
wb_S = 00 → ALU result
wb_S = 01 → Memory data
wb_S = 10 → PC + 4
```

This allowed instructions such as:

```text
LW
JAL
JALR
```

to use the same register writeback hardware.

---

# Phase 6: Building the Control Unit

Once the datapath was taking shape, the next major task was the Control Unit.

The Control Unit does not perform the operations itself.

It looks at the instruction and decides which hardware paths should be active.

The main inputs are:

```text
opcode
funct3
funct7
imm_out
```

The main control outputs include:

```text
we
alu_srcA
alu_srcB
alu_control
mem_write
mem_read
wb_S
pc_S
branch
```

The basic philosophy became:

```text
Instruction
     ↓
Control Unit
     ↓
Control signals
     ↓
Datapath
     ↓
Result
```

This separation made the design much easier to reason about.

---

# Phase 7: Instruction Decode and Control Decisions

The Control Unit was organized around the RV32I instruction types.

For example:

### R type

The instruction uses two registers.

```text
rs1 → ALU A
rs2 → ALU B
ALU operation determined by funct3/funct7
result → rd
```

Therefore:

```text
alu_srcA = 0
alu_srcB = 0
we = 1
```

### I type arithmetic

The second ALU input comes from the immediate.

```text
rs1 → ALU A
imm → ALU B
result → rd
```

Therefore:

```text
alu_srcA = 0
alu_srcB = 1
we = 1
```

### Load

The ALU calculates:

```text
rs1 + immediate
```

The resulting address goes to memory.

Memory data then goes to writeback.

### Store

The ALU again calculates:

```text
rs1 + immediate
```

but instead of writing a register, the value in `rs2` is written to memory.

### Branch

The ALU is used for comparison and the branch logic determines whether the PC changes.

### JAL

The PC and immediate are used to calculate the jump target, while `PC + 4` is written into `rd`.

### JALR

The target is calculated using:

```text
rs1 + immediate
```

and bit 0 of the target is cleared.

---

# Phase 8: The LUI Problem

One of the more interesting debugging moments came from LUI.

The instruction was:

```text
123459b7
```

which represents:

```text
lui x19, 0x12345
```

The expected result was:

```text
12345000
```

Instead, the processor initially produced:

```text
12346400
```

At first this looked strange.

The datapath contained a special LUI handling path:

```verilog
assign alu_rs1_data =
    (opcode == 7'b0110111) ? 32'b0 : rs1_data;
```

The idea was to make the first ALU input zero for LUI because LUI does not actually have an `rs1` operand.

The problem was not immediately obvious.

Instead of changing several modules blindly, internal signals were added to the simulation output.

The important signals were:

```text
alu_rs1_data
inA
inB
alu_result
```

The final debug output showed:

```text
alu_rs1_data = 00000000
inA          = 00000000
inB          = 12345000
alu_result   = 12345000
```

The problem was solved.

This was a valuable debugging lesson:

**When a result is wrong, trace the data through the hardware instead of guessing which module is broken.**

---

# Phase 9: Integrating the CPU

Once the Datapath and Control Unit were working, they were connected at the CPU level.

The top level became:

```text
             ┌──────────────┐
 instruction │              │
────────────→│  Datapath    │
             │              │
             └──────┬───────┘
                    │
             decoded signals
                    │
                    ↓
             ┌──────────────┐
             │ Control Unit │
             └──────┬───────┘
                    │
              control signals
                    │
                    ↓
             ┌──────────────┐
             │  Datapath    │
             └──────────────┘
```

The top level itself became relatively simple.

That was intentional.

The CPU module should primarily connect the Control Unit and Datapath rather than contain all of the processor logic itself.

---

# Phase 10: First Integrated CPU Test

The first serious CPU test program included arithmetic, logic, memory, branches, and jumps.

The beginning of the program initialized registers:

```text
addi x1, x0, 5
addi x2, x0, 10
```

The processor successfully produced:

```text
x1 = 5
x2 = 10
```

Then:

```text
add x3, x1, x2
```

produced:

```text
x3 = 15
```

Subtraction, AND, OR, XOR, shifts, SLT, and SLTU were also tested.

The ALU results matched expectations.

---

# Phase 11: Testing Negative Values

Testing only positive values would not have been enough.

A negative immediate was introduced:

```text
addi x13, x0, -1
```

The processor produced:

```text
x13 = FFFFFFFF
```

This allowed signed and unsigned comparison behavior to be tested.

For example:

```text
SLT
-1 < 5
```

should produce:

```text
1
```

while:

```text
SLTU
0xFFFFFFFF < 5
```

should produce:

```text
0
```

The processor produced those expected results.

This was an important verification point because it demonstrated that the ALU was distinguishing signed and unsigned comparisons correctly.

---

# Phase 12: Testing LUI and AUIPC

After fixing LUI, the integrated CPU produced:

```text
LUI
12345000
```

as expected.

AUIPC was also tested.

For an AUIPC instruction at:

```text
PC = 0000004C
```

with a zero immediate, the result was:

```text
0000004C
```

This confirmed that the PC could successfully be routed into the ALU when required.

---

# Phase 13: Testing Memory

The CPU was then tested with:

```text
sw x3, 0(x0)
lw x21, 0(x0)
```

The value in `x3` was:

```text
15
```

The store wrote that value to memory.

The subsequent load returned:

```text
15
```

and writeback correctly sent the memory data into the destination register.

This verified the complete path:

```text
Register File
     ↓
ALU
     ↓
Data Memory
     ↓
Writeback
     ↓
Register File
```

---

# Phase 14: Testing Branches

Branch testing exposed an important issue with the test program itself.

The branch hardware and the branch instruction encodings both needed to be considered.

The intended test values were:

```text
x1  = 5
x13 = -1
```

The intended behavior was:

```text
BEQ  x1, x1   → taken
BNE  x1, x2   → taken
BLT  x13, x1  → taken
BGE  x1, x13  → taken
BLTU x13, x1  → not taken
BGEU x13, x1  → taken
```

During debugging, some of the instruction encodings did not match the comments describing them.

This was a useful lesson.

A processor can be working correctly while the test program is wrong.

The simulation therefore had to be checked at two levels:

```text
Hardware correctness
        +
Instruction encoding correctness
```

Both matter.

---

# Phase 15: Testing JAL

JAL was tested using:

```text
jal x28, +8
```

The processor changed the PC from:

```text
000000A0
```

to:

```text
000000A8
```

At the same time, the destination register received:

```text
000000A4
```

which is the correct `PC + 4` return address.

This verified both sides of JAL:

```text
PC → jump target

PC + 4 → rd
```

---

# Phase 16: Testing JALR

JALR was also tested.

The processor calculated:

```text
rs1 + immediate
```

and then cleared bit 0 of the target address.

The simulation showed:

```text
ALU result = 000000B4
```

and the PC was directed to the corresponding aligned target.

The test also revealed a problem in the test program itself.

The chosen target landed directly on an instruction that was intended to be skipped.

This was not a failure of the JALR hardware.

It was a test program design issue.

The next revision of the test program will move the JALR target so the waveform clearly demonstrates the intended jump behavior.

---

# Highs

Several points in the project have been particularly rewarding.

## Seeing the first complete instruction execute

There was a major difference between testing an ALU and seeing:

```text
instruction
→ decode
→ control
→ datapath
→ ALU
→ writeback
```

work as one system.

That was the point where the processor became real.

## Getting memory to work

The successful:

```text
SW → LW
```

test proved that the CPU could communicate with memory and recover the stored value.

## Getting LUI working

The LUI bug was frustrating, but solving it by tracing the actual signals was one of the better debugging experiences in the project.

## Seeing jumps change the PC

JAL and JALR demonstrated that the processor was no longer simply executing sequential instructions.

It could change its own control flow.

## Verifying signed and unsigned operations

Using:

```text
-1
```

to distinguish signed and unsigned comparisons was a good test because it exposed differences that simple positive numbers would not reveal.

---

# Lows

The project has also had its share of problems.

## Verilog width warnings

The memory indexing warning initially looked small, but it pointed to an actual hardware width issue.

It had to be understood rather than ignored.

## Incorrect assumptions during debugging

The LUI problem showed how easy it is to assume that a control signal is responsible for a wrong result without checking the actual signals.

The simulation proved otherwise.

## Instruction encoding mistakes

Some branch instructions in the test program did not match their comments.

This made the processor appear suspicious even though the comparison hardware was behaving consistently with the instruction it actually received.

## JALR test design

The JALR instruction worked, but the selected target was not ideal for demonstrating the intended skip behavior.

This showed that verification programs themselves need to be designed carefully.

---

# Current State

The processor currently has a working single cycle structure with:

```text
Instruction Fetch
Instruction Decode
Register File
ALU
Execute MUXes
Data Memory
Writeback
Control Unit
PC selection
Branch decision logic
Jump logic
```

The integrated simulation has successfully demonstrated:

```text
ADDI
ADD
SUB
AND
OR
XOR
SLL
SRL
SRA
SLT
SLTU
LUI
AUIPC
LW
SW
BEQ
BNE
JAL
JALR
```

The processor has also been tested with negative values and both signed and unsigned comparisons.

The remaining work is not to redesign the CPU.

The next stage is to systematically complete and verify the remaining RV32I instructions, clean the test program, and then perform a final integrated verification run.

---

# What I Learned

The biggest lesson from this project is that a processor is not primarily about writing a large amount of Verilog.

It is about understanding how information moves.

For every instruction, I now ask:

```text
Where does the instruction come from?

What does the decoder extract?

What does the Control Unit decide?

Where does each operand come from?

Which MUX selects it?

What does the ALU do?

Does memory participate?

What gets written back?

Where does the PC go next?
```

That way of thinking has been more valuable than memorizing individual Verilog statements.

I also learned that debugging hardware requires tracing signals through the design.

When something goes wrong, the useful question is not:

> "Which line looks wrong?"

The better question is:

> "At which point did the data become wrong?"

That change in thinking has made the debugging process much more systematic.

---

# Next Steps

The next phase of the project is:

1. Finish the conditional branch verification.
2. Correct the branch instruction encodings in the test program.
3. Clean up the JALR test.
4. Add the remaining immediate ALU instructions.
5. Complete the remaining memory instruction support where appropriate.
6. Run a comprehensive RV32I test program.
7. Verify final register and memory states.
8. Capture the final waveform.
9. Clean the Verilog source and project structure.
10. Document the final architecture and verification results.

The ultimate goal is a processor that is not only functional, but also understandable, testable, and presentable as an engineering portfolio project.

---

# Reflection

This project started as an exercise in learning Verilog.

It has become something much more useful.

Building the processor forced me to connect concepts that are often learned separately:

```text
Digital Logic
      ↓
Verilog
      ↓
Combinational Logic
      ↓
Sequential Logic
      ↓
Datapath
      ↓
Control
      ↓
Instruction Set Architecture
      ↓
Processor Architecture
      ↓
Verification
```

The difficult parts have been as valuable as the successful simulations.

Every warning, incorrect waveform, wrong instruction encoding, and unexpected result forced me to look deeper into what the hardware was actually doing.

That is the purpose of this project.

Not just to say that I built a RISC V processor, but to be able to explain **how it works, why it works, and how I verified it.**
