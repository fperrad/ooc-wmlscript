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
use File::Copy;

use Test::More tests => 5;
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

copy('test.wmlsc', 'hello.wmlsc');

wmls_is(<<'CODE', <<'OUT', 'use url');
use url OtherScript "hello.wmlsc";

extern function main()
{
    OtherScript#hello();
}
CODE
Hello World!
OUT

wmls_like(<<'CODE', <<'OUT', 'unable to load', todo => 'exception');
use url OtherScript "hello_x.wmlsc";

extern function main()
{
    OtherScript#hello();
}
CODE
/Couldn't open hello_x\.wmlsc for reading/
OUT

wmls_like(<<'CODE', <<'OUT', 'incorrect version', todo => 'exception');
use url OtherScript "test.wmls";

extern function main()
{
    OtherScript#hello();
}
CODE
/incorrect version/
OUT

wmls_like(<<'CODE', <<'OUT', 'external not found', todo => 'exception');
use url OtherScript "hello.wmlsc";

extern function main()
{
    OtherScript#hello2();
}
CODE
/ExternalFunctionNotFound/
OUT

unlink('hello.wmlsc');
