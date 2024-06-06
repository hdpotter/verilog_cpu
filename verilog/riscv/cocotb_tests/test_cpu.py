import cocotb
from cpu import CPU

@cocotb.test()
async def test_add(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x0 67")
    cpu.instr("add x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 18 + 67


@cocotb.test()
async def test_sub(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x0 7")
    cpu.instr("sub x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 18 - 7

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

    assert cpu.register(3) == 0
    assert cpu.register(4) == 1
    assert cpu.register(5) == 1
    assert cpu.register(6) == 0

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

    assert cpu.register(3) == 0
    assert cpu.register(4) == 1
    assert cpu.register(5) == 1
    assert cpu.register(6) == 1

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

    assert cpu.register(3) == 0
    assert cpu.register(4) == 0
    assert cpu.register(5) == 0
    assert cpu.register(6) == 1

@cocotb.test()
async def test_sll(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 7")
    cpu.instr("addi x2 x0 3")
    cpu.instr("sll x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 32 + 16 + 8

@cocotb.test()
async def test_srl(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 56")
    cpu.instr("addi x2 x0 3")
    cpu.instr("srl x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3) == 7

@cocotb.test()
async def test_sra(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -8")
    cpu.instr("addi x2 x0 1")
    cpu.instr("sra x3 x1 x2")

    await cpu.execute()

    assert cpu.register(3).signed_integer == -4

@cocotb.test()
async def test_slt(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -11")
    cpu.instr("addi x2 x0 -15")
    # cpu.instr("slt x3 x1 x2")
    cpu.instr_raw(0x0020a1b3) # error in riscv_assembler
    # cpu.instr("slt x4 x2 x1")
    cpu.instr_raw(0x00112233)

    await cpu.execute()

    assert cpu.register(3) == 0
    assert cpu.register(4) == 1

@cocotb.test()
async def test_sltu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 11")
    cpu.instr("addi x2 x0 15")
    cpu.instr("sltu x3 x1 x2")
    cpu.instr("sltu x4 x2 x1")

    await cpu.execute()

    assert cpu.register(3) == 1
    assert cpu.register(4) == 0

@cocotb.test()
async def test_addi(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 11")
    cpu.instr("addi x2 x1 15")

    await cpu.execute()

    assert cpu.register(2) == 11 + 15

@cocotb.test()
async def test_xori(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 1")
    cpu.instr("addi x2 x0 0")
    cpu.instr("xori x3 x1 1")
    cpu.instr("xori x4 x1 0")
    cpu.instr("xori x5 x2 1")
    cpu.instr("xori x6 x2 0")

    await cpu.execute()

    assert cpu.register(3) == 0
    assert cpu.register(4) == 1
    assert cpu.register(5) == 1
    assert cpu.register(6) == 0

@cocotb.test()
async def test_ori(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 1")
    cpu.instr("addi x2 x0 0")
    cpu.instr("ori x3 x1 1")
    cpu.instr("ori x4 x1 0")
    cpu.instr("ori x5 x2 1")
    cpu.instr("ori x6 x2 0")

    await cpu.execute()

    assert cpu.register(3) == 1
    assert cpu.register(4) == 1
    assert cpu.register(5) == 1
    assert cpu.register(6) == 0

@cocotb.test()
async def test_xand(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 1")
    cpu.instr("addi x2 x0 0")
    cpu.instr("andi x3 x1 1")
    cpu.instr("andi x4 x1 0")
    cpu.instr("andi x5 x2 1")
    cpu.instr("andi x6 x2 0")

    await cpu.execute()

    assert cpu.register(3) == 1
    assert cpu.register(4) == 0
    assert cpu.register(5) == 0
    assert cpu.register(6) == 0

@cocotb.test()
async def test_slli(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 7")
    cpu.instr("slli x3 x1 2")

    await cpu.execute()

    assert cpu.register(3) == 16 + 8 + 4

@cocotb.test()
async def test_srli(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 15")
    # cpu.instr("srli x3 x1 2")
    cpu.instr_raw(0x0020d193)

    await cpu.execute()

    assert cpu.register(3) == 2 + 1

@cocotb.test()
async def test_srai(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -16")
    # cpu.instr("srai x3 x1 2")
    cpu.instr_raw(0x4020d193)

    await cpu.execute()

    assert cpu.register(3).signed_integer == -4

@cocotb.test()
async def test_slti(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -4")
    cpu.instr("slti x2 x1 -8")
    cpu.instr("slti x3 x1 5")

    await cpu.execute()

    assert cpu.register(2) == 0
    assert cpu.register(3) == 1

@cocotb.test()
async def test_sltiu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 48")
    cpu.instr("sltiu x2 x1 5")
    cpu.instr("sltiu x3 x1 93")

    await cpu.execute()

    assert cpu.register(2) == 0
    assert cpu.register(3) == 1

@cocotb.test()
async def test_sb(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 1073741819")
    # cpu.instr("sb x2 1(x1)")
    cpu.instr_raw(0x002080a3)
    # cpu.instr("sb x2 -1(x1)")
    cpu.instr_raw(0xfe208fa3)

    await cpu.execute()

    assert cpu.memory(4) == 251
    assert cpu.memory(6) == 251

@cocotb.test()
async def test_sh(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 1073741819")
    # cpu.instr("sb x2 1(x1)")
    cpu.instr_raw(0x002090a3)
    # cpu.instr("sb x2 -1(x1)")
    cpu.instr_raw(0xfe209fa3)

    await cpu.execute()

    assert cpu.memory(4) == 251
    assert cpu.memory(5) == 255
    assert cpu.memory(6) == 251
    assert cpu.memory(7) == 255