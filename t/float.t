#!/usr/bin/env perl

=head1 WMLScript floating-point & conversion

=head2 Synopsis

    % prove t/float.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 41;
require Helpers;

wmls_is(<<'CODE', <<'OUT', '! 0.0', cflags => '-On');
extern function main()
{
    var a = ! 0.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '! 3.14', cflags => '-On');
extern function main()
{
    var a = ! 3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '~ 1.0', cflags => '-On');
extern function main()
{
    var a = ~ 1.0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '- 3.14', cflags => '-On', todo => 'float');
extern function main()
{
    var a = - 3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
-3.14
1
OUT

wmls_is(<<'CODE', <<'OUT', '++', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 12.34;
    a ++;
    Console.println(a);
    Console.println(typeof a);
}
CODE
13.34
1
OUT

wmls_is(<<'CODE', <<'OUT', '--', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 12.34;
    a --;
    Console.println(a);
    Console.println(typeof a);
}
CODE
11.34
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 << 2', cflags => '-On');
extern function main()
{
    var a = 3.14 << 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 >> 3', cflags => '-On');
extern function main()
{
    var a = 3.14 >> 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 >>> 4', cflags => '-On');
extern function main()
{
    var a = 3.14 >>> 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 & 2', cflags => '-On');
extern function main()
{
    var a = 3.14 & 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 ^ 3', cflags => '-On');
extern function main()
{
    var a = 3.14 ^ 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 | 4', cflags => '-On');
extern function main()
{
    var a = 3.14 | 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 % 5', cflags => '-On');
extern function main()
{
    var a = 3.14 % 5;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 div 6', cflags => '-On');
extern function main()
{
    var a = 3.14 div 6;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 * 1.5', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 * 1.5;
    Console.println(a);
    Console.println(typeof a);
}
CODE
4.71
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 * 2', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 * 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
6.28
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 * true', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 * true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
3.14
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 * "text"', cflags => '-On');
extern function main()
{
    var a = 3.14 * "text";
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 / 2.0', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 / 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.57
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 / 2', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 / 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.57
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 / 0.0', cflags => '-On');
extern function main()
{
    var a = 3.14 / 0.0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 / 0', cflags => '-On');
extern function main()
{
    var a = 3.14 / 0;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 - 1.5', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 - 1.5;
    Console.println(a);
    Console.println(typeof a);
}
CODE
1.64
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 - 1', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 - 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
2.14
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 - invalid', cflags => '-On');
extern function main()
{
    var a = 3.14 - invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 + 1', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 + 1;
    Console.println(a);
    Console.println(typeof a);
}
CODE
4.14
1
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 + "text"', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 + "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
3.14text
2
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 == 3.14', cflags => '-On');
extern function main()
{
    var a = 3.14 == 3.14;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 == 2.0', cflags => '-On');
extern function main()
{
    var a = 3.14 == 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 != 2.0', cflags => '-On');
extern function main()
{
    var a = 3.14 != 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.0 == 3', cflags => '-On');
extern function main()
{
    var a = 3.0 == 3;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.0 != true', cflags => '-On');
extern function main()
{
    var a = 3.0 != true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 == "3.14"', cflags => '-On', todo => 'float');
extern function main()
{
    var a = 3.14 == "3.14";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 != "text"', cflags => '-On');
extern function main()
{
    var a = 3.14 != "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 == invalid', cflags => '-On');
extern function main()
{
    var a = 3.14 == invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 != invalid', cflags => '-On');
extern function main()
{
    var a = 3.14 != invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 <= 2.0', cflags => '-On');
extern function main()
{
    var a = 3.14 <= 2.0;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 < 2', cflags => '-On');
extern function main()
{
    var a = 3.14 <= 2;
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 >= true', cflags => '-On');
extern function main()
{
    var a = 3.14 >= true;
    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 > "text"', cflags => '-On');
extern function main()
{
    var a = 3.14 > "text";
    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '3.14 < invalid', cflags => '-On');
extern function main()
{
    var a = 3.14 < invalid;
    Console.println(typeof a);
}
CODE
4
OUT

