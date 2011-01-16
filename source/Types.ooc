/*
 *  ooc-wmlscript : <http://fperrad.github.com/lua-TestMore/>
 *
 *  Copyright (c) 2011 Francois Perrad
 *
 *  This code is licensed under the terms of the Artistic License 2.0.
 */

WmlsException: class extends Exception {
    init: func(=origin, =message) {}
}

WmlsAny: abstract class {
    _repr: abstract func -> String
    _toString: abstract func -> String

    _toBool: inline func -> Bool {
        return false
    }

    _toInt: inline func -> Int {
        WmlsException new("runtime") throw()
        return 0    // avoid warning
    }

    _toFloat: inline func -> Float {
        WmlsException new("runtime") throw()
        return 0.0  // avoid warning
    }

    incr: func -> WmlsAny {
        return WmlsInvalid new()
    }

    decr: func -> WmlsAny {
        return WmlsInvalid new()
    }

    uminus: func -> WmlsAny {
        return WmlsInvalid new()
    }

    add: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    sub: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    mul: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    div: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    idiv: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    rem: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    band: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    bor: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    bxor: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    bnot: func -> WmlsAny {
        return WmlsInvalid new()
    }

    blshift: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    brsshift: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    brszshift: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    eq: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    le: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    lt: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    ge: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    gt: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    ne: func(op: WmlsAny) -> WmlsAny {
        return WmlsInvalid new()
    }

    not: func -> WmlsAny {
        return WmlsInvalid new()
    }

    toBool: func -> WmlsAny {
        return WmlsInvalid new()
    }

    typeOf: func -> WmlsAny {
        return WmlsInvalid new()
    }

    isValid: func -> WmlsAny {
        return WmlsInvalid new()
    }
}

WmlsNumber: abstract class extends WmlsAny {}

WmlsInteger: class extends WmlsNumber {
    v: Int32

    init: func(=v) {}

    _repr: inline func -> String {
        return "I " + _toString()
    }

    _toInt: inline func -> Int32 {
        return v
    }

    _toFloat: inline func -> Float {
        return v as Float
    }

    _toString: inline func -> String {
        return "%d" format(v)
    }

    _toBool: inline func -> Bool {
        return v != 0
    }

    incr: func -> WmlsAny {
        return WmlsInteger new(v + 1)
    }

    decr: func -> WmlsAny {
        return WmlsInteger new(v - 1)
    }

    uminus: func -> WmlsAny {
        return WmlsInteger new(-v)
    }

    add: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v + op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() + op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsString new(_toString() + op _toString())
        else
            return WmlsInvalid new()
    }

    sub: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v - op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() - op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this sub(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    mul: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v * op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() * op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this mul(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    div: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean)) {
            d := op _toFloat()
            if (d == 0.0)
                return WmlsInvalid new()
            else
                return WmlsFloat new(_toFloat() / d)
        }
        else if (op instanceOf?(WmlsFloat)) {
            d := op _toFloat()
            if (d == 0.0)
                return WmlsInvalid new()
            else
                return WmlsFloat new(_toFloat() / d)
        }
        else if (op instanceOf?(WmlsString))
            return this div(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    idiv: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean)) {
            d := op _toInt()
            if (d == 0)
                return WmlsInvalid new()
            else
                return WmlsInteger new(v / d)
        }
        else if (op instanceOf?(WmlsString))
            return this idiv(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    rem: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean)) {
            d := op _toInt()
            if (d == 0)
                return WmlsInvalid new()
            else
                return WmlsInteger new(v % d)
        }
        else if (op instanceOf?(WmlsString))
            return this idiv(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    band: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v & op _toInt())
        else if (op instanceOf?(WmlsString))
            return this band(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bor: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v | op _toInt())
        else if (op instanceOf?(WmlsString))
            return this bor(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bxor: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v ^ op _toInt())
        else if (op instanceOf?(WmlsString))
            return this bxor(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bnot: func -> WmlsAny {
        return WmlsInteger new(~v)
    }

    blshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v << op _toInt())
        else if (op instanceOf?(WmlsString))
            return this blshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    brsshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v >> op _toInt())
        else if (op instanceOf?(WmlsString))
            return this brsshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    brszshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(v >> op _toInt())
        else if (op instanceOf?(WmlsString))
            return this brszshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    eq: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v == op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() == op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) == 0)
        else
            return WmlsInvalid new()
    }

    le: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v <= op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() <= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) <= 0)
        else
            return WmlsInvalid new()
    }

    lt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v < op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() < op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) < 0)
        else
            return WmlsInvalid new()
    }

    ge: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v >= op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() >= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) >= 0)
        else
            return WmlsInvalid new()
    }

    gt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v > op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() > op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) > 0)
        else
            return WmlsInvalid new()
    }

    ne: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v != op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() != op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) != 0)
        else
            return WmlsInvalid new()
    }

    not: func -> WmlsAny {
        return WmlsBoolean new(! _toBool())
    }

    toBool: func -> WmlsAny {
        return WmlsBoolean new(_toBool())
    }

    typeOf: func -> WmlsAny {
        return WmlsInteger new(0)
    }

    isValid: func -> WmlsAny {
        return WmlsBoolean new(true)
    }
}

WmlsFloat: class extends WmlsNumber {
    v: Float

    init: func(=v) {}

    _repr: inline func -> String {
        return "F " + _toString()
    }

    _toFloat: inline func -> Float {
        return v
    }

    _toString: inline func -> String {
//        return "%f" format(v)
//        return v toString() // FIXME
        /* workaround */
        ip, dp: Int
        neg := v < 0.0
        ip = v
        dp = 100000*v - 100000*ip
        if (ip < 0)
            ip = - ip
        if (dp < 0)
            dp = - dp
        s:= "%s%d.%05d" format(neg ? "-" : "", ip, dp)
        while (s endsWith?("0"))
            s = s substring(0, s length() - 1)
        if (s endsWith?("."))
            s = s substring(0, s length() - 1)
        return s
    }

    _toBool: inline func -> Bool {
        return v != 0.0
    }

    incr: func -> WmlsAny {
        return WmlsFloat new(v + 1.0)
    }

    decr: func -> WmlsAny {
        return WmlsFloat new(v - 1.0)
    }

    uminus: func -> WmlsAny {
        return WmlsFloat new(-v)
    }

    add: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsFloat new(v + op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsString new(_toString() + op _toString())
        else
            return WmlsInvalid new()
    }

    sub: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsFloat new(v - op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this sub(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    mul: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsFloat new(v * op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this mul(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    div: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean)) {
            d := op _toFloat()
            if (d == 0.0)
                return WmlsInvalid new()
            else
                return WmlsFloat new(v / d)
        }
        else if (op instanceOf?(WmlsString))
            return this div(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    eq: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v == op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) == 0)
        else
            return WmlsInvalid new()
    }

    le: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v <= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) <= 0)
        else
            return WmlsInvalid new()
    }

    lt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v < op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) < 0)
        else
            return WmlsInvalid new()
    }

    ge: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v >= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) >= 0)
        else
            return WmlsInvalid new()
    }

    gt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v > op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) > 0)
        else
            return WmlsInvalid new()
    }

    ne: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(v != op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) != 0)
        else
            return WmlsInvalid new()
    }

    not: func -> WmlsAny {
        return WmlsBoolean new(! _toBool())
    }

    toBool: func -> WmlsAny {
        return WmlsBoolean new(_toBool())
    }

    typeOf: func -> WmlsAny {
        return WmlsInteger new(1)
    }

    isValid: func -> WmlsAny {
        return WmlsBoolean new(true)
    }
}

WmlsString: class extends WmlsAny {
    v: String

    init: func(=v) {}

    init: func~empty() {
        v = ""
    }

    _repr: inline func -> String {
        return "S " + _toString()
    }

    _toString: inline func -> String {
        return v
    }

    _toBool: inline func -> Bool {
        return v != ""
    }

    uminus: func -> WmlsAny {
        return parseNumber() uminus()
    }

    add: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsString new(v + op _toString())
    }

    sub: func(op: WmlsAny) -> WmlsAny {
        return parseNumber() sub(op)
    }

    mul: func(op: WmlsAny) -> WmlsAny {
        return parseNumber() mul(op)
    }

    div: func(op: WmlsAny) -> WmlsAny {
        return parseNumber() div(op)
    }

    idiv: func(op: WmlsAny) -> WmlsAny {
        return parseInt() idiv(op)
    }

    rem: func(op: WmlsAny) -> WmlsAny {
        return parseInt() rem(op)
    }

    band: func(op: WmlsAny) -> WmlsAny {
        return parseInt() band(op)
    }

    bor: func(op: WmlsAny) -> WmlsAny {
        return parseInt() bor(op)
    }

    bxor: func(op: WmlsAny) -> WmlsAny {
        return parseInt() bxor(op)
    }

    bnot: func -> WmlsAny {
        return parseInt() bnot()
    }

    blshift: func(op: WmlsAny) -> WmlsAny {
        return parseInt() blshift(op)
    }

    brsshift: func(op: WmlsAny) -> WmlsAny {
        return parseInt() brsshift(op)
    }

    brszshift: func(op: WmlsAny) -> WmlsAny {
        return parseInt() brszshift(op)
    }

    eq: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) == 0)
    }

    le: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) <= 0)
    }

    lt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) < 0)
    }

    ge: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) >= 0)
    }

    gt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) > 0)
    }

    ne: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInvalid))
            return WmlsInvalid new()
        else
            return WmlsBoolean new(strcmp(v, op _toString()) != 0)
    }

    not: func -> WmlsAny {
        return WmlsBoolean new(! _toBool())
    }

    toBool: func -> WmlsAny {
        return WmlsBoolean new(_toBool())
    }

    typeOf: func -> WmlsAny {
        return WmlsInteger new(2)
    }

    isValid: func -> WmlsAny {
        return WmlsBoolean new(true)
    }

    parseInt: inline func -> WmlsAny {
        s1, s2: CString
        s1 = v toCString()
        d := strtol(s1, s2&, 10)

        if (s1 != s2 && (s2[0] == '\0' || s2[0] whitespace?()))
            return WmlsInteger new(d)
        else
            return WmlsInvalid new()
    }

    parseFloat: inline func -> WmlsAny {
        s1, s2: CString
        s1 = v toCString()
        d := strtod(s1, s2&)

        if (s1 != s2 && (s2[0] == '\0' || s2[0] whitespace?()))
            return WmlsFloat new(d)
        else
            return WmlsInvalid new()
    }

    parseNumber: inline func -> WmlsAny {
        r := parseInt()
        if (r instanceOf?(WmlsInvalid))
            r = parseFloat()
        return r
    }
}

WmlsBoolean: class extends WmlsAny {
    v: Bool

    init: func(=v) {}

    _repr: inline func -> String {
        return "B " + _toString()
    }

    _toInt: inline func -> Int32 {
        return v ? 1 : 0
    }

    _toFloat: inline func -> Float {
        return v ? 1.0 : 0.0
    }

    _toString: inline func -> String {
        return v ? "true" : "false"
    }

    _toBool: inline func -> Bool {
        return v
    }

    incr: func -> WmlsAny {
        return WmlsInteger new(_toInt() + 1)
    }

    decr: func -> WmlsAny {
        return WmlsInteger new(_toInt() - 1)
    }

    uminus: func -> WmlsAny {
        return WmlsInteger new(v ? -1 : 0)
    }

    add: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() + op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() + op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsString new(_toString() + op _toString())
        else
            return WmlsInvalid new()
    }

    sub: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() - op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() - op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this sub(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    mul: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() * op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsFloat new(_toFloat() * op _toFloat())
        else if (op instanceOf?(WmlsString))
            return this mul(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    div: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsNumber) || op instanceOf?(WmlsBoolean)) {
            d := op _toFloat()
            if (d == 0.0)
                return WmlsInvalid new()
            else
                return WmlsFloat new(_toFloat() / d)
        }
        else if (op instanceOf?(WmlsString))
            return this div(op as WmlsString parseNumber())
        else
            return WmlsInvalid new()
    }

    idiv: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean)) {
            d := op _toInt()
            if (d == 0)
                return WmlsInvalid new()
            else
                return WmlsInteger new(_toInt() / d)
        }
        else if (op instanceOf?(WmlsString))
            return this idiv(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    rem: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean)) {
            d := op _toInt()
            if (d == 0)
                return WmlsInvalid new()
            else
                return WmlsInteger new(_toInt() % d)
        }
        else if (op instanceOf?(WmlsString))
            return this idiv(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    band: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() & op _toInt())
        else if (op instanceOf?(WmlsString))
            return this band(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bor: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() | op _toInt())
        else if (op instanceOf?(WmlsString))
            return this bor(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bxor: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() ^ op _toInt())
        else if (op instanceOf?(WmlsString))
            return this bxor(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    bnot: func -> WmlsAny {
        return WmlsInteger new(~ _toInt())
    }

    blshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() << op _toInt())
        else if (op instanceOf?(WmlsString))
            return this blshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    brsshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() >> op _toInt())
        else if (op instanceOf?(WmlsString))
            return this brsshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    brszshift: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsInteger new(_toInt() >> op _toInt())
        else if (op instanceOf?(WmlsString))
            return this brszshift(op as WmlsString parseInt())
        else
            return WmlsInvalid new()
    }

    eq: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() == op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() == op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) == 0)
        else
            return WmlsInvalid new()
    }

    le: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() <= op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() <= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) <= 0)
        else
            return WmlsInvalid new()
    }

    lt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() < op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() < op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) < 0)
        else
            return WmlsInvalid new()
    }

    ge: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() >= op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() >= op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) >= 0)
        else
            return WmlsInvalid new()
    }

    gt: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() > op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() > op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) > 0)
        else
            return WmlsInvalid new()
    }

    ne: func(op: WmlsAny) -> WmlsAny {
        if (op instanceOf?(WmlsInteger) || op instanceOf?(WmlsBoolean))
            return WmlsBoolean new(_toInt() != op _toInt())
        else if (op instanceOf?(WmlsFloat))
            return WmlsBoolean new(_toFloat() != op _toFloat())
        else if (op instanceOf?(WmlsString))
            return WmlsBoolean new(strcmp(_toString(), op _toString()) != 0)
        else
            return WmlsInvalid new()
    }

    not: func -> WmlsAny {
        return WmlsBoolean new(!v)
    }

    toBool: func -> WmlsAny {
        return WmlsBoolean new(v)
    }

    typeOf: func -> WmlsAny {
        return WmlsInteger new(3)
    }

    isValid: func -> WmlsAny {
        return WmlsBoolean new(true)
    }
}

WmlsInvalid: class extends WmlsAny {
    init: func() {}

    _repr: inline func -> String {
        return "$ invalid"
    }

    _toString: inline func -> String {
        return "invalid"
    }

    typeOf: func -> WmlsAny {
        return WmlsInteger new(4)
    }

    isValid: func -> WmlsAny {
        return WmlsBoolean new(false)
    }
}

