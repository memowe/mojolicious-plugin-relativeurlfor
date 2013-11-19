package Mojolicious::Plugin::RelativeUrlFor;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.04';

sub register {
    my ($self, $app, $conf) = @_;

    # url_for helper
    my $url_for = *Mojolicious::Controller::url_for{CODE};

    # helper sub ref
    my $rel_url_for = sub {
        my $c = shift;

        # create urls
        my $url     = $url_for->($c, @_)->to_abs;
        my $req_url = $c->req->url->to_abs;

        # return relative version if request url exists
        if ($req_url->to_string) {

            # repair if empty
            my $rel_url = $url->to_rel($req_url);
            return Mojo::URL->new('./') unless $rel_url->to_string;
            return $rel_url;
        }

        # change nothing without request url
        return $url;
    };

    # register rel(ative)_url_for helpers
    $app->helper(relative_url_for   => $rel_url_for);
    $app->helper(rel_url_for        => $rel_url_for);

    # replace url_for helper
    if ($conf->{replace_url_for}) {
        no strict 'refs';
        no warnings 'redefine';
        *Mojolicious::Controller::url_for = $rel_url_for;
    }
}

1;
__END__

=head1 NAME

Mojolicious::Plugin::RelativeUrlFor - relative links in Mojolicious, really.

=head1 SYNOPSIS

    # Mojolicious
    $self->plugin('RelativeUrlFor');

    # Mojolicious::Lite
    plugin 'RelativeUrlFor';

=head1 DESCRIPTION

This Mojolicious plugin adds a new helper to your web app: C<relative_url_for>,
together with its short alias C<rel_url_for>. Mojo's URL objects already have a
method for this, but to get really relative URLs like I<../foo.html> you need
to add the request url like this:

    my $url     = $self->url_to('foo', bar => 'baz');
    my $rel_url = $url->to_rel($self->req->url);

The new helper method gets the job done for you:

    my $rel_url = $self->rel_url_for('foo', bar => 'baz');

Generated URLs are always relative to the request url. 

=head2 In templates

Since this is a helper method, it's available in templates after using
this plugin:

    <%= rel_url_for 'foo', bar => 'baz' %>

=head2 Replacing C<url_for>

To use relative URLs in your whole web app without rewriting the code, this
plugin can replace Mojolicious' C<url_for> helper for you, which is used by
useful things like C<link_to> and C<form_for>. You need to set the
C<replace_url_for> option for this:

    # Mojolicious
    $self->plugin(RelativeUrlFor => { replace_url_for => 1 });

    # Mojolicious::Lite
    plugin RelativeUrlFor => { replace_url_for => 1 };

=head1 REPOSITORY AND ISSUE TRACKING

This plugin lives in github:
L<http://github.com/memowe/mojolicious-plugin-relativeurlfor>.
You're welcome to use github's issue tracker to report bugs or discuss the code:
L<http://github.com/memowe/mojolicious-plugin-relativeurlfor/issues>

=head1 AUTHOR AND LICENSE

Copyright Mirko Westermeier E<lt>mail@memowe.deE<gt>

This software is released under the MIT license. See MIT-LICENSE for details.
