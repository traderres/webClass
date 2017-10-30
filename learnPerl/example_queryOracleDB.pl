#########################################################################
#  Filename:    queryOracleDB.pl
#########################################################################
#
#  Purpose:
#    Run a SQL Query against an Oracle database from within a Perl script
#
#  Design:
#    1) Connect to the Oracle DB
#    2) Execute the SQL query
#    3) Display the SQL query results
#       4) Close Oracle connection
#
# Assumptions:
#    1) Oracle Client must be installed on computer running Perl script????
#
#  Usage:
#    1) queryOracleDB.pl <enter>
#    2) perl queryOracleDB.pl > output.txt <enter>
#########################################################################
use strict;                     # You must declare variables before using them
use warnings "all";             # Show any compile warnings


use DBI;


# DECLARE  CONSTANTS


# DECLARE  GLOBAL  VARIABLES
my $DB_USERID = "aresnick";
my $DB_PASSWORD = "aresnick";
my $DB_SERVICE = "tdc_tirs";
my $g_script_name;
my $dbHandle;       # a handle to the database
my $stHandle;       # a handle to a single SQL statement
my $singleRow;
my $count;
my $sqlColumn;

# Get the Script name without all of the path information
$g_script_name = $0;
$g_script_name =~ s/.*\\([^\\]*)$/$1/;



# S C R I P T         S T A R T S        H E R E
printf "$g_script_name has started\n";


# PART 1:  Connect to the Oracle Database
print "\tConnecting to $DB_SERVICE Oracle DB....\n";
$dbHandle = DBI->connect("DBI:Oracle:$DB_SERVICE", $DB_USERID, $DB_PASSWORD)
             || die "Couldn't connect to database: " . DBI->errstr();


# So we don't have to check every DBI call we set RaiseError..
$dbHandle->{RaiseError} = 1;



# PART 2: Query the database
print "\tPreparing the SQL statement handle....\n";
$stHandle = $dbHandle->prepare( q{
                 select view_name,owner from all_views order by view_name
                }) || die $dbHandle->errstr;


print "\tExecuting the SQL statement....\n";
$stHandle->execute || die "Problem executing query " . $dbHandle->errstr();


# PART 3: Display the query results
print "\tFetching all data from the query....\n";
$count=0;

## NOTE: for this appraoch singleRow must be defined using my @singleRow;
## 
## # Loop through every row, displaying every column
## while (@singleRow = $stHandle->fetchrow_array) 
##  {
##   foreach (@singleRow) 
##    {
##      print "$_ -";
##    }
##  print "\n";
## }

while (  $singleRow = $stHandle->fetchrow_hashref ) 
  {
    # This row of data is a hash, so loop through all keys in the hash 
       foreach $sqlColumn ( sort keys %{ $singleRow } )
        {
        # Display each column of this row of data
          print "$sqlColumn=$singleRow->{ $sqlColumn }  ";
    }


    # NOTE: if you wanted to display just one column you could do this
    # print "VIEW_NAME holds $singleRow->{ 'VIEW_NAME' } ";
    
    print "\n";
    $count++;
 }
print "$count record(s) retrieved.\n";




# PART 4: Close the Oracle connection
$stHandle->finish;
$dbHandle->disconnect;


# S C R I P T        H A S         F I N I S H E D
printf("\n%s has finished.\n",$g_script_name);

exit 0;
