package Test::Schema::Result::B;

use strict;
use parent 'DBIx::Class::Validate::Core'; 
use CLASS;

CLASS->table( 'b' );
CLASS->add_columns(
  a => { data_type => 'varchar', is_nullable => 1 },
  b => { data_type => 'varchar', is_nullable => 1 },
  c => { data_type => 'varchar', is_nullable => 1 },
  d => { data_type => 'varchar', is_nullable => 1 },
  e => { data_type => 'varchar', is_nullable => 1 },
);

CLASS->validates_format_of( 'a', with => qr(a+b+), message => 'x'x1 );
CLASS->validates_format_of( 'b', with => qr(M[1-9]{2}[A-C]{2}), message => 'x'x2 );
CLASS->validates_format_of( 'c', without => qr([0-9]), message => 'x'x3 );
CLASS->validates_format_of( 'e', with => qr!https?://(\w+)(\.\w+)+((\/\w+)+)?!, message => 'x'x4 );

1;
__END__

