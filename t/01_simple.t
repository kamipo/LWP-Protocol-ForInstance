use strict;
use warnings;
use LWP::UserAgent;
use LWP::Protocol::ForInstance;
use Test::More;

my $ua1 = LWP::UserAgent->new;
my $ua2 = LWP::UserAgent->new;

{
    require LWP::Protocol::http10;
    LWP::Protocol::implementor('http', 'LWP::Protocol::http10', $ua1);
}

my $proto1 = LWP::Protocol::create('http', $ua1);
my $proto2 = LWP::Protocol::create('http', $ua2);

isa_ok $proto1, 'LWP::Protocol::http10';
isa_ok $proto2, 'LWP::Protocol::http';

done_testing;
