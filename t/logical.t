#!/usr/bin/env perl

=head1 Logical operators

=head2 Synopsis

    % prove t/logical.t

=head2 Description

Test opcodes C<SCAND> and C<SCOR>.

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 18;
require Helpers;

wmls_is(<<'CODE', <<'OUT', '3 && 2', cflags => '-On');
extern function main()
{
    var a = 3 && 2;

    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '1 && 0', cflags => '-On');
extern function main()
{
    var a = 1 && 0;

    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '1 && invalid', cflags => '-On');
extern function main()
{
    var a = 1 && invalid;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '0 && 2', cflags => '-On');
extern function main()
{
    var a = 0 && 2;

    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '0 && 0', cflags => '-On');
extern function main()
{
    var a = 0 && 0;

    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '0 && invalid', cflags => '-On');
extern function main()
{
    var a = 0 && invalid;

    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid && 2', cflags => '-On');
extern function main()
{
    var a = invalid && 2;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid && 0', cflags => '-On');
extern function main()
{
    var a = invalid && 0;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid && invalid', cflags => '-On');
extern function main()
{
    var a = invalid && invalid;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', '3 || 2', cflags => '-On');
extern function main()
{
    var a = 3 || 2;

    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '1 || 0', cflags => '-On');
extern function main()
{
    var a = 1 || 0;

    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '1 || invalid', cflags => '-On');
extern function main()
{
    var a = 1 || invalid;

    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '0 || 2', cflags => '-On');
extern function main()
{
    var a = 0 || 2;

    Console.println(a);
    Console.println(typeof a);
}
CODE
true
3
OUT

wmls_is(<<'CODE', <<'OUT', '0 || 0', cflags => '-On');
extern function main()
{
    var a = 0 || 0;

    Console.println(a);
    Console.println(typeof a);
}
CODE
false
3
OUT

wmls_is(<<'CODE', <<'OUT', '0 || invalid', cflags => '-On');
extern function main()
{
    var a = 0 || invalid;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid || 2', cflags => '-On');
extern function main()
{
    var a = invalid || 2;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid || 0', cflags => '-On');
extern function main()
{
    var a = invalid || 0;

    Console.println(typeof a);
}
CODE
4
OUT

wmls_is(<<'CODE', <<'OUT', 'invalid || invalid', cflags => '-On');
extern function main()
{
    var a = invalid || invalid;

    Console.println(typeof a);
}
CODE
4
OUT

