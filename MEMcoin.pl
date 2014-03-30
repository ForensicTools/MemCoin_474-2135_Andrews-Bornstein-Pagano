use strict;
use warnings;
system("pwd");
#if sudo install fmem
chdir("fmem_1.6-0/");
system("pwd");
system("make");

# Revision - if fmem install fails due to kernal headers report failure
system("./run.sh");
chdir("../");
system("pwd");
chdir("MemoryImages");

#grab an image
system("dd if=/dev/fmem of=investigatedcompmem");
system("cat investigatedcompmem | strings > memstrings");

#check to see if password exists
my @strings=();
my $flag = 0;

my $file = 'memstrings';
open my $fh, '<', $file or die "Could not open '$file' $!\n";
 
 
#get 3 lines after regex in memory dump 
while (my $line = <$fh>) 
{
   
   chomp $line;

   if($flag > 0)
   {

	print "$line\n";
	print "$flag\n";	
	$flag--;
	

   }

  # need to figure out regex
   if($line =~ '')
   {
	print "$line \n";
	$flag =3;

   }

}
