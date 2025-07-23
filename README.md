# Processor Design

## Overview

This project involves the design and implementation of a custom-built processor architecture that runs on an FPGA board. It features a bespoke 16-bit instruction format and supports a broad range of computational and control operations. The system receives instructions via UART and processes them using a tailored instruction set. A Python-based assembler translates human-readable assembly into binary machine code and communicates with the FPGA through the PySerial library. 

The processor's state and operations can be visualized directly on the FPGA hardware: incoming instructions are indicated via 16 onboard LEDs, while output data is presented in hexadecimal form on the 7-segment displays. All design logic has been developed using Verilog, with simulation and synthesis carried out in Vivado.

---

## Key Specifications

- **Registers:** The processor contains 8 general-purpose registers, each addressable using 3-bit identifiers.
- **Data Memory:** Can store up to 64 words, addressed via 6-bit addresses.
- **Instruction Memory:** Also supports 64 instructions, with a 6-bit program counter.
- **Instruction Set:** A total of 32 unique instructions are supported.
- **Accumulator:** The ALU outputs are temporarily stored in a dedicated accumulator register.
- **Flags:** Four flags are maintained to support conditional logic: `bool`, `carry`, `overflow`, and `zero`.

---

## Instruction Structure

All instructions are 16 bits in size. The high-order bits define the instruction type and operation, while the remaining bits specify operands or constants based on the type.

