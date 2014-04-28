#lastest updates:
#-fmem usuage has been removed
#-additional options plan:
# ability to open wallet file if wallet is found
# ability to display wallet address when password scan complete

use strict;
use warnings;

my $option = $ARGV[0];

if ($option eq "-l")
{
	limeSetup();
}
elsif ($option eq "--help")
{
	print "Usage:  'perl MEMcoin.pl <argument>'\n";
	print "Argument -l for LiME Installation\n";
	exit;
}
else
{
	print "Error - Invalid Installation Option - Please Choose -l <lime> or --help <help> ...\n";
	exit;
}

searchForWallets();
imageMemory($option);
memorySearch();

#install the lime package and setup config
sub limeSetup{
	system("pwd");
	chdir("src/");
	system("pwd");
	system("make");

	chdir("../");
	system("mkdir InvestigationInfo");
	chdir("InvestigationInfo");
	system("mkdir InvestigationInfo");
	system("pwd");
}

#find all wallet files on the file system
sub searchForWallets{
	print "Searching for Wallets...\n";
	system("find / -name \*.wallet > WalletInfoFound");
}

#dump contents of memory
sub imageMemory{	
	my $kofile;
	
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

#find the password in memory (regex removed until premission is granted)
sub memorySearch{
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
	  
	   if($line =~ '^\w{52}\s\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z')
	   {
		print FILE "$line \n";
		$flag =3;
	   }
	}
	print "MEMCoin has finished investigation...\n";
}
