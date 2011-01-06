
import structs/ArrayList
import Bytecode

main: func(args: ArrayList<String>) {
    if (args getSize() != 2) {
        ("Usage: " + args[0] + " filename") println()
        exit(-1)
    }
    Script new(args[1]) dump()
}

