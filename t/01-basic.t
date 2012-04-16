use strict;

BEGIN {
  my @mods = qw/
    Error
    Core
  /;

  my @fragments = qw/
    Number
    Length
    Callbacks
    Inclusion
    Format
    Unique
  /;


  use Test::More 'no_plan'; 

  use_ok "DBIx::Class::Validate::$_" for @mods;
  use_ok "DBIx::Class::Validate::Fragment::$_" for @fragments;

}



