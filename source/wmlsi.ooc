
import structs/ArrayList

import Bytecode
import Interp
import Libs

STACK_SIZE := const 100

main: func(args: ArrayList<String>) {
    nbArgs := args getSize()
    if (nbArgs < 3) {
        ("Usage: " + args[0] + " filename entry") println()
        exit(-1)
    }
    script := Script new(args[1])
    findex := script find(args[2])
    script checkNbArg(findex, nbArgs - 3)
    params := nbArgs == 3 ? ArrayList<String> new() : args slice(3..nbArgs-1)
/* workaround
    [OutOfBoundsException in ArrayList]:
    Trying to access an element at offset 3, but size is only 3!
*/
    interp := Interp new(STACK_SIZE, script, findex, params)
    interp addLib(0, langLib)
    interp addLib(1, floatLib)
    interp addLib(2, stringLib)
    interp addLib(99, consoleLib)
    try {
        interp run()
    } catch e: WmlsException {
        e message println()
    }
}

