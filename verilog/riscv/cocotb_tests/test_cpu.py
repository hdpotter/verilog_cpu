import cocotb
from cocotb.triggers import FallingEdge, Timer
from cocotb.clock import Clock

from riscv_assembler.convert import AssemblyConverter

def bitstring_to_int(bitstring: str) -> int:
    multiplier = 1
    output = 0
    for i in range(len(bitstring)):
        output += multiplier * int(bitstring[i])
        multiplier *= 2

    return output


def assemble(instr: str) -> int:
    bits = AssemblyConverter().convert(instr)[0][::-1] # last index reverses string by taking slice that steps backward
    return bitstring_to_int(bits)

async def load_instruction_stream(dut, stream):
    for i in range(len(stream)):
        dut.program_memory.memory[i] = stream[i]
    
    dut.pc = 0


def instr(dut, i, instr):
    dut.program_memory.memory[i].value = assemble(instr)
    return i+1

def print_reg(dut, reg):
    print(dut.registers.mem[reg])

def print_first_regs(dut, n):
    print("registers:")
    for i in range(n):
        print("  x" + str(i) + ": " + str(dut.registers.mem[i].value))


async def clock(dut):
    await Timer(2, units="ns")
    dut.clk.value = 1
    await Timer(2, units="ns")
    dut.clk.value = 0
    await Timer(2, units="ns")


@cocotb.test()
async def test_add(dut):

    dut.clk.value = 0

    i = 0
    i = instr(dut, i, "addi x1 x0 18")
    i = instr(dut, i, "addi x2 x0 67")
    i = instr(dut, i, "add x3 x1 x2")


    dut.pc.value = 0
    await Timer(2, units="ns")


    await clock(dut)

    print_first_regs(dut, 4)

    print("pc: " + str(dut.pc.value))
    print("instr: " + str(dut.instr.value))
    print("i_en: " + str(dut.decoder.i_en.value))
    print("s_en: " + str(dut.decoder.s_en.value))
    print("b_en: " + str(dut.decoder.b_en.value))
    print("lui_en: " + str(dut.decoder.lui_en.value))
    print("jal_en: " + str(dut.decoder.jal_en.value))

    print("rs1_addr: " + str(dut.rs1_addr.value))

    print("immediate: " + str(dut.imm.value))

    print("funct3: " + str(dut.funct3.value))
    print("funct7: " + str(dut.funct7.value))
    print("alu_in1: " + str(dut.alu_in1.value))
    print("alu_in2: " + str(dut.alu_in2.value))
    print("alu_out: " + str(dut.alu_out.value))

    print("reg_in: " + str(dut.reg_in.value))

    await clock(dut)

    print_first_regs(dut, 4)

    await clock(dut)

    print_first_regs(dut, 4)







    assert dut.registers.mem[3] == 18+67, "adder result incorrect"


