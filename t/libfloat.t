#!/usr/bin/env perl

=head1 WMLScript Float library

=head2 Synopsis

    % prove t/libfloat.t

=head2 Description

Tests WMLScript Float Library

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 8;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'Float.int');
extern function main()
{
    var a = 3.14;
    var b = Float.int(a);
    Console.println(b);
    Console.println(typeof b);

    var c = Float.int(-2.8);
    Console.println(c);
    Console.println(typeof c);
}
CODE
3
0
-2
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.floor');
extern function main()
{
    var a = 3.14;
    var b = Float.floor(a);
    Console.println(b);
    Console.println(typeof b);

    var c = Float.floor(-2.8);
    Console.println(c);
    Console.println(typeof c);
}
CODE
3
0
-3
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.ceil');
extern function main()
{
    var a = 3.14;
    var b = Float.ceil(a);
    Console.println(b);
    Console.println(typeof b);

    var c = Float.ceil(-2.8);
    Console.println(c);
    Console.println(typeof c);
}
CODE
4
0
-2
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.pow');
extern function main()
{
    var a = 3;
    var b = Float.pow(a,2);
    Console.println(b);
    Console.println(typeof b);
}
CODE
9
1
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.round', todo => 'round');
extern function main()
{
    var a = Float.round(3.5);
    Console.println(a);
    Console.println(typeof a);

    var b = Float.round(-3.5);
    Console.println(b);
    Console.println(typeof b);

    var c = Float.round(0.5);
    Console.println(c);
    Console.println(typeof c);

    var d = Float.round(-0.5);
    Console.println(d);
    Console.println(typeof d);
}
CODE
4
0
-3
0
1
0
0
0
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.sqrt', todo => 'float');
extern function main()
{
    var a = 4;
    var b = Float.sqrt(a);
    Console.println(b);
    Console.println(typeof b);

    var c = Float.sqrt(5);
    Console.println(c);
    Console.println(typeof c);

    var d = Float.sqrt(-1);
    Console.println(typeof d);
}
CODE
2
1
2.23607
1
4
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.maxFloat', todo => 'float');
extern function main()
{
    var a = Float.maxFloat();
    Console.println(a);
    Console.println(typeof a);
}
CODE
3.40282e+38
1
OUT

wmls_is(<<'CODE', <<'OUT', 'Float.minFloat', todo => 'float');
extern function main()
{
    var a = Float.minFloat();
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.17549e-38
1
OUT

