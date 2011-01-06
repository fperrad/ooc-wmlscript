#!/usr/bin/env perl

=head1 WMLScript Statements

=head2 Synopsis

    % prove t/statements.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 3;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'for');
extern function main()
{
    var sum = 0;
    for (var i = 1; i < 5; i++) {
        Console.println(i);
        sum += i;
    }
    Console.println("Sum: " + sum);
}
CODE
1
2
3
4
Sum: 10
OUT

wmls_is(<<'CODE', <<'OUT', 'for break');
extern function main()
{
    var sum = 0;
    for (var i = 1; i < 10; i++) {
        Console.println(i);
        sum += i;
        if (sum >= 10) break;
    }
    Console.println("Sum: " + sum);
}
CODE
1
2
3
4
Sum: 10
OUT

wmls_is(<<'CODE', <<'OUT', 'while', cflags => '-On');
extern function main()
{
    var sum = 0;
    var i = 5;
    while (--i) {
        Console.println(i);
        sum += i;
    }
    Console.println("Sum: " + sum);
}
CODE
4
3
2
1
Sum: 10
OUT

