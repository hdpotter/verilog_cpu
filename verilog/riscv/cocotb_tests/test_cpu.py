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

@cocotb.test()
async def test_xor(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 0")
    cpu.instr("addi x2 x0 1")
    cpu.instr("xor x3 x1 x1")
    cpu.instr("xor x4 x1 x2")
    cpu.instr("xor x5 x2 x1")
    cpu.instr("xor x6 x2 x2")

    await cpu.execute()

    assert cpu.register(3) == 0, "0 xor 0 result incorrect"
    assert cpu.register(4) == 1, "0 xor 1 result incorrect"
    assert cpu.register(5) == 1, "1 xor 0 result incorrect"
    assert cpu.register(6) == 0, "1 xor 1 result incorrect"

@cocotb.test()
async def test_or(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 0")
    cpu.instr("addi x2 x0 1")
    cpu.instr("or x3 x1 x1")
    cpu.instr("or x4 x1 x2")
    cpu.instr("or x5 x2 x1")
    cpu.instr("or x6 x2 x2")

    await cpu.execute()

    assert cpu.register(3) == 0, "0 or 0 result incorrect"
    assert cpu.register(4) == 1, "0 or 1 result incorrect"
    assert cpu.register(5) == 1, "1 or 0 result incorrect"
    assert cpu.register(6) == 1, "1 or 1 result incorrect"

@cocotb.test()
async def test_and(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 0")
    cpu.instr("addi x2 x0 1")
    cpu.instr("and x3 x1 x1")
    cpu.instr("and x4 x1 x2")
    cpu.instr("and x5 x2 x1")
    cpu.instr("and x6 x2 x2")

    await cpu.execute()

    assert cpu.register(3) == 0, "0 and 0 result incorrect"
    assert cpu.register(4) == 0, "0 and 1 result incorrect"
    assert cpu.register(5) == 0, "1 and 0 result incorrect"
    assert cpu.register(6) == 1, "1 and 1 result incorrect"

@cocotb.test()
async def test_sll(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 7")
    cpu.instr("addi x2 x0 3")
    cpu.instr("sll x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 32 + 16 + 8, "7 << 3 (sll) result incorrect"

@cocotb.test()
async def test_srl(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 56")
    cpu.instr("addi x2 x0 3")
    cpu.instr("srl x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 7, "7 >> 3 (srl) result incorrect"

@cocotb.test()
async def test_sra(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -8")
    cpu.instr("addi x2 x0 1")
    cpu.instr("sra x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3).signed_integer == -4, "-8 >> 1 (sra) result incorrect"
