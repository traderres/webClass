use strict;               # declare variables before you use them
use warnings "all";       # perl will give hints if you forget something

use File::Basename;
use Time::localtime;
use Spreadsheet::WriteExcel;

my $programName = $0;   # the variable $0 holds the full and path of perl script

$programName = basename($programName);  # basename gives just the name of the program

print "$programName has started as of " . ctime() . "\n";


my $workbook;
my $worksheet;
my $format;
my $col;
my $row;


# Create a new Excel workbook
$workbook = Spreadsheet::WriteExcel->new('sample.xls');

# Add a worksheet
$worksheet = $workbook->add_worksheet();

#  Add and define a format
$format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_color('red');
$format->set_align('center');

# Write a formatted and unformatted string, row and column notation.
$col = $row = 0;
$worksheet->write($row, $col, 'Hi Excel!', $format);
$worksheet->write(1,    $col, 'Hi Excel!');


# Write a number and a formula using A1 notation
$worksheet->write('A3', 1.2345);
$worksheet->write('A4', '=SIN(PI()/4)');


# sleep for 5 seconds
print "sleeping.\n";
sleep(10);
print "finished sleeping.\n";

print "$programName has finished as of " . ctime() . "\n";
exit 0;
