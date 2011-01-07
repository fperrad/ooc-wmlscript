#!/usr/bin/env perl

=head1 WMLScript Pragmas

=head2 Synopsis

    % prove t/pragmas.t

=head2 Description

=cut

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

#use Test::More tests => 5;
use Test::More skip_all => 'not implemented';
require Helpers;

wmls_is(<<'CODE', <<'OUT', 'hello');
extern function hello()
{
    Console.println("Hello World!");
}

extern function main()
{
    hello();
}
CODE
Hello World!
OUT

wmls_is(<<'CODE', <<'OUT', 'use url');
use url OtherScript "t/pragmas_1.wmlsc";

extern function main()
{
    OtherScript#hello();
}
CODE
Hello World!
OUT

wmls_like(<<'CODE', <<'OUT', 'unable to load');
use url OtherScript "t/pragmas_x.wmlsc";

extern function main()
{
    OtherScript#hello();
}
CODE
/unable to load/
OUT

wmls_like(<<'CODE', <<'OUT', 'verification failed');
use url OtherScript "t/pragmas_1.out";

extern function main()
{
    OtherScript#hello();
}
CODE
/verification failed/
OUT

wmls_like(<<'CODE', <<'OUT', 'external function not found');
use url OtherScript "t/pragmas_1.wmlsc";

extern function main()
{
    OtherScript#hello2();
}
CODE
/external function '\w+' not found/
OUT

