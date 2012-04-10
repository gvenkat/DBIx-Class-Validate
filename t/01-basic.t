use strict;

BEGIN {
  my @mods = qw/
    AM::DBIC::Validate
    AM::DBIC::Error
    AM::DBIC::Validate::Number
    AM::DBIC::Validate::Length
    AM::DBIC::Validate::Callbacks
    AM::DBIC::Validate::Inclusion
    AM::DBIC::Validate::Format
    AM::DBIC::Validate::Unique
  /;

  use Test::More 'no_plan'; 

  for ( @mods ) {
    use_ok $_;
  }

}



