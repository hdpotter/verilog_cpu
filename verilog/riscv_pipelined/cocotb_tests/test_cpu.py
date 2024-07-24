import cocotb
from cpu import CPU

@cocotb.test()
async def test_add(dut):
    cpu = CPU(dut)
    
    cpu.instr("addi x1 x0 18")
    # cpu.instr("addi x2 x0 67")
    # cpu.instr("addi x0 x0 0")
    # cpu.instr("addi x0 x0 0")
    # cpu.instr("addi x0 x0 0")
    # cpu.instr("addi x0 x0 0")
    # cpu.instr("addi x0 x0 0")
    # cpu.instr("add x3 x1 x2")
    cpu.instr_ebreak()


    # await cpu.execute()
    # await cpu.setup_execution()

    # cpu.print_first_instrs(12)
    
    await cpu.execute(print_pipeline=True)


    # cpu.print_pipeline() # nothing done

    # await cpu.clock()
    # cpu.print_pipeline() # IF complete

    # print("==== funct3: " + str(dut.decoder.funct3.value))
    # print("==== funct7: " + str(dut.decoder.funct7.value))
    # print("==== sub_en: " + str(dut.decoder.sub_en.value))
    # print("==== add_en: " + str(dut.decoder.add_en.value))


    # await cpu.clock()
    # # cpu.print_pipeline() # ID complete

    # await cpu.clock()
    # # cpu.print_pipeline() # EX complete

    # await cpu.clock()
    # # cpu.print_pipeline() # M complete

    # await cpu.clock()
    # # cpu.print_pipeline() # WB complete

    # await cpu.clock()
    # # cpu.print_pipeline() # second WB complete

    # await cpu.clock()
    # # cpu.print_pipeline() # third WB complete

    # await cpu.clock()
    # await cpu.clock()
    # await cpu.clock()
    # await cpu.clock()
    # await cpu.clock()
    # await cpu.clock()
    # await cpu.clock()

    cpu.print_first_regs(6)
