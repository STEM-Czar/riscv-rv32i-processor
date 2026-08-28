# Writeback Stage

With the Memory stage completed, the final stage in the single cycle datapath was **Writeback (WB)**.

The purpose of Writeback is to determine what value should be written back into the Register File.

For our RV32I processor, that value can come from two places. Instructions that perform an ALU operation need to write the `alu_result` back to the Register File, while load instructions need to write the data returned from Data Memory.

I implemented a **2 to 1 MUX** to make this selection.

The MUX takes `alu_result` as input A and `r_mdata` as input B. Its output becomes `w_data`, which will eventually connect to the Register File write data input.

The select signal, `wb_S`, will come from the Control Unit.

Following the MUX convention already established in the project, a select value of 0 chooses input A, while a select value of 1 chooses input B.

The Writeback stage itself is **combinational**. It does not need a clock because it only selects which value should be passed forward. The actual write into the Register File remains clock controlled by the Register File.

I then created a simple testbench using an ALU result of 43 and Data Memory output of 12.

With `wb_S = 0`, the MUX correctly passed 43 to `w_data`.

With `wb_S = 1`, it correctly passed 12 to `w_data`.

The first test initially produced an unexpected zero because I displayed the output immediately after assigning the select signal. The combinational logic had not yet propagated the new value at that simulation time. Adding a small delay before the `$display` allowed the output to settle.

The final simulation produced the expected results.

```text
Control = 0 | InA(ALU) = 43 | InB(DMEM) = 12 | Result = 43
Control = 1 | InA(ALU) = 43 | InB(DMEM) = 12 | Result = 12
```

The Writeback stage is now independently verified.

This completes the five major stages planned for the single cycle processor.

**Fetch → Decode → Execute → Memory → Writeback**

The individual pieces are now built and tested.

The next phase is different. I am no longer building isolated blocks. It is time to connect them together and make the processor execute instructions as one system.
