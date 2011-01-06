#!/usr/bin/env perl

=head1 WMLScript functions

=head2 Synopsis

    % prove t/functions.t

=head2 Description


=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 8;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'function call');
function f()
{
    Console.println("in");
}

extern function main()
{
    Console.println("out");
    f();
    Console.println("end");
}
CODE
out
in
end
OUT

wmls_is(<<'CODE', <<'OUT', '1 arg');
function f(a)
{
    Console.println(a);
}

extern function main()
{
    f(20);
}
CODE
20
OUT

wmls_is(<<'CODE', <<'OUT', '3 args');
function f(a, b, c)
{
    Console.println(a);
    Console.println(b);
    Console.println(c);
}

extern function main()
{
    f(10, 20, 30);
}
CODE
10
20
30
OUT

wmls_is(<<'CODE', <<'OUT', 'no return');
function f(a)
{
    Console.println(a);
}

extern function main()
{
    var ret;
    ret = f("text");
    Console.println(ret == "");
}
CODE
text
true
OUT

wmls_is(<<'CODE', <<'OUT', 'return');
function f(a)
{
    Console.println(a);
    return;
}

extern function main()
{
    var ret;
    ret = f("text");
    Console.println(ret == "");
}
CODE
text
true
OUT

wmls_is(<<'CODE', <<'OUT', 'return value');
function f(a)
{
    Console.println(a);
    return "ok";
}

extern function main()
{
    var ret;
    ret = f("text");
    Console.println(ret);
}
CODE
text
ok
OUT

wmls_is(<<'CODE', <<'OUT', 'passing by value');
function f(val)
{
    val += 20;
    Console.println(val);
}

extern function main()
{
    var a = 10;
    Console.println(a);
    f(a);
    Console.println(a);
}
CODE
10
30
10
OUT

wmls_is(<<'CODE', <<'OUT', 'recursive call');
function fact(n)
{
    if (n == 0) {
        return 1;
    }
    else {
        return n * fact(n - 1);
    }
}

extern function main()
{
    Console.println(fact(7));
}
CODE
5040
OUT

