import cocotb
from cpu import CPU

@cocotb.test()
async def test_add(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x1 23")
    cpu.instr("addi x3 x1 84")
    cpu.instr("addi x4 x1 5")
    cpu.instr_ebreak()

    await cpu.execute(print_pipeline=True)

    cpu.print_first_regs(6)
