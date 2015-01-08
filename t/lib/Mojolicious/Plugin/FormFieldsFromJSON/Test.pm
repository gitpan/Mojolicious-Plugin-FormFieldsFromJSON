package
  Mojolicious::Plugin::FormFieldsFromJSON::Test;

use Mojo::Base 'Mojolicious::Plugin';

sub register { 1 };

sub Mojolicious::Plugin::FormFieldsFromJSON::_testfield {
    my ($self, $c, $field, %params) = @_;

    my $name = $field->{name};
    return qq~<input id="$name" name="$name" type="test" value="" />~;
}

1;
