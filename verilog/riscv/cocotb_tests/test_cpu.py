import cocotb
from cpu import CPU

@cocotb.test()
async def test_add(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x0 67")
    cpu.instr("add x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 18 + 67, "add result incorrect"


@cocotb.test()
async def test_sub(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x0 7")
    cpu.instr("sub x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 18 - 7, "sub result incorrect"
