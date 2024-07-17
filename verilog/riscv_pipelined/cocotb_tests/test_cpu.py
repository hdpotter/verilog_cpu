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

    cpu.print_first_instrs(6)

    cpu.print_pipeline() # nothing done

    await cpu.clock()
    cpu.print_pipeline() # IF complete

    await cpu.clock()
    cpu.print_pipeline() # ID complete

    await cpu.clock()
    cpu.print_pipeline() # EX complete

    await cpu.clock()
    cpu.print_pipeline() # M complete

    await cpu.clock()
    cpu.print_pipeline() # WB complete

    await cpu.clock()
    cpu.print_pipeline() # second WB complete

    await cpu.clock()
    # cpu.print_pipeline() # third WB complete

    cpu.print_first_regs(6)
