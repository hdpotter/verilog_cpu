from riscv_assembler.convert import AssemblyConverter

def print_with_type(item):
    print("printing " + str(item) + " with type " + str(type(item)))

def bitstring_to_int(bitstring: str) -> int:
    multiplier = 1
    output = 0

    for i in range(len(bitstring)):
        print("adding " + str(multiplier * int(bitstring[i])))

        output += multiplier * int(bitstring[i])
        multiplier *= 2

    return output


def assemble(instr: str) -> int:
    bits = AssemblyConverter().convert(instr)[0]
    return bitstring_to_int(bits)




print_with_type(assemble("addi x0 x1 18"))