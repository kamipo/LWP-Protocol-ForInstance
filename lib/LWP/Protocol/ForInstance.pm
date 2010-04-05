package LWP::Protocol::ForInstance;

use strict;
use warnings;
our $VERSION = '0.01';

use LWP::UserAgent ();

my %ImplementedByForInstance = (); # instance => scheme => classname

sub LWP::UserAgent::DESTROY {
    my $self = shift;
    delete $ImplementedByForInstance{$self+0};
}

{
    my $orig_implementor = *LWP::Protocol::implementor{CODE};

    no warnings 'redefine';
    *LWP::Protocol::implementor = sub {
        my ($scheme, $impclass, $ua) = @_;
        my $new_impclass;

        if ($ua) {
            my $orig_impclass = $orig_implementor->($scheme);

            $new_impclass = $orig_implementor->($scheme, $impclass);
            $ImplementedByForInstance{$ua+0}{$scheme} = $new_impclass;

            $orig_implementor->($scheme, $orig_impclass);
        } else {
            $new_impclass = $orig_implementor->($scheme, $impclass);
        };

        $new_impclass;
    };

    *LWP::Protocol::create = sub {
        my ($scheme, $ua) = @_;
        my $impclass;

        if (exists $ImplementedByForInstance{$ua+0}{$scheme}) {
            $impclass = $ImplementedByForInstance{$ua+0}{$scheme};
        } else {
            $impclass = LWP::Protocol::implementor($scheme) or
                Carp::croak("Protocol scheme '$scheme' is not supported");
        }

        # hand-off to scheme specific implementation sub-class
        my $protocol = $impclass->new($scheme, $ua);

        return $protocol;
    };

}

1;

__END__

=head1 NAME

LWP::Protocol::ForInstance -

=head1 SYNOPSIS

  use LWP::UserAgent;
  use LWP::Protocol::ForInstance;
  
  my $ua1 = LWP::UserAgent->new;
  my $ua2 = LWP::UserAgent->new;
  
  {
      require LWP::Protocol::http10;
      LWP::Protocol::implementor('http', 'LWP::Protocol::http10', $ua1);
  }
  
  my $res1 = $ua1->get('http://www.cpan.org/');
  my $res2 = $ua2->get('http://www.cpan.org/');

=head1 DESCRIPTION

LWP::Protocol::ForInstance is

=head1 AUTHOR

Ryuta Kamizono E<lt>kamipo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
