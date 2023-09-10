BEGIN { chdir 't' if -d 't' }

use Test::More      'no_plan';
use File::Basename  'basename';
use strict;
use lib '../lib';

my $NO_UNLINK   = @ARGV ? 1 : 0;

my $Class       = 'Archive::Tar';
my $FileClass   = $Class . '::File';

use_ok( $Class );
use_ok( $FileClass );

### bug 103279
### retain trailing whitespace on filename
SKIP: {
  ok( 1,                      "Testing bug 103279" );
	my $tar = $Class->new;
	isa_ok( $tar, $Class,       "   Object" );
	ok( open my $fh, '>', 'white_space   ' );
	ok( close $fh );
	if (-e 'white_space' && $^O eq 'MSWin32') {
		skip 'Windows tries to be clever', 1;
	}
	ok( $tar->add_files( 'white_space   ' ),
				    "   Add file <white_space   > containing filename with trailing whitespace");
	ok( unlink 'white_space   ' );
	ok( $tar->extract(),        "	Extract filename with trailing whitespace" );
	ok( ! -e 'white_space',     "	<white_space> should not exist" );
	ok( -e 'white_space   ',    "	<white_space   > should exist" );
	unlink foreach ('white_space   ', 'white_space');
}
