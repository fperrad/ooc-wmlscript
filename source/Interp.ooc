/*
 *  ooc-wmlscript : <http://fperrad.github.com/lua-TestMore/>
 *
 *  Copyright (c) 2011 Francois Perrad
 *
 *  This code is licensed under the terms of the Artistic License 2.0.
 */

import structs/ArrayList
import structs/HashMap

import Types
import Bytecode

/*
WmlsLib: class extends HashMap<UInt, Func(Interp)> {
    init: func {
        super()
    }
}
*/

ContextReturn: class {
    variables: ArrayList<WmlsAny> { get set }
    functionIndex: UInt8 { get set }
    ip: UInt16 { get set }
    script: Script { get set }

    init: func~call(=variables, =functionIndex, =ip, =script) {}
}

Interp: class {
    libs:               HashMap<UInt, Func(Interp) -> WmlsAny >
    operandStack:       ArrayList<WmlsAny>
    callStack:          ArrayList<ContextReturn>
    constants:          ArrayList<WmlsAny>
    variables:          ArrayList<WmlsAny>
    script:             Script
    functionIndex:      UInt8
    nbVar:              UInt8
    nbCst:              UInt16
    codeArray:          ArrayList<UInt8>
    codeSize:           UInt16
    ip:                 UInt16  // Instruction Pointer

    init: func(capacity: SizeT,
                      =script,
                      =functionIndex,
                      args: ArrayList<String>) {
        libs = HashMap<UInt, Func(Interp) -> WmlsAny > new()
        operandStack = ArrayList<WmlsAny> new(capacity)
        callStack = ArrayList<ContextReturn> new()

        constants = script constants
        nbCst = constants getSize()
        fct := script functions[functionIndex]
        nbVar = fct numberOfArguments + fct numberOfLocalVariables
        variables = ArrayList<WmlsAny> new(nbVar)
        codeArray = fct codeArray
        codeSize = codeArray getSize()
        ip = 0

        for (arg in args)
            variables add(WmlsString new(arg))
        for (i in 0..fct numberOfLocalVariables)
            variables add(WmlsString new(""))
    }

    addLib: func(lindex: UInt16,
                 lib: HashMap<UInt8, Func(Interp) -> WmlsAny >) {
        lib each(|findex, fct| libs put(0x100 * lindex + findex, fct))
    }

    run: func {
        while (true) {
            idx0, idx1, idx2, idx3: UInt
//            dump()
            opcode := (ip != codeSize) ? codeArray[ip] : RETURN_ES
            ip += 1
            info := args[opcode]
            if (info != 0) {
                idx0 = 0
                match (info & 0x000F) {
                    case INLINE3 =>
                        idx0 = opcode & 0x07
                        opcode = opcode & 0xF8
                    case INLINE4 =>
                        idx0 = opcode & 0x0F
                        opcode = opcode & 0xF0
                    case INLINE5 =>
                        idx0 = opcode & 0x1F
                        opcode = opcode & 0xE0
                }
                idx1 = idx0
                info /= 0x10
                if (info != 0) {
                    idx1 = 0
                    match (info & 0x000F) {
                        case ARG8 =>
                            idx1 = codeArray[ip]
                            ip += 1
                        case ARG16 =>
                            idx1 = codeArray[ip] * 0x100
                            ip += 1
                            idx1 += codeArray[ip]
                            ip += 1
                    }
                    info /= 0x10
                    if (info != 0) {
                        idx2 = 0
                        match (info & 0x000F) {
                            case ARG8 =>
                                idx2 = codeArray[ip]
                                ip += 1
                            case ARG16 =>
                                idx2 = codeArray[ip] * 0x100
                                ip += 1
                                idx2 += codeArray[ip]
                                ip += 1
                        }
                        info /= 0x10
                        if (info != 0) {
                            idx3 = 0
                            idx3 = codeArray[ip]
                            ip += 1
                        }
                    }
                }
            }

            match opcode {
                case JUMP_FW_S =>
                    ip = ip + idx1
                    if (ip > codeSize)
                        error("VerificationFailed")
                case JUMP_FW =>
                    ip = ip + idx1
                    if (ip > codeSize)
                        error("VerificationFailed")
                case JUMP_FW_W =>
                    ip = ip + idx1
                    if (ip > codeSize)
                        error("VerificationFailed")
                case JUMP_BW_S =>
                    ip = ip - 1 - idx1
                    if (ip < 0)
                        error("VerificationFailed")
                case JUMP_BW =>
                    ip = ip - 2 - idx1
                    if (ip < 0)
                        error("VerificationFailed")
                case JUMP_BW_W =>
                    ip = ip - 3 - idx1
                    if (ip < 0)
                        error("VerificationFailed")
                case TJUMP_FW_S =>
                    if (! pop() _toBool()) {
                        ip = ip + idx1
                        if (ip > codeSize)
                            error("VerificationFailed")
                    }
                case TJUMP_FW =>
                    if (! pop() _toBool()) {
                        ip = ip + idx1
                        if (ip > codeSize)
                            error("VerificationFailed")
                    }
                case TJUMP_FW_W =>
                    if (! pop() _toBool()) {
                        ip = ip + idx1
                        if (ip > codeSize)
                            error("VerificationFailed")
                    }
                case TJUMP_BW =>
                    if (! pop() _toBool()) {
                        ip = ip - 2 - idx1
                        if (ip < 0)
                            error("VerificationFailed")
                    }
                case TJUMP_BW_W =>
                    if (! pop() _toBool()) {
                        ip = ip - 3 - idx1
                        if (ip < 0)
                            error("VerificationFailed")
                    }
                case CALL_S =>
                    call(idx1)
                case CALL =>
                    call(idx1)
                case CALL_LIB_S =>
                    callLib(idx0, idx1)
                case CALL_LIB =>
                    callLib(idx1, idx2)
                case CALL_LIB_W =>
                    callLib(idx1, idx2)
                case CALL_URL =>
                    callUrl(idx1, idx2, idx3)
                case CALL_URL_W =>
                    callUrl(idx1, idx2, idx3)
                case LOAD_VAR_S =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    push(variables[idx1])
                case LOAD_VAR =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    push(variables[idx1])
                case STORE_VAR_S =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = pop()
                case STORE_VAR =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = pop()
                case INCR_VAR_S =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = variables[idx1] incr()
                case INCR_VAR =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = variables[idx1] incr()
                case DECR_VAR =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = variables[idx1] decr()
                case LOAD_CONST_S =>
                    if (idx1 >= nbCst)
                        error("VerificationFailed")
                    push(constants[idx1])
                case LOAD_CONST =>
                    if (idx1 >= nbCst)
                        error("VerificationFailed")
                    push(constants[idx1])
                case LOAD_CONST_W =>
                    if (idx1 >= nbCst)
                        error("VerificationFailed")
                    push(constants[idx1])
                case CONST_0 =>
                    push(WmlsInteger new(0))
                case CONST_1 =>
                    push(WmlsInteger new(1))
                case CONST_M1 =>
                    push(WmlsInteger new(-1))
                case CONST_ES =>
                    push(WmlsString new(""))
                case CONST_INVALID =>
                    push(WmlsInvalid new())
                case CONST_TRUE =>
                    push(WmlsBoolean new(true))
                case CONST_FALSE =>
                    push(WmlsBoolean new(false))
                case INCR =>
                    push(pop() incr())
                case DECR =>
                    push(pop() decr())
                case ADD_ASG =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = variables[idx1] add(pop())
                case SUB_ASG =>
                    if (idx1 >= nbVar)
                        error("VerificationFailed")
                    variables[idx1] = variables[idx1] sub(pop())
                case UMINUS =>
                    push(pop() uminus())
                case ADD =>
                    op := pop()
                    push(pop() add(op))
                case SUB =>
                    op := pop()
                    push(pop() sub(op))
                case MUL =>
                    op := pop()
                    push(pop() mul(op))
                case DIV =>
                    op := pop()
                    push(pop() div(op))
                case IDIV =>
                    op := pop()
                    push(pop() idiv(op))
                case REM =>
                    op := pop()
                    push(pop() rem(op))
                case B_AND =>
                    op := pop()
                    push(pop() band(op))
                case B_OR =>
                    op := pop()
                    push(pop() bor(op))
                case B_XOR =>
                    op := pop()
                    push(pop() bxor(op))
                case B_NOT =>
                    push(pop() bnot())
                case B_LSHIFT =>
                    op := pop()
                    push(pop() blshift(op))
                case B_RSSHIFT =>
                    op := pop()
                    push(pop() brsshift(op))
                case B_RSZSHIFT =>
                    op := pop()
                    push(pop() brszshift(op))
                case EQ =>
                    op := pop()
                    push(pop() eq(op))
                case LE =>
                    op := pop()
                    push(pop() le(op))
                case LT =>
                    op := pop()
                    push(pop() lt(op))
                case GE =>
                    op := pop()
                    push(pop() ge(op))
                case GT =>
                    op := pop()
                    push(pop() gt(op))
                case NE =>
                    op := pop()
                    push(pop() ne(op))
                case NOT =>
                    push(pop() not())
                case SCAND =>
                    v := pop() toBool()
                    push(v)
                    if (v _toBool() == false)
                        push(WmlsBoolean new(false))
                case SCOR =>
                    v := pop() toBool()
                    if (v instanceOf?(WmlsBoolean) && v _toBool() == false)
                        push(WmlsBoolean new(true))
                    else {
                        push(v)
                        push(WmlsBoolean new(false))
                    }
                case TOBOOL =>
                    push(pop() toBool())
                case POP =>
                    pop()
                case TYPEOF =>
                    push(pop() typeOf())
                case ISVALID =>
                    push(pop() isValid())
                case RETURN =>
                    if (_return(pop()))
                        return
                case RETURN_ES =>
                    if (_return(WmlsString new("")))
                        return
                case DEBUG =>
                    /* nop */
                case =>
                    error("VerificationFailed")
            }
        }
    }

    push: inline func(elt: WmlsAny) {
        operandStack add(elt)
    }

    pop: inline func() -> WmlsAny {
        if (operandStack empty?())
            error("StackUnderflow")

        return operandStack removeAt(operandStack lastIndex())
    }

    call: inline func(findex: UInt8) {
        callStack add(ContextReturn new(variables, functionIndex , ip, script))
        if (findex >= script functions getSize())
            error("VerificationFailed")

        fct := script functions[findex]
        nbArg := fct numberOfArguments
        nbVar = nbArg + fct numberOfLocalVariables
        variables = ArrayList<WmlsAny> new(nbVar)
        for (i in 0..nbVar)
            variables add(WmlsString new(""))
        for (i in 0..nbArg)
            variables[nbArg - 1 - i] = pop()
        functionIndex = findex
        codeArray = fct codeArray
        codeSize = codeArray getSize()
        ip = 0
    }

    callUrl: inline func(urlindex, findex: UInt16, args: UInt8) {
        callStack add(ContextReturn new(variables, functionIndex , ip, script))
        if (urlindex >= nbCst)
            error("VerificationFailed")
        url := constants[urlindex]
        if (! url instanceOf?(WmlsString))
            error("VerificationFailed")
        if (findex >= nbCst)
            error("VerificationFailed")
        name := constants[findex]
        if (! name instanceOf?(WmlsString))
            error("VerificationFailed")
        script = Script new(url _toString())
        idx := script find(name _toString())
        script checkNbArg(idx, args)

        constants = script constants
        nbCst = constants getSize()
        fct := script functions[findex]
        nbArg := fct numberOfArguments
        nbVar = nbArg + fct numberOfLocalVariables
        variables = ArrayList<WmlsAny> new(nbVar)
        for (i in 0..nbVar)
            variables add(WmlsString new(""))
        for (i in 0..nbArg)
            variables[nbArg - 1 - i] = pop()
        functionIndex = findex
        codeArray = fct codeArray
        codeSize = codeArray getSize()
        ip = 0
    }

    _return: inline func(val: WmlsAny) -> Bool {
        push(val)

        if (callStack getSize() == 0) {
            return true
        }
        // restore context
        ctxt := callStack removeAt(callStack lastIndex())
        if (ctxt script != script) {
            script = ctxt script
            constants = script constants
            nbCst = constants getSize()
        }
        functionIndex = ctxt functionIndex
        fct := script functions[functionIndex]
        codeArray = fct codeArray
        codeSize = codeArray getSize()
        ip = ctxt ip
        variables = ctxt variables
        nbVar = variables getSize()
        return false
    }

    callLib: inline func(findex: UInt8, lindex: UInt16) {
        if (! libs contains?(0x100 * lindex + findex))
            error("VerificationFailed")
        fct := libs get(0x100 * lindex + findex)
        push(fct(this))
    }

    error: inline func(msg: String) {
        WmlsException new(This, msg) throw()
    }

    dump: func() {
        "-------------------------------" println()
        for (element in operandStack)
            element _repr() println()
        if (ip == codeSize)
            "IP %d\tEND" format(ip) println()
        else {
            fct := script functions[functionIndex]
            "IP %d\t%s" format(ip, fct _reprOpcode(ip)) println()
        }
    }
}

JUMP_FW_S       := const 0x80 as UInt8
JUMP_FW         := const 0x01 as UInt8
JUMP_FW_W       := const 0x02 as UInt8
JUMP_BW_S       := const 0xA0 as UInt8
JUMP_BW         := const 0x03 as UInt8
JUMP_BW_W       := const 0x04 as UInt8
TJUMP_FW_S      := const 0xC0 as UInt8
TJUMP_FW        := const 0x05 as UInt8
TJUMP_FW_W      := const 0x06 as UInt8
TJUMP_BW        := const 0x07 as UInt8
TJUMP_BW_W      := const 0x08 as UInt8
CALL_S          := const 0x60 as UInt8
CALL            := const 0x09 as UInt8
CALL_LIB_S      := const 0x68 as UInt8
CALL_LIB        := const 0x0A as UInt8
CALL_LIB_W      := const 0x0B as UInt8
CALL_URL        := const 0x0C as UInt8
CALL_URL_W      := const 0x0D as UInt8
LOAD_VAR_S      := const 0xE0 as UInt8
LOAD_VAR        := const 0x0E as UInt8
STORE_VAR_S     := const 0x40 as UInt8
STORE_VAR       := const 0x0F as UInt8
INCR_VAR_S      := const 0x70 as UInt8
INCR_VAR        := const 0x10 as UInt8
DECR_VAR        := const 0x11 as UInt8
LOAD_CONST_S    := const 0x50 as UInt8
LOAD_CONST      := const 0x12 as UInt8
LOAD_CONST_W    := const 0x13 as UInt8
CONST_0         := const 0x14 as UInt8
CONST_1         := const 0x15 as UInt8
CONST_M1        := const 0x16 as UInt8
CONST_ES        := const 0x17 as UInt8
CONST_INVALID   := const 0x18 as UInt8
CONST_TRUE      := const 0x19 as UInt8
CONST_FALSE     := const 0x1A as UInt8
INCR            := const 0x1B as UInt8
DECR            := const 0x1C as UInt8
ADD_ASG         := const 0x1D as UInt8
SUB_ASG         := const 0x1E as UInt8
UMINUS          := const 0x1F as UInt8
ADD             := const 0x20 as UInt8
SUB             := const 0x21 as UInt8
MUL             := const 0x22 as UInt8
DIV             := const 0x23 as UInt8
IDIV            := const 0x24 as UInt8
REM             := const 0x25 as UInt8
B_AND           := const 0x26 as UInt8
B_OR            := const 0x27 as UInt8
B_XOR           := const 0x28 as UInt8
B_NOT           := const 0x29 as UInt8
B_LSHIFT        := const 0x2A as UInt8
B_RSSHIFT       := const 0x2B as UInt8
B_RSZSHIFT      := const 0x2C as UInt8
EQ              := const 0x2D as UInt8
LE              := const 0x2E as UInt8
LT              := const 0x2F as UInt8
GE              := const 0x30 as UInt8
GT              := const 0x31 as UInt8
NE              := const 0x32 as UInt8
NOT             := const 0x33 as UInt8
SCAND           := const 0x34 as UInt8
SCOR            := const 0x35 as UInt8
TOBOOL          := const 0x36 as UInt8
POP             := const 0x37 as UInt8
TYPEOF          := const 0x38 as UInt8
ISVALID         := const 0x39 as UInt8
RETURN          := const 0x3A as UInt8
RETURN_ES       := const 0x3B as UInt8
DEBUG           := const 0x3C as UInt8

