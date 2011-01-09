/*
 *  ooc-wmlscript : <http://fperrad.github.com/lua-TestMore/>
 *
 *  Copyright (c) 2011 Francois Perrad
 *
 *  This code is licensed under the terms of the Artistic License 2.0.
 */

import structs/ArrayList
import Bytecode

main: func(args: ArrayList<String>) {
    if (args getSize() != 2) {
        ("Usage: " + args[0] + " filename") println()
        exit(-1)
    }
    Script new(args[1]) dump()
}

