
use strict;
use warnings;

use Test::Builder;

my $builder = Test::Builder->new();

sub spew {
    my ($content, $filename) = @_;

    open my $fh, '>', $filename
        or die "Can't open $filename ($!)";
    print {$fh} $content;
    close $fh;
}


sub wmls_is {
    my ($code, $expected, $desc, %options) = @_;

    my $cflags   = $options{cflags}   || q{};
    my $function = $options{function} || 'main';
    my $params   = $options{params}   || q{};
    my $src      = 'test.wmls';
    my $bytecode = 'test.wmlsc';

    spew($code, $src);

    qx{wmlsc $cflags $src};

    my $out = qx{./wmlsi $bytecode $function $params};

    my $pass = $out eq $expected;
    $builder->todo_start($options{todo}) if exists $options{todo};
    $builder->ok($pass, $desc);
    $builder->_is_diag($out, 'eq', $expected) unless $pass;
    $builder->todo_end() if exists $options{todo};
}

sub wmls_like {
    my ($code, $patt, $desc, %options) = @_;

    my $cflags   = $options{cflags}   || q{};
    my $function = $options{function} || 'main';
    my $params   = $options{params}   || q{};
    my $src      = 'test.wmls';
    my $bytecode = 'test.wmlsc';

    spew($code, $src);

    qx{wmlsc $cflags $src};

    my $out = qx{./wmlsi $bytecode $function $params};

#    my $pass = $out eq $expected;
#    $builder->ok($pass, $desc);
#    $builder->_is_diag($out, 'eq', $expected) unless $pass;

    $builder->todo_start($options{todo}) if exists $options{todo};
    like($out, $patt, $desc);
    $builder->todo_end() if exists $options{todo};
}

1;
