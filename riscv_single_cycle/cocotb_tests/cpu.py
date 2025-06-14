import cocotb
from cocotb.triggers import Timer
from riscv_assembler.convert import AssemblyConverter
import math


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


class CPU:
    def __init__(self, dut):
        self.dut = dut
        self.instr_count = 0
    
    def instr(self, s):
        self.instr_raw(assemble(s))

    def instr_raw(self, s):
        self.dut.program_memory.memory[self.instr_count].value = s
        self.instr_count += 1
    
    async def setup_execution(self):
        self.dut.clk.value = 0
        self.dut.pc.value = 0

        await self.reset_first_memory(16)
        await self.reset_regs()

        await self.wait(2)

    async def wait(self, n):
        await Timer(2, units="ns")

    async def clock(self, n=1):
        for i in range(n):
            await self.wait(2)
            self.dut.clk.value = 1
            await self.wait(2)
            self.dut.clk.value = 0
            await self.wait(2)

    async def execute(self, n=64, trace=False, end_in_middle=False):
        await self.setup_execution()

        breakout = False
        for i in range(n):
            if trace:
                print("pc_" + str(i).ljust(math.ceil(math.log(n, 10))) + ": " + str(int(self.dut.pc.value.integer/4)))

            if self.dut.pc.value.integer >= 4*self.instr_count: # reached end of instructions
                breakout = True
                break

            await self.clock()
        
        if not breakout and not end_in_middle:
            assert False, "executed " + str(n) + " cycles without reaching end of instruction stream"

    def register(self, n):
        return self.dut.registers.mem[n].value

    def print_first_regs(self, n):
        print("registers:")
        for i in range(n):
            print("  x" + str(i) + ": " + str(self.dut.registers.mem[i].value))

    async def reset_regs(self):
        for i in range(1, 32):
            self.dut.registers.mem[i].value = cocotb.types.LogicArray("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")


    def memory(self, n):
        return self.dut.memory.mem[n].value
    
    def set_memory(self, n, value):
        self.dut.memory.mem[n] = value

    async def reset_first_memory(self, n):
        for i in range(n):
            self.set_memory(i, cocotb.types.LogicArray("xxxxxxxx"))
        await self.wait(2)

    def print_first_memory(self, n):
        print("memory:")
        for i in range(n):
            print("  mem[" + str(i) + "]: " + str(self.dut.memory.mem[i].value))

    def pc(self):
        return self.dut.pc.value
    
    def print_program(self):
        print("program:")
        for i in range(self.instr_count):
            print("  " + str(self.dut.program_memory.memory[i].value))
    
    def print_wires(self):
        print("pc: " + str(self.dut.pc.value))
        print("instr: " + str(self.dut.instr.value))
        print("i_en: " + str(self.dut.decoder.i_en.value))
        print("s_en: " + str(self.dut.decoder.s_en.value))
        print("b_en: " + str(self.dut.decoder.b_en.value))
        print("lui_en: " + str(self.dut.decoder.lui_en.value))
        print("jal_en: " + str(self.dut.decoder.jal_en.value))
        print("auipc_en: " + str(self.dut.decoder.auipc_en.value))

        print("rs1_addr: " + str(self.dut.rs1_addr.value))

        print("imm_is: " + str(self.dut.decoder.imm_is.value))
        print("imm: " + str(self.dut.imm.value))

        print("funct3: " + str(self.dut.funct3.value))
        print("funct7: " + str(self.dut.funct7.value))

        print("rs1: " + str(self.dut.rs1.value))
        print("rs2: " + str(self.dut.rs2.value))


        print("alu_in1: " + str(self.dut.alu_in1.value))
        print("alu_in2: " + str(self.dut.alu_in2.value))
        print("alu_out: " + str(self.dut.alu_out.value))

        print("mem_out: " + str(self.dut.mem_out.value))
        print("reg_in: " + str(self.dut.reg_in.value))

        print("memory.addr: " + str(self.dut.memory.addr.value))
        print("memory.offset: " + str(self.dut.memory.offset.value))
        print("memory.full_addr: " + str(self.dut.memory.full_addr.value))
        print("memory.read: " + str(self.dut.memory.read.value))
        print("memory.data: " + str(self.dut.memory.data.value))
    
