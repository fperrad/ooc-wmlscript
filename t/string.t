#!/usr/bin/env perl

=head1 WMLScript string & conversion

=head2 Synopsis

    % prove t/string.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 48;
require Helpers;

wmls_is(<<'CODE', <<'OUT', '! ""', cflags => '-On');
extern function main()
{
    var a = ! "";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '! "text"', cflags => '-On');
extern function main()
{
    var a = ! "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '~ "text"', cflags => '-On');
extern function main()
{
    var a = ~ "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '~ "2"', cflags => '-On');
extern function main()
{
    var a = ~ "2";
    Console.println(a);
    Console.println(typeof a);
}
CODE
-3
0
OUT

wmls_is(<<'CODE', <<'OUT', '- "text"', cflags => '-On');
extern function main()
{
    var a = - "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '- " 12 "', cflags => '-On');
extern function main()
{
    var a = - " 12 ";
    Console.println(a);
    Console.println(typeof a);
}
CODE
-12
0
OUT

wmls_is(<<'CODE', <<'OUT', '- " 3.14 "', cflags => '-On');
extern function main()
{
    var a = - " 3.14 ";
    Console.println(a);
    Console.println(typeof a);
}
CODE
-3.14
1
OUT

wmls_is(<<'CODE', <<'OUT', '++', cflags => '-On');
extern function main()
{
    var a = "text";
    a ++;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '--', cflags => '-On');
extern function main()
{
    var a = "text";
    a --;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"2" << 2', cflags => '-On');
extern function main()
{
    var a = "2" << 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
8
0
OUT

wmls_is(<<'CODE', <<'OUT', '"5" << true', cflags => '-On');
extern function main()
{
    var a = 5 << true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
10
0
OUT

wmls_is(<<'CODE', <<'OUT', '"6" >> 1', cflags => '-On');
extern function main()
{
    var a = "6" >> 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', '"6" >> "text"', cflags => '-On');
extern function main()
{
    var a = "6" >> "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"12" >>> 2', cflags => '-On');
extern function main()
{
    var a =  "12" >>> 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', '"15" >>> "2"', cflags => '-On');
extern function main()
{
    var a =  "15" >>> "2";
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', '"6" & 2', cflags => '-On');
extern function main()
{
    var a = "6" & 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
2
0
OUT

wmls_is(<<'CODE', <<'OUT', '"6" & 2.0', cflags => '-On');
extern function main()
{
    var a = "6" & 2.0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"6" ^ 2', cflags => '-On');
extern function main()
{
    var a = "6" ^ 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
4
0
OUT

wmls_is(<<'CODE', <<'OUT', '"6" ^ invalid', cflags => '-On');
extern function main()
{
    var a = "6" ^ invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"6" | 5', cflags => '-On');
extern function main()
{
    var a = "6" | 5;
    Console.println(a);
    Console.println(typeof a);
}
CODE
7
0
OUT

wmls_is(<<'CODE', <<'OUT', '"7" div 2', cflags => '-On');
extern function main()
{
    var a = "7" div 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', '"7" div 0', cflags => '-On');
extern function main()
{
    var a = "7" div 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"7" % 2', cflags => '-On');
extern function main()
{
    var a =  "7" % 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1
0
OUT

wmls_is(<<'CODE', <<'OUT', '"7" div 0', cflags => '-On');
extern function main()
{
    var a = "7" % 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"3" * 4', cflags => '-On');
extern function main()
{
    var a = "3" * 4;
    Console.println(a);
    Console.println(typeof a);
}
CODE
12
0
OUT

wmls_is(<<'CODE', <<'OUT', '"2" * 3.14', cflags => '-On');
extern function main()
{
    var a = "2" * 3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
6.28
1
OUT

wmls_is(<<'CODE', <<'OUT', '"3" * true', cflags => '-On');
extern function main()
{
    var a = "3" * true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3
0
OUT

wmls_is(<<'CODE', <<'OUT', '"3" * "text"', cflags => '-On');
extern function main()
{
    var a = "3" * "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"3" / 2', cflags => '-On');
extern function main()
{
    var a = "3" / 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.5
1
OUT

wmls_is(<<'CODE', <<'OUT', '"3" / 2.0', cflags => '-On');
extern function main()
{
    var a = "3" / 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.5
1
OUT

wmls_is(<<'CODE', <<'OUT', '"3" / 0', cflags => '-On');
extern function main()
{
    var a = "3" / 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"3" / 0.0', cflags => '-On');
extern function main()
{
    var a = "3" / 0.0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"3" - 1', cflags => '-On');
extern function main()
{
    var a = "3" - 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
2
0
OUT

wmls_is(<<'CODE', <<'OUT', '"3" - 1.4', cflags => '-On');
extern function main()
{
    var a = "3" - 1.4;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.6
1
OUT

wmls_is(<<'CODE', <<'OUT', '"3" - invalid', cflags => '-On');
extern function main()
{
    var a = "3" - invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"3" + 1', cflags => '-On');
extern function main()
{
    var a = "3" + 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
31
2
OUT

wmls_is(<<'CODE', <<'OUT', '"3" + "text"', cflags => '-On');
extern function main()
{
    var a = "3" + "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
3text
2
OUT

wmls_is(<<'CODE', <<'OUT', '"ABC" == "ABC"', cflags => '-On');
extern function main()
{
    var a = "ABC" == "ABC";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"ABC" != "123"', cflags => '-On');
extern function main()
{
    var a = "ABC" != "123";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"123" == 123', cflags => '-On');
extern function main()
{
    var a = "123" == 123;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"123" != 123.0', cflags => '-On');
extern function main()
{
    var a = "123" != 123.4;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"123" != true', cflags => '-On');
extern function main()
{
    var a = "123" != true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"text" == invalid', cflags => '-On');
extern function main()
{
    var a = "text" == invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '"text" <= "TEXT"', cflags => '-On');
extern function main()
{
    var a = "text" <= "TEXT";
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '"text" < 123', cflags => '-On');
extern function main()
{
    var a = "text" < 123;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '"text" >= true', cflags => '-On');
extern function main()
{
    var a = "text" >= true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '"text" > -3.14', cflags => '-On');
extern function main()
{
    var a = "text" > -3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '"text" < invalid', cflags => '-On');
extern function main()
{
    var a = "text" < invalid;
    Console.println(typeof a);
}
CODE
4
OUT

