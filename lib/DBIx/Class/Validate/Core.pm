package DBIx::Class::Validate::Core; 

use strict;
use parent qw/
  DBIx::Class::Core
/;

__PACKAGE__->load_components( qw/
  +DBIx::Class::Validate
  InflateColumn::DateTime
  DynamicDefault
/);


# use utf and innodb by default
=pod
sub sqlt_deploy_hook {
  my ($self, $sqlt_table) = @_;
  $sqlt_table->extra(
      mysql_table_type => 'InnoDB',
      mysql_charset    => 'utf8'
  );
}
=cut


1;
__END__
