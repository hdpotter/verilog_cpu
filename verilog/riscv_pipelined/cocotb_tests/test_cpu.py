import cocotb
from cpu import CPU

@cocotb.test()
async def test_add(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x0 67")
    cpu.instr("addi x3 x0 34")
    cpu.instr("addi x4 x0 19")
    cpu.instr("addi x5 x0 86")


    # await cpu.execute()
    await cpu.setup_execution()

    cpu.print_pipeline()

    await cpu.clock()
    cpu.print_pipeline()

    await cpu.clock()
    cpu.print_pipeline()

    await cpu.clock()
    cpu.print_pipeline()

    # cpu.print_first_regs(6)
