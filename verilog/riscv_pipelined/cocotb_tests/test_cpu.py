import cocotb
from cpu import CPU

@cocotb.test()
# async def test_addi_stack(dut):
#     cpu = CPU(dut)
    
#     cpu.instr("addi x1 x0 18")
#     cpu.instr("addi x2 x1 23")
#     cpu.instr("addi x3 x1 84")
#     cpu.instr("addi x4 x1 5")
#     cpu.instr_ebreak()

#     await cpu.execute()

#     assert cpu.register(1) == 18
#     assert cpu.register(2) == 18 + 23
#     assert cpu.register(3) == 18 + 84
#     assert cpu.register(4) == 18 + 5

# @cocotb.test()
# async def test_addi_add_stack(dut):
#     cpu = CPU(dut)

#     cpu.instr("addi x1 x0 14")
#     cpu.instr("addi x2 x0 17")
#     cpu.instr("add x3 x1 x2")
#     cpu.instr("add x4 x3 x1")
#     cpu.instr_ebreak()

#     await cpu.execute()

#     assert cpu.register(1) == 14
#     assert cpu.register(2) == 17
#     assert cpu.register(3) == 14 + 17
#     assert cpu.register(4) == 14 + 14 + 17

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

    await cpu.execute(print_pipeline=True)

    cpu.print_first_regs(4)

    # assert cpu.register(2) == 0x01234567
