# ALU Journal

## Task

Implement and verify a parameterized ALU capable of performing arithmetic, shifts, logical operations, comparisons, and generating status flags.

## Description

The ALU brings together many of the combinational operations explored individually so far into a single reusable datapath. Rather than creating a separate module for every operation, a control signal determines which operation the ALU performs.

The design is parameterized by `bit_width` and `opcode_bits`, allowing the same structure to be adapted to different datapath widths. With four control bits, sixteen operation codes are available. The current implementation uses these for addition, subtraction, logical and arithmetic shifts, rotations, bitwise logic, equality, and greater than comparisons.

A major part of the design was handling status information alongside the main result. The ALU produces Zero, Negative, Carry, and Overflow flags and packs them into a single status vector as `{V, C, N, Z}`.

For addition and subtraction, the intermediate result was extended by one bit so that carry information could be retained separately from the main output. Signed overflow was handled by examining the sign bits of the operands and result rather than relying only on the carry bit.

The shift operations also required different interpretations of the same basic operation. Logical right shifts fill with zeros, while arithmetic right shifts preserve the sign bit. Rotations go a step further by wrapping the bits that leave one side of the datapath back around to the other side.

## Expected Results

The ALU should produce the correct result for each control code while generating the appropriate status flags.

The testbench covers normal addition and subtraction, zero results, unsigned carry, signed overflow, shifts, rotations, bitwise operations, and comparisons. It also checks the ALU using both decimal values and binary representations depending on the operation being tested.

## Mistakes Made

The ALU introduced several small but useful Verilog lessons.

A replication expression was initially written with incorrect braces. The correct nested replication syntax is required when constructing a vector such as a single `1` padded with zeros.

There were also straightforward naming and syntax mistakes, including a misspelled `bit_width`, using `+` instead of `-` in the subtraction branch, and writing `default;` instead of `default:`.

Some case branches contained multiple procedural statements without `begin ... end`, which reinforced that case items need explicit block boundaries when they contain more than one statement.

The signed arithmetic right shift also exposed an expression sizing issue. Explicitly converting the signed shifted result back to an unsigned vector made the intended bit pattern clear.

During verification, the subtraction overflow test for `127 - (-1)` exposed a problem with the Carry flag expectation. The result itself was correct at `-128`, but the status vector did not match the expected value. This became another reminder that producing the correct main result does not necessarily mean every accompanying status signal is correct.


## Lesson Learned

The ALU brought together several concepts that had previously been explored separately.

One important realization was that arithmetic operations are not just about the value appearing at the output. A processor also needs information about what happened during the operation. Carry, Zero, Negative, and Overflow provide that additional context to later stages of the processor.

The distinction between carry and signed overflow became particularly important. A carry out of the most significant bit is not the same thing as signed overflow. Signed overflow depends on the relationship between the operand signs and the resulting sign.

The shift operations reinforced another distinction. Logical and arithmetic right shifts may look similar in code, but they represent different hardware behavior because arithmetic shifting preserves the sign of a signed value.

Parameterization also became more meaningful here. Instead of writing an ALU specifically for an 8-bit datapath, `bit_width` allows the same design to scale toward the 32-bit datapath required by the eventual RV32I processor.

The testbench also became more structured than the earlier modules. Separate checking tasks were used for decimal and binary oriented operations, making the simulation output easier to read while keeping the actual verification reusable.

I learned that the MSB of the extended temp can be used directly as the carry flag for addition, but subtraction requires the MSB to be inverted because it represents the inverse of the borrow condition. I caught this during verification, corrected the subtraction carry logic, and confirmed the status flags matched the expected behavior.

Most importantly, the failed overflow test showed why verification is more than checking whether the output "looks right". A circuit can produce the expected result while one of its status signals is still wrong. That is exactly the kind of issue that needs to be caught before the block becomes part of a larger processor.
