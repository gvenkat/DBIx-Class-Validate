use ExtUtils::MakeMaker;
WriteMakefile
(
  'PL_FILES' => {},
  'INSTALLDIRS' => 'site',
  'NAME' => 'AM::DBIC::Validate',
  'EXE_FILES' => [],
  'VERSION_FROM' => 'lib/AM/DBIC/Validate.pm',
  'PREREQ_PM' => {
    'DBIx::Class'            => 0,
    'parent'                 => 0,
    'Hash::Merge'           => 0,
    'Scalar::Util'          => 0,
    'Email::Valid'          => 0,
  }
);
