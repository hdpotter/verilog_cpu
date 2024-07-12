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

    async def wait(self, n=2):
        await Timer(n, units="ns")

    async def clock(self, n=1):
        for i in range(n):
            await self.wait()
            self.dut.clk.value = 1
            await self.wait()
            self.dut.clk.value = 0
            await self.wait()

    async def reset(self):
        await self.wait()
        self.dut.rst.value = 1
        await self.clock()
        self.dut.rst.value = 0
        await self.wait()





    def instr_raw(self, s):
        self.dut.instruction_memory.memory[self.instr_count].value = s
        self.instr_count += 1
    
    async def setup_execution(self):
        self.dut.clk.value = 0
        
        await self.reset()

        await self.clear_first_memory(16)
        await self.clear_regs()

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

    async def clear_regs(self):
        for i in range(1, 32):
            self.dut.registers.mem[i].value = cocotb.types.LogicArray("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")


    def memory(self, n):
        return self.dut.memory.mem[n].value
    
    def set_memory(self, n, value):
        self.dut.memory.mem[n].value = value

    async def clear_first_memory(self, n):
        for i in range(n):
            self.set_memory(i, cocotb.types.LogicArray("xxxxxxxx"))
        await self.wait(2)

