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
elsif ($option eq "-i")
{
	print "Reading your image of memory\n";
}
elsif ($option eq "-h")
{
	print "Usage:  'perl MEMcoin.pl <argument>'\n";
	print "Argument -f for FMEM Installation\n";
	print "Argument -l for LiME Installation\n";
	print "Argument -i to pass an existing memory image to the tool\n";
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
	system("pwd");

}

sub searchForWallets{

	print "Searching for Wallets...\n";
	system("find / -name \*.wallet > WalletInfoFound");

}

sub imageMemory {

	#get passed arguments
	my $input = @_;
	#grab an image
	my $option = $_[chomp($input)];
	
	if ($option eq "-f")
	{
		print "Grabbing an Image of Memory...\n";
		system("dd if=/dev/fmem of=investigatedcompmem");
		print "MEMCoin is making sense of all this data...\n";
		system("cat investigatedcompmem | strings > memstrings");
	}
	elsif ($option eq "-l")
	{

		my $kofile;
		chdir("..");
		chdir("src/");
		system("pwd");
		
		#find the .ko file made by lime
		$kofile = `ls | grep \*.ko`;
		chomp($kofile);

		system("insmod $kofile path=../InvestigationInfo/investigatedcompmem.lime format=lime");
		system("rmmod lime");
		print "MEMCoin is making sense of all this data...\n";
		system("pwd");		
		chdir("..");
		system("pwd");
		chdir("InvestigationInfo");
		system("cat investigatedcompmem.lime | strings > memstrings");
	}
	elsif ($option eq "-i")
	{

		system("mkdir InvestigationInfo");
		chdir("InvestigationInfo");
		system("pwd");

		if ($ARGV[1])
		{
			print "Investing the memory image passed to MEMCoin...\n";
			system("cat $ARGV[1] | strings > memstrings");
		}
		else
		{
		
			print "Failed to pass memory image file name after -i option\n";
			exit;
		
		}
	}
	
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
	  #added by sean
	   if($line =~ '^\w{52}\s\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z')
	   {
		print FILE "$line \n";
		$flag =3;

	   }

	}

	print "MEMCoin has finished investigation...\n";
}
