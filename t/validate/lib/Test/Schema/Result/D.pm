package Test::Schema::Result::D;

use strict;
use parent 'DBIx::Class::Validate::Core';
use CLASS;

CLASS->table( 'd' );
CLASS->add_columns(
  email => { data_type => 'varchar', is_nullable => 0 }
);

CLASS->validates_email( 'email', message => 'email is invalid' );


1;
__END__



