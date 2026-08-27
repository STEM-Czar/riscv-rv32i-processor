# Data Memory Implementation

After completing the Execute stage, I moved on to the **Data Memory** block.

The goal was to keep the implementation aligned with the bigger single cycle RV32I processor rather than overcomplicating the memory at this stage.

I decided to make the **write operation sequential** and the **read operation combinational**.

The Data Memory takes:

* `addr`
* `w_mdata`
* `mem_write`
* `mem_read`

and produces:

* `r_mdata`

The memory itself was implemented as a 1024 word array of 32 bit registers.

For writes, the memory waits for the rising edge of the clock and only writes when `mem_write` is asserted.

For reads, `r_mdata` is driven combinationally from the selected memory address when `mem_read` is asserted.

I then built a dedicated testbench instead of immediately connecting it to the processor.

The first test was deliberately simple: **try writing while reset is active.**

I attempted to write:

```text
Address = 3
Data    = 67
```

while `rst_n = 0`.

The memory correctly did not accept the write.

Next, I released reset and performed the same write with `mem_write = 1`.

The write completed on the clock edge.

Finally, I disabled writing, enabled reading, and accessed address 3.

The result was:

```text
read_data = 67
```

The final simulation confirmed the expected behavior:

```text
Rst = 0 | mem_write = 1 | mem_read = 0 | addr = 3 | write_data = 67 | read_data = 0

Rst = 1 | mem_write = 1 | mem_read = 0 | addr = 3 | write_data = 67 | read_data = 0

Rst = 1 | mem_write = 0 | mem_read = 1 | addr = 3 | write_data = 67 | read_data = 67
```

The Data Memory is now independently verified.

The important part is not just that the memory can store and return a value. I now have a clear separation between the two operations:

**Write → clock controlled**

**Read → combinational**

This gives the processor the basic memory behavior it needs for instructions such as `sw` and `lw`.

The next step is to bring this block into the processor datapath and connect it to the Execute stage output and the appropriate control signals.
