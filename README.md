# RV32I 5-Stage Pipelined RISC-V Processor Design & Verification

## Project Overview
This project focuses on designing and verifying a 32-bit RV32I RISC-V processor using Verilog.

The goal is to gain hands-on experience in RTL design, processor architecture, and hardware verification by building a complete CPU from fundamental digital logic blocks.

The final objective is to implement a 5-stage pipelined processor capable of executing RV32I instructions.

## Project Goal
The main objective is to understand how a modern processor works internally by designing each hardware component and integrating them into a functional pipelined CPU.

The processor will follow the classic 5-stage pipeline architecture:

1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

## Implementation Roadmap

The processor will be developed gradually through individual modules:

### Digital Logic Foundations
- AND Gate
- OR Gate
- XOR Gate
- XNOR Gate
- NAND Gate
- NOR Gate
- NOT Gate
- Buffer Gate

### Processor Building Blocks
- Multiplexers
- Decoders
- Encoders
- Adders
- Registers
- Program Counter (PC)
- Instruction Memory
- Data Memory
- Register File
- Arithmetic Logic Unit (ALU)
- Immediate Generator
- Control Unit
- Instruction Decoder

### Pipeline Implementation
- Instruction Fetch (IF) stage
- IF/ID pipeline register
- Instruction Decode (ID) stage
- ID/EX pipeline register
- Execute (EX) stage
- EX/MEM pipeline register
- Memory Access (MEM) stage
- MEM/WB pipeline register
- Write Back (WB) stage

### Advanced Pipeline Features
- Data hazard detection
- Forwarding unit
- Pipeline stall logic
- Branch handling
- Pipeline verification

## Design Approach

The processor will be developed using a modular approach. Each hardware block will be implemented, tested, simulated, and documented individually before integration.

Each module will contain:

- Verilog RTL files
- Testbench files
- Simulation waveforms
- Design notes/journal
- Verification results

## Tools Used

- Verilog for RTL design
- Verilator for simulation
- Surfer for waveform analysis
- GitHub for version control and documentation

## Expected Final Result

The completed processor should be able to:

- Fetch instructions from memory
- Decode RV32I instructions
- Execute arithmetic and logical operations
- Perform memory read/write operations
- Write results back to registers
- Execute programs using the RV32I instruction set

The final design will be verified through simulation using test programs and waveform analysis.

## Learning Objectives

Through this project, I aim to develop practical experience in:

- RTL hardware design
- CPU architecture
- Pipelined processor design
- Verilog development
- Digital system verification
- Debugging hardware designs
- Understanding the internal operation of RISC-V processors

## Project Status

Currently building and verifying fundamental hardware modules before integrating them into the complete RV32I 5-stage pipelined processor.
