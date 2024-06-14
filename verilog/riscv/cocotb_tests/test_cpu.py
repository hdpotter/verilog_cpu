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

    cpu.instr("addi x2 x0 169") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x0 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x0 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x0 229") # least significant bit 0xe5

    # cpu.instr("sb x2 1(x1)")
    cpu.instr_raw(0x002080a3)
    # cpu.instr("sb x2 -1(x1)")
    cpu.instr_raw(0xfe208fa3)

    await cpu.execute()

    assert cpu.memory(4) == 229
    assert cpu.memory(6) == 229

@cocotb.test()
async def test_sh(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 169") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5

    # cpu.instr("sh x2 -1(x1)")
    cpu.instr_raw(0xfe209fa3)
    # cpu.instr("sh x2 1(x1)")
    cpu.instr_raw(0x002090a3)

    await cpu.execute()

    assert cpu.memory(4) == 229
    assert cpu.memory(5) == 230
    assert cpu.memory(6) == 229
    assert cpu.memory(7) == 230

@cocotb.test()
async def test_sw(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 169") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5


    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    await cpu.execute()

    assert cpu.memory(4) == 229
    assert cpu.memory(5) == 230
    assert cpu.memory(6) == 41
    assert cpu.memory(7) == 169

    assert cpu.memory(9) == 229
    assert cpu.memory(10) == 230
    assert cpu.memory(11) == 41
    assert cpu.memory(12) == 169

@cocotb.test()
async def test_lb(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 137") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5
    
    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    # cpu.instr("lb x3 -1(x1)")
    cpu.instr_raw(0xfff08183)
    # cpu.instr("lb x4 4(x1)")
    cpu.instr_raw(0x00408203)

    await cpu.execute()

    assert cpu.register(3) == 0xffffffe5 # result will be sign-extended
    assert cpu.register(4) == 0xffffffe5

@cocotb.test()
async def test_lh(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 137") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5

    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    # cpu.instr("lh x3 -1(x1)")
    cpu.instr_raw(0xfff09183)
    # cpu.instr("lh x4 4(x1)")
    cpu.instr_raw(0x00409203)

    await cpu.execute()

    assert cpu.register(3) == 0xffffe6e5
    assert cpu.register(4) == 0xffffe6e5

@cocotb.test()
async def test_lw(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 137") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5

    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    # cpu.instr("lw x3 -1(x1)")
    cpu.instr_raw(0xfff0a183)
    # cpu.instr("lw x4 4(x1)")
    cpu.instr_raw(0x0040a203)

    await cpu.execute()

    assert cpu.register(3) == 0x8929e6e5
    assert cpu.register(4) == 0x8929e6e5

@cocotb.test()
async def test_lbu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 137") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5
    
    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    # cpu.instr("lbu x3 -1(x1)")
    cpu.instr_raw(0xfff0c183)
    # cpu.instr("lb x4 4(x1)")
    cpu.instr_raw(0x0040c203)

    await cpu.execute()

    assert cpu.register(3) == 0x000000e5 # result will be zero-extended
    assert cpu.register(4) == 0x000000e5

@cocotb.test()
async def test_lhu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")

    cpu.instr("addi x2 x0 137") # most significant byte 0x89
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 41") # 0x29
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 230") # 0xe6
    cpu.instr("slli x2 x2 8")
    cpu.instr("addi x2 x2 229") # least significant bit 0xe5

    # cpu.instr("sw x2 -1(x1)")
    cpu.instr_raw(0xfe20afa3)
    # cpu.instr("sw x2 4(x1)")
    cpu.instr_raw(0x0020a223)

    # cpu.instr("lhu x3 -1(x1)")
    cpu.instr_raw(0xfff0d183)
    # cpu.instr("lhu x4 4(x1)")
    cpu.instr_raw(0x0040d203)

    await cpu.execute()

    assert cpu.register(3) == 0x0000e6e5
    assert cpu.register(4) == 0x0000e6e5

@cocotb.test()
async def test_beq(dut):
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

    await cpu.execute()

    assert cpu.register(4) == 0
    assert cpu.register(5) == 1

@cocotb.test()
async def test_bne(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 5")
    cpu.instr("addi x3 x0 6")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("bne x1 x2 8") # skip next instruction if x1 and x2 are unequal (which they aren't)
    cpu.instr_raw(0x00209463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("bne x1 x3 8") # skip next instruction if x1 and x3 are unequal (which they are)

    cpu.instr_raw(0x00309463)
    cpu.instr("addi x5 x0 1")

    await cpu.execute()

    assert cpu.register(4) == 1
    assert cpu.register(5) == 0

@cocotb.test()
async def test_blt(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -6")
    cpu.instr("addi x2 x0 -6")
    cpu.instr("addi x3 x0 -5")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("blt x1 x2 8") # skip next instruction if x1 < x2 (false)
    cpu.instr_raw(0x0020c463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("blt x1 x3 8") # skip next instruction if x1 < x3 (true)
    cpu.instr_raw(0x0030c463)
    cpu.instr("addi x5 x0 1")

    await cpu.execute()

    assert cpu.register(4) == 1
    assert cpu.register(5) == 0
    # todo: should really make three tests for this one

@cocotb.test()
async def test_bge(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 -6")
    cpu.instr("addi x2 x0 -5")
    cpu.instr("addi x3 x0 -7")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("bge x1 x2 8") # skip next instruction if x1 >= x2 (false)
    cpu.instr_raw(0x0020d463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("bge x1 x3 8") # skip next instruction if x1 >= x3 (true)
    cpu.instr_raw(0x0030d463)
    cpu.instr("addi x5 x0 1")

    await cpu.execute()

    assert cpu.register(4) == 1
    assert cpu.register(5) == 0
    # todo: should really make three tests for this one

@cocotb.test()
async def test_bltu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 5")
    cpu.instr("addi x2 x0 5")
    cpu.instr("addi x3 x0 6")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("bltu x1 x2 8") # skip next instruction if x1 < x2 (false)
    cpu.instr_raw(0x0020e463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("bltu x1 x3 8") # skip next instruction if x1 < x3 (true)
    cpu.instr_raw(0x0030e463)
    cpu.instr("addi x5 x0 1")

    await cpu.execute()

    assert cpu.register(4) == 1
    assert cpu.register(5) == 0
    # todo: should really make three tests for this one

@cocotb.test()
async def test_bgeu(dut):
    cpu = CPU(dut)

    cpu.instr("addi x1 x0 6")
    cpu.instr("addi x2 x0 7")
    cpu.instr("addi x3 x0 5")

    cpu.instr("addi x4 x0 0") # write to these to measure if we skip
    cpu.instr("addi x5 x0 0")

    # cpu.instr("bgeu x1 x2 8") # skip next instruction if x1 >= x2 (false)
    cpu.instr_raw(0x0020f463)
    cpu.instr("addi x4 x0 1")
    # cpu.instr("bgeu x1 x3 8") # skip next instruction if x1 >= x3 (true)
    cpu.instr_raw(0x0030f463)
    cpu.instr("addi x5 x0 1")

    await cpu.execute()

    assert cpu.register(4) == 1
    assert cpu.register(5) == 0
    # todo: should really make three tests for this one

@cocotb.test()
async def test_jal(dut):
    cpu = CPU(dut)

    cpu.instr("addi x0 x0 0") # nop
    cpu.instr("addi x0 x0 0") # nop
    # cpu.instr("jal x1 16")
    cpu.instr_raw(0x010000ef)

    await cpu.execute()

    assert cpu.register(1) == (2+1)*4
    assert cpu.pc() == 2*4 + 16

@cocotb.test()
async def test_jalr(dut):
    cpu = CPU(dut)

    cpu.instr("addi x0 x0 0") # nop
    cpu.instr("addi x1 x0 16") # nop
    # cpu.instr("jalr x2 12(x1)")
    cpu.instr_raw(0x00c08167)

    await cpu.execute()

    assert cpu.register(2) == (2+1)*4
    assert cpu.pc() == 16 + 12

@cocotb.test()
async def test_lui(dut):
    cpu = CPU(dut)

    # cpu.instr("lui x1 9")
    cpu.instr_raw(0x000090b7)

    await cpu.execute()

    assert cpu.register(1) == 9 << 12

@cocotb.test()
async def test_auipc(dut):
    cpu = CPU(dut)

    cpu.instr("addi x0 x0 0") # nop
    cpu.instr("addi x0 x0 0") # nop
    # cpu.instr("auipc x1 9")
    cpu.instr_raw(0x00009097)

    await cpu.execute()

    assert cpu.register(1) == 2*4 + (9 << 12)


