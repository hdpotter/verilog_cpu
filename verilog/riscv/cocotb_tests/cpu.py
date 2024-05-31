import cocotb
from cocotb.triggers import Timer
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
        await Timer(2, units="ns")

    async def clock(self):
        await Timer(2, units="ns")
        self.dut.clk.value = 1
        await Timer(2, units="ns")
        self.dut.clk.value = 0
        await Timer(2, units="ns")

    async def execute(self):
        await self.setup_execution()

        for i in range(self.instr_count):
            await self.clock()

    def register(self, n):
        return self.dut.registers.mem[n].value


    def print_first_regs(self, n):
        print("registers:")
        for i in range(n):
            print("  x" + str(i) + ": " + str(self.dut.registers.mem[i].value))
    
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

        print("rs1_addr: " + str(self.dut.rs1_addr.value))

        print("immediate: " + str(self.dut.imm.value))

        print("funct3: " + str(self.dut.funct3.value))
        print("funct7: " + str(self.dut.funct7.value))
        print("alu_in1: " + str(self.dut.alu_in1.value))
        print("alu_in2: " + str(self.dut.alu_in2.value))
        print("alu_out: " + str(self.dut.alu_out.value))

        print("reg_in: " + str(self.dut.reg_in.value))
    
