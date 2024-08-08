import cocotb
from cpu import CPU

@cocotb.test()
async def test_addi_stack(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    cpu.instr("addi x2 x1 23")
    cpu.instr("addi x3 x1 84")
    cpu.instr("addi x4 x1 5")
    cpu.instr_ebreak()

    await cpu.execute()

    assert cpu.register(1) == 18
    assert cpu.register(2) == 18 + 23
    assert cpu.register(3) == 18 + 84
    assert cpu.register(4) == 18 + 5

@cocotb.test()
async def test_addi_add_stack(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 14")
    cpu.instr("addi x2 x0 17")
    cpu.instr("add x3 x1 x2")
    cpu.instr("add x4 x3 x1")
    cpu.instr_ebreak()

    await cpu.execute()

    assert cpu.register(1) == 14
    assert cpu.register(2) == 17
    assert cpu.register(3) == 14 + 17
    assert cpu.register(4) == 14 + 14 + 17

@cocotb.test()
async def test_lw(dut):
    cpu = CPU(dut)

    cpu.instr_raw(0x00002083) # lw x1 0(x0)
    cpu.instr_ebreak()

    await cpu.set_memory_word(0, 0xdeadbeef)

    await cpu.execute()

    assert cpu.register(1) == 0xdeadbeef
    
@cocotb.test()
async def test_lw_pause(dut):
    cpu = CPU(dut)

    cpu.instr_raw(0x00002083) # lw x1 0(x0)
    cpu.instr("addi x2 x1 0")
    cpu.instr_ebreak()

    await cpu.set_memory_word(0, 0x01234567)

    await cpu.execute()

    assert cpu.register(2) == 0x01234567

@cocotb.test()
async def test_lw_pause_in_context(dut):
    cpu = CPU(dut)

    cpu.instr("addi x3 x0 5")
    cpu.instr_raw(0x00002083) # lw x1 0(x0)
    cpu.instr("addi x2 x1 0")
    cpu.instr("add x4 x2 x3")
    cpu.instr("addi x5 x0 7")
    cpu.instr("addi x6 x0 9")
    cpu.instr("add x7 x5 x6")
    cpu.instr_ebreak()

    await cpu.set_memory_word(0, 0x01234567)

    await cpu.execute()

    assert cpu.register(1) == 0x01234567
    assert cpu.register(2) == 0x01234567
    assert cpu.register(3) == 5
    assert cpu.register(4) == 5 + 0x01234567
    assert cpu.register(5) == 7
    assert cpu.register(6) == 9
    assert cpu.register(7) == 16

@cocotb.test()
async def test_beq_simple(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    # cpu.instr("beq x0 x0 8") # skip next instruction
    cpu.instr_raw(0x00000463)
    cpu.instr("addi x1 x0 7") # should be skipped
    cpu.instr("addi x2 x0 3")
    cpu.instr_ebreak()

    await cpu.execute(print_pipeline=True)

    cpu.print_first_regs(8)

    assert cpu.register(1) == 5
    assert cpu.register(2) == 3


@cocotb.test()
async def test_beq_longer(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 5")
    cpu.instr("addi x3 x0 6")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("beq x1 x2 8") # skip next instruction if x1 and x2 are equal (which they are)
    cpu.instr_raw(0x00208463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("beq x1 x3 8") # skip next instruction if x1 and x3 are equal (which they aren't)
    cpu.instr_raw(0x00308463)
    cpu.instr("addi x5 x0 1")
    cpu.instr_ebreak()

    await cpu.execute()

    assert cpu.register(4) == 0
    assert cpu.register(5) == 1

@cocotb.test()
async def test_beg_complex(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 7")
    cpu.instr("addi x3 x0 9")
    cpu.instr("addi x4 x0 9")

    # cpu.instr("beq x3 x4 12")
    cpu.instr_raw(0x00418663)
    cpu.instr("addi x1 x0 21")
    cpu.instr("addi x2 x0 23")

    cpu.instr("addi x5 x0 31")
    cpu.instr("addi x6 x0 33")
    cpu.instr("addi x7 x0 35")
    cpu.instr("addi x8 x0 37")

    # cpu.instr("beq x0 x0 16")
    cpu.instr_raw(0x00000863)
    cpu.instr("addi x5 x0 1")
    cpu.instr("addi x6 x0 3")
    cpu.instr("addi x7 x0 5")

    cpu.instr("addi x8 x0 6")
    cpu.instr_ebreak()

    await cpu.execute(n=64)

    assert cpu.register(1) == 5
    assert cpu.register(2) == 7
    assert cpu.register(3) == 9
    assert cpu.register(4) == 9
    assert cpu.register(5) == 31
    assert cpu.register(6) == 33
    assert cpu.register(7) == 35
    assert cpu.register(8) == 6


