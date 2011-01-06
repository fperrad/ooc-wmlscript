#!/usr/bin/env perl

=head1 WMLScript invalid & conversion

=head2 Synopsis

    % prove t/invalid.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 23;
require Helpers;

wmls_is(<<'CODE', <<'OUT', '! invalid', cflags => '-On');
extern function main()
{
    var a = ! invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '~ invalid', cflags => '-On');
extern function main()
{
    var a = ~ invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '- invalid', cflags => '-On');
extern function main()
{
    var a = - invalid;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '++', cflags => '-On');
extern function main()
{
    var a = invalid;
    a ++;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '--', cflags => '-On');
extern function main()
{
    var a = invalid;
    a --;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid << 2', cflags => '-On');
extern function main()
{
    var a = invalid << 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid >> 3', cflags => '-On');
extern function main()
{
    var a = invalid >> 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid >>> 4', cflags => '-On');
extern function main()
{
    var a = invalid >>> 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid & 2', cflags => '-On');
extern function main()
{
    var a = invalid & 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid ^ 3', cflags => '-On');
extern function main()
{
    var a = invalid ^ 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid | 4', cflags => '-On');
extern function main()
{
    var a = invalid | 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid % 5', cflags => '-On');
extern function main()
{
    var a = invalid % 5;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid div 6', cflags => '-On');
extern function main()
{
    var a = invalid div 6;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid * 2', cflags => '-On');
extern function main()
{
    var a = invalid * 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid / 3', cflags => '-On');
extern function main()
{
    var a = invalid / 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid - 4', cflags => '-On');
extern function main()
{
    var a = invalid - 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid + 5', cflags => '-On');
extern function main()
{
    var a = invalid + 5;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid == 1', cflags => '-On');
extern function main()
{
    var a = invalid == 1;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid != 2', cflags => '-On');
extern function main()
{
    var a = invalid != 2;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid <= 3', cflags => '-On');
extern function main()
{
    var a = invalid <= 3;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid < 4', cflags => '-On');
extern function main()
{
    var a = invalid < 4;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid >= 5', cflags => '-On');
extern function main()
{
    var a = invalid >= 5;
    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid > 6', cflags => '-On');
extern function main()
{
    var a = invalid > 6;
    Console.println(typeof a);
}
CODE
4
OUT

