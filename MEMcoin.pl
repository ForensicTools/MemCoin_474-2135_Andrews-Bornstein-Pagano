use strict;
use warnings;

#Left 'fmem' installation as an option due to testing purposes
#We can remove at any time
my $option = $ARGV[0];

if ($option eq "-f")
{
	fmemSetup();
}
elsif ($option eq "-l")
{
	limeSetup();
}
elsif ($option eq "-h")
{
	print "Usage:  'perl MEMcoin.pl <argument>'\n";
	print "Argument -f for FMEM Installation\n";
	print "Argument -l for LiME Installation\n";
	exit;
}
else
{
	print "Error - Invalid Installation Option - Please Choose -f <fmem> or -l <lime> ...\n";
	exit;
}


searchForWallets();
imageMemory($option);
memorySearch();

sub fmemSetup{
	system("pwd");
	#if sudo install fmem
	chdir("fmem_1.6-0/");
	system("pwd");
	system("make");

	# Revision - if fmem install fails due to kernal headers report 	failure
	system("./run.sh");
	chdir("../");
	system("mkdir InvestigationInfo");
	chdir("InvestigationInfo");
	system("mkdir InvestigationInfo");
	system("pwd");
}
sub limeSetup{
	system("pwd");
	#if sudo install fmem
	chdir("src/");
	system("pwd");
	system("make");

	# Revision - if fmem install fails due to kernal headers report 	failure
	#system("./run.sh");
	chdir("../");
	system("mkdir InvestigationInfo");
	chdir("InvestigationInfo");
	system("mkdir InvestigationInfo");
	system("pwd");
}

sub searchForWallets{

	print "Searching for Wallets...\n";
	system("find / -name \*.wallet > WalletInfoFound");

}

sub imageMemory{	
	my $kofile;

	#grab an image
	print "Grabbing an Image of Memory...\n";
	
	if ($option eq "-f")
	{
		system("dd if=/dev/fmem of=investigatedcompmem");
		print "MEMCoin is making sense of all this data...\n";
	}
	elsif ($option eq "-l")
	{
		chdir("..");
		chdir("src/");

		#find the .ko file made by lime
		$kofile = `ls | grep \*.ko`;
		chomp($kofile);

		system("insmod $kofile path=../InvestigationInfo/investigatedcompmem.lime format=lime");
		system("rmmod lime");
		print "MEMCoin is making sense of all this data...\n";
	}
	chdir("..");
	chdir("InvestigationInfo");
	system("cat investigatedcompmem.lime | strings > memstrings");
}

sub memorySearch{

	#check to see if password exists
	print "Checking to see if passwords exist...\n";
	my @strings=();
	my $flag = 0;

	my $file = 'memstrings';
	open my $fh, '<', $file or die "Could not open '$file' $!\n";

	system("touch PossiblePasswords");
	open(FILE, ">>PossiblePasswords") || die("Error could not open file");
	 
	while (my $line = <$fh>) 
	{
	   chomp $line;

	   if($flag > 0)
	   {
		print FILE "$line\n";	
		$flag--;
	   }

	  #regex not listed
	   if($line =~ '')
	   {
		print FILE "$line \n";
		$flag =3;
	   }
	}

	print "MEMCoin has finished investigation...\n";
}
