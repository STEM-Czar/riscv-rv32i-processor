````md
# D Flip Flop

## Task

Design and verify a positive edge triggered D Flip Flop with an active low asynchronous reset.

## Description

The goal was to understand and implement a D Flip Flop from its internal building blocks rather than treating it as a standalone component.

The journey started with the **S-R Latch**, which uses two cross-coupled NOR gates to create a feedback path that allows the circuit to retain its state.

The **Gated S-R Latch** was then introduced by adding an Enable signal. The Enable controls whether the S and R signals can reach the internal latch.

Next, the **D Latch** simplified the interface to a single data input. The D signal feeds the Set path directly while an inverted D signal feeds the Reset path. This ensures that Set and Reset cannot both be active at the same time.

Finally, the D Latch was extended into an edge triggered **D Flip Flop** using the clock signal. Unlike the level sensitive D Latch, the D Flip Flop captures the input only on the rising edge of the clock.

## Implementation

The final Verilog module uses:

- `d` as the data input
- `clk` as the clock
- `rst_n` as an active low asynchronous reset
- `q` as the stored output
- `q_bar` as the complementary output

The sequential block is triggered by:

```verilog
always @(posedge clk or negedge rst_n)
````

This allows the circuit to respond to either a rising clock edge or a falling reset signal.

When `rst_n` is low, `q` is immediately cleared to `0`, regardless of the clock.

When `rst_n` is high, `q` captures the value of `d` on every rising edge of `clk`.

The complementary output is generated with:

```verilog
assign q_bar = ~q;
```

## Key Lessons Learned

* **Sequential logic is built from feedback.** The S-R Latch provided the foundation for understanding how digital circuits can retain state.
* **Level sensitive and edge triggered storage are different.** A D Latch responds while Enable is active, while a D Flip Flop captures data only at a clock edge.
* **The D input eliminates the forbidden S-R condition.** Using D and its inverse ensures that Set and Reset cannot be active simultaneously.
* **Asynchronous reset operates independently of the clock.** The `negedge rst_n` sensitivity allows the stored value to be cleared immediately when reset is asserted.
* **Nonblocking assignment is used for sequential logic.** `q <= d;` models the behavior of a flip flop by updating the stored value after the triggering event.
* **Understanding the internal structure makes implementation simpler.** Once the latch and edge triggering concepts were clear, the final D Flip Flop implementation became straightforward rather than something I was simply reproducing from a diagram.

## Result

Successfully implemented a positive edge triggered D Flip Flop with an active low asynchronous reset and complementary output.