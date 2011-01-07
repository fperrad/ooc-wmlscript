#!/usr/bin/env perl

=head1 WMLScript Lang library

=head2 Synopsis

    % prove t/lang.t

=head2 Description

Tests WMLScript Lang Library

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 25;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'Lang.abs');
extern function main()
{
    var a = -3;
    var b = Lang.abs(a);

    Console.println(b);
    Console.println(typeof b);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.abs', todo => 'float');
extern function main()
{
    var a = Lang.abs(-3.14);
    Console.println(a);
    Console.println(typeof a);

    a = Lang.abs("text");
    Console.println(typeof a);

    a = Lang.abs(true);
    Console.println(typeof a);

    a = Lang.abs(invalid);
    Console.println(typeof a);
}
CODE
3.14
1
4
4
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.min', todo => 'float');
extern function main()
{
    var a = -3;
    var b = Lang.abs(a);

    var c = Lang.min(a,b); // c = -3
    Console.println(c);
    Console.println(typeof c);

    var d = Lang.min(45, 76.3); // d = 45 (integer)
    Console.println(d);
    Console.println(typeof d);

    var e = Lang.min(45, 45.0); // e = 45 (integer)
    Console.println(e);
    Console.println(typeof e);
}
CODE
-3
0
45
0
45
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.min');
extern function main()
{
    var a = Lang.min(3, invalid);
    Console.println(typeof a);

    var b = Lang.min(true, 12);
    Console.println(b);
    Console.println(typeof b);

    var c = Lang.min(1, "12");
    Console.println(c);
    Console.println(typeof c);
}
CODE
4
true
3
1
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.max', todo => 'float');
extern function main()
{
    var a = -3;
    var b = Lang.abs(a);

    var c = Lang.max(a,b); // c = 3
    Console.println(c);
    Console.println(typeof c);

    var d = Lang.max(45.5, 76); // d = 76 (integer)
    Console.println(d);
    Console.println(typeof d);

    var e = Lang.max(45.0, 45); // e = 45.0 (float)
    Console.println(e);
    Console.println(typeof e);
}
CODE
3
0
76
0
45
1
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.max');
extern function main()
{
    var a = Lang.max(3, invalid);
    Console.println(typeof a);

    var b = Lang.max(true, 12);
    Console.println(b);
    Console.println(typeof b);

    var c = Lang.max(1, "12");
    Console.println(c);
    Console.println(typeof c);
}
CODE
4
12
0
12
2
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.parseInt');
extern function main()
{
    var i = Lang.parseInt("1234");
    Console.println(i);
    Console.println(typeof i);

    var j = Lang.parseInt(" 100 m/s");
    Console.println(j);
    Console.println(typeof j);
}
CODE
1234
0
100
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.parseInt');
extern function main()
{
    var a = Lang.parseInt(12);
    Console.println(a);
    Console.println(typeof a);

    a = Lang.parseInt(3.14);
    Console.println(typeof a);

    a = Lang.parseInt(true);
    Console.println(typeof a);

    a = Lang.parseInt(invalid);
    Console.println(typeof a);
}
CODE
12
0
4
4
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.parseFloat', todo => 'float');
extern function main()
{
    var a = Lang.parseFloat("123.7");
    Console.println(a);
    Console.println(typeof a);

    var b = Lang.parseFloat("  +7.34e2 Hz");
    Console.println(b);
    Console.println(typeof b);

    var c = Lang.parseFloat(" 70e-2 F");
    Console.println(c);
    Console.println(typeof c);

    var d = Lang.parseFloat("-.1 C");
    Console.println(d);
    Console.println(typeof d);

    var e = Lang.parseFloat(" 100 ");
    Console.println(e);
    Console.println(typeof e);

    var f = Lang.parseFloat("Number: 5.5");
    Console.println(typeof f);

    var g = Lang.parseFloat("7.3e meters");
    Console.println(typeof g);

    var h = Lang.parseFloat("7.3e- ms");
    Console.println(typeof h);
}
CODE
123.7
1
734
1
0.7
1
-0.1
1
100
1
4
4
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.parseFloat', todo => 'float');
extern function main()
{
    var a = Lang.parseFloat(12);
    Console.println(a);
    Console.println(typeof a);

    a = Lang.parseFloat(3.14);
    Console.println(a);
    Console.println(typeof a);

    a = Lang.parseFloat(true);
    Console.println(typeof a);

    a = Lang.parseFloat(invalid);
    Console.println(typeof a);
}
CODE
12
1
3.14
1
4
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.isInt');
extern function main()
{
    var a = Lang.isInt(" -123");
    Console.println(a);

    var b = Lang.isInt(" 123.33");  // true ???
    Console.println(b);

    var c = Lang.isInt("string");
    Console.println(c);

    var d = Lang.isInt("#123");
    Console.println(d);

    var e = Lang.isInt(invalid);
    Console.println(typeof e);
}
CODE
true
false
false
false
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.isInt');
extern function main()
{
    var a = Lang.isInt(12);
    Console.println(a);

    a = Lang.isInt(3.14);
    Console.println(a);

    a = Lang.isInt(true);
    Console.println(a);

    a = Lang.isInt(invalid);
    Console.println(typeof a);
}
CODE
true
false
false
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.isFloat');
extern function main()
{
    var a = Lang.isFloat(" -123");
    Console.println(a);

    var b = Lang.isFloat(" 123.33");
    Console.println(b);

    var c = Lang.isFloat("string");
    Console.println(c);

    var d = Lang.isFloat("#123.33");
    Console.println(d);

    var e = Lang.isInt(invalid);
    Console.println(typeof e);
}
CODE
true
true
false
false
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.isFloat');
extern function main()
{
    var a = Lang.isFloat(12);
    Console.println(a);

    a = Lang.isFloat(3.14);
    Console.println(a);

    a = Lang.isFloat(true);
    Console.println(a);

    a = Lang.isFloat(invalid);
    Console.println(typeof a);
}
CODE
true
true
false
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.maxInt');
extern function main()
{
    var a = Lang.maxInt();
    Console.println(a);
    Console.println(typeof a);
}
CODE
2147483647
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.minInt');
extern function main()
{
    var a = Lang.minInt();
    Console.println(a);
    Console.println(typeof a);
}
CODE
-2147483648
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.float');
extern function main()
{
    var a = Lang.float();
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.exit(0)');
extern function main()
{
    Console.println("exit");
    Lang.exit(0);
    Console.println("ko");
}
CODE
exit
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.exit("1")');
extern function main()
{
    Console.println("exit");
    Lang.exit("1");
    Console.println("ko");
}
CODE
exit
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.exit(invalid)');
extern function main()
{
    Console.println("exit");
    Lang.exit(invalid);
    Console.println("ko");
}
CODE
exit
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.abort');
extern function main()
{
    Lang.abort("abort");
    Console.println("ko");
}
CODE
abort
OUT

wmls_like(<<'CODE', <<'OUT', 'Lang.random');
extern function main()
{
    var a = Lang.random(10);
    Console.println(a);
}
CODE
/^\d$/
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.random');
extern function main()
{
    var a = Lang.random("invalid");
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.seed');
extern function main()
{
    var a = Lang.seed(314); // todo: float
    Console.println(a);
    Console.println(typeof a);
}
CODE

2
OUT

wmls_is(<<'CODE', <<'OUT', 'Lang.characterSet');
extern function main()
{
    var a = Lang.characterSet();
    Console.println(a);
    Console.println(typeof a);
}
CODE
4
0
OUT

