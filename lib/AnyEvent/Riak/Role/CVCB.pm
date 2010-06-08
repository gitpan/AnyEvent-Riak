package AnyEvent::Riak::Role::CVCB;
BEGIN {
  $AnyEvent::Riak::Role::CVCB::VERSION = '0.02';
}

# ABSTRACT: return a default condvar and callback if none defined

use Moose::Role;

sub _cvcb {
    my ($self, $options) = @_;

    my ($cv, $cb) = (AnyEvent->condvar, sub { return @_ });
    if ($options && @$options) {
        $cv = pop @$options if UNIVERSAL::isa($options->[-1], 'AnyEvent::CondVar');
        $cb = pop @$options if ref $options->[-1] eq 'CODE';
    }
    ($cv, $cb);
}

1;


__END__
=pod

=head1 NAME

AnyEvent::Riak::Role::CVCB - return a default condvar and callback if none defined

=head1 VERSION

version 0.02

=head1 AUTHOR

  franck cuny <franck@lumberjaph.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by linkfluence.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

