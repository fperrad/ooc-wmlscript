#!/usr/bin/env perl

=head1 WMLScript boolean & conversion

=head2 Synopsis

    % prove t/boolean.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 40;
require Helpers;

wmls_is(<<'CODE', <<'OUT', '! false', cflags => '-On');
extern function main()
{
    var a = ! false;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '~ false', cflags => '-On');
extern function main()
{
    var a = ~ false;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-1
0
OUT

wmls_is(<<'CODE', <<'OUT', '- true', cflags => '-On');
extern function main()
{
    var a = - true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-1
0
OUT

wmls_is(<<'CODE', <<'OUT', '++', cflags => '-On');
extern function main()
{
    var a = true;
    a ++;
    Console.println(a);
    Console.println(typeof a);
}
CODE
2
0
OUT

wmls_is(<<'CODE', <<'OUT', '--', cflags => '-On');
extern function main()
{
    var a = false;
    a --;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-1
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true << 2', cflags => '-On');
extern function main()
{
    var a = true << 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
4
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true << true', cflags => '-On');
extern function main()
{
    var a = true << true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
2
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true >> 1', cflags => '-On');
extern function main()
{
    var a = true >> 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
0
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true >> "text"', cflags => '-On');
extern function main()
{
    var a = true >> "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true >>> 2', cflags => '-On');
extern function main()
{
    var a =  true >>> 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
0
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true >>> "2"', cflags => '-On');
extern function main()
{
    var a =  true >>> "2";
    Console.println(a);
    Console.println(typeof a);
}
CODE
0
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true & 1', cflags => '-On');
extern function main()
{
    var a = true & 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true & 2.0', cflags => '-On');
extern function main()
{
    var a = true & 2.0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true ^ 2', cflags => '-On');
extern function main()
{
    var a = true ^ 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true ^ invalid', cflags => '-On');
extern function main()
{
    var a = true ^ invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true | 6', cflags => '-On');
extern function main()
{
    var a = true | 6;
    Console.println(a);
    Console.println(typeof a);
}
CODE
7
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true div 2', cflags => '-On');
extern function main()
{
    var a = true div 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
0
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true div 0', cflags => '-On');
extern function main()
{
    var a = true div 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true % 2', cflags => '-On');
extern function main()
{
    var a =  true % 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true div 0', cflags => '-On');
extern function main()
{
    var a = true % 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true * 3', cflags => '-On');
extern function main()
{
    var a = true * 3;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true * 3.14', cflags => '-On');
extern function main()
{
    var a = true * 3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3.14
1
OUT

wmls_is(<<'CODE', <<'OUT', 'true * "text"', cflags => '-On');
extern function main()
{
    var a = true * "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true / 2', cflags => '-On');
extern function main()
{
    var a = true / 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
0.5
1
OUT

wmls_is(<<'CODE', <<'OUT', 'true / 2.0', cflags => '-On');
extern function main()
{
    var a = true / 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
0.5
1
OUT

wmls_is(<<'CODE', <<'OUT', 'true - 3', cflags => '-On');
extern function main()
{
    var a = true - 3;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-2
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true - 1.5', cflags => '-On');
extern function main()
{
    var a = true - 1.5;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-0.5
1
OUT

wmls_is(<<'CODE', <<'OUT', 'false - invalid', cflags => '-On');
extern function main()
{
    var a = false - invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true + 3', cflags => '-On');
extern function main()
{
    var a = true + 3;
    Console.println(a);
    Console.println(typeof a);
}
CODE
4
0
OUT

wmls_is(<<'CODE', <<'OUT', 'true + "text"', cflags => '-On');
extern function main()
{
    var a = true + "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
truetext
2
OUT

wmls_is(<<'CODE', <<'OUT', 'true == true', cflags => '-On');
extern function main()
{
    var a = true == true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true != false', cflags => '-On');
extern function main()
{
    var a = true != false;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true == 1', cflags => '-On');
extern function main()
{
    var a = true == 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'false == 0.0', cflags => '-On');
extern function main()
{
    var a = false == 0.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true == "true"', cflags => '-On');
extern function main()
{
    var a = true == "true";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true != invalid', cflags => '-On');
extern function main()
{
    var a = true != invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'true <= false', cflags => '-On');
extern function main()
{
    var a = true <= false;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true < -3', cflags => '-On');
extern function main()
{
    var a = true <= -3;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true >= "text"', cflags => '-On');
extern function main()
{
    var a = true >= "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', 'true < invalid', cflags => '-On');
extern function main()
{
    var a = true <= invalid;
    Console.println(typeof a);
}
CODE
4
OUT

