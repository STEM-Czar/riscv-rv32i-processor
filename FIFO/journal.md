# Journal / README

## Task

Parameterized FIFO implementation in Verilog

## Description

A FIFO (First In, First Out) is a storage structure where the first data written into the FIFO is the first data read out.

The implementation uses a parameterized memory array to store the data, with separate write and read pointers to keep track of where data should be written and read. The `data_width` parameter controls the size of each stored word, while `fifo_depth` determines how many words the FIFO can hold.

A `count` register keeps track of the number of words currently stored. This is also used to generate the `full` and `empty` status signals.

Writing occurs when `w_en` is enabled and the FIFO is not full. Reading occurs when `r_en` is enabled and the FIFO is not empty.

The write and read pointers advance independently. The count increases when a valid write occurs, decreases when a valid read occurs, and remains unchanged when both happen during the same clock cycle.

## Expected Results

For a FIFO depth of 16:

* After reset, `empty` should be `1` and `full` should be `0`.
* Up to 16 data words should be accepted while writing.
* Once 16 words are stored, `full` should become `1` and additional writes should be blocked.
* Data should be read in the same order it was written.
* Once all 16 words have been read, `empty` should become `1`.
* Reads should be blocked while the FIFO is empty.

## Verification

The testbench first resets the FIFO and then writes 16 values into it.

The FIFO is then given an additional write attempt using `32'hDEADBEEF` to verify that writing is prevented when the FIFO is full.

Afterwards, the 16 stored values are read back in order. The waveform can be inspected using `fifo_wave.vcd` to verify the pointer movement, count, full and empty flags, and data flow.

## Lessons Learned (& Mistakes Made)

* A FIFO needs separate read and write positions because data is not necessarily read from the same location where new data is being written.

* The `count` register provides a simple way to track how much data is currently stored and determine the `full` and `empty` conditions.

* The FIFO must protect against invalid operations, so writes are only allowed when `!full` and reads are only allowed when `!empty`.

* When a read and write happen during the same clock cycle, the number of stored elements does not change, so the count must remain unchanged.

* Parameterizing both `data_width` and `fifo_depth` makes the FIFO reusable instead of tying it to one fixed data size or storage capacity.
