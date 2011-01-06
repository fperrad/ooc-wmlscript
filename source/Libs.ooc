
import math
import math/Random
import os/Time
import structs/HashMap

import Interp
import Types

langLib := HashMap<UInt8, Func(Interp) -> WmlsAny > new()

langLib put(0, func(interp: Interp) -> WmlsAny {
    // abs(number)
    val := interp pop()
    if (val instanceOf?(WmlsInteger))
        return WmlsInteger new(val _toInt() abs())
    else if (val instanceOf?(WmlsFloat))
        return WmlsFloat new(val _toFloat() abs())
    else
        return WmlsInvalid new()
})

langLib put(1, func(interp: Interp) -> WmlsAny {
    // min(number1, number2)
    val2 := interp pop()
    val1 := interp pop()
    if (val1 instanceOf?(WmlsString))
        val1 = val1 as WmlsString parseNumber()
    if (val2 instanceOf?(WmlsString))
        val2 = val2 as WmlsString parseNumber()
    diff := val1 sub(val2)
    if (diff instanceOf?(WmlsInteger)) {
        if (diff _toInt() < 0)
            return WmlsInteger new(val1 _toInt())
        else
            return WmlsInteger new(val2 _toInt())
    }
    else if (diff instanceOf?(WmlsFloat)) {
        if (diff _toFloat() < 0.0)
            return WmlsFloat new(val1 _toFloat())
        else
            return WmlsFloat new(val2 _toFloat())
    }
    else
        return WmlsInvalid new()
})

langLib put(2, func(interp: Interp) -> WmlsAny {
    // max(number1, number2)
    val2 := interp pop()
    val1 := interp pop()
    if (val1 instanceOf?(WmlsString))
        val1 = val1 as WmlsString parseNumber()
    if (val2 instanceOf?(WmlsString))
        val2 = val2 as WmlsString parseNumber()
    diff := val1 sub(val2)
    if (diff instanceOf?(WmlsInteger)) {
        if (diff _toInt() >= 0)
            return WmlsInteger new(val1 _toInt())
        else
            return WmlsInteger new(val2 _toInt())
    }
    else if (diff instanceOf?(WmlsFloat)) {
        if (diff _toFloat() >= 0.0)
            return WmlsFloat new(val1 _toFloat())
        else
            return WmlsFloat new(val2 _toFloat())
    }
    else
        return WmlsInvalid new()
})

langLib put(3, func(interp: Interp) -> WmlsAny {
    // parseInt(string)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        return val as WmlsString parseInt()
    else if (val instanceOf?(WmlsInteger))
        return WmlsInteger new(val _toInt())
    else
        return WmlsInvalid new()
})

langLib put(4, func(interp: Interp) -> WmlsAny {
    // parseFloat(string)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        return val as WmlsString parseInt()
    else if (val instanceOf?(WmlsNumber))
        return WmlsFloat new(val _toFloat())
    else
        return WmlsInvalid new()
})

langLib put(5, func(interp: Interp) -> WmlsAny {
    // isInt(value)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseInt()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else
        return WmlsBoolean new(val instanceOf?(WmlsInteger))
})

langLib put(6, func(interp: Interp) -> WmlsAny {
    // isFloat(value)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseFloat()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else
        return WmlsBoolean new(val instanceOf?(WmlsNumber))
})

langLib put(7, func(interp: Interp) -> WmlsAny {
    // maxInt()
    return WmlsInteger new(INT_MAX)
})

langLib put(8, func(interp: Interp) -> WmlsAny {
    // minInt()
    return WmlsInteger new(INT_MIN)
})

langLib put(9, func(interp: Interp) -> WmlsAny {
    // float()
    return WmlsBoolean new(true)
})

langLib put(10, func(interp: Interp) -> WmlsAny {
    // exit(code)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsNumber))
        exit(val _toInt())
    else
        exit(0)
    return null // avoid warning
})

langLib put(11, func(interp: Interp) -> WmlsAny {
    // abort(msg)
    val := interp pop()
    interp error(val _toString())
    return null // avoid warning
})

langLib put(12, func(interp: Interp) -> WmlsAny {
    // random(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsInvalid) || val _toInt() < 0)
        return WmlsInvalid new()
    max := val _toInt()
    return WmlsInteger new(max == 0 ? 0 : rand() % (max+1))
})

langLib put(13, func(interp: Interp) -> WmlsAny {
    // seed(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    seed := val _toInt()
    srand(seed >= 0 ? seed : Time microtime())
    return WmlsString new("")
})

langLib put(14, func(interp: Interp) -> WmlsAny {
    // characterSet()
    return WmlsInteger new(4)
})


floatLib := HashMap<UInt8, Func(Interp) -> WmlsAny > new()

floatLib put(0, func(interp: Interp) -> WmlsAny {
    // int(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsNumber))
        return WmlsInteger new(val _toInt())
    else
        return WmlsInvalid new()
})

floatLib put(1, func(interp: Interp) -> WmlsAny {
    // floor(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsNumber))
        return WmlsInteger new(val _toFloat() floor())
    else
        return WmlsInvalid new()
})

floatLib put(2, func(interp: Interp) -> WmlsAny {
    // ceil(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsNumber))
        return WmlsInteger new(val _toFloat() ceil())
    else
        return WmlsInvalid new()
})

floatLib put(3, func(interp: Interp) -> WmlsAny {
    // pow(number1, number2)
    val2 := interp pop()
    val1 := interp pop()
    if (val1 instanceOf?(WmlsString))
        val1 = val1 as WmlsString parseNumber()
    if (val2 instanceOf?(WmlsString))
        val2 = val2 as WmlsString parseNumber()
    if (val1 instanceOf?(WmlsNumber) && val2 instanceOf?(WmlsNumber))
        return WmlsFloat new(val1 _toFloat() pow(val2 _toFloat()))
    else
        return WmlsInvalid new()
})

floatLib put(4, func(interp: Interp) -> WmlsAny {
    // round(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (val instanceOf?(WmlsNumber))
        return WmlsInteger new(val _toFloat() round())
    else
        return WmlsInvalid new()
})

floatLib put(5, func(interp: Interp) -> WmlsAny {
    // sqrt(number)
    val := interp pop()
    if (val instanceOf?(WmlsString))
        val = val as WmlsString parseNumber()
    if (! val instanceOf?(WmlsNumber) || val _toFloat() < 0)
        return WmlsInvalid new()
    else
        return WmlsFloat new(val _toFloat() sqrt())
})

floatLib put(6, func(interp: Interp) -> WmlsAny {
    // maxFloat()
    return WmlsFloat new(FLT_MAX)
})

floatLib put(7, func(interp: Interp) -> WmlsAny {
    // minFloat()
    return WmlsFloat new(FLT_MIN)
})


stringLib := HashMap<UInt8, Func(Interp) -> WmlsAny > new()

stringLib put(0, func(interp: Interp) -> WmlsAny {
    // length(string)
    val := interp pop()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else
        return WmlsInteger new(val _toString() length())
})

stringLib put(1, func(interp: Interp) -> WmlsAny {
    // isEmpty(string)
    val := interp pop()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else
        return WmlsBoolean new(val _toString() length() == 0)
})

stringLib put(2, func(interp: Interp) -> WmlsAny {
    // charAt(string, index)
    idx := interp pop()
    str := interp pop()
    if (idx instanceOf?(WmlsString))
        idx = idx as WmlsString parseNumber()
    if (str instanceOf?(WmlsInvalid) || idx instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    s := str _toString()
    len := s length()
    i := idx _toInt()
    return WmlsString new(i >= 0 && i < len ? s substring(i, 1) : "")
})

stringLib put(3, func(interp: Interp) -> WmlsAny {
    // subString(string, startIndex, length)
    len := interp pop()
    idx := interp pop()
    str := interp pop()
    if (len instanceOf?(WmlsString))
        len = len as WmlsString parseNumber()
    if (idx instanceOf?(WmlsString))
        idx = idx as WmlsString parseNumber()
    if (str instanceOf?(WmlsInvalid) || idx instanceOf?(WmlsInvalid) ||
        len instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    s := str _toString()
    i := idx _toInt()
    l := len _toInt()
    return WmlsString new(s substring(i, l))
})

stringLib put(4, func(interp: Interp) -> WmlsAny {
    // find(string, subString)
    sub := interp pop()
    str := interp pop()
    if (str instanceOf?(WmlsInvalid) || sub instanceOf?(WmlsInvalid) ||
        sub _toString() length() == 0)
        return WmlsInvalid new()
    return WmlsInteger new(str _toString() indexOf(sub _toString(), 0))
})

//stringLib put(5, func(interp: Interp) -> WmlsAny { // replace
//    return WmlsInvalid new() // TODO
//})

//stringLib put(6, func(interp: Interp) -> WmlsAny { // elements
//    return WmlsInvalid new() // TODO
//})

//stringLib put(7, func(interp: Interp) -> WmlsAny { // elementAt
//    return WmlsInvalid new() // TODO
//})

//stringLib put(8, func(interp: Interp) -> WmlsAny { // removeAt
//    return WmlsInvalid new() // TODO
//})

//stringLib put(9, func(interp: Interp) -> WmlsAny { // replaceAt
//    return WmlsInvalid new() // TODO
//})

//stringLib put(10, func(interp: Interp) -> WmlsAny { // insertAt
//    return WmlsInvalid new() // TODO
//})

//stringLib put(11, func(interp: Interp) -> WmlsAny { // squeeze
//    return WmlsInvalid new() // TODO
//})

stringLib put(12, func(interp: Interp) -> WmlsAny {
    // trim(string)
    val := interp pop()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else
        return WmlsString new(val _toString() trim())
})

stringLib put(13, func(interp: Interp) -> WmlsAny {
    // compare(string1, string2)
    str2 := interp pop()
    str1 := interp pop()
    if (str1 instanceOf?(WmlsInvalid) || str2 instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    s1 := str1 _toString()
    s2 := str2 _toString()
    cmp := (s1 == s2) ? 0 : ((s1 < s2) ? -1 : 1)
    return WmlsInteger new(cmp)
})

stringLib put(14, func(interp: Interp) -> WmlsAny {
    // toString(value)
    val := interp pop()
    return WmlsString new(val _toString())
})

//stringLib put(15, func(interp: Interp) -> WmlsAny { // format(format, value)
//    return WmlsInvalid new() // TODO
//})


consoleLib := HashMap<UInt8, Func(Interp) -> WmlsAny > new()

consoleLib put(0, func(interp: Interp) -> WmlsAny {
    // print
    val := interp pop()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else {
        str := val _toString()
        str print()
        return WmlsInteger new(str length())
    }
})

consoleLib put(1, func(interp: Interp) -> WmlsAny {
    // println
    val := interp pop()
    if (val instanceOf?(WmlsInvalid))
        return WmlsInvalid new()
    else {
        str := val _toString()
        str println()
        return WmlsInteger new(str length())
    }
})

