package AnyEvent::Riak::Role::HTTPUtils;
BEGIN {
  $AnyEvent::Riak::Role::HTTPUtils::VERSION = '0.02';
}

# ABSTRACT: HTTP methods

use Moose::Role;

use AnyEvent;
use AnyEvent::HTTP;
use URI;
use MIME::Base64;

has client_id => (is => 'rw', isa => 'Str', lazy_build => 1,);

sub _build_client_id {
    "perl_anyevent_riak" . encode_base64(int(rand(10737411824)), '');
}

sub _build_uri {
    my ($self, $path, $options) = @_;

    my $uri = URI->new($self->host);
    $uri->path(join("/", @$path));
    $uri->query_form($self->_build_query($options));
    return $uri->as_string;
}

sub _build_headers {
    my $self = shift;
    my $headers = shift || {};

    $headers->{'X-Riak-ClientId'} = $self->client_id;
    $headers->{'Content-Type'}    = 'application/json'
      unless exists $headers->{'Content-Type'};
    return $headers;
}

sub _build_query {
    my ($self, $options) = @_;
    my $valid_options = [qw/props keys returnbody w r dw/];
    my $query;
    foreach (@$valid_options) {
        $query->{$_} = $options->{$_} if exists $options->{$_};
    }
    $query;
}

1;

__END__
=pod

=head1 NAME

AnyEvent::Riak::Role::HTTPUtils - HTTP methods

=head1 VERSION

version 0.02

=head1 AUTHOR

  franck cuny <franck@lumberjaph.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by linkfluence.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

