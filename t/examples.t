#!/usr/bin/env perl

=head1 some WMLScript code examples

=head2 Synopsis

    % prove t/examples.t

=head2 Description

First tests in order to check infrastructure.

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More tests => 5;
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'hello world');
extern function main()
{
    Console.println("Hello World!");
}
CODE
Hello World!
OUT

wmls_is(<<'CODE', <<'OUT', 'another main', function => 'hello');
extern function hello()
{
    Console.println("Hello World!");
}
CODE
Hello World!
OUT

wmls_is(<<'CODE', <<'OUT', 'with params', params => "abc def");
extern function main(arg1, arg2)
{
    Console.println(arg1);
    Console.println(arg2);
}
CODE
abc
def
OUT

wmls_is(<<'CODE', <<'OUT', 'no optim', cflags => '-On');
extern function main()
{
    Console.println(1 + 2);
}
CODE
3
OUT

wmls_is(<<'CODE', <<'OUT', 'sieve', function => 'sieve');
/*
 *  Eratosthenes Sieve prime number calculation
 */
extern function sieve ()
{
    var MAX_PRIME = 17;
    var i;
    var count = 0;
    var flag = 0;
    for (i = 0; i < MAX_PRIME; i++) {
        flag |= (1 << i);   // set
    }
    for (i = 0; i < MAX_PRIME; i++) {
        if (flag & (1 << i)) {  // test
            var prime = i + i + 3;
            var k = i + prime;
            while (k < MAX_PRIME) {
                flag &= ~(1 << k);  // clear
                k += prime;
            }
            count++;
            Console.println(" prime " + count + " = " + prime);
        }
    }
    Console.println("");
    Console.println(count + " primes.");
}
CODE
 prime 1 = 3
 prime 2 = 5
 prime 3 = 7
 prime 4 = 11
 prime 5 = 13
 prime 6 = 17
 prime 7 = 19
 prime 8 = 23
 prime 9 = 29
 prime 10 = 31

10 primes.
OUT

