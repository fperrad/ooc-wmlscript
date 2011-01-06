#!/usr/bin/env perl

=head1 WMLScript expressions

=head2 Synopsis

    % prove t/expr.t

=head2 Description


=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 2;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'assign', cflags => '-On');
extern function main()
{
    var a = "abc";
    var b = a;
    b = "def";
    Console.println(a);
    Console.println(b);
}
CODE
abc
def
OUT

wmls_is(<<'CODE', <<'OUT', 'incr', cflags => '-On');
extern function main()
{
    var a = 10;
    var b = a;
    b ++;
    Console.println(a);
    Console.println(b);
}
CODE
10
11
OUT

