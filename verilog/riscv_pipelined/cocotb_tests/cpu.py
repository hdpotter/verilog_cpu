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

    def instr_ebreak(self):
        self.instr_raw(0x00100073)

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
        self.dut.rst.value = 0
        self.dut.pc.value = 0

        await self.reset()

        # await self.clear_first_memory(16)
        # await self.clear_regs()

        await self.wait(2)



    async def execute(self, n=64, trace=False, print_pipeline = False, end_in_middle=False):
        await self.setup_execution()

        breakout = False
        last = 0
        for i in range(n):
            if self.dut.broken.value:
                breakout = True
                last = i
                break

            if trace:
                print("pc_" + str(i).ljust(math.ceil(math.log(n, 10))) + ": " + str(int(self.dut.pc.value.integer/4)))

            if print_pipeline:
                print("cycle " + str(i) + "  ================================================================")
                self.print_pipeline()

            await self.clock()
        
        if not breakout and not end_in_middle:
            assert False, "executed " + str(n) + " cycles without reaching end of instruction stream"
        
        for i in range(6):
            # print("final cycle " + str(i))

            if trace:
                print("pc_" + str(i).ljust(math.ceil(math.log(n, 10))) + ": " + str(int(self.dut.pc.value.integer/4)))

            if print_pipeline:
                print("cycle " + str(last + i) + "  ================================================================")
                self.print_pipeline()

            await self.clock()

    def register(self, n):
        return self.dut.registers.mem[n].value

    def print_first_regs(self, n):
        print("registers:")
        for i in range(n):
            print("  x" + str(i) + ": " + str(self.dut.registers.mem[i].value))

    async def clear_regs(self):
        for i in range(1, 32):
            self.dut.registers.mem[i].value = cocotb.types.LogicArray("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")

    def print_first_instrs(self, n):
        print("instructions")
        for i in range(n):
            print("  " + str(i) + ": " + str(self.dut.instruction_memory.memory[i].value))

    def print_first_mem(self, n):
        print("memory")
        for i in range(n):
            print("  " + str(i) + ": " + str(self.dut.memory.mem[i].value))

    def memory(self, n):
        return self.dut.memory.mem[n].value
    
    def set_memory(self, n, value):
        self.dut.memory.mem[n].value = value

    async def set_memory_word(self, n, value):
        base_addr = n
        byte0 = (value // pow(256, 0)) % 256 #double slash for integer division
        byte1 = (value // pow(256, 1)) % 256
        byte2 = (value // pow(256, 2)) % 256
        byte3 = (value // pow(256, 3)) % 256

        self.dut.memory.mem[base_addr + 0].value = byte0
        self.dut.memory.mem[base_addr + 1].value = byte1
        self.dut.memory.mem[base_addr + 2].value = byte2
        self.dut.memory.mem[base_addr + 3].value = byte3

        await self.wait(2)

    async def clear_first_memory(self, n):
        for i in range(n):
            self.set_memory(i, cocotb.types.LogicArray("xxxxxxxx"))
        await self.wait(2)


    def print_pipeline(self):
        print("pipeline; pc = " + str(self.dut.pc.value))
        print("broken: " + str(self.dut.broken.value))
        self.print_if()
        self.print_id()
        self.print_ex()
        self.print_m()
        self.print_wb()
        self.print_aux()
        print()


    def print_if(self):
        print("  if:")
        print("    pc: " + str(self.dut.pc.value))
        # print("    instr: " + str(self.dut.instruction_memory.instr.value))
    
    def print_id(self):
        print("  id:")
        print("    instr: " + str(self.dut.if_id.instr_out.value))
    
    def print_ex(self):
        print("  ex:")
        print("    rd_addr: " + str(self.dut.id_ex.rd_addr_out.value))
        print("    rs1: " + str(self.dut.id_ex.rs1_out.value))
        print("    rs2: " + str(self.dut.id_ex.rs2_out.value))
        print("    alu_rs2_reg: " + str(self.dut.id_ex.alu_rs2_reg_out.value))
        print("    imm: " + str(self.dut.id_ex.imm_out.value))
        print("    add_en: " + str(self.dut.id_ex.add_en_out.value))
        print("    sub_en: " + str(self.dut.id_ex.sub_en_out.value))
        print("    xor_en: " + str(self.dut.id_ex.xor_en_out.value))
        print("    or_en: " + str(self.dut.id_ex.or_en_out.value))
        print("    and_en: " + str(self.dut.id_ex.and_en_out.value))
        print("    writeback_en: " + str(self.dut.id_ex.writeback_en_out.value))
        print("    writeback_from_mem: " + str(self.dut.id_ex.writeback_from_mem_out.value))

    def print_m(self):
        print("  m:")
        print("    rd_addr: " + str(self.dut.ex_m.rd_addr_out.value))
        print("    alu_result: " + str(self.dut.ex_m.alu_result_out.value))
        print("    writeback_en: " + str(self.dut.ex_m.writeback_en_out.value))
        print("    writeback_from_mem: " + str(self.dut.ex_m.writeback_from_mem_out.value))

    def print_wb(self):
        print("  wb:")
        print("    rd_addr: " + str(self.dut.m_wb.rd_addr_out.value))
        print("    rd: " + str(self.dut.m_wb.rd_out.value))
        print("    writeback_en: " + str(self.dut.m_wb.writeback_en_out.value))
        print("    writeback_from_mem: " + str(self.dut.m_wb.writeback_from_mem_out.value))
    
    def print_aux(self):
        print("  aux:")
        print("    skip_instr_id: " + str(self.dut.skip_instr_id.value))
        print("    skip_instr_ex: " + str(self.dut.skip_instr_ex.value))
        print("    alu.arg1: " + str(self.dut.alu.arg1.value))
        print("    alu.arg2: " + str(self.dut.alu.arg2.value))
        # print("    rd_addr_ex: " + str(self.dut.rd_addr_ex.value))
        print("    alu_result_ex: " + str(self.dut.alu_result_ex.value))
        # print("    rd_addr_m: " + str(self.dut.rd_addr_m.value))
        # print("    rd_m: " + str(self.dut.rd_m.value))
        # print("    ex_m.rd_addr_in: " + str(self.dut.ex_m.rd_addr_in.value))
        # print("    ex_m.rd_addr_out: " + str(self.dut.ex_m.rd_addr_out.value))
        
        # print("    alu_in_2_maybe_loopback: " + str(self.dut.alu_in_2_maybe_loopback.value))
        # print("    rd_m: " + str(self.dut.rd_m.value))
        # print("    rs2_ex: " + str(self.dut.rs2_ex.value))
        # print("    alu_in_2: " + str(self.dut.alu_in_2.value))
        # print("    alu_rs2_reg_ex: " + str(self.dut.alu_rs2_reg_ex.value))
        # print("    imm_ex: " + str(self.dut.imm_ex.value))

