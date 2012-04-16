package Test::Schema::Result::C;

use strict;
use parent 'DBIx::Class::Validate::Core';
use CLASS;

CLASS->table( 'c' );
CLASS->add_columns(
  a => { data_type => 'varchar', is_nullable => 0 },
  b => { data_type => 'varchar', is_nullable => 0 },
);

CLASS->validates_length_of( 'a', min => 5, max => 10, message => 'x' );
CLASS->validates_length_of( 'b', in => [ 10..20 ], message => 'xx' );


1;
__END__



