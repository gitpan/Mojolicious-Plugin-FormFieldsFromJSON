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
  my ($field) = $c->form_fields( $config_name );
  $c->render(text => $field);
};

get '/stash' => sub {
  my $c = shift;
  $c->param( languages => [qw/cn jp/] );
  my ($field) = $c->form_fields( $config_name );
  $c->render(text => $field);
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is(join '',
  '<select id="languages" multiple="multiple" name="languages" size="3">',
  '<option value="cn">cn</option>',
  '<option selected="selected" value="de">de</option>',
  '<option selected="selected" value="en">en</option>',
  '<option value="jp">jp</option>',
  '</select>',
);

$t->get_ok("/?languages=cn&languages=jp")->status_is(200)->content_is(join '',
  '<select id="languages" multiple="multiple" name="languages" size="3">',
  '<option selected="selected" value="cn">cn</option>',
  '<option value="de">de</option>',
  '<option value="en">en</option>',
  '<option selected="selected" value="jp">jp</option>',
  '</select>',
);

$t->get_ok('/stash')->status_is(200)->content_is(join '',
  '<select id="languages" multiple="multiple" name="languages" size="3">',
  '<option selected="selected" value="cn">cn</option>',
  '<option value="de">de</option>',
  '<option value="en">en</option>',
  '<option selected="selected" value="jp">jp</option>',
  '</select>',
);

done_testing();

