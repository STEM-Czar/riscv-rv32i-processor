# Journal / README

## Task

Parameterized Gray Code to Binary Decoder implementation in Verilog

## Description

After implementing Binary to Gray code conversion, the next step was to implement the reverse operation: converting Gray code back to its original binary representation.

The important property of Gray code is that each bit represents an XOR relationship with the binary bits around it. To recover the binary value, the MSB can be copied directly from the Gray code, while each following binary bit is obtained by XORing the previously calculated binary bit with the corresponding Gray code bit.

The implementation therefore starts at the MSB and works toward the LSB:

`dec_out[bit_width - 1] = dec_in[bit_width - 1];`

Then, for each remaining bit:

`dec_out[i] = dec_out[i + 1] ^ dec_in[i];`

The design is parameterized by `bit_width`, allowing the same conversion logic to be used with different data widths.

## Expected Results

| Gray Input (`dec_In`) | Binary Output (`dec_Out`) |
| --------------------- | ------------------------- |
| `0001`                | `0001`                    |
| `0010`                | `0011`                    |
| `0011`                | `0010`                    |
| `0100`                | `0111`                    |
| `0101`                | `0110`                    |
| `0110`                | `0100`                    |
| `0111`                | `0101`                    |
| `1000`                | `1111`                    |

The simulation confirmed the expected Gray code to Binary conversion for the tested values.

## Lessons Learned (& Mistakes Made)

* Gray to Binary conversion requires a cumulative XOR operation rather than the single XOR and shift used for Binary to Gray conversion.

* The MSB remains unchanged during the conversion and can therefore be assigned directly from the Gray input.

* Each subsequent binary bit depends on the binary bit calculated immediately to its left and the corresponding Gray bit.

* The direction of the loop matters. The conversion must proceed from the MSB toward the LSB because each calculation depends on the previously calculated binary bit.

* The implementation demonstrates how the order in which combinational logic is described can reflect dependencies between signals, even though the resulting hardware remains combinational.

* Parameterizing the bit width keeps the conversion reusable for different sizes without changing the underlying algorithm.

* The Binary to Gray and Gray to Binary modules form a complementary pair: one converts binary data into Gray code, while the other reconstructs the binary representation from Gray code.
