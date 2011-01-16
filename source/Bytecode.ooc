/*
 *  ooc-wmlscript : <http://fperrad.github.com/lua-TestMore/>
 *
 *  Copyright (c) 2011 Francois Perrad
 *
 *  This code is licensed under the terms of the Artistic License 2.0.
 */

import io/FileReader
import io/Reader
import structs/ArrayList
import structs/HashMap

import Types

getMB16: inline func(stream: Reader) -> UInt16 {
    value := 0 as UInt16
    while (true) {
        c := stream read() as UInt8
        value *= 0x80
        value += (c & 0x7F)
        if ((c & 0x80) == 0)
            break
    }
    return value
}

getMB32: inline func(stream: Reader) -> UInt32 {
    value := 0 as UInt32
    while (true) {
        c := stream read() as UInt8
        value *= 0x80
        value += (c & 0x7F)
        if ((c & 0x80) == 0)
            break
    }
    return value
}

getUInt8: inline func(stream: Reader) -> UInt8 {
    return stream read() as UInt8
}

getUInt16: inline func(stream: Reader) -> UInt16 {
    value: UInt16
    c := stream read() as UInt8
    value = c & 0xFF
    c = stream read() as UInt8
    value *= 0x100
    value += (c & 0xFF)
    return value
}

getInt8: inline func(stream: Reader) -> Int8 {
    return stream read() as Int8
}

getInt16: inline func(stream: Reader) -> Int16 {
    value: Int16
    c := stream read() as UInt8
    value = c & 0xFF
    c = stream read() as UInt8
    value *= 0x100
    value += (c & 0xFF)
    return value
}

getInt32: inline func(stream: Reader) -> Int32 {
    value: Int16
    c := stream read() as UInt8
    value = c & 0xFF
    c = stream read() as UInt8
    value *= 0x100
    value += (c & 0xFF)
    c = stream read() as UInt8
    value *= 0x100
    value += (c & 0xFF)
    c = stream read() as UInt8
    value *= 0x100
    value += (c & 0xFF)
    return value
}

getFloat: inline func(stream: Reader) -> Float {
    value := 0.0 as Float
    // FIXME
    c := stream read() as UInt8
    c = stream read() as UInt8
    c = stream read() as UInt8
    c = stream read() as UInt8
    return value
}

getString: inline func(stream: Reader, size: Int32) -> String {
    buff := CString new(size)
    stream read(buff, 0, size)
    return String new(buff, size)
}

Script: class {
    filename:                   String
    versionNumber:              UInt8
    codeSize:                   UInt32
    characterSet:               UInt16
    constants:                  ArrayList<WmlsAny> { get set }
    pragmas:                    ArrayList<Pragma>
    functionNameTable:          HashMap<String, UInt8>
    functions:                  ArrayList<Function> { get set }

    init: func(=filename) {
        stream := FileReader new(filename)
        versionNumber = getUInt8(stream)
        if (versionNumber != 0x01)
            WmlsException new("incorrect version") throw()
        codeSize = getMB32(stream)

        numberOfConstants := getMB16(stream)
        characterSet = getMB16(stream)
        constants = ArrayList<WmlsAny> new(numberOfConstants)
        for (i in 0..numberOfConstants) {
            constantType := getUInt8(stream)
            cst: WmlsAny
            match constantType {
                case 0 =>
                    cst = WmlsInteger new(getInt8(stream) as Int32)
                case 1 =>
                    cst = WmlsInteger new(getInt16(stream) as Int32)
                case 2 =>
                    cst = WmlsInteger new(getInt32(stream))
                case 3 =>
                    cst = WmlsFloat new(getFloat(stream))
                case 4 =>
                    stringSize := getMB32(stream)
                    cst = WmlsString new(getString(stream, stringSize))
                case 5 =>
                    cst = WmlsString new()
                case 6 =>
                    stringSize := getMB32(stream)
                    cst = WmlsString new(getString(stream, stringSize))
                case =>
                    msg := "invalid ConstantType [%d]." format(constantType)
                    WmlsException new(msg) throw()
            }
            constants add(cst)
        }

        numberOfPragmas := getMB16(stream)
        pragmas = ArrayList<Pragma> new(numberOfPragmas)
        for (i in 0..numberOfPragmas) {
            pragmaType := getUInt8(stream)
            prg: Pragma
            match pragmaType {
                case 0 =>
                    accessDomainIndex := getMB16(stream)
                    prg = AccessDomain new(accessDomainIndex)
                case 1 =>
                    accessPathIndex := getMB16(stream)
                    prg = AccessPath new(accessPathIndex)
                case 2 =>
                    propertyNameIndex := getMB16(stream)
                    contentIndex := getMB16(stream)
                    prg = UserAgentProperty new(propertyNameIndex,
                                                contentIndex)
                case 3 =>
                    propertyNameIndex := getMB16(stream)
                    contentIndex := getMB16(stream)
                    schemeIndex := getMB16(stream)
                    prg = UserAgentPropertyScheme new(propertyNameIndex,
                                                      contentIndex,
                                                      schemeIndex)
                case =>
                    msg := "invalid PragmaType [%d]." format(pragmaType)
                    WmlsException new(msg) throw()
            }
            pragmas add(prg)
        }

        numberOfFunctions := getUInt8(stream)
        numberOfFunctionNames := getUInt8(stream)
        functionNameTable = HashMap<String, UInt8> new()
        for (i in 0..numberOfFunctionNames) {
            functionIndex := getUInt8(stream)
            functionNameSize := getUInt8(stream)
            name := getString(stream, functionNameSize)
            functionNameTable put(name, functionIndex)
        }
        functions = ArrayList<Function> new(numberOfFunctions)
        for (i in 0..numberOfFunctions) {
            numberOfArguments := getUInt8(stream)
            numberOfLocalVariables := getUInt8(stream)
            functionSize := getMB16(stream)
            codeArray := ArrayList<UInt8> new(functionSize)
            for (j in 0..functionSize)
                codeArray add(getUInt8(stream))
            fct := Function new(numberOfArguments,
                                numberOfLocalVariables,
                                codeArray)
            functions add(fct)
        }
    }

    find: func(name: String) -> UInt8 {
        if (!functionNameTable contains?(name))
             WmlsException new("ExternalFunctionNotFound " + name) throw()
        return functionNameTable get(name)
    }

    checkNbArg: func(findex, nb: UInt8) {
        if (nb != functions[findex] numberOfArguments)
             WmlsException new("InvalidFunctionArguments") throw()
    }

    dump: func {
        ("## file:" + filename) println()
        "##" println()
        "## Bytecode Header" println()
        "##" println()
        major := 1 + versionNumber / 16
        minor := versionNumber % 16
        "VersionNumber %d.%d" format(major, minor) println()
        "CodeSize %d" format(codeSize) println()

        "## Constant Pool" println()
        "##" println()
        numberOfConstants := constants getSize()
        "NumberOfConstants %d" format(numberOfConstants) println()
        "CharacterSet %d" format(characterSet) println()
        for (i in 0..numberOfConstants)
            "cst%d %s" format(i, constants[i] _repr()) println()

        "## Pragma Pool" println()
        "##" println()
        numberOfPragmas := pragmas getSize()
        "NumberOfPragmas %d" format(numberOfPragmas) println()
        for (i in 0..numberOfPragmas)
            "pragma%d %s" format(i, pragmas[i] _repr()) println()

        "## Function Pool" println()
        "##" println()
        numberOfFunctions := functions getSize()
        "NumberOfFunctions %d" format(numberOfFunctions) println()
        "## Function Name Table" println()
        "NumberOfFunctionNames %d" format(functionNameTable size) println()
        functionNameTable each(|name, idx|
            "%d %s" format(idx, name) println()
        )
        for (i in 0..numberOfFunctions) {
            "## function %d" format(i) println()
             functions[i] _repr() println()
        }
        "## EOF" println()
    }
}

Pragma: abstract class {
    _repr: abstract func -> String
}

AccessDomain: class extends Pragma {
    accessDomainIndex:          UInt16 { get set }

    init: func(=accessDomainIndex) {}

    _repr: func -> String {
        return "AccessDomain %d" format(accessDomainIndex)
    }
}

AccessPath: class extends Pragma {
    accessPathIndex:            UInt16 { get set }

    init: func(=accessPathIndex) {}

    _repr: func -> String {
        return "AccessPath %d" format(accessPathIndex)
    }
}

UserAgentProperty: class extends Pragma {
    propertyNameIndex:          UInt16 { get set }
    contentIndex:               UInt16 { get set }

    init: func(=propertyNameIndex, =contentIndex) {}

    _repr: func -> String {
        return "UserAgentProperty %d %d" format(propertyNameIndex,
                                                contentIndex)
    }
}

UserAgentPropertyScheme: class extends Pragma {
    propertyNameIndex:          UInt16 { get set }
    contentIndex:               UInt16 { get set }
    schemeIndex:                UInt16 { get set }

    init: func(=propertyNameIndex, =contentIndex, =schemeIndex) {}

    _repr: func -> String {
        return "UserAgentPropertyScheme %d %d %d" format(propertyNameIndex,
                                                         contentIndex,
                                                         schemeIndex)
    }
}

Function: class {
    numberOfArguments:          UInt8 { get set }
    numberOfLocalVariables:     UInt8 { get set }
    codeArray:                  ArrayList<UInt8> { get set }

    init: func(=numberOfArguments, =numberOfLocalVariables, =codeArray) {}

    _repr: func -> String {
        functionSize := codeArray getSize() as UInt16
        l := ArrayList<String> new(3 + functionSize)
        l add("NumberOfArgument %d" format(numberOfArguments))
        l add("NumberOfLocalVariables %d" format(numberOfLocalVariables))
        l add("FunctionSize %d" format(functionSize))
        offset := 0 as UInt16
        while (offset < functionSize)
            l add(_reprOpcode(offset&))
        return l join("\n")
    }

    _reprOpcode: func~safe(offset: UInt16) -> String {
        return _reprOpcode(offset&)
    }

    _reprOpcode: func(offset: UInt16@) -> String {
        opcode := codeArray[offset]
        offset += 1
        s := "%-12s" format(nmemo[opcode])
        while (s length() < 12) s += " " // workaround
        info := args[opcode]
        match (info & 0x000F) {
            case INLINE3 =>
                s += "%7u" format(opcode & 0x07)
            case INLINE4 =>
                s += "%7u" format(opcode & 0x0F)
            case INLINE5 =>
                s += "%7u" format(opcode & 0x1F)
        }
        info /= 0x10
        while (info != 0) {
            match (info & 0x000F) {
                case ARG8 =>
                    arg := codeArray[offset]
                    offset += 1
                    s += "%7u" format(arg)
                case ARG16 =>
                    arg := codeArray[offset] * 0x100
                    offset += 1
                    arg += codeArray[offset]
                    offset += 1
                    s += "%7u" format(arg)
            }
            info /= 0x10
        }
        return s
    }
}

NO_INLINE   := const 0
INLINE3     := const 3
INLINE4     := const 4
INLINE5     := const 5
ARG8        := const 1
ARG16       := const 2

args := [
    NO_INLINE,  // 00
    NO_INLINE + ARG8 * 0x10,  // JUMP_FW
    NO_INLINE + ARG16 * 0x10, // JUMP_FW_W
    NO_INLINE + ARG8 * 0x10,  // JUMP_BW
    NO_INLINE + ARG16 * 0x10, // JUMP_BW_W
    NO_INLINE + ARG8 * 0x10,  // TJUMP_FW
    NO_INLINE + ARG16 * 0x10, // TJUMP_FW_W
    NO_INLINE + ARG8 * 0x10,  // TJUMP_BW
    NO_INLINE + ARG16 * 0x10, // TJUMP_BW_W
    NO_INLINE + ARG8 * 0x10,  // CALL
    NO_INLINE + ARG8 * 0x10 + ARG8 * 0x100,     // CALL_LIB
    NO_INLINE + ARG8 * 0x10 + ARG16 * 0x100,    // CALL_LIB_W
    NO_INLINE + ARG8 * 0x10 + ARG8 * 0x100 + ARG8 * 0x1000,   // CALL_URL
    NO_INLINE + ARG16 * 0x10 + ARG16 * 0x100 + ARG8 * 0x1000, // CALL_URL_W
    NO_INLINE + ARG8 * 0x10,  // LOAD_VAR
    NO_INLINE + ARG8 * 0x10,  // STORE_VAR
    NO_INLINE + ARG8 * 0x10,  // INCR_VAR
    NO_INLINE + ARG8 * 0x10,  // DECR_VAR
    NO_INLINE + ARG8 * 0x10,  // LOAD_CONST
    NO_INLINE + ARG16 * 0x10, // LOAD_CONST_W
    NO_INLINE,  // CONST_0
    NO_INLINE,  // CONST_1
    NO_INLINE,  // CONST_M1
    NO_INLINE,  // CONST_ES
    NO_INLINE,  // CONST_INVALID
    NO_INLINE,  // CONST_TRUE
    NO_INLINE,  // CONST_FALSE
    NO_INLINE,  // INCR
    NO_INLINE,  // DECR
    NO_INLINE + ARG8 * 0x10,  // ADD_ASG
    NO_INLINE + ARG8 * 0x10,  // SUB_ASG
    NO_INLINE,  // UMINUS
    NO_INLINE,  // ADD
    NO_INLINE,  // SUB
    NO_INLINE,  // MUL
    NO_INLINE,  // DIV
    NO_INLINE,  // IDIV
    NO_INLINE,  // REM
    NO_INLINE,  // B_AND
    NO_INLINE,  // B_OR
    NO_INLINE,  // B_XOR
    NO_INLINE,  // B_NOT
    NO_INLINE,  // B_LSHIFT
    NO_INLINE,  // B_RSSHIFT
    NO_INLINE,  // B_RSZSHIFT
    NO_INLINE,  // EQ
    NO_INLINE,  // LE
    NO_INLINE,  // LT
    NO_INLINE,  // GE
    NO_INLINE,  // GT
    NO_INLINE,  // NE
    NO_INLINE,  // NOT
    NO_INLINE,  // SCAND
    NO_INLINE,  // SCOR
    NO_INLINE,  // TOBOOL
    NO_INLINE,  // POP
    NO_INLINE,  // TYPEOF
    NO_INLINE,  // ISVALID
    NO_INLINE,  // RETURN
    NO_INLINE,  // RETURN_ES
    NO_INLINE,  // DEBUG
    NO_INLINE,  // 3D
    NO_INLINE,  // 3E
    NO_INLINE,  // 3F
    INLINE4,    // STORE_VAR_S
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,    // LOAD_CONST_S
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE4,
    INLINE3,    // CALL_S
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3 + ARG8 * 0x10,    // CALL_LIB_S
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3 + ARG8 * 0x10,
    INLINE3,    // INCR_VAR_S
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    INLINE3,
    NO_INLINE,  // 78
    NO_INLINE,  // 79
    NO_INLINE,  // 7A
    NO_INLINE,  // 7B
    NO_INLINE,  // 7C
    NO_INLINE,  // 7D
    NO_INLINE,  // 7E
    NO_INLINE,  // 7F
    INLINE5,    // JUMP_FW_S
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,    // JUMP_BW_S
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,    // TJUMP_FW_S
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,    // LOAD_VAR_S
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5,
    INLINE5
]

nmemo := [
    "?-00",
    "JUMP_FW",
    "JUMP_FW_W",
    "JUMP_BW",
    "JUMP_BW_W",
    "TJUMP_FW",
    "TJUMP_FW_W",
    "TJUMP_BW",
    "TJUMP_BW_W",
    "CALL",
    "CALL_LIB",
    "CALL_LIB_W",
    "CALL_URL",
    "CALL_URL_W",
    "LOAD_VAR",
    "STORE_VAR",
    "INCR_VAR",
    "DECR_VAR",
    "LOAD_CONST",
    "LOAD_CONST_W",
    "CONST_0",
    "CONST_1",
    "CONST_M1",
    "CONST_ES",
    "CONST_INVALID",
    "CONST_TRUE",
    "CONST_FALSE",
    "INCR",
    "DECR",
    "ADD_ASG",
    "SUB_ASG",
    "UMINUS",
    "ADD",
    "SUB",
    "MUL",
    "DIV",
    "IDIV",
    "REM",
    "B_AND",
    "B_OR",
    "B_XOR",
    "B_NOT",
    "B_LSHIFT",
    "B_RSSHIFT",
    "B_RSZSHIFT",
    "EQ",
    "LE",
    "LT",
    "GE",
    "GT",
    "NE",
    "NOT",
    "SCAND",
    "SCOR",
    "TOBOOL",
    "POP",
    "TYPEOF",
    "ISVALID",
    "RETURN",
    "RETURN_ES",
    "DEBUG",
    "?-3D",
    "?-3E",
    "?-3F",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "STORE_VAR_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "LOAD_CONST_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "CALL_LIB_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "INCR_VAR_S",
    "?-78",
    "?-79",
    "?-7A",
    "?-7B",
    "?-7C",
    "?-7D",
    "?-7E",
    "?-7F",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_FW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "JUMP_BW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "TJUMP_FW_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S",
    "LOAD_VAR_S"
]

