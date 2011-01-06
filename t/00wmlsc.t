#!/usr/bin/env perl

=head1 WMLScript Compiler

=head2 Synopsis

    % prove t/00wmlsc.t

=head2 Description

=cut

use strict;
use warnings;

use Test::More tests => 1;

BAIL_OUT("wmlsc not found. sudo cpan WAP::wmls")
    unless qx{wmlsc -v} =~ /^WAP::wmls/;

pass('wmlsc found');
