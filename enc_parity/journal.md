# Journal / README

## Task

Parameterized Encoder with Parity Generation implementation in Verilog

## Description

An encoder converts a one-hot input into the binary index of the active input. This implementation extends the encoder by adding parity generation as a simple error checking mechanism.

The parity output is generated using a reduction XOR operation:

`assign parity = ^enc_in;`

The reduction XOR checks the number of HIGH bits in the input vector. The output becomes HIGH when the input contains an odd number of `1`s and LOW when the number of `1`s is even.

Although the encoder is designed for one-hot inputs, testing multiple active inputs provides an opportunity to observe the parity behavior and verify that the error checking logic responds correctly to different input patterns.

The testbench verified normal one-hot inputs and multiple active input conditions to observe both encoding and parity generation.

## Expected Results

| `enc_In`   | `enc_Out` | `Parity` |
| ---------- | --------- | -------- |
| `00000001` | `000`     | `1`      |
| `00000010` | `001`     | `1`      |
| `00000011` | `001`     | `0`      |
| `00000100` | `010`     | `1`      |
| `00000101` | `010`     | `0`      |
| `00000110` | `010`     | `0`      |
| `00000111` | `010`     | `1`      |
| `00001000` | `011`     | `1`      |

The simulation confirmed correct encoding and parity generation based on the number of active input bits.

## Lessons Learned (& Mistakes Made)

* Reduction operators provide a compact way to perform operations across all bits of a vector. The reduction XOR (`^`) is useful for parity generation.

* Parity checking provides a simple method for detecting errors by monitoring whether the number of HIGH bits matches the expected parity.

* A one-hot encoder normally expects a single active input. Testing multiple active inputs showed that the existing encoder behavior remains MSB priority while the parity output reflects the total number of active bits.

* Combining additional outputs such as validity and parity demonstrates how a basic encoder can be extended with extra information for more reliable hardware communication and control.

* The same parameterized encoder structure can be reused while adding different supporting functions without changing the core encoding logic.
