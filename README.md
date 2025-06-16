# CPU Designs

This repository contains two CPU designs that I created in the process of learning about SystemVerilog and hardware design.
This is a hobby project, and is likely unsuitable for real applications.

These CPUs implement the [RISC-V](https://riscv.org/) open-standard instruction set architecture, or parts thereof.
In particular, they use the RV32I base 32-bit integer instruction set.

I've chosen to focus here on instruction execution, leaving cache-enabled memory subsystems and detailed exception handling for a future project.

## RISC-V Single Cycle

This CPU design performs all calculations for a single instruction via combinational logic within a single CPU cycle.
The design process for single-cycle CPUs is straightforward, but without pipelining or other forms of parallel execution, performance is lackluster.

This CPU implements the complete RV32I unprivileged instruction set.

## RISC-V Pipelined

In pipelined execution, a CPU executes different parts of several different instructions simultaneously.
For example, it might fetch the sixth instruction in a stream while decoding the fifth, executing the fourth, and so on in parallel.
Pipelining introduces possible hazards, such as when a branch instruction invalidates the current pipeline, or a register value change impacts following in-progress instructions.

This CPU uses a pipelined execution model with complete hazard handling, using the fetch-decode-execute-memory-writeback model described in [Patterson and Hennessy](https://www.elsevier.com/books-and-journals/book-companion/9780128203316).
It implements a representative subset of the RV32I unprivileged instruction set.
It implements all instruction types, but I have not finished adding, for example, all of the variations of masked memory access instructions.

## Testing

I created test suites for both CPUs with the [cocotb](https://www.cocotb.org/) Python verification framework, using the [Icarus](https://bleyer.org/icarus) Verilog implementation.
