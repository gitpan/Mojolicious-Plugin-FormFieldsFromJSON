#!/usr/bin/env perl

use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use File::Basename;
use File::Spec;

plugin 'FormFieldsFromJSON' => {
  dir => File::Spec->catdir( dirname( __FILE__ ) || '.', 'conf' ),
};

my $config_name = basename __FILE__;
$config_name    =~ s{\A \d+_ }{}xms;
$config_name    =~ s{\.t \z }{}xms;

get '/' => sub {
  my $c = shift;
  my ($textfield) = $c->form_fields( $config_name );
  $c->render(text => $textfield);
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is(
  '<input id="type" name="type" type="checkbox" value="internal" />' . "\n\n\n" .
  '<input id="type" name="type" type="checkbox" value="external" />' . "\n"
);

done_testing();

